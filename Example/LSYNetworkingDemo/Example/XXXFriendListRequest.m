//
//  XXXFriendListRequest.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "XXXFriendListRequest.h"
#import "XXXFirendInfo.h"

@implementation XXXFriendListRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apiName = @"/user/firend_list";
    }
    return self;
}

-(Class)resultClass{
    return NSArray.class;
}

-(Class)elementClassIfResultIsCollection{
    return XXXFirendInfo.class;
}

-(id)responseDataSource{
    NSArray *friendList = [NSArray arrayWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"FriendsInfoList" ofType:@"plist"]];
    return @{
        @"resultcode":@(200),
        @"resultmsg":@"请求成功!",
        @"result":friendList
    };
}

- (void)requestSuccessWithResponseObject:(id<LSYResponseProtocol>)response task:(nonnull NSURLSessionTask *)task{
    NSArray<XXXFirendInfo *> *firendList = response.result;
    //这里可以对firendList进行一些处理,如排序操作,写在这里可以避免每次请求都需要在请求回调里写相同的排序逻辑
    firendList = firendList.copy;
}

@end
