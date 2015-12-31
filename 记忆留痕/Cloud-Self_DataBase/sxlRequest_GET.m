//
//  sxlRequest_GET.m
//  LBS云存储自学DEMO
//
//  Created by kys-2 on 14-9-9.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "sxlRequest_GET.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "LBS_defines.h"
#import "iToast.h"
#import "SVProgressHUD.h"
static sxlRequest_GET* _sxlRequest_GET = nil;
@interface sxlRequest_GET()
{
    NSDictionary *ReturnValues_get;
}

@end
@implementation sxlRequest_GET
+(id)sharedInstance
{//单例类创建
    if (_sxlRequest_GET) return _sxlRequest_GET;
	return _sxlRequest_GET = [[self alloc] init];
}
-(NSDictionary *)LBS_GET_RequestWithRequestURl:(NSString *)url
{
    //[SVProgressHUD showWithStatus:@"正在拉取数据"];
    @try {
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setValidatesSecureCertificate:NO];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            //请求成功
            ReturnValues_get=[NSJSONSerialization JSONObjectWithData:request.responseData options: NSJSONReadingMutableContainers error:nil];
            //[SVProgressHUD showSuccessWithStatus:@"成功"];
        }];
        [request setFailedBlock:^{
            //请求失败
            NSError *error =[request error];
            NSLog(@"error=%@",error);
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startSynchronous];//同步请求
        
        

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"正在从云端获取数据");
        //[SVProgressHUD dismiss]
    }
    return ReturnValues_get;
    }

/*-(UIImage *)getImageFromURL:(NSString *)url
{
    @try {
        __block UIImage *returnImage;
        NSURL *imageUrl=[NSURL URLWithString:url];
        __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:imageUrl];
        [request setCompletionBlock:^
         {
             returnImage=[UIImage imageWithData:[request responseData]];
         }];
        return returnImage;
    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"获取图片");
    }
  
}*/
@end
