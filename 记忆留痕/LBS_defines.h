//
//  LBS_defines.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-11.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#ifndef _____LBS_defines_h
#define _____LBS_defines_h
//LBS云存储
#define LBS_ak @"AAwab4s5GQDGL7f59vxGGfRa"
/*****************创建表的key值(不可变)***********/
#define LBS_Create_URL @"http://api.map.baidu.com/geodata/v3/geotable/create"
#define LBS_Key_name @"name"
#define LBS_Key_geotype @"geotype"
#define LBS_Key_is_published @"is_published"
/**************创建列的key值********************/
#define LBS_Create_COlumn_URL @"http://api.map.baidu.com/geodata/v3/column/create"
#define LBS_Key_key @"key"  //column存储的属性key
#define LBS_Key_type @"type" //存储的值的类型
#define LBS_Key_geotable_id @"geotable_id"//所属于的geotable_id
#define LBS_Key_is_sortfilter_field @"is_sortfilter_field"//检索引擎的数值排序筛选字段
#define LBS_Key_is_search_field @"is_search_field"//是否检索引擎的文本检索字段
#define LBS_Key_is_index_field @"is_index_field"//是否存储引擎的索引字段
/*******************修改表key值**************/
#define LBS_Update_List_URL @"http://api.map.baidu.com/geodata/v3/geotable/update"
#define LBS_Key_id @"id"//geotable主键
/*******************修改指定列key值**************/
#define LBS_Update_Column_URL @"http://api.map.baidu.com/geodata/v3/column/update"
/*******************删除表key值**************/
#define LBS_Delete_List_URL @"http://api.map.baidu.com/geodata/v3/geotable/delete"//当geotable里面没有有效数据时，才能删除geotable
/*id	表主键	uint32	必选
 ak	用户的访问权限key	string(50)	必选。
 sn	用户的权限签名*/
/*******************删除列key值**************/
#define LBS_Delete_Column_URL @"http://api.map.baidu.com/geodata/v3/column/delete"
/***************创建数据POI*************/
#define LBS_Create_POI_URL @"http://api.map.baidu.com/geodata/v3/poi/create"
#define LBS_Key_PassWord @"PassWord"
#define LBS_Key_title @"title"//poi名称
#define LBS_Key_ADDRESS  @"address" //地址
#define LBS_Key_tags @"tags"
#define LBS_Key_latitude @"latitude"//用户上传的纬度
#define LBS_Key_longitude @"longitude"//用户上传的经度
#define LBS_Key_coord_type @"coord_type"//用户上传的坐标的类型
#define LBS_Key_columnKey @"price1"
//{column key}	用户在column定义的key/value对	开发者自定义的类型（string、int、double）	唯一索引字段需要保证唯一，否则会创建失败
/***************修改数据（poi）接口*************/
#define LBS_Update_POI_URL @"http://api.map.baidu.com/geodata/v3/poi/update"
/***************删除数据（poi）接口*************/
#define LBS_Delete_POI_URL @"http://api.map.baidu.com/geodata/v3/poi/delete"
#define LBS_Key_ids @"ids"

/******************GET****************/

/***********************查询表************/
/*
 参数名	参数含义	类型	备注
 name	geotable的名字	string(45)	可选
 ak	用户的访问权限key	string(50)	必选	*/
#define LBS_QUERY_List_URL @"http://api.map.baidu.com/geodata/v3/geotable/list"
/*****************查询指定id表***************/
/*id	指定geotable的id	int32	必选
 ak	用户的访问权限key	string(50)	必选*/
#define LBS_QUERY_IDList_URL @"http://api.map.baidu.com/geodata/v3/geotable/detail"
/*****************查询列***************/
/*name	geotable meta的属性中文名称	string(45)	可选
 key	geotable meta存储的属性key	string(45)	可选
 geotable_id	所属于的geotable_id	string(50)	必选
 ak	用户的访问权限key	string	必选*/
#define  LBS_QUERY_COLUMN_URL @"http://api.map.baidu.com/geodata/v3/column/list"
/***************查询指定id的列*************/
/*id	列的id	uint32	必选
 geotable_id	表的id	uint32	必选
 ak	用户的访问权限key	string	必选*/
#define  LBS_QUERY_IDCOLUMN_URL @"http://api.map.baidu.com/geodata/v3/column/detail"
/*******查询指定条件的数据（poi）列表*************/
/**/
#define LBS_QUERY_POI_URL @"http://api.map.baidu.com/geodata/v3/poi/list"
/*******查询指定id的数据（poi）列表*************/
/*id	poi主键	uint64	必须
 geotable_id	表主键	int32	必须
 ak	用户的访问权限key	string(50)	必选。*/
#define LBS_QUERY_IDPOI_URL @"http://api.map.baidu.com/geodata/v3/poi/detail"

/*******************sqlite************/

#define IMAGETABLE @"IMAGES"//用于存储每个人的多张图片
#define FOOT_IMAGEURL @"image_urls"
#define TABLE @"FOOT"
#define TABLE1 @"CONTENT"
#define TABLE2 @"title/record"
#define TABLE3 @"IMAGEDATA"
#define FOOT_TITLE @"title"
#define FOOT_CONTENT @"content"
#define FOOT_FILE_RECORD @"record"
#define FOOT_IMAGE @"imagedata"
#define FOOT_URL @"url"



#define FT_CONTENT @"ft_Content"//存储content的键值
#define FT_RECORD_URL @"ft_RecordUrl"//录音的存储路径



//车联网API
#define CLW_WEATHER_URL @"http://api.map.baidu.com/telematics/v3/weather?location="                     //天气预报接口
//旅游线路查询api
#define CLW_TRIP_ROUTINE_URL @"http://api.map.baidu.com/telematics/v3/travel_city?output=json&location="
//最佳风景区api
#define CLW_THE_BEST_SCENE_URL @"http://api.map.baidu.com/telematics/v3/local?output=json&number=20&sort_rule=0&location="
//热门景点介绍
#define CLW_HOTSCENE_URL @"http://api.map.baidu.com/telematics/v3/travel_attractions?output=json&ak=AAwab4s5GQDGL7f59vxGGfRa&id="
//二维码生成服务接口
#define TD_CODE_URL @"http://api.uihoo.com/qrcode/qrcode.http.php?width=150&bgc=FFFFFF&fgc=000000&logo=http://api.uihoo.com/demo/images/logo.png&logosize=0.4&el=3&format=json&string="
#endif
