//
//  NSObject+LSYPropertysToDictionary.h
//  bangjob
//
//  Created by 刘思洋 on 2022/7/20.
//  Copyright © 2022 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LSYPropertysToDictionaryProtocol <NSObject>

@optional

/** 获取到指定父类的属性列表,如果不实现,则默认是当前类 */
- (Class)propertysDictionaryUntilClass;

/**
 设置propertysDictionary的key和属性之间的映射表
 key:属性名
 value:转换成propertysDictionary后的key值
 @return 属性名和propertysDictionary key值的映射表
 */
+ (NSDictionary *)propertysToDictionaryMapper;

/** 属性黑名单,黑名单中的key对应的属性不会加入到转化的dictionary中 */
+ (nullable NSArray<NSString *> *)propertyBlacklist;

@end

@interface NSObject (LSYPropertysToDictionary)

/**
 获取当前对象的(属性-值)集合,默认只获取当前类的属性
 如果想指定获取到具体的父类,可以实现-propertysDictionaryUntilClass方法
 */
- (NSMutableDictionary *)propertysDictionary;
- (NSMutableDictionary *)propertysDictionaryUntilClass:(Class)clazz;

@end

NS_ASSUME_NONNULL_END
