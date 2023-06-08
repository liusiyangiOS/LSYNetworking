//
//  LSYUploadRequest.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/11/7.
//

#import "LSYUploadRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation LSYUploadRequest

+ (NSURLSessionUploadTask *)uploadFileWithUrl:(NSString *)url
                                     filePath:(NSString *)filePath
                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                progressBlock:(nullable LSYRequestProgressBlock)progressBlock
                                 successBlock:(nullable LSYRequestSuccessBlock)successBlock
                                 failureBlock:(nullable LSYRequestFailBlock)failureBlock{
    if (!filePath.length) return nil;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    
    NSURLSessionUploadTask *task = [[AFHTTPSessionManager manager] uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:filePath] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            if (successBlock) {
                successBlock(responseObject);
            }
        }
    }];
    if (task) {
        [task resume];
        return task;
    }
    return nil;
}

+ (NSURLSessionUploadTask *)uploadFileWithUrl:(NSString *)url
                                     fileData:(NSData *)fileData
                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                progressBlock:(nullable LSYRequestProgressBlock)progressBlock
                                 successBlock:(nullable LSYRequestSuccessBlock)successBlock
                                 failureBlock:(nullable LSYRequestFailBlock)failureBlock{
    if (!fileData) return nil;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeoutInterval];
    
    NSURLSessionUploadTask *task = [[AFHTTPSessionManager manager] uploadTaskWithRequest:request fromData:fileData progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            if (successBlock) {
                successBlock(responseObject);
            }
        }
    }];
    if (task) {
        [task resume];
        return task;
    }
    return nil;
}

@end
