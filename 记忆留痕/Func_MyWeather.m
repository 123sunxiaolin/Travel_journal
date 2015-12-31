//
//  Func_MyWeather.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-20.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "Func_MyWeather.h"
#import "defines.h"
#import "LBS_defines.h"
#import "sxlRequest_GET.h"
#import "iToast.h"
#import "SVProgressHUD.h"
#import "UIImageView+Cache.h"
#import "FutureWeatherCell.h"
#import "Toast+UIView.h"
#import "CheckWLAN.h"
@interface Func_MyWeather ()

@end

@implementation Func_MyWeather

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark--------UI
-(void)DesignWeather_headView
{
    UIImageView *weatherView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 260)];
    weatherView.backgroundColor=[UIColor clearColor];
    weatherView.image=[UIImage imageNamed:@"weather_bck"];
    
    //当前温度
    w_Current_temperate=[[UILabel alloc] initWithFrame:CGRectMake(20, 15,120, 45)];
    w_Current_temperate.backgroundColor=[UIColor clearColor];
    w_Current_temperate.textColor=[UIColor whiteColor];
    w_Current_temperate.font=[UIFont fontWithName:@"Arial-BoldMT" size:47];
    w_Current_temperate.text=@"13℃";
    
    //温度范围
    w_temperatehigh_low=[[UILabel alloc]initWithFrame:CGRectMake(150, 40, 100, 20)];
    w_temperatehigh_low.textAlignment=NSTextAlignmentLeft;
    w_temperatehigh_low.textColor=[UIColor whiteColor];
    w_temperatehigh_low.font=[UIFont systemFontOfSize:12];
    w_temperatehigh_low.text=@"14 ~ 9℃";
    //刷新按钮
    W_freshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    W_freshBtn.frame=CGRectMake(320-40, 84, 30, 30);
    [W_freshBtn setImage:[UIImage imageNamed:@"navbar_refresh"] forState:UIControlStateNormal];
    [W_freshBtn addTarget:self action:@selector(getLocationPositionForWeather) forControlEvents:UIControlEventTouchUpInside];
    
    //天气状况图标
    w_CurrentWeatherIcon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 70, 43, 30)];
    w_CurrentWeatherIcon.backgroundColor=[UIColor clearColor];
    //天气状况
    w_currentStation=[[UILabel alloc] initWithFrame:CGRectMake(75, 75, 140, 25)];
    w_currentStation.textAlignment=NSTextAlignmentLeft;
    w_currentStation.textColor=[UIColor whiteColor];
    w_currentStation.font=[UIFont fontWithName:@"Arial-BoldMT" size:17];
    w_currentStation.text=@"多云转晴";
    
    //风力情况
    w_Windstation=[[UILabel alloc]initWithFrame:CGRectMake(20, 120, 100, 20)];
    w_Windstation.textAlignment=NSTextAlignmentLeft;
    w_Windstation.textColor=[UIColor whiteColor];
    w_Windstation.font=[UIFont fontWithName:@"Arial" size:16];
    w_Windstation.text=@"南风3-4级";
    //PM 2.5
    w_PM=[[UILabel alloc]initWithFrame:CGRectMake(200, 120, 110, 20)];
    w_PM.textAlignment=NSTextAlignmentLeft;
    w_PM.textColor=[UIColor orangeColor];
    w_PM.font=[UIFont systemFontOfSize:17];
    w_PM.text=@"PM 2.5: 89";
    //日期
    w_CurrentTimeStr=[[UILabel alloc]initWithFrame:CGRectMake(20, 140, 150, 20)];
    w_CurrentTimeStr.textAlignment=NSTextAlignmentLeft;
    w_CurrentTimeStr.textColor=[UIColor whiteColor];
    w_CurrentTimeStr.font=[UIFont systemFontOfSize:14];
    w_CurrentTimeStr.text=@"2014年09月20日";
    //城市
    w_currentCity=[[UILabel alloc]initWithFrame:CGRectMake(20, 200, 100, 40)];
    w_currentCity.backgroundColor=[UIColor clearColor];
    w_currentCity.textColor=[UIColor whiteColor];
    w_currentCity.font=[UIFont fontWithName:@"Arial-BoldMT" size:30];
    w_currentCity.text=@"北京市";
    //旅游指数
    UIButton *trip_zhishu=[UIButton buttonWithType:UIButtonTypeInfoLight];
    trip_zhishu.frame=CGRectMake(ScreenWidth-40, 324-40, 30, 30);
    [trip_zhishu addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [weatherView addSubview:w_PM];
    [weatherView addSubview:w_currentCity];
    [weatherView addSubview:w_temperatehigh_low];
    [weatherView addSubview:w_CurrentTimeStr];
    [weatherView addSubview:w_Windstation];
    [weatherView addSubview:w_currentStation];
    [weatherView addSubview:w_CurrentWeatherIcon];
    [weatherView addSubview:w_Current_temperate];
    [self.view addSubview:weatherView];
    [self.view insertSubview:W_freshBtn aboveSubview:weatherView];
    [self.view insertSubview:trip_zhishu aboveSubview:weatherView];

    //未来几天天气情况
    FutureWeatherInfoTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 324, ScreenWidth, ScreenHeight-324)];
    FutureWeatherInfoTable.backgroundColor=[UIColor whiteColor];
    FutureWeatherInfoTable.delegate=self;
    FutureWeatherInfoTable.dataSource=self;
    //FutureWeatherInfoTable.scrollEnabled=NO;
    [self.view addSubview:FutureWeatherInfoTable];
}
-(void)btnClick
{
    [self.view makeToast:tripLabel];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];//当视图快消失的时候，加载视图消失
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocationPositionForWeather];
    self.view.backgroundColor=[UIColor whiteColor];
   
}
#pragma mark----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return Weather_WeatherArray.count-1;
    
}
-(CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    FutureWeatherCell *cell = (FutureWeatherCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FutureWeatherCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.userInteractionEnabled=NO;
    //if (<#condition#>) {
    //    <#statements#>
    //}
    cell.backgroundColor=[UIColor clearColor];
    //UIImageView *test=[[UIImageView alloc]init];
    //[test setImageWithRequest:[Weather_dayPictureUrlArray objectAtIndex:1]];
    //cell.imageView=test;
    //[cell.imageView setImageWithRequest:[Weather_dayPictureUrlArray objectAtIndex:indexPath.row+1]]
    [cell.F_imageView setImageWithRequest:[Weather_dayPictureUrlArray objectAtIndex:indexPath.row+1]];
    cell.temperatureLabel.text=[Weather_temperatureArray objectAtIndex:indexPath.row+1];
    cell.weather_label.text=[Weather_WeatherArray objectAtIndex:indexPath.row+1];
    cell.Windlabel.text=[Weather_windArray objectAtIndex:indexPath.row+1];
    cell.Datelabel.text=[Weather_DateArray objectAtIndex:indexPath.row+1];
   // cell.textLabel.textColor=[UIColor blackColor];
    //cell.textLabel.text=[Weather_WeatherArray objectAtIndex:indexPath.row];
        return cell;
}

#pragma mark---------------获得当前地理信息
-(void)getLocationPositionForWeather
{
    if ([CheckWLAN CheckWLAN]) {
        //有网的时候进行请求
        if ([CLLocationManager locationServicesEnabled]) { // 检查定位服务是否可用
        [SVProgressHUD showWithStatus:@"正在拉取天气数据"];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter=0.5;
        [locationManager startUpdatingLocation]; // 开始定位
    }
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"网络未连接"];
    }

    
}
#pragma mark  定位成功时调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    /////////获取位置信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // newLocation.coordinate.latitude
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0   )
         {
             NSLog(@"%@",placemarks);
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             //NSLog(@"%@",plmark.locality);
             NSString *TestStr=[[NSString alloc]init];
             TestStr=[plmark.addressDictionary valueForKey:@"State"];
             NSString *the_lastLocation=[[NSString alloc]init];
             //判断是否是直辖市
             if ([TestStr isEqualToString:@"北京市"]||[TestStr isEqualToString:@"天津市"]||[TestStr isEqualToString:@"上海市"]||[TestStr isEqualToString:@"重庆市市"]) {
                 
                 the_lastLocation=[NSString stringWithFormat:@"%@",TestStr];
                 
             }else
             {//如果不是直辖市
                 the_lastLocation=[NSString stringWithFormat:@"%@",plmark.locality];
                 
             }

             if (the_lastLocation.length) {
                 
        NSString *cityStr_UTF=[the_lastLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//对地点名称进行UTF8编码
                 
      NSString *lastURL=[NSString stringWithFormat:@"%@%@&output=json&ak=%@",CLW_WEATHER_URL,cityStr_UTF,LBS_ak];
      Weather_jsonObjects=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:lastURL];
      NSLog(@"weatherUrl====%@",lastURL);
    if (!Weather_jsonObjects.count) {
        //返回数据为空的时候
        [SVProgressHUD showErrorWithStatus:@"拉取数据失败"];
        NSLog(@"获取天气失败");
     }else
    {
    if ([[Weather_jsonObjects valueForKey:@"status"] isEqualToString:@"success"])
    {//返回请求成功
        
    [SVProgressHUD showSuccessWithStatus:@"成功"];
    [self DesignWeather_headView];//加载视图
        
    NSMutableDictionary *getDataDic=[[NSMutableDictionary alloc]init];
    NSArray *fuTureArray=[[NSArray alloc]init];
    Weather_DateArray=[[NSMutableArray alloc]init];
    Weather_dayPictureUrlArray=[[NSMutableArray alloc]init];
    Weather_nightPictureUrlArray=[[NSMutableArray alloc]init];
    Weather_temperatureArray=[[NSMutableArray alloc]init];
    Weather_WeatherArray=[[NSMutableArray alloc]init];
    Weather_windArray=[[NSMutableArray alloc]init];
        
    @try {
    getDataDic=[Weather_jsonObjects valueForKey:@"results"];
        
    w_currentCity.text=the_lastLocation;//城市
    fuTureArray=[getDataDic valueForKey:@"weather_data"];
        NSLog(@"11%@  ",[[[getDataDic valueForKeyPath:@"weather_data"] objectAtIndex:0] valueForKeyPath:@"date"]);
        Weather_DateArray=[[[getDataDic valueForKey:@"weather_data"] objectAtIndex:0] valueForKey:@"date"];//日期
       // NSLog(@"2222=%@",Weather_DateArray);
        Weather_dayPictureUrlArray=[[[getDataDic valueForKey:@"weather_data"] objectAtIndex:0] valueForKey:@"dayPictureUrl"];//白天的图片
        Weather_nightPictureUrlArray=[[[getDataDic valueForKey:@"weather_data"] objectAtIndex:0] valueForKey:@"nightPictureUrl"];//夜间的图片
        Weather_temperatureArray=[[[getDataDic valueForKey:@"weather_data"] objectAtIndex:0] valueForKey:@"temperature"];//温度差
        Weather_WeatherArray=[[[getDataDic valueForKey:@"weather_data"] objectAtIndex:0] valueForKey:@"weather"];//天气状况
        Weather_windArray=[[[getDataDic valueForKey:@"weather_data"] objectAtIndex:0] valueForKey:@"wind"];//风力情况
        
        w_temperatehigh_low.text=[Weather_temperatureArray objectAtIndex:0];//当前天气温度差
        NSLog(@"%d",w_temperatehigh_low.text.length);
        NSString *currentDateAndTemperature=[Weather_DateArray objectAtIndex:0];
       NSLog(@"%@",currentDateAndTemperature);
        if ([[Weather_temperatureArray objectAtIndex:0] length]==8) {
            w_Current_temperate.text=[[Weather_temperatureArray objectAtIndex:0] substringFromIndex:4];
        }else
        {
            w_Current_temperate.text=@"13℃";
        }
        
        /*weather change  改动位置*/
      // NSLog(@"%@",[[currentDateAndTemperature substringFromIndex:14] substringWithRange:NSMakeRange(0, 3)]);
       // w_Current_temperate.text=[[currentDateAndTemperature substringFromIndex:14] substringWithRange:NSMakeRange(0, 3)];//当前温度
       // w_CurrentTimeStr.text=[NSString stringWithFormat:@"%@ 发布",[currentDateAndTemperature substringWithRange:NSMakeRange(0, 10)]];//发布时间
        w_currentStation.text=[Weather_WeatherArray objectAtIndex:0];//当前天气
        w_Windstation.text=[Weather_windArray objectAtIndex:0];//当前风力情况
        if (![[getDataDic valueForKey:@"pm25"] count]) {
            w_PM.text=@"";
        }else
        {
            w_PM.text=[NSString stringWithFormat:@"PM 2.5: %@",[[getDataDic valueForKey:@"pm25"] objectAtIndex:0]];//PM 2.5
        }
        
        [w_CurrentWeatherIcon setImageWithRequest:[Weather_dayPictureUrlArray objectAtIndex:0]];//天气状况的图标
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(100, 340, 43, 30)];
        [icon setImageWithRequest:[Weather_WeatherArray objectAtIndex:1]];
        [self.view insertSubview:icon aboveSubview:FutureWeatherInfoTable];
        
        [FutureWeatherInfoTable reloadData];//刷新数据
        NSString *label1=[[[[getDataDic valueForKey:@"index"] objectAtIndex:0] objectAtIndex:2] valueForKey:@"zs"];//指数
        NSString *label2=[[[[getDataDic valueForKey:@"index"] objectAtIndex:0] objectAtIndex:2] valueForKey:@"des"];//描述
        tripLabel=[NSString stringWithFormat:@"%@旅游       \n 旅游指数:  %@",label1,label2];
        w_CurrentTimeStr.text=[NSString stringWithFormat:@"%@ 发布",[currentDateAndTemperature substringWithRange:NSMakeRange(0, 9)]];//发布时间
        w_currentStation.text=[Weather_WeatherArray objectAtIndex:0];//当前天气

    }
    @catch (NSException *exception) {
        NSLog(@"error=%@",exception);
    [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
        
    }
    @finally {
    NSLog(@"获取天气情况");
        
    }
    }else
        {
        NSLog(@"获取天气信息为空");
        //foot_CurrentString=[NSString stringWithFormat:@"暂无天气信息，请检查一下网络"];
                     }
                 }
             }
         }
     }];
}
// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"123===%@",[error description]);
    NSLog(@"获取天气失败");
    //foot_CurrentString=[NSString stringWithFormat:@"暂无天气信息，请检查一下网络"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
