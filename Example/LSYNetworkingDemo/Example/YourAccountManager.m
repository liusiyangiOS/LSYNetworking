//
//  YourAccountManager.m
//  LSYNetworkingDemo
//
//  Created by liusiyang on 2023/12/29.
//

#import "YourAccountManager.h"

@implementation YourAccountManager

static NSString *_token = nil;
+(void)setToken:(NSString *)token{
    _token = token;
}

+ (NSString *)token{
    return _token;
}

static NSString *_refreshToken = nil;
+(void)setRefreshToken:(NSString *)refreshToken{
    _refreshToken = refreshToken;
}

+(NSString *)refreshToken{
    return _refreshToken;
}

@end
