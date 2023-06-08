//
//  XXXFriendListRequest.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "YourBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXFriendListRequest : YourBaseRequest

@property (assign, nonatomic) NSInteger page;

@property (assign, nonatomic) NSInteger size;

@end

NS_ASSUME_NONNULL_END
