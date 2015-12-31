//
//  Query.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Query : UIViewController<CLLocationManagerDelegate>
{
    //天气预报获取 当前地理信息
    CLLocationManager *locationManager;
    //存储城市名称
    NSString *CityName;
    //CLLocationCoordinate2D *LLcoordinate;//存储
    NSArray *positionArr;//存储经纬度
    
   // NSArray *itemsArray;//标题名称数组

}
/*构造多项功能的界面*/
-(void)initFunctionView;
/*功能按钮的点击事件*/
-(void)BtnOnClickedOnQueryView:(UIButton *)sender;
@end
