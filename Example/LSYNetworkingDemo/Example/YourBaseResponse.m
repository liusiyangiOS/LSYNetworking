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

+ (NSString *)resultKey{
    return @"result";
}

- (instancetype)initWithResponse:(id)response{
    self = [super init];
    if (self) {
        /*
         根据你们公司response的结构进行赋值,如:
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
        _result = [response objectForKey:[self.class resultKey]];
        
        _responseJson = response;
    }
    return self;
}

- (void)updateResponseJsonObject{
    NSMutableDictionary *decryptResponse = [_responseJson mutableCopy];
    if (!_result) {
        [decryptResponse removeObjectForKey:[YourBaseResponse resultKey]];
    }else{
        [decryptResponse setObject:_result forKey:[YourBaseResponse resultKey]];
    }
    _responseJson = decryptResponse.copy;
}

- (BOOL)isRequestSuccess{
    //和后台约定的表示请求成功的code,比如200
    return _code == 200;
}

- (instancetype)modelWithClass:(Class)resultClass json:(id)resultJson{
    if ([resultClass isSubclassOfClass:NSDictionary.class] ||
        [resultClass isSubclassOfClass:NSArray.class] ||
        [resultClass isSubclassOfClass:NSString.class] ||
        [resultClass isSubclassOfClass:NSNumber.class]) {
        //如果resultClass是以上四种类型,则不需要转model,只有自定义模型需要转化
        return resultJson;
    }
    //这里可以根据你项目里使用的json转model的工具进行转化,我用的是YYModel
    return [resultClass yy_modelWithJSON:resultJson];
}

- (NSArray *)modelArrayWithClass:(Class)elementClass json:(id)resultJson{
    //这里可以断言下类型是否匹配,或者可以做一下判断,如果不匹配,则直接返回resultJson/返回空
    NSAssert([resultJson isKindOfClass:NSArray.class], @"Result class error,result json object is not a kind of NSArray!");
    return [NSArray yy_modelArrayWithClass:elementClass json:resultJson];
}

- (NSDictionary *)modelDictionaryWithClass:(Class)elementClass json:(id)resultJson{
    //这里可以断言下类型是否匹配,或者可以做一下判断,如果不匹配,则直接返回resultJson/返回空
    NSAssert([resultJson isKindOfClass:NSDictionary.class], @"Result class error,result json object is not a kind of NSDictionary!");
    return [NSDictionary yy_modelDictionaryWithClass:elementClass json:resultJson];
}

@end
