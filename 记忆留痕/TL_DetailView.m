//
//  TL_DetailView.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-16.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "TL_DetailView.h"
#import "defines.h"
#import "LBS_defines.h"
#import "sxlDataBase_Sqlite.h"
#import "iToast.h"
#import "The_Traval_routine.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIColor+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/NSString+Common.h>
@interface TL_DetailView ()

@end

@implementation TL_DetailView
@synthesize TitleStr;
@synthesize AddressStr;
@synthesize locationStr;
@synthesize DateStr;
@synthesize IsSound;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark--------初始化地图
-(void)initmapViewOnPopoverView
{
    my_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 200,100)];
    my_mapView.delegate = self;
    my_mapView.userInteractionEnabled = YES;
    my_mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    
    //popoverview
    CGPoint point =CGPointMake(33, 140-1);
    [PopoverView showPopoverAtPoint:point inView:self.view withTitle:nil withContentView:my_mapView  delegate:self];
    CLLocationCoordinate2D coordinateSelected;
    coordinateSelected.latitude=[[locationStr objectAtIndex:1] doubleValue];//学生的纬度
    coordinateSelected.longitude=[[locationStr objectAtIndex:0] doubleValue];
    map_ann = [[WXAnation alloc] initWithCoordinate2D:coordinateSelected];
    map_ann.title =AddressStr ;
    //map_ann.subtitle = @"当前位置";
    //设置一下显示范围
    MKCoordinateSpan span = {1,1};//详细范围
    MKCoordinateRegion region = {coordinateSelected,span};
    [my_mapView setRegion:region animated:YES];
    [my_mapView addAnnotation:map_ann];
    
    
}
#pragma mark - MKAnnotationView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"Annotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        //设置是否显示标题视图
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;// 设置该标注点动画显示
        annotationView.annotation=annotation;
    }
    
    return annotationView;
    
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{//点击大头针 所显现的视图
    // Initialize each view
    // 当前位置 的大头针设为紫色，并且没有右边的附属按钮
        // Initialize each view
        for (MKPinAnnotationView *mkaview in views)
        {
            
            mkaview.pinColor = MKPinAnnotationColorPurple ;//设置为紫色
            mkaview.rightCalloutAccessoryView = nil;
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            imgView.image=[UIImage imageNamed:@"foor_noTag"];
            mkaview.leftCalloutAccessoryView=imgView;
  
        }
    
   
}

