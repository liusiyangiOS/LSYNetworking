//
//  NSError+LSYNetworking.m
//  bangjob
//
//  Created by 刘思洋 on 2022/6/29.
//  Copyright © 2022 com.58. All rights reserved.
//

#import "NSError+LSYNetworking.h"

NSString * const NSExtraInfoKey = @"ExtraInfo";
NSString * const NSBusinessErrorKey = @"BusinessError";

@implementation NSError (LSYNetworking)

+ (NSError *)customErrorWithCode:(NSInteger)code errorMsg:(NSString *)errorMsg extraInfo:(NSDictionary *)extraInfo{
    return [NSError errorWithDomain:NSCocoaErrorDomain code:code userInfo:@{
        NSLocalizedDescriptionKey:errorMsg?:@"",
        NSExtraInfoKey:extraInfo?:@{},
    }];
}

+ (NSError *)businessErrorWithCode:(NSInteger)code errorMsg:(NSString *)errorMsg extraInfo:(NSDictionary *)extraInfo{
    return [NSError errorWithDomain:NSCocoaErrorDomain code:code userInfo:@{
        NSLocalizedDescriptionKey:errorMsg?:@"",
        NSExtraInfoKey:extraInfo?:@{},
        NSBusinessErrorKey:@(YES)
    }];
}

- (id)extraInfo{
    return self.userInfo[NSExtraInfoKey];
}

- (BOOL)isBusinessError{
    return [self.userInfo[NSBusinessErrorKey] boolValue];
}

@end
