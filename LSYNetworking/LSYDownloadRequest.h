//
//  LSYDownloadRequest.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/11/1.
//

#import <Foundation/Foundation.h>
#import "LSYRequestDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSYDownloadRequest : NSObject

@property (copy, nonatomic) NSString *url;

/* 超时时间,默认10 */
@property (assign, nonatomic) NSTimeInterval timeoutInterval;

/* 如果savePath为空,则下载到默认的路径 */
@property (copy, nonatomic) NSString *savePath;

@property (copy, nonatomic, readonly) NSURLSessionDownloadTask *task;

/** 下载文件,实现了断点续传功能 */
- (void)startRequestWithProgressBlock:(nullable LSYRequestProgressBlock)progressBlock
                         successBlock:(nullable LSYRequestSuccessBlock)successBlock
                         failureBlock:(nullable LSYRequestFailBlock)failureBlock;

/** 取消请求请务必调用此方法取消,因为此方法内部实现了断点续传逻辑 */
- (void)cancelRequest;

@end

NS_ASSUME_NONNULL_END
