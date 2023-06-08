//
//  YourBaseResponse.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import <Foundation/Foundation.h>
#import "LSYResponseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YourBaseResponse : NSObject <LSYResponseProtocol>

@property (strong, nonatomic) id responseJson;

- (instancetype)initWithResponse:(id)response;

/**
 更新Response json
 注意这里只能外部显式调用,不要在result的setter方法内部自动调用更新
 因为框架内部有替换result为转换后的model的操作,自动调用更新会导致不必要的model-json之间的转化
 */
- (void)updateResponseJsonObject;

@end

NS_ASSUME_NONNULL_END
