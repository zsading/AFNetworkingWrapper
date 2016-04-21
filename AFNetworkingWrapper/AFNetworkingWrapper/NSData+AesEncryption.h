//
//  NSData+AesEncryption.h
//  AFNetworkingWrapper
//
//  Created by yoanna on 16/4/20.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AesEncryption)

-(NSData *)AES256EncryptWithKey:(NSData *)key; //加密
-(NSData *)AES256DecryptWithKey:(NSData *)key; //解密

@end
