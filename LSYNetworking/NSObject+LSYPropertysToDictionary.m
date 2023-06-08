//
//  NSObject+LSYPropertysToDictionary.m
//  bangjob
//
//  Created by 刘思洋 on 2022/7/20.
//  Copyright © 2022 com.58. All rights reserved.
//

#import "NSObject+LSYPropertysToDictionary.h"
#import <objc/runtime.h>

@implementation NSObject (LSYPropertysToDictionary)

- (NSMutableDictionary *)propertysDictionary{
    Class cls = Nil;
    if ([self respondsToSelector:@selector(propertysDictionaryUntilClass)]) {
        cls = [((id<LSYPropertysToDictionaryProtocol>)self) propertysDictionaryUntilClass];
    }
    return [self propertysDictionaryUntilClass:cls];
}

- (NSMutableDictionary *)propertysDictionaryUntilClass:(Class)clazz{
    //获取映射表
    NSDictionary *propertyMapper = nil;
    if ([self.class respondsToSelector:@selector(propertysToDictionaryMapper)]) {
        propertyMapper = [self.class performSelector:@selector(propertysToDictionaryMapper)];
    }
    //获取黑名单
    NSSet *blackList = nil;
    if ([self.class respondsToSelector:@selector(propertyBlacklist)]) {
        NSArray *arr = [self.class performSelector:@selector(propertyBlacklist)];
        blackList = [NSSet setWithArray:arr];
    }
    __block NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [self.class lsy_enumeratePropertyNamesUntilClass:clazz usingBlock:^(NSString *propertyName) {
        if ([blackList containsObject:propertyName]) {
            return;
        }
        id value = [self valueForKey:propertyName];
        if (value) {
            value = [self lsy_toJsonObject:value];
            if (value) {
                NSString *transPropertyName = nil;
                if (propertyMapper.count) {
                    transPropertyName = propertyMapper[propertyName];
                }
                transPropertyName = transPropertyName.length ? transPropertyName : propertyName;
                [dictionary setObject:value forKey:transPropertyName];
            }
        }
    }];
    return dictionary;
}

#pragma mark - private method

- (id)lsy_toJsonObject:(id)obj{
    if ([obj isKindOfClass:[NSArray class]]) {
        return [self lsy_arrayToJsonObject:obj];
    }else if ([obj isKindOfClass:[NSDictionary class]]) {
        return [self lsy_dictionaryToJsonObject:obj];
    }else if ([obj isKindOfClass:[NSNumber class]] ||
             [obj isKindOfClass:[NSString class]]) {
        return obj;
    }else if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }else {
        return [obj propertysDictionary];
    }
}

- (NSDictionary *)lsy_dictionaryToJsonObject:(NSDictionary *)dictionary{
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictionary.copy enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id propertyValue = [self lsy_toJsonObject:obj];
        if (propertyValue) [dic setObject:propertyValue forKey:key];
    }];
    return dic;
}

- (NSArray *)lsy_arrayToJsonObject:(NSArray *)array{
    __block NSMutableArray *arr = [NSMutableArray arrayWithCapacity:array.count];
    [array.copy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id propertyValue = [self lsy_toJsonObject:obj];
        if (propertyValue) [arr addObject:propertyValue];
    }];
    return arr;
}

+ (void)lsy_enumeratePropertyNamesUntilClass:(Class)sCls usingBlock:(void (^)(NSString *propertyName))block {
    if (!sCls) sCls = self.class;
    Class cls = [self class];
    while ((cls != [NSObject class]) && (cls != [sCls superclass])) {
        unsigned propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
        for ( int i = 0 ; i < propertyCount ; i++ ) {
            objc_property_t property = properties[i];
            const char *propertyAttributes = property_getAttributes(property);
            BOOL isReadWrite = (strstr(propertyAttributes, ",V") != NULL);
            if (isReadWrite) {
                NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
                if (block) block(propertyName);
            }
        }
        cls = [cls superclass];
        free(properties);
    }
}

@end
