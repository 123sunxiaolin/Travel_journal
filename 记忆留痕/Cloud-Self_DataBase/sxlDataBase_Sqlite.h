//
//  sxlDataBase_Sqlite.h
//  LBS云存储自学DEMO
//
//  Created by kys-2 on 14-9-10.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "LBS_defines.h"
/*创建本地数据库的应用*/
@interface sxlDataBase_Sqlite : NSObject
+ (id)sharedInstance;
-(NSString *)DataBase_Path;//用于存储
/*根据不同类型创建不同的表 type=content、record、image*/
-(void)sxl_CreateTableOnDataBaseWithType:(NSString *)type;//创建数据表
/*****************插入数据******************/
-(void)insertDataToDataBaseWithTitle:(NSString *)title Contents:(NSString *)content ;//table1
-(void)insertDataToDataBaseWithTitle:(NSString *)title RecordURL:(NSString *)url;//table2
-(void)insertDataToDataBaseWithTitle:(NSString *)title ImageData:(NSData *)imagedata;//table3
-(BOOL)insertDataToDatabaseWithTitle:(NSString *)title content:(NSString *)content RecordURL:(NSString *)url ;//table
-(BOOL)insertImagesToDatabaseWithTitle:(NSString *)title image_urls:(NSArray *)images;//images
-(BOOL)insertimageDatasToDatabaseWithTitle:(NSString *)title  imageDatas:(NSArray *)datas;//imagedata  //改

/*****************查询数据********************/
-(NSMutableDictionary *)QueryContent_RecordUrlWithTitle:(NSString *)title;//用于查询content recordURL
-(NSString *)QueryDataOnDataBaseWithTitle:(NSString *)title tag:(NSString *)tag;//
//-(NSData *)QueryImageDataOnDataBaseWithTitle:(NSString *)title;//table3
-(NSMutableArray *)QueryImageDataOnDataBaseWithTitle:(NSString *)title;//table3
/*****************删除数据*******************/
-(void)deleteDataWithTitle:(NSString *)title content:(NSString *)content;
/*静态成员函数 判断是否有数据*/
-(BOOL)judgeStatusForHaving_Photos:(NSString *)title;//用于判断本地数据库是否有图片资源
-(BOOL)judgestatusforhave_recordOrcontent:(NSString *)title;//用于判断本地数据库是否含有录音或内容
@end
