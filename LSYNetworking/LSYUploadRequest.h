//
//  LSYUploadRequest.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/11/7.
//

#import <Foundation/Foundation.h>
#import "LSYRequestDef.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSYUploadRequest : NSObject

/** 上传本地文件 */
+ (NSURLSessionUploadTask *)uploadFileWithUrl:(NSString *)url
                                     filePath:(NSString *)filePath
                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                progressBlock:(nullable LSYRequestProgressBlock)progressBlock
                                 successBlock:(nullable LSYRequestSuccessBlock)successBlock
                                 failureBlock:(nullable LSYRequestFailBlock)failureBlock;

/** 上传data */
+ (NSURLSessionUploadTask *)uploadFileWithUrl:(NSString *)url
                                     fileData:(NSData *)fileData
                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                progressBlock:(nullable LSYRequestProgressBlock)progressBlock
                                 successBlock:(nullable LSYRequestSuccessBlock)successBlock
                                 failureBlock:(nullable LSYRequestFailBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
