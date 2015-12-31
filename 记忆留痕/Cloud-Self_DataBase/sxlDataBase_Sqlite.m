//
//  sxlDataBase_Sqlite.m
//  LBS云存储自学DEMO
//
//  Created by kys-2 on 14-9-10.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "sxlDataBase_Sqlite.h"
#import "iToast.h"
static sxlDataBase_Sqlite* _sxlDataBase_Sqlite = nil;
@interface sxlDataBase_Sqlite()
{
    sqlite3 *dataBase;
}

@end
@implementation sxlDataBase_Sqlite
+(id)sharedInstance
{//创建单例类
    if (_sxlDataBase_Sqlite) return _sxlDataBase_Sqlite;
	return _sxlDataBase_Sqlite = [[self alloc] init];
}
-(NSString *)DataBase_Path
{
    NSArray * myPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,
                                                             NSUserDomainMask, YES); NSString * myDocPath = [myPaths objectAtIndex:0];
    NSString *filename = [myDocPath stringByAppendingPathComponent:@"sxl.sqlite"];
    return filename;

}
-(void)sxl_CreateTableOnDataBaseWithType:(NSString *)type
{
    @try {
        NSString *fileName=[self DataBase_Path];
        if (sqlite3_open([fileName UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
        } else {
            char *err;
            NSString *createSQL;
            if ([type isEqualToString:@"content"]) {
                //创建title-content表
                createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@  TEXT PRIMARY KEY,%@ TEXT);" ,
                             TABLE1,FOOT_TITLE,FOOT_CONTENT];
            }else if ([type isEqualToString:@"record"])
            {//创建title-record表
                createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID TEXT PRIMARY KEY, %@ TEXT, %@ TEXT);" ,
                             TABLE2,FOOT_TITLE,FOOT_FILE_RECORD];
            }else if ([type isEqualToString:@"all"])
            {//主表******正在使用
                createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT);" ,
                             TABLE,FOOT_TITLE,FOOT_CONTENT, FOOT_FILE_RECORD];
            }else if ([type isEqualToString:@"images"])
            {//图片路径表
                createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT,%@ TEXT);" ,
                             IMAGETABLE,FOOT_TITLE, FOOT_IMAGEURL];
            }
            else if([type isEqualToString:@"imagedata"])
            {//创建title-image表******正在使用
                createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ BLOB);" ,
                             TABLE3,FOOT_TITLE,FOOT_IMAGE];
            }
            
            if (sqlite3_exec(dataBase,[createSQL UTF8String],NULL,NULL,&err) != SQLITE_OK)
            {
                sqlite3_close(dataBase);
             }else
                 
            {
                NSLog(@"创建表成功");
            }
            sqlite3_close(dataBase);
        }

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"创建表 错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"正在创建数据表");
    }
    
}
#pragma mark------------插入数据----正在使用
-(BOOL)insertDataToDatabaseWithTitle:(NSString *)title content:(NSString *)content RecordURL:(NSString *)url//主要的一个表
{
    
    @try {
        BOOL IsSuccess;
        NSString *filename = [self DataBase_Path];
        NSLog(@"%@",filename);
        if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
            
        } else {
            
            NSString *sqlStr = [NSString stringWithFormat: @"INSERT OR REPLACE INTO %@ (%@, %@ , %@) VALUES (?,?,?)",
                                TABLE, FOOT_TITLE,FOOT_CONTENT,FOOT_FILE_RECORD];//取消约束冲突
            sqlite3_stmt *statement;
            //预处理过程
            if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                IsSuccess=YES;
                //绑定参数开始
                sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);//标题
                sqlite3_bind_text(statement, 2, [content UTF8String], -1, NULL);//内容
                sqlite3_bind_text(statement, 3, [url UTF8String], -1, NULL);
                //执行插入
                //int i=sqlite3_step(statement);
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    //NSAssert(0, @"插入数据失败。");
                    IsSuccess=NO;
                }else
                {
                    IsSuccess=YES;
                }
            }else
            {
                IsSuccess=NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
        return IsSuccess;
    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"插入数据 错误:%@",exception] duration:800];

    }
    @finally {
        NSLog(@"正在插入数据");
    }
    }
