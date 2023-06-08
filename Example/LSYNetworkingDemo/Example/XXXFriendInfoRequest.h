//
//  XXXFriendInfoRequest.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "YourBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

//请求次数太多需要进行身份验证的code
extern NSInteger const LSYNetworkNeedAuthenticationErrorCode;

@interface XXXFriendInfoRequest : YourBaseRequest

@property (assign, nonatomic) int friendId;

//请求失败的错误类型,0:普通失败类型 1:请求频率过高需要验证
@property (assign, nonatomic) int errorType;

@end

NS_ASSUME_NONNULL_END
