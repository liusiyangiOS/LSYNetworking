//
//  LSYRequestDef.h
//  LSYNetworkingDemo
//
//  Created by 刘思洋 on 2022/11/2.
//

/** 请求成功block回调 */
typedef void (^LSYRequestSuccessBlock) (id responseData);
/** 请求失败block回调 */
typedef void (^LSYRequestFailBlock) (NSError *error);
/** 网络传输进度block */
typedef void (^LSYRequestProgressBlock) (int64_t completed, int64_t total);
