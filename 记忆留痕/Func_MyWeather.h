//
//  Func_MyWeather.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-20.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface Func_MyWeather : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    //UI HeadView
    UIImageView *w_CurrentWeatherIcon;//天气图标
    UILabel *w_Current_temperate;//当前温度
    UILabel *w_temperatehigh_low;//温度差
    UILabel *w_currentStation;//当前天气状况
    UILabel *w_Windstation;//当前风力情况状况
    UILabel *w_CurrentTimeStr;//发布时间
    UILabel *w_currentCity;//当前城市
    UILabel *w_PM;//pw 2.5
    UIButton *W_freshBtn;//刷新按钮
    
    //获取数据
    //天气预报获取 当前地理信息
    CLLocationManager *locationManager;
   // NSString *foot_CurrentString;//当前位置信息
    NSDictionary *Weather_jsonObjects;//返回天气的数量
    
    //未来几天天气情况
    UITableView *FutureWeatherInfoTable;
    NSMutableArray *Weather_DateArray;//日期数组
    NSMutableArray *Weather_dayPictureUrlArray;//白天图片Url数组
    NSMutableArray *Weather_nightPictureUrlArray;//夜间图片Url数组
    NSMutableArray *Weather_WeatherArray;//相应天气情况数组
    NSMutableArray *Weather_windArray;//风力情况的数组
    NSMutableArray *Weather_temperatureArray;//温度情况数组
    NSString *tripLabel;//旅游指数

}
/*初始化视图*/
-(void)DesignWeather_headView;
/*获取当前地理位置信息*/
-(void)getLocationPositionForWeather;
/*旅游指数*/
-(void)btnClick;
@end
