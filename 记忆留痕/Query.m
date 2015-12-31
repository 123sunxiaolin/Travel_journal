//
//  Query.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "Query.h"
#import "defines.h"
#import "CheckWLAN.h"
#import "iToast.h"
#import "The_Traval_routine.h"
#import "sxlRequest_GET.h"
#import "CommomThemeView.h"
@interface Query ()

@end

@implementation Query

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark----设置tab图标和文字
- (NSString *)tabImageName
{
	return @"third";
}

- (NSString *)tabTitle
{
	return @"旅行查";
}
-(void)initFunctionView
{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight)];
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.bounces=NO;
    NSArray *itemsArray1=[NSArray arrayWithObjects:@"旅游线路",@"经典美食",@"星级酒店", nil];
    NSArray *imageArray1=[NSArray arrayWithObjects:@"fral_img",@"food_img",@"restaurant_img", nil];
    NSArray *itemsArray2=[NSArray arrayWithObjects:@"最佳风景区",@"附近超市",@"美味咖啡厅", nil];
    NSArray *imageArray2=[NSArray arrayWithObjects:@"best_img",@"supermarket_img",@"coffee_img", nil];
        for (int i=0; i<3; i++) {
        //第一列的功能按钮
        UIButton *FuctBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        FuctBtn.frame=CGRectMake(40, i*140, 100, 100);
        FuctBtn.backgroundColor=[UIColor clearColor];
        [FuctBtn setImage:[UIImage imageNamed:[imageArray1 objectAtIndex:i]] forState:UIControlStateNormal];
        FuctBtn.tag=10+i;
        [FuctBtn addTarget:self action:@selector(BtnOnClickedOnQueryView:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(40, 105+i*140, 100, 30)];
        label1.textColor=[UIColor cyanColor];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.text=[itemsArray1 objectAtIndex:i];
        [scrollView addSubview:label1];
        [scrollView addSubview:FuctBtn];
    }
    
    for (int j=0; j<3; j++) {
        //第一列的功能按钮
        UIButton *FuctBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
        FuctBtn2.frame=CGRectMake(180,j*140, 100, 100);
        FuctBtn2.backgroundColor=[UIColor clearColor]
        ;
        [FuctBtn2 setImage:[UIImage imageNamed:[imageArray2 objectAtIndex:j]] forState:UIControlStateNormal];
        FuctBtn2.tag=13+j;
        [FuctBtn2 addTarget:self action:@selector(BtnOnClickedOnQueryView:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(180, 105+j*140, 100, 30)];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.textColor=[UIColor cyanColor];
        label2.text=[itemsArray2 objectAtIndex:j];
        [scrollView addSubview:label2];
        [scrollView addSubview:FuctBtn2];
    }
    if (ScreenHeight==568) {
         scrollView.contentSize=CGSizeMake(ScreenWidth, 510);
    }else
    {
         scrollView.contentSize=CGSizeMake(ScreenWidth, 600);
    }
   
    [self.view addSubview:scrollView];
}
-(void)Trip_TRal
{
    NSLog(@"123");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocationPositionForWeather];//已进入成就启动定位获取位置信息
    [self initFunctionView];//加载选项视图
    CityName=[[NSString alloc] init];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"trip_checkbck"]];
}
#pragma mark-------------click Delegate
-(void)BtnOnClickedOnQueryView:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {//旅游线路
            if ([CityName isEqualToString:@""]) {
                [self getLocationPositionForWeather];
            }else
            {//进入详细界面
                if ([CityName isEqualToString:@"(null)"]) {
                    [iToast make:@"返回数据为空，请重试" duration:1000];
                }else
                {
                The_Traval_routine *TTR=[[The_Traval_routine alloc]init];
                TTR.title=@"看线路";
                TTR.TTR_city=CityName;
                TTR.lai_long=positionArr;
                TTR.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:TTR animated:YES];
                }
            }
            
        }
            break;
        case 11:
        {//美食
            if ([CityName isEqualToString:@""]) {
                [self getLocationPositionForWeather];
            }else
            {
                CommomThemeView *common=[[CommomThemeView alloc]init];
                common.title=@"周边美食";
                common.identifer=[NSString stringWithFormat:@"美食"];
                common.lai_degree_common=[positionArr objectAtIndex:0];
                common.long_degree_common=[positionArr objectAtIndex:1];
                common.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:common animated:YES];
            }
        }
            break;
        case 12:
        {//星级酒店
            if ([CityName isEqualToString:@""]) {
                [self getLocationPositionForWeather];
            }else
            {
            CommomThemeView *common=[[CommomThemeView alloc]init];
            common.title=@"星级酒店";
            common.identifer=[NSString stringWithFormat:@"星级酒店"];
            common.lai_degree_common=[positionArr objectAtIndex:0];
            common.long_degree_common=[positionArr objectAtIndex:1];
            common.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:common animated:YES];
            }
        }
            break;
        case 13:
        {//最佳风景区
            if ([CityName isEqualToString:@""]) {
                [self getLocationPositionForWeather];
            }else
            {
                CommomThemeView *common=[[CommomThemeView alloc]init];
                common.title=@"周边风景区";
                common.identifer=[NSString stringWithFormat:@"风景区"];
                common.lai_degree_common=[positionArr objectAtIndex:0];
                common.long_degree_common=[positionArr objectAtIndex:1];
                common.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:common animated:YES];
            }
        }
            break;
        case 14:
        {//超市
            if ([CityName isEqualToString:@""]) {
                [self getLocationPositionForWeather];
            }else
            {
                CommomThemeView *common=[[CommomThemeView alloc]init];
                common.title=@"周边超市";
                common.identifer=[NSString stringWithFormat:@"超市"];
                common.lai_degree_common=[positionArr objectAtIndex:0];
                common.long_degree_common=[positionArr objectAtIndex:1];
                common.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:common animated:YES];
            }

            
        }
            break;
        case 15:
        {//找咖啡厅
            if ([CityName isEqualToString:@""]) {
                [self getLocationPositionForWeather];
            }else
            {
                CommomThemeView *common=[[CommomThemeView alloc]init];
                common.title=@"美味咖啡厅";
                common.identifer=[NSString stringWithFormat:@"咖啡厅"];
                common.lai_degree_common=[positionArr objectAtIndex:0];
                common.long_degree_common=[positionArr objectAtIndex:1];
                common.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:common animated:YES];
            }

            
        }
            break;
        default:
            break;
    }
    
}
#pragma mark---------------获得当前地理信息
-(void)getLocationPositionForWeather
{
    if ([CheckWLAN CheckWLAN]) {
        //有网的时候进行请求
        if ([CLLocationManager locationServicesEnabled]) { // 检查定位服务是否可用
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.distanceFilter=0.5;
            [locationManager startUpdatingLocation]; // 开始定位
        }
        
    }else{
        [iToast make:@"当前无网络连接" duration:1000];
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
            
             
             //获取反编码的地理信息
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             NSString *llll=[NSString stringWithFormat:@"%@",plmark.name];
             [iToast make:[NSString stringWithFormat:@"已定位到 %@",llll] duration:2200];
             NSString *TestStr=[[NSString alloc]init];
             TestStr=[plmark.addressDictionary valueForKey:@"State"];
             //判断是否是直辖市
             if ([TestStr isEqualToString:@"北京市"]||[TestStr isEqualToString:@"天津市"]||[TestStr isEqualToString:@"上海市"]||[TestStr isEqualToString:@"重庆市市"]) {
                 
                 CityName=[NSString stringWithFormat:@"%@",TestStr];

             }else
             {//如果不是直辖市
                 CityName=[NSString stringWithFormat:@"%@",plmark.locality];

             }

            NSString *weidu=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
             NSString *jingdu=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
             positionArr =[NSArray arrayWithObjects:weidu,jingdu,nil];
             NSLog(@"%@",positionArr);
         }
     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
