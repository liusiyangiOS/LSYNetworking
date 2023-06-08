//
//  NSError+LSYNetworking.h
//  bangjob
//
//  Created by 刘思洋 on 2022/6/29.
//  Copyright © 2022 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 服务器返回的额外信息 */
FOUNDATION_EXPORT NSErrorUserInfoKey const NSExtraInfoKey;

/** 是否是业务error */
FOUNDATION_EXPORT NSErrorUserInfoKey const NSBusinessErrorKey;

@interface NSError (LSYNetworking)

/** 业务逻辑的error */
+ (NSError *)businessErrorWithCode:(NSInteger)code errorMsg:(nullable NSString *)errorMsg extraInfo:(nullable NSDictionary *)extraInfo;

+ (NSError *)customErrorWithCode:(NSInteger)code errorMsg:(nullable NSString *)errorMsg extraInfo:(nullable NSDictionary *)extraInfo;

- (id)extraInfo;

/** 是否是业务error(后台返回的逻辑上的error) */
- (BOOL)isBusinessError;

@end

NS_ASSUME_NONNULL_END
