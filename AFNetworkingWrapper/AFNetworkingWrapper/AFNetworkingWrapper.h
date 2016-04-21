//
//  AFNetworkingWrapper.h
//  AFNetworkingWrapper
//
//  Created by yoanna on 16/4/20.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "LswuyouNetWorkObserver.h"

/**
 *  请求成功/失败/进度block
 */
typedef void(^DidFinishRequestBlock)(id object,NSInteger code);
typedef void (^DidFailRequestBlock)(BaseResponse *object);
typedef void (^RequestProgressBlock)(float progressValue);

typedef enum
{
    NO_ENCRYPT = 0,  // 未加密
    AES_ENCRYPT = 1, // aes 登录后加密
    RSA_ENCRYPT = 2, // rsa 登录前加密
}encryptType;

typedef enum
{
    REQ_POST = 0,  // post请求
    REQ_GET = 1, // get请求
    
}reqType;

@interface AFNetworkingWrapper : NSObject

/**
 *  普通请求
 *
 *  @param requestUrl   请求url
 *  @param params       请求数组
 *  @param reqType      请求类型
 *  @param eType        加密类型
 *  @param successBlock 成功后的回调
 *  @param failBlock    失败后的回调
 *
 *  @return AFHTTPSessionManager 对象
 */
+(AFHTTPSessionManager *)sendRequest:(NSString*)requestUrl params:(NSDictionary *)params reqType:(NSInteger)reqType eType:(NSInteger)eType success:(DidFinishRequestBlock)successBlock fail:(DidFailRequestBlock)failBlock;


/**
 *  下载请求
 *
 *  @param requestUrl   请求url
 *  @param successBlock 成功后的回调
 *  @param failBlock    失败后的回调
 */
+(void)downloadWithRequest:(NSString *)requestUrl andFileName:(NSString *)fileName;
/**
 *  同步服务器时间
 */
+(void)resetTheServTimeInApp;

@end
