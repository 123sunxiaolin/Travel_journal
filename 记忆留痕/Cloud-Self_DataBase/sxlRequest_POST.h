//
//  sxlRequest_POST.h
//  LBS云存储自学DEMO
//
//  Created by kys-2 on 14-9-8.
//  Copyright (c) 2014年 sxl. All rights reserved.
//
#import <Foundation/Foundation.h>
/*创建网络共享的单例类，主要应用于网络的POST请求*/
@interface sxlRequest_POST : NSObject
+ (id)sharedInstance;
//创建表的方法
/*
 *@param params  包含创建表所需要的Value
 @pramas  返回值  创建数据表的反馈信息
 */

//创建列的方法
/*
 *@param params  包含创建列所需要的Value
 @pramas  返回值  创建数据列的反馈信息
 */
//修改表
/*
 *@param params  包含创建列所需要的Value
 @pramas  返回值  创建数据列的反馈信息
 */
-(NSDictionary *)LBS_POST_RequestWithParams:(NSDictionary *)params RequestURl:(NSString *)url RequestType:(int )type;
@end
