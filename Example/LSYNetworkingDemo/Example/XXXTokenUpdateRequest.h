//
//  XXXTokenUpdateRequest.h
//  LSYNetworkingDemo
//
//  Created by liusiyang on 2023/12/29.
//

#import "YourBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXXTokenUpdateRequest : YourBaseRequest

@property (nonatomic, copy) NSString *refreshToken;

@end

NS_ASSUME_NONNULL_END
