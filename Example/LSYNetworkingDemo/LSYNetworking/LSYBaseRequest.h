//
//  LSYBaseRequest.h
//  bangjob
//
//  Created by 刘思洋 on 2022/4/20.
//  Copyright © 2022 com.58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYResponseProtocol.h"
#import "NSError+LSYNetworking.h"
#import "NSObject+LSYPropertysToDictionary.h"
#import "LSYRequestUploadItem.h"
#import "LSYRequestDef.h"
@class AFSecurityPolicy,AFHTTPRequestSerializer,AFHTTPResponseSerializer;

NS_ASSUME_NONNULL_BEGIN

/** 网络请求格式化器 */
typedef NS_ENUM(NSUInteger, LSYRequestSerializerType) {
    LSYRequestSerializerTypeHTTP         = 0, /*!< NSData格式 */
    LSYRequestSerializerTypeJSON         = 1, /*!< JSON格式，默认格式 */
    LSYRequestSerializerTypePropertyList = 2, /*!< 属性列表 */
};

/** 网络响应格式化器 */
typedef NS_ENUM(NSUInteger, LSYResponseSerializerType) {
    LSYResponseSerializerTypeJSON         = 0, /*!< JSON格式，默认格式 */
    LSYResponseSerializerTypeXMLParser    = 1, /*!< XML格式 */
    LSYResponseSerializerTypeHTTP         = 2, /*!< NSData格式 */
};

@protocol LSYBaseRequest <NSObject>

/**
 处理response,子类可以重写此方法对数据进行解密操作
 该方法在子线程调用,子类根据需要重写
 @param response 服务器返回的,未经任何处理的response
 @return 处理后的response,必须实现 LSYResponseProtocol 协议
 */
- (id<LSYResponseProtocol>)handleResponse:(id)response;

@optional

/**
 返回数据的类型,将response的result转换成该类的实例,未实现此方法或者返回空不处理
 建议不要重写此方法来返回NSString,NSNumber这样的Class,这些类型不需要转化
 建议elementClassIfResultIsCollection方法未实现或者返回空的时候,不要重写此方法来返回NSArray,NSDictionary这样的Class,这种情况不需要转化
 */
- (Class)resultClass;

/**
 如果resultClass是容器(array,dictionary等),里边的元素是什么类型的,返回空不处理
 建议不要重写此方法来返回NSArray,NSDictionary,NSString,NSNumber这样的Class,这些类型不需要转化
 */
- (Class)elementClassIfResultIsCollection;

/** 请求格式化器格式，默认为LSYRequestSerializerTypeHTTP */
-(LSYRequestSerializerType)requestType;

/** 响应格式化器格式，默认为LSYResponseSerializerTypeJSON */
-(LSYResponseSerializerType)responseType;

/**
 Response数据源,可以用来实现缓存功能或者测试
 若实现此方法,并返回一个非空的 json object,则直接用该json object作为response回调,不会进行请求
 */
- (id)responseDataSource;

/**
 处理最终的请求参数,子类可以重写对参数进行加密
 该方法在子线程调用,子类根据需要重写
 @param params 最终的请求参数,这里同self.finalParams
 @result 处理后的参数字典
 */
- (NSDictionary *)handleParams:(NSDictionary *)params;

/**
 请求成功回调,子类可以重写此方法来实现一些功能,如数据缓存,请求记录存储等,主线程调用
 @param response 将返回结果的data转化成model之后的response
 */
- (void)requestSuccessWithResponseObject:(id<LSYResponseProtocol>)response task:(NSURLSessionTask *)task;

/**
 请求失败回调,子类可以重写此方法来对错误进行统一的处理,主线程调用
 @param error 错误信息,调用[error extraInfo]可以获取服务器返回的错误信息(如果有的话)
 */
- (void)requestFailedWithError:(NSError *)error task:(NSURLSessionTask *)task successBlock:(nullable LSYRequestSuccessBlock)successBlock failureBlock:(nullable LSYRequestFailBlock)failureBlock;

@end

@interface LSYBaseRequest : NSObject <LSYBaseRequest,LSYPropertysToDictionaryProtocol>

/**
 是否使用POST请求,默认YES
 YES:POST请求,NO:GET请求
 */
@property (assign, nonatomic) BOOL usePost;

@property (copy, nonatomic) NSString *host;
@property (copy, nonatomic) NSString *apiName;

/** 请求头 */
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *httpRequestHeaders;

/**
 *  安全相关设置（可选）
 */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

- (NSString *)url;

/** 最终的请求参数(未处理过的) */
- (NSDictionary *)finalParams;

/** 子类除了可以自定义参数属性,也可以直接把参数放到这里 */
- (void)addExtraParamsWithDictionary:(NSDictionary *)extraParams;

- (AFHTTPRequestSerializer *)requestSerializer;

- (AFHTTPResponseSerializer *)responseSerializer;

/**
 一般请求方法
 @return task的token,用来获取请求的task
 */
- (NSString *)startRequestWithSuccessBlock:(nullable LSYRequestSuccessBlock)successBlock
                              failureBlock:(nullable LSYRequestFailBlock)failureBlock;

/** 涉及到上传部分文件相关的请求方法,如上传图片,上传个人信息附带头像啥的 */
- (NSString *)uploadFileWithItems:(nullable NSArray<LSYRequestUploadItem *> *)items
                    progressBlock:(nullable LSYRequestProgressBlock)progressBlock
                     successBlock:(nullable LSYRequestSuccessBlock)successBlock
                     failureBlock:(nullable LSYRequestFailBlock)failureBlock;

- (NSURLSessionTask *)taskWithToken:(NSString *)token;
- (void)cancelRequestWithTaskToken:(NSString *)taskToken;

@end

NS_ASSUME_NONNULL_END
