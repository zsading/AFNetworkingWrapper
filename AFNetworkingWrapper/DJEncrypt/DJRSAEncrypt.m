//
//  DJRSAEncrypt.m
//  AFNetworkingWrapper
//
//  Created by 丁嘉 on 16/7/12.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "DJRSAEncrypt.h"
#import <Security/Security.h>

@implementation DJRSAEncrypt

//Get public Key
+(SecKeyRef)getPublicKey
{
    NSString *certPath = [[NSBundle mainBundle] pathForResource:lswuyouServerPublicKey ofType:@"der"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:certPath]){
        NSLog(@"%@", certPath);
    }
    
    SecCertificateRef myCertificate = nil;
    NSData *certificateData = [[NSData alloc] initWithContentsOfFile:certPath];
    myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    return SecTrustCopyPublicKey(myTrust);
}

//RSA encode
+(NSString *)RSAEncrypotoTheData:(NSString *)plainText RSAEncrypotoSpliter:(NSString *)spliterString
{
    NSData *spliterData = [spliterString dataUsingEncoding:NSUTF8StringEncoding];
    SecKeyRef publicKey=nil;
    publicKey=[self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    long blockSize = cipherBufferSize-11;  // 这个地方比较重要是加密问组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        long bufferSize = MIN(blockSize,[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                      initWithBytes:(const void *)cipherBuffer
                                      length:cipherBufferSize];
            
            if (i > 0)
            {
                [encryptedData appendData:spliterData];
            }
            
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@",[encryptedData base64EncodedStringWithOptions:0]];
    return encrypotoResult;
}

@end
