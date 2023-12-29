//
//  XXXTokenUpdateRequest.m
//  LSYNetworkingDemo
//
//  Created by liusiyang on 2023/12/29.
//

#import "XXXTokenUpdateRequest.h"

@implementation XXXTokenUpdateRequest

- (instancetype)init{
    self = [super init];
    if (self) {
        self.apiName = @"/account/tokenUpdate";
    }
    return self;
}

-(id)responseDataSource{
    return @{
        @"resultcode":@(200),
        @"resultmsg":@"请求成功!",
        @"result":@"BROIDVB45REG6GER654HER45H6ER5454EJNN+E4R65ERH4H6546847=E98R7/E7R=74G8E/RG"
    };
}

@end
