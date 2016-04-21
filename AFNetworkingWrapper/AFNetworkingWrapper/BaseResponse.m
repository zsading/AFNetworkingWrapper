//
//  HYBaseResponse.m
//  lswuyou
//
//  Created by yoanna on 15/8/18.
//  Copyright (c) 2015年 yoanna. All rights reserved.
//

#import "BaseResponse.h"


NSString *const BRResultCodeKey = @"code";
//NSString *const BRErrorCodeKey = @"errorCode";
NSString *const BRMessageKey = @"msg";
NSString *const BRResultMapKey = @"data";

@implementation BaseResponse


- (id)initWithDict:(NSDictionary *)dict
{
    self = [[BaseResponse alloc] init];
    
    if (self && dict && [dict isKindOfClass:[NSDictionary class]])
    {
        self.resultCode = [NSString stringWithFormat:@"%@", [self objectOrNilForKey:BRResultCodeKey fromDict:dict]];
        self.resultMap = [self objectOrNilForKey:BRResultMapKey fromDict:dict];
        self.message = [NSString stringWithFormat:@"%@",[self objectOrNilForKey:BRMessageKey fromDict:dict]];
        self.originalDict = dict;
    }
    return self;
}
- (BaseResponse *)modelObjectWithDict:(NSDictionary *)dict
{
    return [self initWithDict:dict];
}

- (id)objectOrNilForKey:(id)aKey fromDict:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
