//
//  sxlRequest_GET.h
//  LBS云存储自学DEMO
//
//  Created by kys-2 on 14-9-9.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <Foundation/Foundation.h>
/*创建网络共享的单例类，主要应用于网络的GET请求*/
@interface sxlRequest_GET : NSObject
+ (id)sharedInstance;
-(NSDictionary *)LBS_GET_RequestWithRequestURl:(NSString *)url;
//-(UIImage *)getImageFromURL:(NSString *)url;
@end
