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

- (instancetype)initWithEncryptedResponse:(id)response;

- (instancetype)initWithResultEncryptedResponse:(id)response;

@end

NS_ASSUME_NONNULL_END
