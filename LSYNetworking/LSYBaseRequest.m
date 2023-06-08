//
//  LSYBaseRequest.m
//  bangjob
//
//  Created by 刘思洋 on 2022/4/20.
//  Copyright © 2022 com.58. All rights reserved.
//

#import "LSYBaseRequest.h"
#import <AFNetworking/AFNetworking.h>

static dispatch_queue_t processing_queue() {
    static dispatch_queue_t request_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request_processing_queue = dispatch_queue_create("com.lsy.request.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    return request_processing_queue;
}

@interface LSYBaseRequest (){
    NSMutableDictionary<NSString *, NSURLSessionTask *> *_taskDic;
    int _index;
    
    NSMutableDictionary *_extraParams;
}
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation LSYBaseRequest
@dynamic securityPolicy;

- (instancetype)init{
    self = [super init];
    if (self) {
        _usePost = YES;
        _taskDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

#pragma mark - public method

- (NSString *)url{
    NSAssert(_host != nil, @"host is nil");
    NSString *apiName = [self apiName];
    if (apiName.length) {
        return [self.host stringByAppendingString:apiName];
    }
    return self.host;
}

- (NSDictionary *)finalParams{
    NSMutableDictionary *params = [self propertysDictionary];
    if (_extraParams.count) {
        [params addEntriesFromDictionary:_extraParams];
    }
    return [params copy];
}

- (void)addExtraParamsWithDictionary:(NSDictionary *)extraParams{
    if (!extraParams.count) {
        return;
    }
    if (!_extraParams) {
        _extraParams = [extraParams mutableCopy];
    }else{
        [_extraParams addEntriesFromDictionary:extraParams];
    }
}

- (AFHTTPRequestSerializer *)requestSerializer{
    if (!self.manager.requestSerializer) {
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self.manager.requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer{
    if (!self.manager.responseSerializer) {
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self.manager.responseSerializer;
}

- (NSString *)startRequestWithSuccessBlock:(LSYRequestSuccessBlock)successBlock
                              failureBlock:(LSYRequestFailBlock)failureBlock{
    if ([self respondsToSelector:@selector(responseDataSource)]) {
        id response = [self responseDataSource];
        if (response) {
            [self handleResponse:response withToken:nil successBlock:successBlock failureBlock:failureBlock];
            return nil;
        }
    }
    NSString *token = [self _generateToken];
    //因为可能涉及到参数加密,所以在子线程执行以下代码
    dispatch_async(processing_queue(), ^{
        NSString *encodeURL = [self _UTF8EncodingWithURLString:[self url]];
        NSDictionary *params = [self finalParams];
        if ([self respondsToSelector:@selector(handleParams:)]) {
            params = [self handleParams:params];
        }
        
        NSURLSessionTask *task = nil;
        if ([self usePost]) {
            task = [self.manager POST:encodeURL parameters:params headers:[self httpRequestHeaders] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:responseObject withToken:token successBlock:successBlock failureBlock:failureBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self _handleError:error withToken:token successBlock:successBlock failureBlock:failureBlock];
            }];
        }else{
            task = [self.manager GET:encodeURL parameters:params headers:[self httpRequestHeaders] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:responseObject withToken:token successBlock:successBlock failureBlock:failureBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self _handleError:error withToken:token successBlock:successBlock failureBlock:failureBlock];
            }];
        }
        if (task) {
            [_taskDic setObject:task forKey:token];
        }
    });
    return token;
}

- (NSString *)uploadFileWithItems:(NSArray<LSYRequestUploadItem *> *)items
                    progressBlock:(LSYRequestProgressBlock)progressBlock
                     successBlock:(LSYRequestSuccessBlock)successBlock
                     failureBlock:(LSYRequestFailBlock)failureBlock{
    if ([self respondsToSelector:@selector(responseDataSource)]) {
        id response = [self responseDataSource];
        if (response) {
            [self handleResponse:response withToken:nil successBlock:successBlock failureBlock:failureBlock];
            return nil;
        }
    }
    NSString *token = [self _generateToken];
    dispatch_async(processing_queue(), ^{
        NSString *encodeURL = [self _UTF8EncodingWithURLString:[self url]];
        NSDictionary *params = [self finalParams];
        if ([self respondsToSelector:@selector(handleParams:)]) {
            params = [self handleParams:params];
        }
        NSURLSessionDataTask *task = [self.manager POST:encodeURL parameters:params headers:[self httpRequestHeaders] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [items enumerateObjectsUsingBlock:^(LSYRequestUploadItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:LSYRequestUploadImage.class]) {
                    LSYRequestUploadImage *imageObj = (LSYRequestUploadImage *)obj;
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(imageObj.image, 1.f)
                                                name:obj.key
                                            fileName:[NSString stringWithFormat:@"%@.jpg", obj.key]
                                            mimeType:@"image/jpeg"];
                }else if ([obj isKindOfClass:LSYRequestUploadData.class]){
                    LSYRequestUploadData *dataObj = (LSYRequestUploadData *)obj;
                    [formData appendPartWithFileData:dataObj.fileData
                                                name:obj.key
                                            fileName:dataObj.fileName
                                            mimeType:dataObj.mimeType];
                } else {
                    NSAssert([obj isKindOfClass:LSYRequestUploadFile.class], @"item should be a kind of LSYRequestUploadItem class");
                    LSYRequestUploadFile *fileObj = (LSYRequestUploadFile *)obj;
                    NSAssert(fileObj.mimeType.length != 0, @"mimeType is nil");
                    NSURL *fileURL = [NSURL fileURLWithPath:fileObj.filePath];
                    NSString *fileName = [fileURL lastPathComponent];
                    if (!fileName) {
                        fileName = obj.key;
                    }
                    [formData appendPartWithFileURL:fileURL
                                               name:obj.key
                                           fileName:fileName
                                           mimeType:fileObj.mimeType
                                              error:nil];
                }
            }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) {
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponse:responseObject withToken:token successBlock:successBlock failureBlock:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self _handleError:error withToken:token successBlock:successBlock failureBlock:failureBlock];
        }];
        if (task) {
            [_taskDic setObject:task forKey:token];
        }
    });
    return token;
}

