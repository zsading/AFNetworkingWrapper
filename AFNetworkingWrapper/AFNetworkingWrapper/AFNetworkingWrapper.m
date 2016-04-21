//
//  AFNetworkingWrapper.m
//  AFNetworkingWrapper
//
//  Created by yoanna on 16/4/20.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "AFNetworkingWrapper.h"
#import "NSData+Base64.h"
#import "NSData+AesEncryption.h"
#import "RsaEncryption.h"
#import "NSString+MD5.h"
#import "NetworkingUtil.h"

@interface AFNetworkingWrapper ()

+ (NSString *)queryStringWithType:(NSInteger)eType;
@end

@implementation AFNetworkingWrapper

+(AFHTTPSessionManager *)sendRequest:(NSString*)requestUrl params:(NSDictionary *)params reqType:(NSInteger)reqType eType:(NSInteger)eType success:(DidFinishRequestBlock)successBlock fail:(DidFailRequestBlock)failBlock
{
    AFHTTPSessionManager *manager =nil;
    NSString * urlString = [NSString stringWithFormat:@"%@%@",SERVER,requestUrl];
    
    manager= [self post:urlString params:params eType:eType completion:^(NSDictionary *object, NSInteger finishCode) {
        
        /**
            根据finsihCode判断
         
         
         //例如
         BaseResponse *response = [[BaseResponse alloc] initWithDict:object];
         
         //若为code = 200，则为成功,取消&& response.resultCode.integerValue == 200 && finishCode == ASK_SERVER_SUCCESS
         if (response && (finishCode == 200 || finishCode == 0 || finishCode == 302 )) {
         if (successBlock) {
         successBlock(response, finishCode);
         }
         }else if (response && finishCode == 402){
         //          时间重置
         
         if (failBlock) {
         failBlock(response);
         }
         
         } else if(response && finishCode == 401) {
         
         
         
         }else{
         if (failBlock) {
         failBlock(response);
         }
         
         }
         
         */

        
        
    }];
    
    return manager;
}


