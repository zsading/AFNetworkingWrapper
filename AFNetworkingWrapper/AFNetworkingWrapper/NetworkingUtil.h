//
//  NetworkingUtil.h
//  AFNetworkingWrapper
//
//  Created by yoanna on 16/4/20.
//  Copyright © 2016年 dingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingUtil : NSObject


+ (NSString *)urlEncode:(NSString *)urlString;

+ (NSString *)urlDecode:(NSString *)urlString;

+ (BOOL)isEmpty:(id)str;
@end
