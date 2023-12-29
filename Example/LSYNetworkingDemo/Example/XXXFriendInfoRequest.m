//
//  XXXFriendInfoRequest.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "XXXFriendInfoRequest.h"
#import "XXXFirendInfo.h"

@implementation XXXFriendInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apiName = @"/user/firend_info";
        //可以通过属性的方式添加请求参数,也可以用下边的方式直接添加一些写死的参数
        [self addExtraParamsWithDictionary:@{
            @"osVersion":@"iOS 14.0.1"
        }];
        self.method = LSYRequestMethodTypeGET;
    }
    return self;
}

-(Class)resultClass{
    return XXXFirendInfo.class;
}

-(id)responseDataSource{
    if (self.errorType == 1) {
        self.errorType = 0;
        return @{
            @"resultcode":@(LSYNetworkNeedAuthenticationErrorCode),
            @"resultmsg":@"您的请求过于频繁,请进行身份验证!",
            @"result":@{
                @"authenticationUrl":@"https://www.lsy.com/account/authentication.html"
            }
        };
    }
    if (self.errorType == 2){
        self.errorType = 0;
        return @{
            @"resultcode":@(LSYNetworkTokenExpiredErrorCode),
            @"resultmsg":@"token已过期!",
        };
    }
    NSArray *friendList = [NSArray arrayWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"FriendsInfoList" ofType:@"plist"]];
    if (self.friendId > friendList.count - 1) {
        return @{
            @"resultcode":@(300300),
            @"resultmsg":@"好友不存在!",
        };
    }
    return @{
        @"resultcode":@(200),
        @"resultmsg":@"请求成功!",
        @"result":friendList[_friendId]
    };
}

#pragma mark - LSYPropertysToDictionaryProtocol

- (Class)propertysDictionaryUntilClass{
    //这里的意思是,除了本类中定义的属性friendId,父类中的所有属性也要作为key-value添加到请求参数的dictionary当中
    return self.superclass;
}

+ (NSDictionary *)propertysToDictionaryMapper{
    //属性friendId映射到请求参数的key为friend_id
    return @{@"friendId":@"friend_id"};
}

+ (nullable NSArray<NSString *> *)propertyBlacklist{
    //这里表示,errorType这个属性不作为请求参数添加到参数dictionary中
    NSMutableArray *blackList = @[@"errorType"].mutableCopy;
    [blackList addObjectsFromArray:[super propertyBlacklist]];
    return blackList;
}

@end
