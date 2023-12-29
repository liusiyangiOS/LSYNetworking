//
//  LSYRequestUploadItem.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSYRequestUploadItem : NSObject

/** 上传文件/图片时对应文件/图片的key */
@property (copy, nonatomic) NSString *key;
/**
 文件名,可不填写,也可指定,当多个item对应同一个key的时候,则需要手动填写不同的文件名来作区分
 LSYRequestUploadFile:默认是filePath中的文件名
 LSYRequestUploadData:默认用key作为文件名,但是这样的文件名是没有拓展名的,因此建议填写
 LSYRequestUploadImage:默认是key的值拼接.jpg拓展
 */
@property (copy, nonatomic) NSString *fileName;

@end

@interface LSYRequestUploadFile : LSYRequestUploadItem

@property (copy, nonatomic) NSString *mimeType;

@property (copy, nonatomic) NSString *filePath;

@end

@interface LSYRequestUploadData : LSYRequestUploadItem

@property (copy, nonatomic) NSString *mimeType;

@property (strong, nonatomic) NSData *fileData;

@end

@interface LSYRequestUploadImage : LSYRequestUploadItem

@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