-(BOOL)insertImagesToDatabaseWithTitle:(NSString *)title image_urls:(NSArray *)images
{//插入图片数据
    BOOL IsSuccess=YES;
    for (int i=0; i<[images count]; i++) {
    
    NSString *filename = [self DataBase_Path];
	NSLog(@"%@",filename);
	if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
		sqlite3_close(dataBase);
		NSAssert(NO,@"数据库打开失败。");
        
    } else {
		
		NSString *sqlStr = [NSString stringWithFormat: @"INSERT OR REPLACE INTO %@ ( %@ ,%@) VALUES (?,?)",
							IMAGETABLE, FOOT_TITLE,FOOT_IMAGEURL];
 		sqlite3_stmt *statement;
  		//预处理过程
		if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            IsSuccess=YES;
            //循环插入
                       //绑定参数开始
			sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);//标题
			sqlite3_bind_text(statement, 2, [[images objectAtIndex:i] UTF8String], -1, NULL);//图片urls
            //执行插入
            //int state=sqlite3_step(statement);
			if (sqlite3_step(statement) != SQLITE_DONE) {
				//NSAssert(0, @"插入数据失败。");
            }
		}else
        {
            IsSuccess=NO;
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(dataBase);
    
    }
   return IsSuccess;
}
#pragma mark-----------正在使用  插入压缩数据
-(BOOL)insertimageDatasToDatabaseWithTitle:(NSString *)title  imageDatas:(NSArray *)datas
{//存入图片的二进制流
    BOOL IsSuccess=YES;
    @try {
        
        for (int i=0; i<[datas count]; i++) {
            
            NSString *filename = [self DataBase_Path];
            NSLog(@"%@",filename);
            if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
                sqlite3_close(dataBase);
                NSAssert(NO,@"数据库打开失败。");
                
            } else {
                
                NSString *sqlStr = [NSString stringWithFormat: @"INSERT OR REPLACE INTO %@ ( %@ ,%@) VALUES (?,?)",
                                    TABLE3, FOOT_TITLE,FOOT_IMAGE];
                sqlite3_stmt *statement;
                //预处理过程
                if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    IsSuccess=YES;
                    //循环插入
                    //绑定参数开始
                    sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);//标题
                    NSData *data=[datas objectAtIndex:i];
                    //int len=data.length;
                    sqlite3_bind_blob(statement, 2, [data bytes],[data length] , NULL);
                    //sqlite3_bind_blob(statement, 2, [[datas objectAtIndex:i] UTF8String], -1, NULL);//图片urls
                    //执行插入
                    //int state=sqlite3_step(statement);
                    if (sqlite3_step(statement) != SQLITE_DONE) {
                        //NSAssert(0, @"插入数据失败。");
                    }
                }else
                {
                    IsSuccess=NO;
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(dataBase);
            
        }
       

    }
    @catch (NSException *exception) {
         [iToast make:[NSString stringWithFormat:@"插入数据 错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"插入图片数据");
    }
     return IsSuccess;
}

-(void)insertDataToDataBaseWithTitle:(NSString *)title Contents:(NSString *)content {
    NSString *filename = [self DataBase_Path];
	NSLog(@"%@",filename);
	if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
		sqlite3_close(dataBase);
		NSAssert(NO,@"数据库打开失败。");
	
    } else {
		
		NSString *sqlStr = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@) VALUES (?,?)",
							TABLE1, FOOT_TITLE,FOOT_CONTENT];
       /* char * errorMsg;
        int state = sqlite3_exec(dataBase,[sqlStr UTF8String], NULL, NULL, &errorMsg);
        if (state == SQLITE_OK) {
            NSLog(@"插入数据成功");
        }*/
		sqlite3_stmt *statement;
        //int i=sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL);
		//预处理过程
		if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);//标题
			sqlite3_bind_text(statement, 2, [content UTF8String], -1, NULL);//内容
            int i=sqlite3_step(statement);
                NSLog(@"1111111=%d",i);
            //执行插入
			if (sqlite3_step(statement) != SQLITE_DONE) {
				//NSAssert(0, @"插入数据失败。");
			}
		}else
        {
            NSLog(@"数据库预处理失败!");
        }
		
		sqlite3_finalize(statement);
		sqlite3_close(dataBase);
        
		
	
    }
}
-(void)insertDataToDataBaseWithTitle:(NSString *)title RecordURL:(NSString *)url
{
    NSString *filename = [self DataBase_Path];
	NSLog(@"%@",filename);
	if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
		sqlite3_close(dataBase);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		
		NSString *sqlStr = [NSString stringWithFormat: @"INSERT OR REPLACE INTO %@ (%@, %@,) VALUES (?,?)",
							TABLE2, FOOT_TITLE, FOOT_FILE_RECORD];
		
		sqlite3_stmt *statement;
		//预处理过程
		if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);//标题
			sqlite3_bind_text(statement, 2, [url UTF8String], -1, NULL);//录音的路径
            //执行插入
			if (sqlite3_step(statement) != SQLITE_DONE) {
				NSAssert(0, @"插入数据失败。");
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(dataBase);
		
	}

}
-(void)insertDataToDataBaseWithTitle:(NSString *)title ImageData:(NSData *)imagedata
{
    NSString *filename = [self DataBase_Path];
	NSLog(@"%@",filename);
	if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
		sqlite3_close(dataBase);
		NSAssert(NO,@"数据库打开失败。");
	} else {
		
		NSString *sqlStr = [NSString stringWithFormat: @"INSERT OR REPLACE INTO %@ (%@, %@,) VALUES (?,?)",
							TABLE2, FOOT_TITLE, FOOT_IMAGE];
		
		sqlite3_stmt *statement;
		//预处理过程
		if (sqlite3_prepare_v2(dataBase, [sqlStr UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			//绑定参数开始
			sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);//标题
			//sqlite3_bind_blob(statement, 2, [imagedata bytes], [imagedata length], NULL);//图片的数据
            //执行插入
			if (sqlite3_step(statement) != SQLITE_DONE) {
				NSAssert(0, @"插入数据失败。");
			}
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(dataBase);
		
	}

    
}
#pragma mark------------查询数据---正在使用
-(NSDictionary *)QueryContent_RecordUrlWithTitle:(NSString *)title
{
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    NSString *content;
    NSString *recordURL;
    @try {
        NSString *filename = [self DataBase_Path];
        NSLog(@"%@",filename);
        if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
        } else {
            NSString *qsql;
            qsql = [NSString stringWithFormat: @"SELECT %@ ,%@ FROM %@ where %@ = ?", FOOT_CONTENT,FOOT_FILE_RECORD, TABLE, FOOT_TITLE];
            NSLog(@"%@",qsql);
            sqlite3_stmt *statement;
            //预处理过程
            if (sqlite3_prepare_v2(dataBase, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                //绑定参数开始
                sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                //执行
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    char *contentStr = (char *) sqlite3_column_text(statement, 0);
                     char *url = (char *) sqlite3_column_text(statement, 1);
                    content=[[NSString alloc]initWithUTF8String:contentStr];
                   NSString *testStr=[[NSString alloc]initWithUTF8String:url];
                    if (testStr.length) {
                         recordURL=[[NSString alloc]initWithUTF8String:url];
                    }else
                    {
                        //char *str="NO";
                        recordURL=[NSString stringWithFormat:@"无"];
                    }
                    NSLog(@"recordurl===%@",recordURL);
                    [dataDic setValue:content forKey:FT_CONTENT];
                    [dataDic setValue:recordURL forKey:FT_RECORD_URL];
                    NSLog(@"333333=%@",dataDic);
                
                }
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
        }
        return dataDic;
        
    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"查询数据 错误:%@",exception] duration:800];
        
    }
    @finally {
        NSLog(@"正在查询数据");
    }

    
}
-(NSString *)QueryDataOnDataBaseWithTitle:(NSString *)title tag:(NSString *)tag
{//查询内容
    @try {
        NSString *data;
        NSString *filename = [self DataBase_Path];
        NSLog(@"%@",filename);
        if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
        } else {
            NSString *qsql;
            if ([tag isEqualToString:@"content"]) {
                qsql = [NSString stringWithFormat: @"SELECT %@ FROM %@ where %@ = ?", FOOT_IMAGEURL, IMAGETABLE, FOOT_TITLE];
            }else  if ([tag isEqualToString:@"content"])
            {
                qsql = [NSString stringWithFormat: @"SELECT %@ FROM %@ where %@ = ?", FOOT_FILE_RECORD, TABLE2, FOOT_TITLE];
            }
            NSLog(@"%@",qsql);
            sqlite3_stmt *statement;
             //预处理过程
            if (sqlite3_prepare_v2(dataBase, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                //绑定参数开始
                sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                //sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                //执行
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    char *content = (char *) sqlite3_column_text(statement, 0);
                    //char *test = (char *) sqlite3_column_text(statement, 1);
                    data=[[NSString alloc]initWithUTF8String:content];
                    NSLog(@"333333=%@",data);
                }
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
        }
        return data;

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"查询数据 错误:%@",exception] duration:800];

    }
    @finally {
        NSLog(@"正在查询数据");
    }
    }
