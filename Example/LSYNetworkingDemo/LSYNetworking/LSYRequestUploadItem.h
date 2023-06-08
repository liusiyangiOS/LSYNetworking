//
//  LSYRequestUploadItem.h
//  bangjob
//
//  Created by 刘思洋 on 2022/7/22.
//  Copyright © 2022 com.58. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSYRequestUploadItem : NSObject

/** 上传文件/图片时对应文件/图片的key */
@property (copy, nonatomic) NSString *key;

@end

@interface LSYRequestUploadFile : LSYRequestUploadItem

@property (copy, nonatomic) NSString *mimeType;

@property (copy, nonatomic) NSString *filePath;

@end

@interface LSYRequestUploadData : LSYRequestUploadItem

@property (copy, nonatomic) NSString *mimeType;

@property (strong, nonatomic) NSData *fileData;

@property (copy, nonatomic) NSString *fileName;

@end

@interface LSYRequestUploadImage : LSYRequestUploadItem

@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
