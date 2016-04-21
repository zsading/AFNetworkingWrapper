//
//  LswuyouBaseResponse.h
//  lswuyou
//
//  Created by yoanna on 15/8/18.
//  Copyright (c) 2015年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponse : NSObject

@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *resultCode;
@property (nonatomic,strong) NSDictionary *resultMap;
@property (nonatomic,strong) NSDictionary *originalDict;


- (id)modelObjectWithDict:(NSDictionary *)dict;
- (BaseResponse *)initWithDict:(NSDictionary *)dict;

// utility
- (id)objectOrNilForKey:(id)aKey fromDict:(NSDictionary *)dict;

@end