- (NSURLSessionTask *)taskWithToken:(NSString *)token{
    return _taskDic[token];
}

- (void)cancelRequestWithTaskToken:(NSString *)taskToken{
    NSURLSessionTask *sessionTask = _taskDic[taskToken];
    [sessionTask cancel];
}

#pragma mark - private method

- (NSString *)_UTF8EncodingWithURLString:(NSString *)URLString {
    return [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)_generateToken{
    return [NSString stringWithFormat:@"%llu%d",(UInt64)self,_index];
}

- (void)handleResponse:(id)response
             withToken:(NSString *)token
          successBlock:(LSYRequestSuccessBlock)successBlock
          failureBlock:(LSYRequestFailBlock)failureBlock{
    //因为可能涉及到response解密,所以在子线程进行
    dispatch_async(processing_queue(), ^{
        id<LSYResponseProtocol> handledResponse = [self handleResponse:response];
        if (!handledResponse) {
            NSError *error = [NSError customErrorWithCode:-1 errorMsg:@"Handled response is nil!" extraInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _handleError:error withToken:token successBlock:successBlock failureBlock:failureBlock];
            });
            return;
        }
        NSAssert([handledResponse conformsToProtocol:@protocol(LSYResponseProtocol)], @"Handled response must confirms the 'LSYResponseProtocol'!");
        if (handledResponse.isRequestSuccess) {
            if (handledResponse.result) {
                Class resultClass = nil;
                if ([self respondsToSelector:@selector(resultClass)]) {
                    resultClass = [self resultClass];
                }
                if (resultClass) {
                    Class elementClass = nil;
                    if ([self respondsToSelector:@selector(elementClassIfResultIsCollection)]) {
                        elementClass = [self elementClassIfResultIsCollection];
                    }
                    id result = handledResponse.result;
                    if (elementClass) {
                        if ([resultClass isSubclassOfClass:NSArray.class]) {
                            result = [handledResponse modelArrayWithClass:elementClass json:result];
                        }else if ([resultClass isSubclassOfClass:NSDictionary.class]){
                            result = [handledResponse modelDictionaryWithClass:elementClass json:result];
                        }
                    }else{
                        result = [handledResponse modelWithClass:resultClass json:result];
                    }
                    handledResponse.result = result;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self respondsToSelector:@selector(requestSuccessWithResponseObject:task:)]) {
                    [self requestSuccessWithResponseObject:handledResponse task:_taskDic[token]];
                }
                if (successBlock) {
                    successBlock(handledResponse.result);
                }
                if (token) {
                    [_taskDic removeObjectForKey:token];
                }
            });
        }else{
            NSError *error = [NSError businessErrorWithCode:handledResponse.code errorMsg:handledResponse.msg extraInfo:handledResponse.result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _handleError:error withToken:token successBlock:successBlock failureBlock:failureBlock];
            });
        }
    });
}

- (void)_handleError:(NSError *)error withToken:(NSString *)token successBlock:(_Nullable LSYRequestSuccessBlock)successBlock failureBlock:(LSYRequestFailBlock)failureBlock{
    if ([self respondsToSelector:@selector(requestFailedWithError:task:successBlock:failureBlock:)]) {
        [self requestFailedWithError:error task:_taskDic[token] successBlock:successBlock failureBlock:failureBlock];
    }
    if (failureBlock) {
        failureBlock(error);
    }
    if (token) {
        [_taskDic removeObjectForKey:token];
    }
}

#pragma mark - setter & getter

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
        if ([self respondsToSelector:@selector(requestType)]) {
            switch ([self requestType]) {
                case LSYRequestSerializerTypeHTTP:
                    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                case LSYRequestSerializerTypeJSON:
                    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                case LSYRequestSerializerTypePropertyList:
                    _manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
                    break;
            }
        }
        
        if ([self respondsToSelector:@selector(responseType)]) {
            switch ([self responseType]) {
                case LSYResponseSerializerTypeJSON:
                    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                case LSYResponseSerializerTypeXMLParser:
                    _manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                case LSYResponseSerializerTypeHTTP:
                    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
            }
        }
    }
    return _manager;
}

- (void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy{
    self.manager.securityPolicy = securityPolicy;
}

-(AFSecurityPolicy *)securityPolicy{
    return self.manager.securityPolicy;
}

#pragma mark - LSYBaseRequest protocol

- (id<LSYResponseProtocol>)handleResponse:(id)response{
    return response;
}

@end
