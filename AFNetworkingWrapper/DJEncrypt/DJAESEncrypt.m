//
//  DJAESEncrypt.m
//  AFNetworkingWrapper
//
//  Created by 丁嘉 on 16/7/12.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "DJAESEncrypt.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation DJAESEncrypt

- (NSData *)AES256EncryptWithKey:(NSData *)key self:(NSData *)selfKey{
    
    //AES256 encode，The private key should be 32 bits
    //    const void * keyPtr2 = [key bytes];
    //    char (*keyPtr)[32] = keyPtr2;
    
    //For block encryption algorithm, the output size is always equal to or less than the input size and the size of a block
    //So we need to plus the size of a block
    NSUInteger dataLength = [selfKey length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key bytes], kCCKeySizeAES256,
                                          NULL,[selfKey bytes], dataLength,/*input*/
                                          buffer, bufferSize,/* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);//free buffer
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSData *)key self:(NSData *)selfKey{
    //AES256 decode，The private key should be 32 bits
    const void * keyPtr2 = [key bytes];
    const char (*keyPtr)[32] = keyPtr2;
    
    //For block encryption algorithm, the output size is always equal to or less than the input size and the size of a block
    //So we need to plus the size of a block
    NSUInteger dataLength = [selfKey length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,[selfKey bytes], dataLength,/* input */
                                          buffer, bufferSize,/* output */
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end
