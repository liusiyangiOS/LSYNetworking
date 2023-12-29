//
//  YourAccountManager.h
//  LSYNetworkingDemo
//
//  Created by liusiyang on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YourAccountManager : NSObject

@property (nonatomic, copy, class) NSString *token;

@property (nonatomic, copy, class) NSString *refreshToken;

@end

NS_ASSUME_NONNULL_END
