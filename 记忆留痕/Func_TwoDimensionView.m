//
//  Func_TwoDimensionView.m
//  记忆留痕
//
//  Created by kys-2 on 14-10-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "Func_TwoDimensionView.h"
#import "defines.h"
#import "LBS_defines.h"
#import "sxlRequest_GET.h"
#import "CheckWLAN.h"
#import "SVProgressHUD.h"
#import "Photo.h"
#import "iToast.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/NSString+Common.h>
@interface Func_TwoDimensionView ()

@end

@implementation Func_TwoDimensionView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    

    }
    return self;
}
-(void)initShareView
{
    bckView=[[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-240)/2, (ScreenHeight-300)/2, 240, 300)];
    bckView.backgroundColor=[UIColor clearColor];
    Code_imageView=[[UIImageView alloc]initWithFrame:CGRectMake((240-200)/2, 0, 200, 200)];
    Code_imageView.backgroundColor=[UIColor clearColor];
    Code_imageView.image=TwoDimensionImage;
    
    
    UILabel *labelStr=[[UILabel alloc]initWithFrame:CGRectMake((240-200)/2, 200, 200, 100)];
    labelStr.backgroundColor=[UIColor clearColor];
    labelStr.font=[UIFont boldSystemFontOfSize:22];
    labelStr.numberOfLines=0;
    labelStr.textAlignment=NSTextAlignmentCenter;
    labelStr.text=@"扫一扫,秀一秀\n  我的二维码";
    [bckView addSubview:labelStr];
    [bckView addSubview:Code_imageView];
    [self.view addSubview:bckView];
    
    UIImageView *combinImage=[[UIImageView alloc] initWithFrame:CGRectMake((240-57)/2, (200-57)/2, 57, 57)];
    combinImage.image=[UIImage imageNamed:@"icon.png"];
    //combinImage.backgroundColor=[UIColor clearColor];
    [bckView insertSubview:combinImage aboveSubview:Code_imageView];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];//当视图快消失的时候，加载视图消失
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"foot_detail_share"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"foot_detail_shareHighlight"] forState:UIControlStateHighlighted];
    rightBtn.tag=13;
    rightBtn.enabled=NO;//初始化为不可点击
    [rightBtn addTarget:self action:@selector(TwoDismensionViewOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBtn=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=shareBtn;

    TDV_json=[[NSDictionary alloc]init];
    [self GetTwo_DismensionView];
   
}
#pragma mark-----------ShareClick
-(void)TwoDismensionViewOnClick
{
    lxsheet=[[LXActionSheet alloc]initWithTitle:@"“秀”出我的二维码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"新浪微博",@"腾讯微博",@"网易微博"]];
    [lxsheet showInView:self.view];
}
#pragma mark--------------sheetDelegate
- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    switch ((int)buttonIndex) {
        case 0:
        {//新浪微博
            [self sharewithType:ShareTypeSinaWeibo];
        
        }
            break;
        case 1:
        {//腾讯微博
            [self sharewithType:ShareTypeTencentWeibo];
            
        }
            break;
        case 2:
        {//网易微博
            [self sharewithType:ShareType163Weibo];
        }
            break;
        default:
            break;
    }
    
}
-(void)sharewithType:(ShareType)type
{
    NSString *content=[NSString stringWithFormat:@"童鞋们,我正在玩#记忆留痕#,非常炫,非常好玩,是旅游玩耍的必备良器。扫描旁边的二维码就能好好的了解神器了,还等什么啊,一起扫一扫吧!  http://v.youku.com/v_show/id_XNzk5NTYxMDQw.html"];
    @try {
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:@"记忆留痕，旅游者的必备利器!"
                                                    image:[ShareSDK jpegImageWithImage:TwoDimensionImage quality:1.0]
                                                    title:@"死一只鸟"
                                                      url:nil
                                              description:@"记忆留痕，旅游者的必备利器!"
                                                mediaType:SSPublishContentMediaTypeText];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:YES
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        
        //显示分享菜单
        [ShareSDK showShareViewWithType:type
                              container:container
                                content:publishContent
                          statusBarTips:YES
                            authOptions:authOptions
                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                               oneKeyShareList:[ShareSDK getShareListWithType:type, nil]
                                                                qqButtonHidden:NO
                                                         wxSessionButtonHidden:NO
                                                        wxTimelineButtonHidden:NO
                                                          showKeyboardOnAppear:NO
                                                             shareViewDelegate:nil
                                                           friendsViewDelegate:nil
                                                         picViewerViewDelegate:nil]
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                     
                                     if (state == SSPublishContentStateSuccess)
                                     {
                                         NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                     }
                                     else if (state == SSPublishContentStateFail)
                                     {
                                         NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                     }
                                 }];

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"获取数据 错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"弹出分享视图");
    }
    }

-(void)GetTwo_DismensionView
{
    [SVProgressHUD showWithStatus:@"正在生成二维码"];
    @try {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@http://v.youku.com/v_show/id_XNzk5NTYxMDQw.html",TD_CODE_URL]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(ASIHttpRequestFailed_get:)];
        [request setDidFinishSelector:@selector(ASIHttpRequestSuceed_get:)];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"获取数据 错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"获得网络数据");
    }
  }
//网络请求失败
- (void)ASIHttpRequestFailed_get:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"获取失败,请重试"];
    NSError *error = [request error];
	NSLog(@"the error is %@",error);
}
//网络请求成功
- (void)ASIHttpRequestSuceed_get:(ASIHTTPRequest *)request{
    [SVProgressHUD showSuccessWithStatus:@"成功"];
    @try {
        NSData *responseData = [request responseData];
        TDV_json=[responseData objectFromJSONDataWithParseOptions:JKParseOptionLooseUnicode];//得到解析的数据
       // NSLog(@"json解析＝%@",[[TDV_json valueForKey:@"base64"] substringFromIndex:22]);
        if (!TDV_json.count) {
            //返回数据为空
        }else
        {
        //返回数据不为空的时候
        rightBtn.enabled=YES;//设置分享按钮可点击
        TwoDimensionImage=[Photo string2Image:[[TDV_json valueForKey:@"base64"] substringFromIndex:22]];
        [self initShareView];
        }
    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"获取数据 错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"获取二维码数据");
    }

   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
