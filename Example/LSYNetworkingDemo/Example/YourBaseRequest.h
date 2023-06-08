//
//  YourBaseRequest.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/9/29.
//

#import "LSYBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YourBaseRequest : LSYBaseRequest

//是否应该缓存数据
@property (assign, nonatomic) BOOL shouldCache;

//参数是否需要加密
@property (assign, nonatomic) BOOL needEncrypt;

//Response是否需要解密
@property (assign, nonatomic) BOOL needDecryptResponse;

//result是否需要解密
@property (assign, nonatomic) BOOL needDecryptResult;

//是否显示菊花
@property (assign, nonatomic) BOOL showLoadingView;

@end

NS_ASSUME_NONNULL_END