-(NSMutableArray *)QueryImageDataOnDataBaseWithTitle:(NSString *)title
{
    @try {
        NSMutableArray *dataArr=[[NSMutableArray alloc]init];
        // NSString *data;
        NSString *filename = [self DataBase_Path];
        NSLog(@"%@",filename);
        if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
        } else {
            
            
            NSData* data = nil;
            NSString* sqliteQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?",FOOT_IMAGE,TABLE3,FOOT_TITLE];
            sqlite3_stmt* statement;
            // int state=sqlite3_prepare_v2(dataBase, [sqliteQuery UTF8String], -1, &statement, NULL);
            if( sqlite3_prepare_v2(dataBase, [sqliteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK )
            {//  if/while has different functions
                //绑定参数开始
                sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                while( sqlite3_step(statement) == SQLITE_ROW )
                {
                    int length = sqlite3_column_bytes(statement, 0);
                    data = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
                    
                    UIImage *image=[UIImage imageWithData:data];
                    [dataArr addObject:image];
                    NSLog(@"4444=%d",[dataArr count]);
                }
                
            }
            
            // Finalize and close database.
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        return dataArr;

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];

    }
    @finally {
        NSLog(@"正在查看图片数据");
    }
    }

/*-(NSData *)QueryImageDataOnDataBaseWithTitle:(NSString *)title
{
    NSData* data = nil;
    NSString* sqliteQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",FOOT_IMAGE,TABLE3,FOOT_TITLE,title];
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(dataBase, [sqliteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
        if( sqlite3_step(statement) == SQLITE_ROW )
        {
            int length = sqlite3_column_bytes(statement, 0);
            data = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
        }
    }
    
    // Finalize and close database.
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return data;
}*/
-(void)deleteDataWithTitle:(NSString *)title content:(NSString *)content
{
    NSString *filename = [self DataBase_Path];
	NSLog(@"%@",filename);
	if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
		sqlite3_close(dataBase);
		NSAssert(NO,@"数据库打开失败。");
	} else {
         NSString* sqliteDelete = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ?",TABLE1,FOOT_TITLE,FOOT_CONTENT];
        //将SQL语句放入sqlite3_stmt中
        sqlite3_stmt *statement;
        int success = sqlite3_prepare_v2(dataBase, [sqliteDelete UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to delete:testTable");
            sqlite3_close(dataBase);
        }
        
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
        sqlite3_bind_text(statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [content UTF8String], -1, SQLITE_TRANSIENT);
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to delete the database with message.");
            //关闭数据库
            sqlite3_close(dataBase);
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(dataBase);
    }

}
-(BOOL)judgeStatusForHaving_Photos:(NSString *)title
{
    BOOL IsHasPic;
    @try {
        // NSMutableArray *dataArr=[[NSMutableArray alloc]init];
        // NSString *data;
        NSString *filename = [self DataBase_Path];
        NSLog(@"%@",filename);
        if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
        } else {
            
            
            NSData* data = nil;
            NSString* sqliteQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?",FOOT_IMAGE,TABLE3,FOOT_TITLE];
            sqlite3_stmt* statement;
            // int state=sqlite3_prepare_v2(dataBase, [sqliteQuery UTF8String], -1, &statement, NULL);
            if( sqlite3_prepare_v2(dataBase, [sqliteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK )
            {//  if/while has different functions
                //绑定参数开始
                
                sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                if( sqlite3_step(statement) == SQLITE_ROW )
                {
                    IsHasPic=YES;
                    int length = sqlite3_column_bytes(statement, 0);
                    data = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
                    
                   // UIImage *image=[UIImage imageWithData:data];
                    //[dataArr addObject:image];
                    //NSLog(@"4444=%d",[dataArr count]);
                }else
                {
                    IsHasPic=NO;
                }
                
                
            }else
            {
                IsHasPic=NO;
            }
            
            // Finalize and close database.
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
        }
        return IsHasPic;
        
    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
        
    }
    @finally {
        NSLog(@"正在查看图片数据");
    }
}
-(BOOL)judgestatusforhave_recordOrcontent:(NSString *)title{
    BOOL Ishas;
    //NSString *content;
   // NSString *recordURL;
    @try {
        NSString *filename = [self DataBase_Path];
        NSLog(@"%@",filename);
        if (sqlite3_open([filename UTF8String], &dataBase) != SQLITE_OK) {
            sqlite3_close(dataBase);
            NSAssert(NO,@"数据库打开失败。");
        } else {
            NSString *qsql;
            qsql = [NSString stringWithFormat: @"SELECT %@ ,%@ FROM %@ where %@ = ?", FOOT_CONTENT,FOOT_FILE_RECORD, TABLE, FOOT_TITLE];
            NSLog(@"%@",qsql);
            sqlite3_stmt *statement;
            //预处理过程
            if (sqlite3_prepare_v2(dataBase, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                //绑定参数开始
                sqlite3_bind_text(statement, 1, [title UTF8String], -1, NULL);
                //执行
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    Ishas=YES;
                   /* char *contentStr = (char *) sqlite3_column_text(statement, 0);
                    char *url = (char *) sqlite3_column_text(statement, 1);
                    content=[[NSString alloc]initWithUTF8String:contentStr];
                    NSString *testStr=[[NSString alloc]initWithUTF8String:url];
                    if (url) {
                        recordURL=[[NSString alloc]initWithUTF8String:url];
                    }else
                    {
                        //char *str="NO";
                        recordURL=[NSString stringWithFormat:@"无"];
                    }
                    NSLog(@"recordurl===%@",recordURL);
                  */
                    
                }else
                {
                    Ishas=NO;
                }
            }else
            {
                Ishas=NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
        }
        return Ishas;
        
    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"查询数据 错误:%@",exception] duration:800];
        
    }
    @finally {
        NSLog(@"正在查询数据");
    }

}

@end
