//
//  LswuyouNetWorkObserver.m
//  lswuyou
//
//  Created by yoanna on 15/8/18.
//  Copyright (c) 2015年 yoanna. All rights reserved.
//

#import "LswuyouNetWorkObserver.h"


@implementation LswuyouNetWorkObserver

+ (LswuyouNetWorkObserver *)netWorkObserverShare
{
    static LswuyouNetWorkObserver *shareObserver;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObserver = [[LswuyouNetWorkObserver alloc] init];
    });
    
    return shareObserver;
}

+ (BOOL)networkAvailable
{
    LswuyouNetWorkObserver *observer = [[LswuyouNetWorkObserver alloc] init];
    NETWORK_TYPE network_type = [observer dataNetworkTypeFromStatusBar];
    if (network_type == NETWORK_TYPE_NONE) {
        return NO;
    }
    return YES;
}

- (int)dataNetworkTypeFromStatusBar {
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            
            dataNetworkItemView = subview;
            
            break;
            
        }
        
    }
    
    int netType = NETWORK_TYPE_NONE;
    
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil)
    {
        netType = NETWORK_TYPE_NONE;
        
    }
    else
    {
        
        int n = [num intValue];
        
        if (n == 0) {
            
            netType = NETWORK_TYPE_NONE;
            
        }else if (n == 1){
            
            netType = NETWORK_TYPE_2G;
            
            
        }else if (n == 2){
            
            netType = NETWORK_TYPE_3G;
            
        }else if (n == 3){
            
            netType = NETWORK_TYPE_4G;
            
        }
        else{
            
            netType = NETWORK_TYPE_WIFI;
            
        }
    }
    
    if (netStatus != netType)
    {
        netStatus = netType;
        [[NSNotificationCenter defaultCenter] postNotificationName:NET_CHANGED_NOTIFICATION object:@(netType)];
    }
    
    return netType;
    
}

- (NSString *)getNetWorkType
{
    
    //该方法有待改进
    int netType = [self dataNetworkTypeFromStatusBar];
    
    if (netType == 0) {
        
        return @"unknown";
        
    }else if (netType == 1){
        
        return @"2g";
        
    }else if (netType == 2){
        
        return @"3g";
        
    }else if (netType == 3){
        
        return @"4g";
    }
    else{
        
        return @"wifi";
    }
}

- (void)startListening
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self selector:@selector(dataNetworkTypeFromStatusBar)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    [self.repeatingTimer fire];
}

- (void)stopListening
{
    [self.repeatingTimer invalidate];
}

@end
