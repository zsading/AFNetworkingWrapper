//
//  NetworkingUtil.m
//  AFNetworkingWrapper
//
//  Created by yoanna on 16/4/20.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import "NetworkingUtil.h"

@implementation NetworkingUtil

+ (NSString *)urlEncode:(NSString *)urlString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)urlString,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}

+ (NSString *)urlDecode:(NSString *)urlString
{
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)urlString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


+ (BOOL)isEmpty:(id)str
{
    if (str == nil || [@"" isEqual:str] || [[NSNull null] isEqual:str] || [@"null" isEqualToString:str] || [@"(null)" isEqualToString:str]) {
        return YES;
    }
    return NO;
}
@end
