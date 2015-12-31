//
//  TimeLine.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "TimeLine.h"
#import "PlanLine.h"
#import "FootRail_Create.h"
#import "sxlRequest_GET.h"
#import "sxlDataBase_Sqlite.h"
#import "LBS_defines.h"
#import "SVProgressHUD.h"
#import "iToast.h"
#import "TL_DetailView.h"
#import "Func_MyFootTral.h"
#import "Func_MyWeather.h"
#import "Func_TwoDimensionView.h"//二维码视图
#define HEADVIEW_HEIGHT 180
@interface TimeLine ()

@end

@implementation TimeLine
@synthesize a,y,c,b;
@synthesize scrollView_line;
@synthesize imageView;
@synthesize monthButton;
@synthesize buttonArray;
@synthesize massageView;
//@synthesize labelMode;
@synthesize massageViewArray;
@synthesize TagArray;
//@synthesize photoImageViewArray;
@synthesize animation1;
@synthesize animationImageView;
@synthesize AddimageView;
//@synthesize textView;
@synthesize line,line1,locationIcon,locationLabel;
@synthesize pictureView;
@synthesize cellbtnArray;
@synthesize pswStatusArr;
@synthesize DatalabelArray;
@synthesize hasRecordIcon;
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
	return @"first";
}

- (NSString *)tabTitle
{
	return @"时光轴";
}
#pragma mark----加载头视图
-(void)initPromptHint
{
    UIImageView *promtHint=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64+HEADVIEW_HEIGHT, ScreenWidth, 20)];
    promtHint.image=[UIImage imageNamed:@"promptHint"];
    HintLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    HintLabel.font=[UIFont systemFontOfSize:14.5];
    HintLabel.text=@" 我的足迹:记忆留痕,愿永远留下最美好的脚印。";
    [promtHint addSubview:HintLabel];
    [self.view addSubview:promtHint];
    
    infoArr=[NSArray arrayWithObjects:@" 我的足迹:记忆留痕,愿永远留下最美好的脚印。",@" 天气预报:好旅行,更要好天气,点一下看看天气呗!",@"我的二维码:扫一扫,秀一秀,属于我的二维码", nil];
    
}
-(void)initHeadView
{

    HeadScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, HEADVIEW_HEIGHT)];
    HeadScrollView.bounces = NO;
    HeadScrollView.pagingEnabled=YES;
    HeadScrollView.delegate = self;
    HeadScrollView.showsVerticalScrollIndicator=NO;
    HeadScrollView.showsHorizontalScrollIndicator=NO;
    HeadScrollView.backgroundColor=[UIColor orangeColor];
     [self createCustomPageControl:HeadScrollView numberOfPages:3];//加载pagecontrol一次
      [self.view addSubview:HeadScrollView];
    flagArr=[NSArray arrayWithObjects:@"我的足迹",@"天气预报",@"我的二维码", nil];
    FlagLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 64, 100, 30)];
    FlagLabel.textColor=[UIColor orangeColor];
    FlagLabel.text=@"我的足迹";
    FlagLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"func_flag"]];
    [self.view insertSubview:FlagLabel aboveSubview:HeadScrollView];
 
    SlideImgArray=[[NSMutableArray alloc] initWithObjects:@"Foot_DrawRouinte",@"Foot_Weather",@"Foot_Share", nil];
    HeadScrollView.contentSize=CGSizeMake(ScreenWidth*[SlideImgArray count], HEADVIEW_HEIGHT);
    for (int i=0; i<[SlideImgArray count]; i++) {
        UIButton *FunctionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        FunctionBtn.frame=CGRectMake(ScreenWidth*i+0,0, ScreenWidth, HEADVIEW_HEIGHT);
        [FunctionBtn setImage:[UIImage imageNamed:[SlideImgArray objectAtIndex:i]] forState:UIControlStateNormal];
         FunctionBtn.tag=10+i;
        [FunctionBtn addTarget:self action:@selector(BtnClickOnTimeLine:) forControlEvents:UIControlEventTouchUpInside];
        [HeadScrollView addSubview:FunctionBtn];
    }
    [self createCustomPageControl:HeadScrollView numberOfPages:3];//加载pagecontrol一次
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];

 }

