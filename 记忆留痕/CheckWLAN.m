//
//  CheckWLAN.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-12.
//  Copyright (c) 2014年 sxl. All rights reserved.
//
#import "CheckWLAN.h"
#import "Reachability.h"
#import "iToast.h"
@implementation CheckWLAN
+(BOOL)CheckWLAN
{
    BOOL link;
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case NotReachable:
        {//未连接网络
            link=NO;
        }
            break;
        case ReachableViaWiFi:
        {
            [iToast make:@"已连接到WiFi" duration:750];
            link=YES;
        }
            break;
        case ReachableViaWWAN:
        {
            [iToast make:@"已连接到WWAN" duration:750];
            link=YES;
        }
            break;
        default:
            break;
    }
    return link;
}
@end