//初始化头文件
+ (AFHTTPRequestSerializer *)initHttpHeaderFiled:(NSInteger)eType
{
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
//    CGSize screenPixel = [LswuyouAppSetting mainScreenPixel];
    
    // 标准报文头
    [serializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"text/html,text/javascript,application/json,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
      forHTTPHeaderField:@"Accept"];//Accept-Encoding: gzip
    [serializer setValue:@"zh-cn,zh;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [serializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //    [serializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    
    
    // 自定义报文头
    [serializer setValue:AppPlatform forHTTPHeaderField:@"pf"];//平台类型，为ios
#if DEBUG
//    NSLog(@"%@",LSWUYOUVERSION);
#endif
    [serializer setValue:@"1.0.0" forHTTPHeaderField:@"v"];//版本
    [serializer setValue:@"com.lswuyou" forHTTPHeaderField:@"pgn"];
    [serializer setValue:[[LswuyouNetWorkObserver netWorkObserverShare] getNetWorkType] forHTTPHeaderField:@"network"];//网络类型
//    [serializer setValue:[NSString stringWithFormat:@"%f", screenPixel.width] forHTTPHeaderField:@"screen-width"];//屏幕像素宽
//    [serializer setValue:[NSString stringWithFormat:@"%f", screenPixel.height] forHTTPHeaderField:@"screen-height"];//屏幕像素长
//    [serializer setValue:[MyUtil getDeviceName] forHTTPHeaderField:@"dn"]; //设别类型,如iphone6
    
    
    
    if (eType == AES_ENCRYPT)
    {
        // 已登录采用 AES 加密
//        [serializer setValue:[LswuyouLoginManager shareManager].loginInfo.userKey  forHTTPHeaderField:@"uk"];
    
    }
    else if (eType == RSA_ENCRYPT)
    {
        // 未登录采用 RSA 加密
    }
    
    return serializer;
}

/**加密方式(分两种)*/
+ (NSString *)encodeQueryString:(NSString *)queryString eType:(NSInteger)eType key:(NSString *)key
{
    
    if (eType == AES_ENCRYPT)
    {
        // 已登录采用 AES 加密
        NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
        NSData *queryData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *aesEncryptedData = [queryData AES256EncryptWithKey:keyData];
        NSString *aesEncryptedString = [aesEncryptedData base64EncodedString];
        
        return aesEncryptedString;
    }
    else if (eType == RSA_ENCRYPT)
    {
        // 未登录采用 RSA 加密
        NSString *rsaEncryptedString = [RsaEncryption RSAEncrypotoTheData:[NSString stringWithFormat:@"%@&aesKey=%@", queryString, key] RSAEncrypotoSpliter:@"#PART#"];
        
        return rsaEncryptedString;
        
    }
    else
    {
        // eType == NO_ENCRYPT 未加密时直接返回原值
        return queryString;
    }
    
    return nil;
}

/**
 eType == 1: RSA 加密
 eType == 2：AES 加密
 */
+ (AFHTTPSessionManager *)post:(NSString *)baseUrl params:(NSDictionary *)params eType:(NSInteger)eType completion:(void (^)(NSDictionary *object, NSInteger code))completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [self initHttpHeaderFiled:eType];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    
    
    //系统参数
    NSString *queryString = [self queryStringWithType:eType];
    
    /**
     *  key为AESKey
     */
    NSString *key = nil;
    
    switch (eType)
    {
        case NO_ENCRYPT: //明文
            break;
            
        case AES_ENCRYPT: //用于登录后
            /*获取ase解密密钥*/
            break;
            
        case RSA_ENCRYPT: //用于登录前
        {
            
            char singleLetter[32];
            for (int x=0; x<32; singleLetter[x++] = (char)('A' + (arc4random_uniform(26))));
            NSString *randomString = [[NSString alloc] initWithBytes:singleLetter length:32 encoding:NSUTF8StringEncoding];
            key = [randomString md5];
        }
            break;
            
        default:
            break;
    }
    
    // 加密 queryString(2种加密类习惯)
    NSString *encodeString = [self encodeQueryString:queryString eType:eType key:key];
    NSString *encodeQueryUrl = encodeString;
    
    //  加密 param
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *myStr = [NSMutableString string];
    
    //循环将业务参数重新变成字符串后加密
    if (params != nil)
    {
        
        int count = 1;
        for (NSString *key in params) {
            
            NSString *valueStr = nil;
            id keyObject = [params objectForKey:key];
            //                    对于不同类型做不同的处理
            if ([keyObject isKindOfClass:[NSString class]]) {
                
                valueStr = keyObject;
                
            }else if ([keyObject isKindOfClass:[NSNumber class]]){
                
                NSNumber *numObject = keyObject;
                valueStr = [NSString stringWithFormat:@"%ld",[numObject longValue]];
                
            }else{
                
                //                     直接发送不进行urlencode
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:keyObject options:kNilOptions error:nil];
                
                valueStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                valueStr = [valueStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                NSLog(@"%@",valueStr);
            }
            
            //空字符处理和添加&符号
            if (valueStr !=nil && ![valueStr  isEqual:@""] ) {
                valueStr = [NetworkingUtil urlEncode:valueStr];
                NSString *valueAndKeyStr = [NSString stringWithFormat:@"%@=%@",key,valueStr];
                [myStr appendString:valueAndKeyStr];
                
                if (count != params.count) {
                    [myStr appendString:@"&"];
                }
            }
            count ++;
        }
        
        
        
        /**
         *  对系统参数，进行AES加密
         */
        NSData *queryData = [myStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData *aesEncryptedData = [queryData AES256EncryptWithKey:keyData];
        NSString *aesEncryptedString = [aesEncryptedData base64EncodedString];
        
        
        
        /**
         *  将系统参数和业务参数放入字典
         */
        if (eType == NO_ENCRYPT) {
            paramDic = nil;
        }else{

            [paramDic setObject:encodeQueryUrl forKey:@"s"];
            [paramDic setObject:aesEncryptedString forKey:@"data"];
        }
        
    }
    
    // 把 keyData(MD5加密后的AESKey，类型为Data) 值传入以下block中
    __block NSData *blockKeyData = [NSData dataWithData:keyData];
  
    [manager POST:baseUrl parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        // resultCode > 0是成功, 0请求失败, -1提示需登录，
        NSDictionary *responseDic;
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)task.response;
        //响应头
        NSString *encryptType = httpURLResponse.allHeaderFields[@"data-type"];
        
        if (encryptType.intValue == AES_ENCRYPT)
        {
            // 对 encodeString 用 AES 解密
            NSString *encodeString = ((NSDictionary *)responseObject)[@"data"];
            NSData *encryptData = [NSData dataFromBase64String:encodeString];
            NSData *decryptData = [encryptData AES256DecryptWithKey:blockKeyData];
            
            NSString *reslutString =[[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
            //  NSLog(@"reslutString----->%@",reslutString);
            
            NSError *err;
            responseDic = [ NSJSONSerialization JSONObjectWithData :[[self dealJsonStr:reslutString] dataUsingEncoding : NSUTF8StringEncoding ] options : NSJSONReadingMutableLeaves error :&err];
            
        }else{
            // encodeString 不需解密，直接传递明文
            responseDic = (NSDictionary *)responseObject;
        }

        
        NSNumber *resultCode = responseDic[@"code"];
        int resultCodeValue = resultCode.intValue;
        if (completion) {
            completion(responseDic,resultCodeValue);
        }
        
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              
              NSString *netType = [[LswuyouNetWorkObserver netWorkObserverShare] getNetWorkType];
              if ([netType isEqualToString:@"unknown"])
              {
                  // 网络无连接错误
                  NSDictionary *response = [[NSDictionary alloc] initWithObjectsAndKeys:@"当前无网络连接",@"message", @"0", @"resultCode", nil];
                  if (completion) {
                      completion(response, 10000);
                  }
              }
              else
              {
                  // 别的未知错误
                  if (completion) {
                      completion(nil, 10000);
                  }
              }
          }];
    
    return manager;
}

+(NSString *)dealJsonStr:(NSString *)jsonStr
{
    if([NetworkingUtil isEmpty:jsonStr]){
        return jsonStr;
    }
    NSMutableString *s = [NSMutableString stringWithString:jsonStr];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"~" withString:@"~" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    return [NSString stringWithString:s];
    
}


#pragma mark - 普通下载
+(void)downloadWithRequest:(NSString *)requestUrl andFileName:(NSString *)fileName
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:nil destination:^ NSURL * (NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *publicDirectoryURL = [documentDirectoryURL URLByAppendingPathComponent:Cache_file];
        return [publicDirectoryURL URLByAppendingPathComponent:fileName];
        
    } completionHandler:^ void(NSURLResponse * response, NSURL * filePath, NSError * error) {
        NSLog(@"download region file to %@",filePath);
    }];
    
    [downloadTask resume];
}

#pragma mark - setter&&getter
+ (NSString *)queryStringWithType:(NSInteger)eType{
    
    NSString *queryString = nil;
    if (eType == NO_ENCRYPT) {
        //未加密的方式无需任何参数
        queryString = [[NSString alloc] init];
        
    }else
    {
        
        NSString *time = nil;
        NSString *deviceId = nil;
        
        queryString = [NSString stringWithFormat:@"t=%@&d=%@", time, deviceId];
    }
    
    return queryString;
}

@end