#pragma mark 创建自定义pageControl
-(void)createCustomPageControl:(UIScrollView *)scrollView numberOfPages:(int )numberOfPage
{
   //修改过坐标
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 64+HEADVIEW_HEIGHT-20, ScreenWidth, 20)];
    pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    pageControl.numberOfPages=numberOfPage;
    pageControl.currentPage=0;
    [self.view addSubview:pageControl];
}
#pragma mark scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{      int page=floor(HeadScrollView.contentOffset.x/HeadScrollView.frame.size.width);
       [pageControl setCurrentPage:floor(HeadScrollView.contentOffset.x/HeadScrollView.frame.size.width)];
    //添加动态消息推送
    [UIView animateWithDuration:1.5 animations:^{
        HintLabel.text=@"";
    }completion:^(BOOL finished){
        HintLabel.text=[infoArr objectAtIndex:page];
        FlagLabel.text=[flagArr objectAtIndex:page];
        
    }];
    
}
#pragma mark -定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > 2 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [HeadScrollView scrollRectToVisible:CGRectMake(320*page,0,320,HEADVIEW_HEIGHT) animated:NO]; // 触摸_xmStarPageControl那个点点 往后翻一页 +1
}

#pragma mark DDPageControl triggered actions  自定义点的点击事件

- (void)pageControlClicked:(id)sender
{
	UIPageControl *thePageControl = (UIPageControl *)sender ;
	
	[HeadScrollView setContentOffset: CGPointMake(HeadScrollView.bounds.size.width * thePageControl.currentPage, HeadScrollView.contentOffset.y) animated: YES] ;
}
#pragma mark-----------获得云端数据
-(void)getDataFromCloud
{
    //首先获得云端数据
    if ([CheckWLAN CheckWLAN]) {
        [SVProgressHUD showWithStatus:@"正在获取..."];
        jsonObjects=[[NSDictionary alloc]init];
        NSString *lastURl=[NSString stringWithFormat:@"%@?geotable_id=79080&page_size=200&ak=%@",LBS_QUERY_POI_URL,LBS_ak];
        jsonObjects=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:lastURl];
        NSLog(@"json==%@",jsonObjects);
        if (!jsonObjects.count) {
            [SVProgressHUD dismiss];
            [iToast make:@"云端获取数据失败" duration:1000];
            [self LoadTheView_WhichNotLoad];
            //当无网的时候  设置设置按钮不可选
            [(UIButton *)[self.view viewWithTag:10] setEnabled:NO];//我的足迹
            [(UIButton *)[self.view viewWithTag:11] setEnabled:NO];//我的天气预报
            [(UIButton *)[self.view viewWithTag:12] setEnabled:NO];//我的二维码
        }else
        {//有数据的时候
            
            //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TimeLineBck.png"]];
            
            [scrollView_line removeFromSuperview];//每一次刷新的时候 将滚动视图移除
            [(UIButton *)[self.view viewWithTag:10] setEnabled:YES];
            [(UIButton *)[self.view viewWithTag:11] setEnabled:YES];//我的天气预报
             [(UIButton *)[self.view viewWithTag:12] setEnabled:YES];//我的二维码
            [UIView animateWithDuration:0.5 animations:^{
                No_loadBtn.transform=CGAffineTransformMakeScale(0.3, 0.3);
                No_loadBtn.alpha=0.0;//有点问题
                
              
            } completion:^(BOOL finished){
                [No_loadBtn removeFromSuperview];

            }];
            
            @try {
               //
                get_CoordinateArray=[[NSMutableArray alloc]init];
                get_titleArray=[[NSMutableArray alloc]init];
                get_AddressArray=[[NSMutableArray alloc]init];
                get_dateArray=[[NSMutableArray alloc]init];
                get_tagArray=[[NSMutableArray alloc]init];
                size_number=[[jsonObjects valueForKeyPath:@"size"] intValue];
                for (int i=0; i<size_number; i++) {
                    NSDictionary *getinfo=[[jsonObjects valueForKeyPath:@"pois"] objectAtIndex:i];
                    [get_titleArray addObject:[getinfo valueForKeyPath:@"title"]];
                    [get_AddressArray addObject:[getinfo valueForKeyPath:@"address"]];
                    [get_dateArray addObject:[getinfo valueForKeyPath:@"create_time"]];
                    [get_tagArray addObject:[getinfo valueForKeyPath:@"tags"]];
                    [get_CoordinateArray addObject:[getinfo valueForKey:@"location"]];
                    [SVProgressHUD showSuccessWithStatus:@"OK"];
                    //NSLog(@"iii=%@",get_CoordinateArray);
                }
                
                
                [[sxlDataBase_Sqlite sharedInstance] QueryDataOnDataBaseWithTitle:[get_titleArray objectAtIndex:0] tag:@"content"];
                
                [self DrawlineAndLoadViews];//当可以从云端获取数据  即可以加载
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
        
        [SVProgressHUD dismiss];
        [iToast make:@"云端获取数据失败" duration:700];
        [self LoadTheView_WhichNotLoad];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self getLocationPositionForWeather];//一加载界面就获取地理位置信息
    [self initHeadView];
    [self initPromptHint];
    [self getDataFromCloud];//获得数据
    //[self DrawlineAndLoadViews];
    
   /* UIBarMetricsDefault：用竖着（拿手机）时UINavigationBar的标准的尺寸来显示UINavigationBar
    UIBarMetricsLandscapePhone：用横着时UINavigationBar的标准尺寸来显示UINavigationBar*/

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot_naving.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent=YES;//设置成透明
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TimeLineBck.png"]];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"write_heighlight"] forState:UIControlStateHighlighted];
    rightBtn.layer.cornerRadius=5.0;
    rightBtn.tag=100;
    [rightBtn addTarget:self action:@selector(BtnClickOnTimeLine:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
    
    //left
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"navbar_refresh.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"navbar_refreshhighlight.png"] forState:UIControlStateHighlighted];
    leftBtn.layer.cornerRadius=5.0;
    leftBtn.tag=101;
    [leftBtn addTarget:self action:@selector(BtnClickOnTimeLine:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    
    /*UIImageView *test=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    test.backgroundColor=[UIColor cyanColor];
    UIButton *sss=(UIButton *)[self.view viewWithTag:11];
    [sss addSubview:test];*/

}
#pragma mark------------没有加载出来视图
-(void)LoadTheView_WhichNotLoad
{
    [scrollView_line removeFromSuperview];//在显示加载未成功的视图之前  清除滚动视图
    No_loadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    No_loadBtn.frame=CGRectMake(0, 84+HEADVIEW_HEIGHT, ScreenWidth, 260);
    [No_loadBtn setImage:[UIImage imageNamed:@"foot-load.png"] forState:UIControlStateNormal];
     No_loadBtn.tag=102;
    [No_loadBtn addTarget:self action:@selector(BtnClickOnTimeLine:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:No_loadBtn];
}
#pragma mark--------------按钮点击事件
-(void)BtnClickOnTimeLine:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {//我的足迹
            NSLog(@"myfoot");
            Func_MyFootTral *footTral=[[Func_MyFootTral alloc]init];
            footTral.title=@"我的足迹";
            footTral.tral_dateArray=get_dateArray;
            footTral.tral_tagArray=get_tagArray;
            footTral.tral_addressArray=get_AddressArray;
            footTral.tral_CoordinateAray=get_CoordinateArray;
               footTral.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:footTral animated:YES];
        }
            break;
        case 11:
        {//当前天气
            NSLog(@"当前天气");
            Func_MyWeather *weather=[[Func_MyWeather alloc]init];
            weather.title=@"天气预报";
            weather.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:weather animated:YES];
        }
            break;
        case 12:
        {//我的分享
            Func_TwoDimensionView *tws=[[Func_TwoDimensionView alloc]init];
            tws.title=@"我的二维码";
            tws.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:tws animated:YES];
        }
            break;
        case 100:
        {//创建按钮的实现方法
            FootRail_Create *foot=[[FootRail_Create alloc]init];
            foot.title=@"新脚印-新鲜事";
            //foot.PushLabel=[NSString stringWithFormat:@"main"];
            [[NSUserDefaults standardUserDefaults]setValue:@"main" forKey:@"PushLabel"];
            foot.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:foot animated:YES];
        }
            break;
        case 101:
        {//刷新功能
            [self getDataFromCloud];
        }
            break;
        case 102:
        {//重新加载
            [self getDataFromCloud];
        }
            break;
        default:
            break;
    }
}
#pragma mark--------------构造时光轴---
-(void)DrawlineAndLoadViews
{
    //[No_loadBtn removeFromSuperview];//清除

    a=0;
    y=0;
    NSInteger number=size_number;//设定显示的条数
    [self makeScrollView:number];//确定scrollView的framework
    imageView = [[UIImageView alloc]init];//确定线条描绘的位置和大小
    imageView.frame = CGRectMake(0, 0, scrollView_line.bounds.size.width, scrollView_line.contentSize.height);
    [scrollView_line addSubview:imageView];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"TimeLineBck.png"]];
    
    PlanLine *plan = [[PlanLine alloc]init];
    plan.delegate = self;
    [plan setImageView:imageView setlineWidth:2.5 setColorRed:0/255 ColorBlue:255/255 ColorGreen:255/255 Alp:.8 setBeginPointX:30 BeginPointY:13 setOverPointX:30 OverPointY:scrollView_line.contentSize.height];//绘制时间线
    [self makeMonthButton:number];//根据月份的个数确定生成按钮的个数
    [self makeView:number];//根据月份的个数确定文字视图的距离和显示
    
    
}
-(void)makeScrollView:(NSInteger)number
{
    scrollView_line = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 264, ScreenWidth, [[UIScreen mainScreen] bounds].size.height-300)];
    scrollView_line.showsVerticalScrollIndicator=NO;
    scrollView_line.backgroundColor=[UIColor clearColor];
    scrollView_line.alpha=0.8;
    scrollView_line.contentSize = CGSizeMake(self.view.bounds.size.width, number*50+200);//需要变动
    [self.view addSubview:scrollView_line];
}
-(void)makeMonthButton:(NSInteger)number
{
    self.buttonArray = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0; i < number; i++)
    {
        monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"Circle.png"];//确定节点图片
        [monthButton setImage:image forState:UIControlStateNormal];
        [monthButton setImage:[UIImage imageNamed:@"red_heartfull"] forState:UIControlStateHighlighted];
        monthButton.frame = CGRectMake(20, 10+i*50, 20, 20);
        monthButton.tag = i;
        [monthButton addTarget:self action:@selector(openMassage:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView_line addSubview:monthButton];
        [buttonArray addObject:monthButton];
    }
    
}
-(NSDictionary *)getLabelImages
{
    NSString *dataPath=[[NSBundle mainBundle]pathForResource:@"labelName" ofType:@"plist"];
    NSDictionary *labelData=[[NSDictionary alloc]initWithContentsOfFile:dataPath];
    return labelData;
    
}

