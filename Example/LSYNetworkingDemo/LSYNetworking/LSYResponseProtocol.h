//
//  LSYResponseProtocol.h
//  Indonesia
//
//  Created by 刘思洋 on 2019/3/2.
//  Copyright © 2019年 GoWithMe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LSYResponseProtocol <NSObject>

/** 返回的状态码(错误码) */
@property (assign, nonatomic, readonly) NSInteger code;
/** 提示信息(错误信息) */
@property (copy, nonatomic, readonly) NSString *msg;
/** 返回的结果数据 */
@property (strong, nonatomic) id result;

/** 请求是否成功 */
- (BOOL)isRequestSuccess;

/**
 将resultJson转化为resultClass类型的实例
 @param resultClass response的result需要转换的模型类
 @param resultJson 需要转化的json对象,可能是数组/字典/json字符串/json data
 @return 转换后的实例
 */
- (instancetype)modelWithClass:(Class)resultClass json:(id)resultJson;

/**
 将resultJson转化为elementClass类型的数组
 @param elementClass 数组里边的元素的类型
 @param resultJson 需要转化的json对象,可能是数组/字典/json字符串/json data
 @return 转换后的数组
 */
- (NSArray *)modelArrayWithClass:(Class)elementClass json:(id)resultJson;

/**
 将resultJson转化为elementClass类型的字典
 @param elementClass 字典里边的元素的类型
 @param resultJson 需要转化的json对象,可能是数组/字典/json字符串/json data
 @return 转换后的字典
 */
- (NSDictionary *)modelDictionaryWithClass:(Class)elementClass json:(id)resultJson;

@end

NS_ASSUME_NONNULL_END
