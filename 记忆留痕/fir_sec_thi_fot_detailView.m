//
//  fir_sec_thi_fot_detailView.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-25.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "fir_sec_thi_fot_detailView.h"
#import "defines.h"
#import "LBS_defines.h"
#import "SVProgressHUD.h"
#import "CheckWLAN.h"
#import "sxlRequest_GET.h"
#import "iToast.h"
#import "Detail_WebView.h"
#import "Toast+UIView.h"
@interface fir_sec_thi_fot_detailView ()

@end

@implementation fir_sec_thi_fot_detailView
@synthesize fstfd_UrlStr,push_tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)fstfd_initDetailView_trip
{
    UIView *functionview;
    if ([push_tag isEqualToString:@"TimeLine"]) {
        functionview=[[UIView alloc]initWithFrame:CGRectMake(0, 64,ScreenWidth , 70)];
    }else
    {
        functionview=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , 70)];
    }
    functionview.backgroundColor=[UIColor clearColor];
    fstfd_POINameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 40)];
    fstfd_POINameLabel.textAlignment=NSTextAlignmentCenter;
    fstfd_POINameLabel.font=[UIFont boldSystemFontOfSize:20];
    fstfd_POINameLabel.textColor=[UIColor blackColor];
    fstfd_POINameLabel.text=fstfd_POI_nameStr;
    [fstfd_POINameLabel sizeToFit];
    //添加门票信息
    ticketBtn=[UIButton buttonWithType:UIButtonTypeInfoLight];
    ticketBtn.frame=CGRectMake(320-50, 10 , 30, 30);
    ticketBtn.tag=101;
    [ticketBtn addTarget:self action:@selector(fstfd_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [functionview addSubview:ticketBtn];
    
    //添加五星
    for (int i=0; i<fstfd_StarCount; i++) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(130+32*i, 40, 25, 25)];
        image.image=[UIImage imageNamed:@"three_star"];
        [functionview addSubview:image];
    }
    //date
    fstfd_datelabel=[[UILabel alloc]initWithFrame:CGRectMake(27, 50, 100, 20)];
    fstfd_datelabel.font=[UIFont systemFontOfSize:13];
    fstfd_datelabel.textAlignment=NSTextAlignmentLeft;
    fstfd_datelabel.textColor=[UIColor blueColor];
    fstfd_datelabel.text=fstfd_dateStr;
    [functionview addSubview:fstfd_datelabel];
    [functionview addSubview:fstfd_POINameLabel];
    [self.view addSubview:functionview];
    
    UIImageView *indeximg;
     if ([push_tag isEqualToString:@"TimeLine"])
     {
         indeximg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 134, ScreenWidth, 30)];
     }else
     {
         indeximg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 70, ScreenWidth, 30)];
     }
    indeximg.image=[UIImage imageNamed:@"indeximg.png"];
    fstfd_ttitleStr=[[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-80)/2, 2, 80, 25)];
    fstfd_ttitleStr.font=[UIFont boldSystemFontOfSize:17];
    fstfd_ttitleStr.textColor=[UIColor orangeColor];
    fstfd_ttitleStr.text=@"风土人情";
    [indeximg addSubview:fstfd_ttitleStr];
    [self.view addSubview:indeximg];
    UIButton *moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if ([push_tag isEqualToString:@"TimeLine"])
    {
        moreBtn.frame=CGRectMake(ScreenWidth-65,140-5 , 60, 30);

    }else
    {
        moreBtn.frame=CGRectMake(ScreenWidth-65,140-69 , 60, 30);

    }
    [moreBtn setImage:[UIImage imageNamed:@"doubleArrowRight"] forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    moreBtn.tag=100;
    [moreBtn addTarget:self action:@selector(fstfd_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:moreBtn aboveSubview:indeximg];
     if ([push_tag isEqualToString:@"TimeLine"])
     {
         fstfd_contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 164, ScreenWidth, ScreenHeight-164)];
     }else
     {
        fstfd_contentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight-164)];
     }
    fstfd_contentTextView.backgroundColor=[UIColor clearColor];
    fstfd_contentTextView.editable=NO;
    fstfd_contentTextView.scrollEnabled=YES;
    fstfd_contentTextView.font=[UIFont systemFontOfSize:16];
    fstfd_contentTextView.text=fstfd_contentStr;
    [self.view addSubview:fstfd_contentTextView];
    
    if (ticket_attention_Name.length) {
        ticketBtn.hidden=NO;
         [self.view makeToast:[NSString stringWithFormat:@"%@:\n  %@",ticket_attention_Name,fstfd_ticketStr]];
    }else
    {
        ticketBtn.hidden=YES;
    }
    
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getPOIFromAPI];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"detailBackground"]];
    //right
    UIButton *DDBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DDBtn.frame=CGRectMake(0, 0, 30, 30);
    [DDBtn setImage:[UIImage imageNamed:@"navbar_refresh.png"] forState:UIControlStateNormal];
    [DDBtn setImage:[UIImage imageNamed:@"navbar_refreshhighlight.png"] forState:UIControlStateHighlighted];
    DDBtn.layer.cornerRadius=5.0;
    DDBtn.tag=102;
    [DDBtn addTarget:self action:@selector(fstfd_btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:DDBtn];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)getPOIFromAPI
{
    [SVProgressHUD showWithStatus:@"正在获取..."];
    
    if ([CheckWLAN CheckWLAN]) {
        
        fstfd_URL_jsonObjects=[[NSDictionary alloc]init];
        NSString *lastUrl_utf=[fstfd_UrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//编码
         fstfd_URL_jsonObjects=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:lastUrl_utf];
        NSLog(@"json==%@",fstfd_URL_jsonObjects);
        if (!fstfd_URL_jsonObjects.count) {
            [SVProgressHUD dismiss];
            [iToast make:@"云端获取数据失败" duration:1000];
        }else
        {//有数据的时候
            
            @try {
                [SVProgressHUD showSuccessWithStatus:@"OK"];
                ticket_attention_Name=[[[[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"ticket_info"] valueForKey:@"attention"] objectAtIndex:0] valueForKey:@"name"];//门票优惠政策
                fstfd_ticketStr=
                    [[[[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"ticket_info"] valueForKey:@"attention"] objectAtIndex:0] valueForKey:@"description"];
                //政策
                fstfd_POI_nameStr=[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"name"];
                fstfd_StarCount=[[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"star"] integerValue];
                fstfd_dateStr=[fstfd_URL_jsonObjects valueForKey:@"date"];
                fstfd_contentStr=[NSString stringWithFormat:@"  %@\n  %@",[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"abstract"],[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"description"]];
                fstfd_web_url=[NSString stringWithFormat:@"%@",[[fstfd_URL_jsonObjects valueForKey:@"result"] valueForKey:@"url"]];
                
                
                [self fstfd_initDetailView_trip];//加载视图
                
                
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
-(void)fstfd_btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {//更多详情
            Detail_WebView *webview=[[Detail_WebView alloc]init];
            webview.title=@"更多";
            webview.webUrl=fstfd_web_url;
            webview.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webview animated:YES];
            
        }
            break;
        case 101:
        {//更多信息
            [self.view makeToast:[NSString stringWithFormat:@"%@:\n  %@",ticket_attention_Name,fstfd_ticketStr]];
        }
            break;
        case 102:
        {//刷新
            [fstfd_contentTextView removeFromSuperview];
            [self getPOIFromAPI];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