-(void)initViewForDetail
{
    //背景图片
    UIImageView *detail_background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 79)];
    detail_background.image=[UIImage imageNamed:@"foot_detail_titlebcg"];
    [self.view addSubview:detail_background];
    
    UIImageView *titleIcon=[[UIImageView alloc] initWithFrame:CGRectMake(20, 6, 30, 30)];
    titleIcon.image=[UIImage imageNamed:@"foot_noTag.png"];
    //
    UILabel *Tlabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 6, ScreenWidth-80, 30)];
    Tlabel.font=[UIFont boldSystemFontOfSize:17];
    Tlabel.text=TitleStr;
    Tlabel.numberOfLines=0;
    //
    UILabel *dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(40, titleIcon.frame.origin.y+titleIcon.frame.size.height, 100, 20)];
    dateLabel.font=[UIFont systemFontOfSize:10];
    dateLabel.text=DateStr;
    //
    UIButton *locaIcon=[UIButton buttonWithType:UIButtonTypeCustom];
    locaIcon.frame=CGRectMake(25, 120, 15,20);
    NSLog(@"qqqqqq==%f",dateLabel.frame.origin.y);
    [locaIcon setImage:[UIImage imageNamed:@"location_icon.png"]forState:UIControlStateNormal];
    locaIcon.tag=10;
    [locaIcon addTarget:self action:@selector(BtnClickedOnDetailView:) forControlEvents:UIControlEventTouchUpInside];
   
    //
    UILabel *locaStr=[[UILabel alloc] initWithFrame:CGRectMake(45, 56, 230, 20)];
    locaStr.textColor=[UIColor blackColor];
    locaStr.font=[UIFont systemFontOfSize:11];
    locaStr.text=AddressStr;
  
    [detail_background addSubview:locaStr];
    [self.view insertSubview:locaIcon  aboveSubview:detail_background];
    [detail_background addSubview:dateLabel];
    [detail_background addSubview:Tlabel];
    [detail_background addSubview:titleIcon];
     //content
    content=[[UILabel alloc]initWithFrame:CGRectMake(0, 143, ScreenWidth, 100)];
    content.alpha=0.5;
    content.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_contentBck"]];
    content.layer.borderColor=[UIColor lightGrayColor].CGColor;
    content.layer.borderWidth=1.5;
    //content.layer.cornerRadius=6.0;
    content.font=[UIFont systemFontOfSize:15];
    content.numberOfLines=0;
    /*进行修改   预设内容数据*/
    @try {
       // NSString *str=[NSString stringWithFormat:@"    %@",[[[sxlDataBase_Sqlite sharedInstance]QueryContent_RecordUrlWithTitle:TitleStr] valueForKey:FT_CONTENT]];
        if ([[sxlDataBase_Sqlite sharedInstance] judgestatusforhave_recordOrcontent:TitleStr]) {
            //数据库有数据的时候获取
            content.text=[[[sxlDataBase_Sqlite sharedInstance]QueryContent_RecordUrlWithTitle:TitleStr] valueForKey:FT_CONTENT];
        }else
        {//数据库没有数据的时候预设数据
            content.text=[[[self getLabelImages] valueForKey:@"TripData"] valueForKey:TitleStr];
            
        }

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"插入内容信息");
    }
    
    NSLog(@"8888=%f",content.frame.origin.y);
    //图片浏览
    photoCarousel=[[iCarousel alloc]init];
    if ([IsSound isEqualToString:@"有"]) {
        //初始化播放器
        @try {
            NSString *path=[[[sxlDataBase_Sqlite sharedInstance] QueryContent_RecordUrlWithTitle:TitleStr] valueForKey:FT_RECORD_URL];
            ft_audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
            ft_audioPlayer.delegate=self;
            [ft_audioPlayer prepareToPlay];
            ft_audioPlayer.volume=0.8;

        }
        @catch (NSException *exception) {
            [iToast make:@"播放语音出错" duration:800];
        }
        @finally {
            NSLog(@"播放录音");
        }
       
        
        UIToolbar *tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, content.frame.origin.y+100, ScreenWidth, 30)];
        tool.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"foot_detail_soundbck"]];
        sound_PlayBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sound_PlayBtn.frame=CGRectMake(0, 0, 45, 30);
        [sound_PlayBtn setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
        sound_PlayBtn.tag=11;
        [sound_PlayBtn addTarget:self action:@selector(BtnClickedOnDetailView:) forControlEvents:UIControlEventTouchUpInside];
        sound_gif=[[UIImageView alloc]initWithFrame:CGRectMake(45, 0, 30, 30)];
        sound_gif.backgroundColor=[UIColor clearColor];
        
        //
        
        ft_progressBar=[[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(80, 0, 220, 30)];
        //[progressBar setThumbTintColor:[UIColor cyanColor]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [ft_progressBar setNumberFormatter:formatter];
        ft_progressBar.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
        
        ft_progressBar.popUpViewAnimatedColors = @[[UIColor purpleColor], [UIColor redColor], [UIColor orangeColor]];
        [ft_progressBar setValue:0.0];
        ft_progressBar.enabled=NO;
        [ft_progressBar addTarget:self action:@selector(handleProgressTapInSide:) forControlEvents:UIControlEventValueChanged];
        [tool addSubview:sound_gif];
        [tool addSubview:ft_progressBar];
        [tool addSubview:sound_PlayBtn];
        [self.view addSubview:tool];

        NSLog(@"88888%f",content.frame.origin.y);
        photoCarousel.frame=CGRectMake(0, tool.frame.origin.y+30, ScreenWidth, ScreenHeight-273);
        photoCarousel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"foot_detall_photo browser2"]];
    }else
    {
        photoCarousel.frame=CGRectMake(0,content.frame.origin.y+100, ScreenWidth, ScreenHeight-243);
        photoCarousel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"foot_detall_photo browser1"]];
    }
    //photoCarousel.backgroundColor=[UIColor clearColor];
    photoCarousel.delegate=self;
    photoCarousel.dataSource=self;
    photoCarousel.type = iCarouselTypeCoverFlow;
    photoCount_sqlite=[[NSMutableArray alloc]init];
   /*进行修改   预设图片数据*/
    if ([[sxlDataBase_Sqlite sharedInstance] judgeStatusForHaving_Photos:TitleStr]) {
        photoCount_sqlite=[[sxlDataBase_Sqlite sharedInstance]QueryImageDataOnDataBaseWithTitle:TitleStr];
        hasDataInSqlite=YES;

    }else
    {
        hasDataInSqlite=NO;
        photoCount_sqlite=[[self getLabelImages] valueForKey:@"pictureList"];//预设图片
    }
    UIButton *chooseType=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseType.frame=CGRectMake(ScreenWidth-30, photoCarousel.frame.size.height-30, 25, 25);
    [chooseType setImage:[UIImage imageNamed:@"foot_choosetype.png"] forState:UIControlStateNormal];
    chooseType.tag=12;
    [chooseType addTarget:self action:@selector(BtnClickedOnDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [photoCarousel addSubview:chooseType];
    [self.view addSubview:photoCarousel];
    [self.view addSubview:content];
    
    //添加更多按钮
    moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame=CGRectMake(ScreenWidth-65, 115, 60, 30);
    moreBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    //[moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"doubleArrowRight"] forState:UIControlStateNormal];
    moreBtn.hidden=YES;
    moreBtn.tag=15;
    [moreBtn addTarget:self action:@selector(BtnClickedOnDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:moreBtn aboveSubview:detail_background];
    
    [self getTheLocation_ForPosition];//加载界面
    
   
}
-(NSDictionary *)getLabelImages
{
    NSString *dataPath=[[NSBundle mainBundle]pathForResource:@"labelName" ofType:@"plist"];
    NSDictionary *labelData=[[NSDictionary alloc]initWithContentsOfFile:dataPath];
    return labelData;
    
}
-(void)getTheLocation_ForPosition
{/*通过给定的位置坐标获取位置信息*/
    
    @try {
        CLLocation *location=[[CLLocation alloc] initWithLatitude:[[locationStr objectAtIndex:1] doubleValue] longitude:[[locationStr objectAtIndex:0] doubleValue]];
        
        /////////获取位置信息
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        // newLocation.coordinate.latitude
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks,NSError *error)
         {
             NSLog(@"%@",placemarks);
             if (placemarks.count >0   )
             {
                 NSLog(@"%@",placemarks);
                 CLPlacemark * plmark = [placemarks objectAtIndex:0];
                  NSLog(@"%@",plmark.name);
                 NSLog(@"%@",plmark.addressDictionary);
                 NSString *TestStr=[[NSString alloc]init];
                 TestStr=[plmark.addressDictionary valueForKey:@"State"];
                 //判断是否是直辖市
                 if ([TestStr isEqualToString:@"北京市"]||[TestStr isEqualToString:@"天津市"]||[TestStr isEqualToString:@"上海市"]||[TestStr isEqualToString:@"重庆市"]) {
                     currentLocationStr=[NSString stringWithFormat:@"%@",TestStr];
                      moreBtn.hidden=NO;
                 }else
                 {//如果不是直辖市
                     moreBtn.hidden=NO;
                     NSLog(@"%@",plmark.name);
                     currentLocationStr=[NSString stringWithFormat:@"%@",plmark.locality];
                 }
                 //重新判断返回的地址信息是否为空
                 if ([currentLocationStr isEqualToString:@"(null)"]) {
                     moreBtn.hidden=YES;
                 }else
                 {
                     moreBtn.hidden=NO;
                 }
                 
             }
         }];


    }
    @catch (NSException *exception) {
         [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"获取地理位置信息");
    }
     
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot_naving.png"] forBarMetrics:UIBarMetricsDefault];
    updateCount=0;
    soundGif_Array=[NSArray arrayWithObjects:@"sound_play1.png",@"sound_play2.png",@"sound_play3.png", nil];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self initViewForDetail];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"foot_detail_share"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"foot_detail_shareHighlight"] forState:UIControlStateHighlighted];
    rightBtn.tag=13;
    [rightBtn addTarget:self action:@selector(BtnClickedOnDetailView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftBtn.tag=14;
    [leftBtn addTarget:self action:@selector(BtnClickedOnDetailView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=left;

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    photoCarousel = nil;
}
#pragma mark--------BtnClickedDelegate
-(void)BtnClickedOnDetailView:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {//地图 点击按钮显示详细地图
            [self initmapViewOnPopoverView];
        }
            break;
        case 11:
        {//语音播放
            [ft_audioPlayer play];
            sound_gif.hidden=NO;//播放时不隐藏
            ft_timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            soundGif_timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(ShowAnimationOnSoundPlay) userInfo:nil repeats:YES];
            [ft_progressBar setEnabled:YES];
        }
            break;
        case 12:
        {//图片浏览模式的切换
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择浏览方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌", nil];
            [sheet showInView:self.view];
        }
            break;
        case 13:
        {//分享
            detail_sheet=[[LXActionSheet alloc]initWithTitle:@"分享游记至" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"新浪微博",@"腾讯微博",@"网易微博"]];
            [detail_sheet showInView:self.view];
        }
            break;
        case 14:
        {
            [self.navigationController popViewControllerAnimated:YES];
            [photoCarousel removeFromSuperview];
        }
            break;
        case 15:
        {//进入更多描述界面
            The_Traval_routine *TTR=[[The_Traval_routine alloc]init];
            TTR.title=@"描述";
            TTR.Push_Tag=[NSString stringWithFormat:@"TimeLine"];
            TTR.TTR_city=currentLocationStr;
            TTR.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:TTR animated:YES];
        }
        default:
            break;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (UIView *view in photoCarousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    
    [UIView beginAnimations:nil context:nil];
    photoCarousel.type = buttonIndex;
    [UIView commitAnimations];
    
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
   // NSString *content=[NSString stringWithFormat:@"童鞋们,我正在玩#记忆留痕#,非常炫,非常好玩,是旅游玩耍的必备良器。扫描旁边的二维码就能好好的了解神器了,还等什么啊,一起扫一扫吧!"];
    UIImage *shareImage;
    if (hasDataInSqlite) {
        shareImage=[photoCount_sqlite objectAtIndex:0];
    }else
    {
        shareImage=[UIImage imageNamed:[photoCount_sqlite objectAtIndex:0]];
    }
    NSString *shareContent=[NSString stringWithFormat:@"    %@\n%@\n位置:%@",TitleStr,content.text,AddressStr];
    @try {
        id<ISSContent> publishContent = [ShareSDK content:shareContent
                                           defaultContent:@"记忆留痕，旅游者的必备利器!"
                                                    image:[ShareSDK jpegImageWithImage:shareImage quality:1.0]
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

#pragma mark- avaudioPlayer delegate
-(void)ShowAnimationOnSoundPlay
{
    updateCount=updateCount>2 ? 0:updateCount;
    sound_gif.image=[UIImage imageNamed:[soundGif_Array objectAtIndex:updateCount]];
    updateCount++;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self destoryTimer];
    [sound_gif setHidden:YES];
    [ft_progressBar setValue:0];

    [ft_progressBar setEnabled:NO];
    
}

-(void)handleProgressTapInSide:(id)sender
{//手动控制
    float currentValue = [(UISlider*)sender value];
    [ft_audioPlayer setCurrentTime:currentValue*ft_audioPlayer.duration];
    ft_timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
}
-(void)updateProgress{
    //播放进度更新
    [ft_progressBar setValue:ft_audioPlayer.currentTime/ft_audioPlayer.duration animated:YES];
}
-(void)destoryTimer{
    //销毁定时器   /*可能存在问题*/
    [ft_timer invalidate];
    [soundGif_timer invalidate];
    soundGif_timer=nil;
    ft_timer = nil;
}

#pragma mark--------ICarosel  Delegate
/*- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    
    [UIView beginAnimations:nil context:nil];
    carousel.type = buttonIndex;
    [UIView commitAnimations];
    
    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
}*/

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return photoCount_sqlite.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    @try {
        UIView *view;
        if (hasDataInSqlite) {
            view = [[UIImageView alloc] initWithImage:[photoCount_sqlite objectAtIndex:index]];
        }else
        {
            view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[photoCount_sqlite objectAtIndex:index]]];
            
        }
        if (IPHONE5) {
            view.frame = CGRectMake(70, 80, 200, 280);
        }else
        {
            view.frame = CGRectMake(70, 80, 200, 260-70);
        }
        
        return view;

    }
    @catch (NSException *exception) {
         [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"图片浏览处有bug");
    }
    
    
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return photoCount_sqlite.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = photoCarousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * photoCarousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
