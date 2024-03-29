//
//  YourBaseRequest.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "YourBaseRequest.h"
#import "YourBaseResponse.h"
#import <YYModel/YYModel.h>
#import "XMLDictionary.h"
#import "YourAccountManager.h"
#import "XXXTokenUpdateRequest.h"

NSInteger const LSYNetworkTokenExpiredErrorCode = -100;
NSInteger const LSYNetworkNeedAuthenticationErrorCode = -200;
NSInteger const LSYNetworkBadAccountErrorCode = -300;

@implementation YourBaseRequest{
    //当前response是否是缓存
    BOOL _isCachedResponse;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //设置你的host
        self.host = @"https://api.lsy.com";
        //添加公共请求参数
        [self addExtraParamsWithDictionary:@{
            @"userId":@"11111111111"
        }];
        //添加请求头
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:@{
            @"version":@"1.0.0",
            @"platform":@"iOS"
        }];
        if (YourAccountManager.token.length) {
            [headers setObject:YourAccountManager.token forKey:@"token"];
        }
        self.httpRequestHeaders = headers.copy;
    }
    return self;
}

-(NSString *)startRequestWithSuccessBlock:(LSYRequestSuccessBlock)successBlock
                             failureBlock:(LSYRequestFailBlock)failureBlock{
    if (_showLoadingView) {
        //这里可以开始转菊花
    }
    return [super startRequestWithSuccessBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - LSYRequest

- (id)responseDataSource{
    //可以在这里处理缓存逻辑
    if(_shouldCache) {
        //假装这是读取缓存操作
        NSDictionary *cachedResponse = [NSUserDefaults.standardUserDefaults objectForKey:self.url];
        //本地是否有已缓存的数据
        if (cachedResponse) {
            _isCachedResponse = YES;
            return cachedResponse;
        }
    }
    return nil;
}

-(LSYResponseSerializerType)responseType{
    if (_needDecryptResponse) {
        return LSYResponseSerializerTypeHTTP;
    }
    return LSYResponseSerializerTypeJSON;
}

- (NSDictionary *)handleParams:(NSDictionary *)params{
    NSLog(@"----------\nRequest url:%@\nParam:%@\n",self.url,params);
    //这里可以对参数进行加密
    if (!_needEncrypt) {
        return params;
    }
    NSDictionary *encryptedParams = params.copy;//假装这是加密操作
    return encryptedParams;
}

- (id<LSYResponseProtocol>)handleResponse:(id)response{
    NSLog(@"Response:%@\n----------",response);
    //这里可以对response进行解密
    
    //缓存不需要解密
    if (_isCachedResponse) {
        return [[YourBaseResponse alloc] initWithResponse:response];
    }
    
    if (_needDecryptResponse) {
        //如果是对整个response进行加密的情况
        //顺便一说,如果是对整个response进行加密,那么responseType一定需要是http
        return [[YourBaseResponse alloc] initWithEncryptedResponse:response];
    }else {
        //如果是xml的response,需要进行xml解析
        if ([response isKindOfClass:NSXMLParser.class]) {
            response = [NSDictionary dictionaryWithXMLParser:response];
        }
        if (_needDecryptResult){
            //如果是对result进行加密的情况
            return [[YourBaseResponse alloc] initWithResultEncryptedResponse:response];
        }
        //不需要解密
        return [[YourBaseResponse alloc] initWithResponse:response];
    }
}

- (void)requestSuccessWithResponseObject:(nullable id<LSYResponseProtocol>)response task:(nonnull NSURLSessionTask *)task{
    //可以在这里处理缓存逻辑
    YourBaseResponse *res = response;
    if(_shouldCache && !_isCachedResponse) {
        //假装这是写入缓存操作
        [NSUserDefaults.standardUserDefaults setObject:[res.responseJson yy_modelToJSONString] forKey:self.url];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    
    //可以在这里实现一些debug功能,如网络请求信息记录,网络请求埋点等
    
    //可以对response.result进行一些处理,如,每次请求完毕都需要对result数组进行排序,可以在这里进行,避免每次请求都要做这些工作
    
    if (_showLoadingView) {
        //这里可以取消转菊花
    }
}

- (BOOL)requestFailedWithError:(NSError *)error task:(nonnull NSURLSessionTask *)task successBlock:(LSYRequestSuccessBlock _Nullable)successBlock failureBlock:(LSYRequestFailBlock _Nullable)failureBlock{
    //处理一些公共的错误
    if (error.isBusinessError) {
        //处理业务逻辑上的错误
        if (error.code == LSYNetworkTokenExpiredErrorCode) {
            //token过期
            XXXTokenUpdateRequest *request = [[XXXTokenUpdateRequest alloc] init];
            request.refreshToken = YourAccountManager.refreshToken;
            [request startRequestWithSuccessBlock:^(NSString *responseData) {
                //更新token
                YourAccountManager.token = responseData;
                NSMutableDictionary *headers = self.httpRequestHeaders.mutableCopy;
                [headers setObject:responseData forKey:@"token"];
                self.httpRequestHeaders = headers.copy;
                //用新的token重新请求
                [self startRequestWithSuccessBlock:successBlock failureBlock:failureBlock];
            } failureBlock:failureBlock];
            return NO;
        }else if (error.code == LSYNetworkNeedAuthenticationErrorCode){
            NSDictionary *extraInfo = error.extraInfo;
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:extraInfo[@"title"] message:extraInfo[@"content"] preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"点击验证" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //验证通过,重新请求
                [self startRequestWithSuccessBlock:successBlock failureBlock:failureBlock];
            }]];
            [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
            return NO;
        }
    }else{
        //处理其他错误(http错误)
    }

    //可以在这里实现一些debug功能,如网络请求信息记录,网络请求埋点等
    
    if (_showLoadingView) {
        //这里可以取消转菊花
    }
    return YES;
}

@end
