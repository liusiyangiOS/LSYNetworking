//
//  YourBaseResponse.m
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "YourBaseResponse.h"
#import <YYModel/YYModel.h>

@implementation YourBaseResponse
@synthesize code = _code;
@synthesize msg = _msg;
@synthesize result = _result;

#pragma mark - LSYResponseProtocol

- (instancetype)initWithEncryptedResponse:(id)response{
    response = [response copy];//假装这是解密操作
    return [self initWithResponse:response];
}

- (instancetype)initWithResultEncryptedResponse:(id)response{
    self = [self initWithResponse:response];
    //对result进行解密
    self.result = [self.result copy];//假装这是解密操作
    //因为有可能涉及到缓存Response,所以需要在result解密后,将Response的result替换为解密后的数据
    NSMutableDictionary *decryptResponse = [_responseJson mutableCopy];
    if (!_result) {
        [decryptResponse removeObjectForKey:@"result"];
    }else{
        [decryptResponse setObject:_result forKey:@"result"];
    }
    _responseJson = decryptResponse.copy;
    return self;
}

- (instancetype)initWithResponse:(id)response{
    self = [super init];
    if (self) {
        /*
         根据response的结构进行赋值,如:
         {
            "resultcode" = 200,
            "resultmsg" = "请求成功!",
            "result" = {
                "name" = "xxx",
                "sex" = 1,
                "age" = 20
            }
         }
         */
        _code = [[response objectForKey:@"resultcode"] integerValue];
        _msg = [response objectForKey:@"resultmsg"];
        _result = [response objectForKey:@"result"];
        
        _responseJson = response;
    }
    return self;
}

- (BOOL)isRequestSuccess{
    //和后台约定的表示请求成功的code,比如200
    return _code == 200;
}

- (instancetype)modelWithClass:(Class)resultClass json:(id)resultJson{
    //这里可以根据你项目里使用的json转model的工具进行转化,我用的是YYModel
    return [resultClass yy_modelWithJSON:resultJson];
}

- (NSArray *)modelArrayWithClass:(Class)elementClass json:(id)resultJson{
    return [NSArray yy_modelArrayWithClass:elementClass json:resultJson];
}

- (NSDictionary *)modelDictionaryWithClass:(Class)elementClass json:(id)resultJson{
    return [NSDictionary yy_modelDictionaryWithClass:elementClass json:resultJson];
}

@end
