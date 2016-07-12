//
//  DJAESEncrypt.h
//  AFNetworkingWrapper
//
//  Created by 丁嘉 on 16/7/12.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJAESEncrypt : NSObject

- (NSData *)AES256EncryptWithKey:(NSData *)key self:(NSData *)selfKey; //AES encode
- (NSData *)AES256DecryptWithKey:(NSData *)key self:(NSData *)selfKey; //AES decode

@end