-(void)makeView:(NSInteger)number
{
    self.massageViewArray = [[NSMutableArray alloc]init];//主cell
    TagArray=[[NSMutableArray alloc] init];//用户选择的标签
    cellbtnArray=[[NSMutableArray alloc]init];//标题按钮
    pswStatusArr=[[NSMutableArray alloc]init];
    DatalabelArray=[[NSMutableArray alloc]init];
    //日期标签
    for (NSInteger i = 0; i < number; i++)
    {
        self.massageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, i*50+5, 251, 30)];//确定主加载视图
        
        massageView.image=[UIImage imageNamed:@"foot_cell_background.png"];
        //tag label  若没有标签 默认为星星
        UIImageView *tagimage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
        NSDictionary *tags=[[self getLabelImages] valueForKeyPath:@"Nameimage"];
        NSString *gettags=[get_tagArray objectAtIndex:i];
        if ([gettags isEqualToString:@"无"]) {
            tagimage.frame=CGRectMake(10, 0, 30, 30);
            tagimage.image=[UIImage imageNamed:@"foor_noTag"];
        }else
        {
            NSString *name=[tags valueForKeyPath:[NSString stringWithFormat:@"%@",gettags]];
            tagimage.image=[UIImage imageNamed:name];

        }
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 140, 30)];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.textColor=[UIColor blackColor];
        titleLabel.text=[get_titleArray objectAtIndex:i];
        
        //cell  button
        /*UIButton *cellBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame=CGRectMake(30, 0, 150, 30);
        cellBtn.backgroundColor=[UIColor clearColor];
        cellBtn.tag=i;
        [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cellBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        cellBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        [cellBtn setTitle:@"身份证和户口薄" forState:UIControlStateNormal];
        [cellBtn addTarget:self action:@selector(openMassage:) forControlEvents:UIControlEventTouchUpInside];*/
        
       /* UILabel *pswStatus=[[UILabel alloc] initWithFrame:CGRectMake(251-25, 5, 20, 20)];
        pswStatus.textColor=[UIColor blueColor];
        pswStatus.font=[UIFont systemFontOfSize:15];
        pswStatus.text=@"🔓";*/
        UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(180, 10,70, 20)];
        date.font=[UIFont systemFontOfSize:8];
        date.textColor=[UIColor orangeColor];
        NSString *datestr=[get_dateArray objectAtIndex:i];
        date.text=[datestr substringWithRange:NSMakeRange(0, 16)];
        [massageView addSubview:date];
        //[massageView addSubview:pswStatus];
        [massageView addSubview:tagimage];
        [massageView addSubview:titleLabel];
        //[massageView addSubview:cellBtn];
        [scrollView_line addSubview:massageView];
        [massageViewArray addObject:massageView];
        [cellbtnArray addObject:titleLabel];
        //[pswStatusArr addObject:pswStatus];
        [TagArray addObject:tagimage];
        // [massageView setUserInteractionEnabled:NO];
    }
}
-(void)openMassage:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"tag = %ld",(long)button.tag);
    c = button.tag;
    NSLog(@"y = %ld",(long)y);
    
    //移除功能
    if (b!=0)
    {
        [animationImageView removeFromSuperview];
        [pictureView removeFromSuperview];
        [AddimageView removeFromSuperview];
        //[textView removeFromSuperview];
        [locationLabel removeFromSuperview];
        [line removeFromSuperview];
        [locationIcon removeFromSuperview];
        [line1 removeFromSuperview];
        [hasRecordIcon removeFromSuperview];
    }
    b++;
    
    //时间段线段
    y = button.tag;
    
    PlanLine *plan = [[PlanLine alloc]init];
    self.AddimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrollView_line.bounds.size.width, scrollView_line.contentSize.height)];
    [plan setImageView:AddimageView setlineWidth:2.5 setColorRed:0/255 ColorBlue:255/255 ColorGreen:255/255 Alp:.8 setBeginPointX:30 BeginPointY:button.tag*50+38.0 setOverPointX:30 OverPointY:(button.tag + 1 )*50+200.0+10];
    animation1 = [CATransition animation];
    animation1.delegate =self;
    animation1.duration = 2.0f;
    animation1.timingFunction = UIViewAnimationCurveEaseInOut;
    animation1.type = kCATransitionMoveIn;
    animation1.subtype = kCATransitionReveal;
    
    [AddimageView.layer addAnimation:animation1 forKey:@"animation"];
    [AddimageView setUserInteractionEnabled:NO];
    [scrollView_line addSubview:AddimageView];
    
    //实例化弹出界面---弹出视图  打开时的方法
    [[massageViewArray objectAtIndex:button.tag] setFrame:CGRectMake(50, button.tag*50+5, 251, 200+20)];
    
    CATransition *animation = [CATransition animation];
    animation.delegate =self;
    animation.duration = 1.0f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransition;
    [[[massageViewArray objectAtIndex:button.tag] layer] addAnimation:animation forKey:@"animation"];
    [[massageViewArray objectAtIndex:button.tag] setUserInteractionEnabled:YES];
    //弹出的view
    UIImageView *view = [massageViewArray objectAtIndex:button.tag];
    view.image=[UIImage imageNamed:@"foot_enlargeBck.png"];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOffset:CGSizeMake(10, 10)];
    [view.layer setShadowOpacity:0.5];
    view.backgroundColor = [UIColor clearColor];
    
    [[buttonArray objectAtIndex:button.tag] setFrame:CGRectMake(16, button.tag*50+10, 30, 30)];
    [[buttonArray objectAtIndex:button.tag] setImage:[UIImage imageNamed:@"indexPoint"] forState:UIControlStateNormal];

    //展开后的视图
    UIControl *control=[[UIControl alloc]initWithFrame:CGRectMake(10, 35, 230, 140)];
    control.tag=button.tag;
    [control addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
    pictureView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 35, 230, 150)];
    @try {
        /*需要修改  进行预设图片信息*/
        if ([[sxlDataBase_Sqlite sharedInstance] judgeStatusForHaving_Photos:[get_titleArray objectAtIndex:button.tag]]) {
            //如果数据库里面有数据
            pictureView.image=[[[sxlDataBase_Sqlite sharedInstance] QueryImageDataOnDataBaseWithTitle:[get_titleArray objectAtIndex:button.tag]] objectAtIndex:0];
        }else
        {//数据库里面没有数据的时候
            pictureView.image=[UIImage imageNamed:[[[self getLabelImages]valueForKey:@"TripView"] valueForKey:[get_titleArray objectAtIndex:button.tag]]];
        }

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"捕获图片");
    }
    //需要进行判断是否有图片pictureView.image=[UIImage imageNamed:@"fruit_4.jpg"];
    [control addSubview:pictureView];
    [[massageViewArray objectAtIndex:button.tag] addSubview:pictureView];
    line=[[UIImageView alloc] initWithFrame:CGRectMake(10, 30-3, massageView.bounds.size.width-12, 8)];
    line.image=[UIImage imageNamed:@"red_line"];
    //line.backgroundColor=[UIColor lightGrayColor];
    line1=[[UIImageView alloc] initWithFrame:CGRectMake(7, 190, massageView.bounds.size.width-12, 1.5)];
    line1.image=[UIImage imageNamed:@"foot_line1"];
    //line1.backgroundColor=[UIColor lightGrayColor];
    locationIcon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 195, 14, 18)];
    locationIcon.image=[UIImage imageNamed:@"location_icon"];
    
    locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 190, 195, 30)];
    locationLabel.backgroundColor=[UIColor clearColor];
    locationLabel.font=[UIFont boldSystemFontOfSize:12];
    locationLabel.textColor=[UIColor lightGrayColor];
    locationLabel.text=[get_AddressArray objectAtIndex:button.tag];
     hasRecordIcon=[[UIImageView alloc] initWithFrame:CGRectMake(230, 195, 15, 15)];
    @try {
        if (![[[sxlDataBase_Sqlite sharedInstance] QueryContent_RecordUrlWithTitle:[get_titleArray objectAtIndex:button.tag]] valueForKey:FT_RECORD_URL]) {
            //没有数据
            IsHasRecord=[NSString stringWithFormat:@"无"];
        }else
        {//有数据
            IsHasRecord=[NSString stringWithFormat:@"有"];
            hasRecordIcon.image=[UIImage imageNamed:@"record_icon.png"];
            [[massageViewArray objectAtIndex:button.tag] addSubview:hasRecordIcon];
        }

    }
    @catch (NSException *exception) {
         [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"判断录音");
    }
    [[massageViewArray objectAtIndex:button.tag] addSubview:control];
    [[massageViewArray objectAtIndex:button.tag]addSubview:locationLabel];
    [[massageViewArray objectAtIndex:button.tag] addSubview:locationIcon];
    [[massageViewArray objectAtIndex:button.tag] addSubview:line1];
    [[massageViewArray objectAtIndex:button.tag] addSubview:line];
    
       //位置调整 分上下 注意！！！！
    //点击处上面的
    if (button.tag == 0)
    {
        NSLog(@"asdasd");
     }
    else
    {//出点击外的其他cell的处理
        for (int i = 0; i < button.tag; i++)
        {
            [[massageViewArray objectAtIndex:i] setFrame:CGRectMake(50, 5+i*50, 251, 30)];
           UIImageView *cellBck=[massageViewArray objectAtIndex:i];
            cellBck.backgroundColor=[UIColor clearColor];
           cellBck.image=[UIImage imageNamed:@"foot_cell_background"];
            [[buttonArray objectAtIndex:i] setFrame:CGRectMake(20, 10+i*50, 20, 20)];
            //[[cellbtnArray objectAtIndex:i] setTitle:@"身份证和户口簿" forState:UIControlStateNormal];
            [[buttonArray objectAtIndex:i] setImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];//按钮
        }
        
        [[massageViewArray objectAtIndex:button.tag-1] setFrame:CGRectMake(50, (button.tag-1)*50+5, 251, 30)];
         [[buttonArray objectAtIndex:button.tag-1] setFrame:CGRectMake(20, (button.tag-1)*50+10, 20, 20)];
        
    }
    //点击处下面的
    for (NSInteger i = button.tag + 1; i < [massageViewArray count]; i++)
    {
        [[massageViewArray objectAtIndex:i] setFrame:CGRectMake(50, 200+i*50+5, 251, 30)];
        UIImageView *cellBck=[massageViewArray objectAtIndex:i];
        cellBck.image=[UIImage imageNamed:@"foot_cell_background"];

        UIImageView *view = [massageViewArray objectAtIndex:i];
        view.backgroundColor=[UIColor clearColor];
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y-200)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.5f];
        [view.layer addAnimation:positionAnim forKey:@"positon"];
        [view setCenter:CGPointMake(view.center.x, view.center.y)];
        
        [[buttonArray objectAtIndex:i] setFrame:CGRectMake(20, 200+i*50+10, 20, 20)];
        //[[cellbtnArray objectAtIndex:i] setTitle:@"身份证和户口簿" forState:UIControlStateNormal];
        [[buttonArray objectAtIndex:i] setImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
        
        UIButton *button = [buttonArray objectAtIndex:i];
        CABasicAnimation *positionAnim1=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim1 setFromValue:[NSValue valueWithCGPoint:CGPointMake(button.center.x, button.center.y-200)]];
        [positionAnim1 setToValue:[NSValue valueWithCGPoint:CGPointMake(button.center.x, button.center.y)]];
        [positionAnim1 setDelegate:self];
        [positionAnim1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim1 setDuration:0.5f];
        [button.layer addAnimation:positionAnim1 forKey:nil];
        [button setCenter:CGPointMake(button.center.x, button.center.y)];
        
        
    }
    
}
-(void)cellClick:(UIControl *)control
{
    NSLog(@"tag==%d",control.tag);
    int num=control.tag;
    TL_DetailView *detail=[[TL_DetailView alloc]init];
    detail.title=@"看详情";
    detail.TitleStr=[get_titleArray objectAtIndex:num];
    detail.AddressStr=[get_AddressArray objectAtIndex:num];
    detail.DateStr=[get_dateArray objectAtIndex:num];
    detail.IsSound=IsHasRecord;
    detail.locationStr=[get_CoordinateArray objectAtIndex:num];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
