//
//  XXXFirendInfo.h
//  Pods
//
//  Created by 刘思洋 on 2022/9/30.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXXFirendInfo : NSObject<YYModel>

@property (assign, nonatomic) int userId;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) int sex;

@property (assign, nonatomic) int age;

@end

NS_ASSUME_NONNULL_END
