//
//  XXXFriendInfoRequest.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "YourBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXFriendInfoRequest : YourBaseRequest

@property (assign, nonatomic) int friendId;

/**
 请求失败的错误类型
 1:请求频率过高需要验证
 2:token过期
 */
@property (assign, nonatomic) int errorType;

@end

NS_ASSUME_NONNULL_END
