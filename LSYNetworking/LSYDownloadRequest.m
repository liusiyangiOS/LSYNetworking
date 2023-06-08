//
//  LSYDownloadRequest.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/11/1.
//

#import "LSYDownloadRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation LSYDownloadRequest

- (void)startRequestWithProgressBlock:(nullable LSYRequestProgressBlock)progressBlock
                         successBlock:(nullable LSYRequestSuccessBlock)successBlock
                         failureBlock:(nullable LSYRequestFailBlock)failureBlock {
    if (!_url) {
        return;
    }
    NSString *url = _url;
    NSString *dirPath = nil;
    if (!_savePath) {
        NSString *savePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        dirPath = savePath = [savePath stringByAppendingPathComponent:@"LSYNetworkingDownload"];
        _savePath = [savePath stringByAppendingPathComponent:url.pathComponents.lastObject];
    }else{
        dirPath = [_savePath stringByDeletingLastPathComponent];
    }
    if (![NSFileManager.defaultManager fileExistsAtPath:dirPath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    void (^ downloadProgressBlock)(NSProgress *downloadProgress) = ^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            });
        }
    };
    NSURL * (^ destination)(NSURL *targetPath, NSURLResponse *response) = ^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:_savePath];
    };
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *resumeDataPath = [self _downloadResumeDataPathWithUrlString:url];
    void (^ completionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error) = ^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            if (resumeData) {
                [resumeData writeToFile:resumeDataPath atomically:NO];
            }
            if (failureBlock) {
                failureBlock(error);
            }
        } else {
            [NSFileManager.defaultManager removeItemAtPath:resumeDataPath error:nil];
            if (successBlock) {
                successBlock(filePath);
            }
        }
    };
    
    NSURLSessionDownloadTask *task = nil;
    NSData *resumeData = [NSData dataWithContentsOfFile:resumeDataPath];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"xxx.xx.x"];
    //在蜂窝网络下是否继续请求
    config.allowsCellularAccess = YES;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    if (resumeData.length > 0) {
        task = [manager downloadTaskWithResumeData:resumeData progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:self.timeoutInterval];
        task = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
    }
    if (task) {
        [task resume];
        _task = task;
    }
}

- (void)cancelRequest {
    [_task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {}];
}

#pragma mark - private method

- (NSString *)_downloadResumeDataPathWithUrlString:(NSString *)URLString {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:@"LSYNetworkingResumeData"];
    if (![NSFileManager.defaultManager fileExistsAtPath:cachePath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [[URLString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

#pragma mark - setter & getter

-(NSTimeInterval)timeoutInterval{
    if (_timeoutInterval <= 0) {
        _timeoutInterval = 10;
    }
    return _timeoutInterval;
}

@end
