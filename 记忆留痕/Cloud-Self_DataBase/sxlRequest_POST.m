//
//  sxlRequest_POST.m
//  LBS云存储自学DEMO
//
//  Created by kys-2 on 14-9-8.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "sxlRequest_POST.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "LBS_defines.h"
#import "iToast.h"
static sxlRequest_POST* _sxlRequest_POST = nil;
@interface sxlRequest_POST()
{
    NSDictionary *ReturnValues;//返回值
}
@end
@implementation sxlRequest_POST
+(id)sharedInstance
{//单例类创建
    if (_sxlRequest_POST) return _sxlRequest_POST;
	return _sxlRequest_POST = [[self alloc] init];
}
-(NSDictionary *)LBS_POST_RequestWithParams:(NSDictionary *)params RequestURl:(NSString *)url RequestType:(int)type
{
    @try {
        __weak ASIFormDataRequest *fromRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [fromRequest setDelegate:self];
        //设置post方式
        switch (type) {
            case 1:
            {//创建表
                [fromRequest setPostValue:[params valueForKey:LBS_Key_name] forKey:LBS_Key_name];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotype] forKey:LBS_Key_geotype];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_is_published] forKey:LBS_Key_is_published];
            }
                break;
            case 2:
            {//创建列
                [fromRequest setPostValue:[params valueForKey:LBS_Key_name] forKey:LBS_Key_name];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_key] forKey:LBS_Key_key];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_type] forKey:LBS_Key_type];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_is_sortfilter_field] forKey:LBS_Key_is_sortfilter_field];
                //[fromRequest setPostValue:[params valueForKey:LBS_Key_is_search_field] forKey:LBS_Key_is_search_field];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_is_index_field] forKey:LBS_Key_is_index_field];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotable_id] forKey:LBS_Key_geotable_id];
            }
                break;
            case 3:
            {//修改表
                [fromRequest setPostValue:[params valueForKey:LBS_Key_name] forKey:LBS_Key_name];//加name
                [fromRequest setPostValue:[params valueForKey:LBS_Key_id] forKey:LBS_Key_id];
                
            }
                break;
            case 4:
            {//修改列
                [fromRequest setPostValue:[params valueForKey:LBS_Key_name] forKey:LBS_Key_name];//可选 属性中文名称
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotable_id] forKey:LBS_Key_geotable_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_id] forKey:LBS_Key_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_type] forKey:LBS_Key_type];
                //[fromRequest setPostValue:[params valueForKey:LBS_Key_key] forKey:LBS_Key_key];
                
            }
                break;
            case 5:
            {//删除表
                [fromRequest setPostValue:[params valueForKey:LBS_Key_id] forKey:LBS_Key_id];
                
            }
                break;
            case 6:
            {//删除列
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotable_id] forKey:LBS_Key_geotable_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_id] forKey:LBS_Key_id];
                
            }
                break;
            case 7:
            {//创建POI
                [fromRequest setPostValue:[params valueForKey:LBS_Key_title] forKey:LBS_Key_title];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_ADDRESS] forKey:LBS_Key_ADDRESS];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_latitude] forKey:LBS_Key_latitude];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_longitude] forKey:LBS_Key_longitude];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_coord_type] forKey:LBS_Key_coord_type];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotable_id] forKey:LBS_Key_geotable_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_PassWord] forKey:LBS_Key_PassWord];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_columnKey] forKey:LBS_Key_columnKey];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_tags] forKey:LBS_Key_tags];
                
            }
                break;
            case 8:
            {//修改poi
                [fromRequest setPostValue:[params valueForKey:LBS_Key_title] forKey:LBS_Key_title];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotable_id] forKey:LBS_Key_geotable_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_id] forKey:LBS_Key_id];
            }
                break;
            case 9:
            {//删除指定的id的poi或者多个ids
                //[fromRequest setPostValue:[params valueForKey:LBS_Key_title] forKey:LBS_Key_title];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_geotable_id] forKey:LBS_Key_geotable_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_id] forKey:LBS_Key_id];
                [fromRequest setPostValue:[params valueForKey:LBS_Key_ids] forKey:LBS_Key_ids];
            }
                break;
                
            default:
                break;
        }
        
        [fromRequest setPostValue:LBS_ak forKey:@"ak"];
        //请求完成
        [fromRequest setCompletionBlock:^
         {//成功
             ReturnValues=[NSJSONSerialization JSONObjectWithData:fromRequest.responseData options: NSJSONReadingMutableContainers error:nil];
         }];
        [fromRequest setFailedBlock:^{//失败
            NSError *error =[fromRequest error];
            [ReturnValues setValue:error forKey:@"message"];
            NSLog(@"error=%@",error);
        }];
        [fromRequest startSynchronous];//设置同步请求
    }
    @catch (NSException *exception) {
        NSLog(@"Post_Error==%@",exception);
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
           }
    @finally {
        NSLog(@"进行云端服务器部署");
    }
   
    return ReturnValues;
}

@end
