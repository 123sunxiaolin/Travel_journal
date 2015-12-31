//
//  The_Traval_routine.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-23.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "The_Traval_routine.h"
#import "defines.h"
#import "LBS_defines.h"
#import "SVProgressHUD.h"
#import "CheckWLAN.h"
#import "sxlRequest_GET.h"
#import "iToast.h"
#import "Detail_WebView.h"
#import "first_sec_third_forth.h"
@interface The_Traval_routine ()

@end

@implementation The_Traval_routine
@synthesize lai_long,TTR_city,Push_Tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initDetailView_trip
{
    if ([Push_Tag isEqualToString:@"TimeLine"]) {
        functionview=[[UIView alloc]initWithFrame:CGRectMake(0,64,ScreenWidth , 70)];
    }else
    {
    functionview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , 70)];
    }
    functionview.backgroundColor=[UIColor clearColor];
    CityNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 40)];
    CityNameLabel.textAlignment=NSTextAlignmentCenter;
    CityNameLabel.font=[UIFont boldSystemFontOfSize:20];
    CityNameLabel.textColor=[UIColor blackColor];
    CityNameLabel.text=TTR_city;
    //添加五星
    for (int i=0; i<StarCount; i++) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(130+32*i, 22, 25, 25)];
        image.image=[UIImage imageNamed:@"three_star"];
        [functionview addSubview:image];
    }
    //date
    datelabel=[[UILabel alloc]initWithFrame:CGRectMake(27, 50, 100, 20)];
    datelabel.font=[UIFont systemFontOfSize:13];
    datelabel.textAlignment=NSTextAlignmentLeft;
    datelabel.textColor=[UIColor blueColor];
    datelabel.text=dateStr;
    [functionview addSubview:datelabel];
    [functionview addSubview:CityNameLabel];
    [self.view addSubview:functionview];
    
    UIImageView *indeximg;
    if ([Push_Tag isEqualToString:@"TimeLine"])
    {
       indeximg=[[UIImageView alloc]initWithFrame:CGRectMake(0,134, ScreenWidth, 30)];
    }else
    {
         indeximg=[[UIImageView alloc]initWithFrame:CGRectMake(0,70, ScreenWidth, 30)];
    }
    indeximg.image=[UIImage imageNamed:@"indeximg.png"];
    ttitleStr=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-80)/2, 2, 80, 25)];
    ttitleStr.font=[UIFont boldSystemFontOfSize:17];
    ttitleStr.textColor=[UIColor orangeColor];
    //ttitleStr.text=@"风土人情";
    [indeximg addSubview:ttitleStr];
    [self.view addSubview:indeximg];
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if ([Push_Tag isEqualToString:@"TimeLine"])
    {
        moreBtn.frame=CGRectMake(ScreenWidth-65,140-5 , 60, 30);

    }else
    {
        moreBtn.frame=CGRectMake(ScreenWidth-65,140-69 , 60, 30);

    }
    [moreBtn setImage:[UIImage imageNamed:@"doubleArrowRight"] forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    moreBtn.tag=100;
    [moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:moreBtn aboveSubview:indeximg];
    
    if ([[URL_jsonObjects valueForKey:@"result"] valueForKey:@"itineraries"]) {
        //如果有线路规划的
        ttitleStr.text=@"线路建议";
        trip_type=[[NSMutableArray alloc]init];
        UIToolbar *tool;
         if ([Push_Tag isEqualToString:@"TimeLine"])
         {
             contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 204, ScreenWidth, ScreenHeight-204)];
             tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 164, ScreenWidth, 40)];
         }else
         {
              contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 204-64, ScreenWidth, ScreenHeight-204)];
             tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 40)];
         }
        tool.backgroundColor=[UIColor clearColor];
        tool.alpha=0.9;
        int countnum;
        if ([[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"itineraries"] count]>4) {
            countnum=4;
        }else
        {
            countnum=[[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"itineraries"] count];
        }
        for (int i=0; i<countnum; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor colorWithPatternImage:[UIImage  imageNamed:@"lvyouxianlu"]];
            [btn setTitle:[[[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"itineraries"] objectAtIndex:i] valueForKey:@"name"] forState:UIControlStateNormal];
            btn.frame=CGRectMake(25+i*70, 5, 60, 30);
            btn.enabled=YES;
            btn.tag=1000+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [tool addSubview:btn];
            [trip_type addObject:[[[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"itineraries"] objectAtIndex:i] valueForKey:@"name"]];
        }
        [self.view addSubview:tool];
    }else
    {
        ttitleStr.text=@"风土人情";
        if ([Push_Tag isEqualToString:@"TimeLine"])
        {
         contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 164, ScreenWidth, ScreenHeight-164)];
        }else
        {
            contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 164-64, ScreenWidth, ScreenHeight-164)];
        }
    }
    contentTextView.backgroundColor=[UIColor clearColor];
    contentTextView.editable=NO;
    contentTextView.scrollEnabled=YES;
    contentTextView.font=[UIFont systemFontOfSize:16];
    contentTextView.text=contentStr;
    [self.view addSubview:contentTextView];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      [self getdataFromAPI];
   self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"detailBackground"]];
    //right
    UIButton *RBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    RBtn.frame=CGRectMake(0, 0, 30, 30);
    [RBtn setImage:[UIImage imageNamed:@"navbar_refresh.png"] forState:UIControlStateNormal];
    [RBtn setImage:[UIImage imageNamed:@"navbar_refreshhighlight.png"] forState:UIControlStateHighlighted];
    RBtn.layer.cornerRadius=5.0;
    RBtn.tag=101;
    [RBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:RBtn];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {//显示更多
            Detail_WebView *webview=[[Detail_WebView alloc] init];
            webview.title=@"更多";
            webview.webUrl=web_url;
            webview.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webview  animated:YES];
        }
            break;
        case 101:
        {//刷新
            [contentTextView removeFromSuperview];
            [self getdataFromAPI];
        }
            break;
        case 1000:
        {//第一个
            first_sec_third_forth *fstf=[[first_sec_third_forth alloc]init];
            fstf.title=[trip_type objectAtIndex:0];
            if ([Push_Tag isEqualToString:@"TimeLine"])
            {
                fstf.pushTag=[NSString stringWithFormat:@"TimeLine"];
            }

            fstf.ccity=TTR_city;
            fstf.sernum=[NSString stringWithFormat:@"0"];
            fstf.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:fstf animated:YES];
        }
            break;
        case 1001:
        {//第二个
            first_sec_third_forth *fstf=[[first_sec_third_forth alloc]init];
            fstf.title=[trip_type objectAtIndex:1];
            if ([Push_Tag isEqualToString:@"TimeLine"])
            {
                fstf.pushTag=[NSString stringWithFormat:@"TimeLine"];
            }

            fstf.ccity=TTR_city;
            fstf.sernum=[NSString stringWithFormat:@"1"];
            fstf.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:fstf animated:YES];
        }
            break;
        case 1002:
        {//第三个
            first_sec_third_forth *fstf=[[first_sec_third_forth alloc]init];
            fstf.title=[trip_type objectAtIndex:2];
            if ([Push_Tag isEqualToString:@"TimeLine"])
            {
                fstf.pushTag=[NSString stringWithFormat:@"TimeLine"];
            }

            fstf.ccity=TTR_city;
            fstf.sernum=[NSString stringWithFormat:@"2"];
            fstf.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:fstf animated:YES];
        }
            break;
        case 1003:
        {//第四个
            first_sec_third_forth *fstf=[[first_sec_third_forth alloc]init];
            fstf.title=[trip_type objectAtIndex:3];
            if ([Push_Tag isEqualToString:@"TimeLine"])
            {
                fstf.pushTag=[NSString stringWithFormat:@"TimeLine"];
            }

            fstf.ccity=TTR_city;
            fstf.sernum=[NSString stringWithFormat:@"3"];
            fstf.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:fstf animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)getdataFromAPI
{
    [SVProgressHUD showWithStatus:@"正在获取数据"];

    if ([CheckWLAN CheckWLAN]) {
        URL_jsonObjects=[[NSDictionary alloc]init];
        NSString *city_utf=[TTR_city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *lastURl=[NSString stringWithFormat:@"%@%@&ak=%@",CLW_TRIP_ROUTINE_URL,city_utf,LBS_ak];
        NSLog(@"url==%@",lastURl);

        URL_jsonObjects=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:lastURl];
        NSLog(@"json==%@",URL_jsonObjects);
        if (!URL_jsonObjects.count) {
            [SVProgressHUD dismiss];
            [iToast make:@"云端获取数据失败" duration:1000];
        }else
        {//有数据的时候
        
            @try {
               
                
                StarCount=[[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"star"] integerValue];
                dateStr=[URL_jsonObjects valueForKey:@"date"];
                contentStr=[NSString stringWithFormat:@"  %@\n  %@",[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"abstract"],[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"description"]];
                web_url=[NSString stringWithFormat:@"%@",[[URL_jsonObjects valueForKey:@"result"] valueForKey:@"url"]];
                    [self initDetailView_trip];//加载视图
                    [SVProgressHUD showSuccessWithStatus:@"OK"];//显示加载成功
 
            }
            @catch (NSException *exception) {
                [iToast make:[NSString stringWithFormat:@"获取数据 错误:%@",exception] duration:800];
                
            }
            @finally {
                NSLog(@"获取数据");
            }
        }
    }else
    {
        
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        [iToast make:@"云端获取数据失败" duration:700];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
