//
//  LswuyouNetWorkObserver.h
//  lswuyou
//
//  Created by yoanna on 15/8/18.
//  Copyright (c) 2015年 yoanna. All rights reserved.
//

#import <Foundation/Foundation.h>

//net changed 网络变化通知
#define NET_CHANGED_NOTIFICATION   @"NetChangedNotification"

typedef enum {
    
    NETWORK_TYPE_NONE= 0,
    
    NETWORK_TYPE_2G= 1,
    
    NETWORK_TYPE_3G= 2,
    
    NETWORK_TYPE_4G= 3,
    
    NETWORK_TYPE_WIFI= 5,
    
}NETWORK_TYPE;

static NSString * NetChangedNotification = @"NetChangedNotification";

static int netStatus = 0;


@interface LswuyouNetWorkObserver : NSObject

@property (nonatomic,strong) NSTimer *repeatingTimer;

/**
 *  单例返回
 *
 *  @return 返回单例对象
 */
+ (LswuyouNetWorkObserver *)netWorkObserverShare;

+ (BOOL)networkAvailable;

- (int)dataNetworkTypeFromStatusBar;

/**
 *  获取网络类型
 */
- (NSString *)getNetWorkType;

- (void)startListening;
- (void)stopListening;


@end
