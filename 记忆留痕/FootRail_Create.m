  //
//  FootRail_Create.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-2.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "FootRail_Create.h"
#import "defines.h"
#import "JYTextField.h"
#import "TestViewController.h"//
#import "Toast+UIView.h"
#import "iToast.h"
#import "UITextField+Shake.h"
#import "DXAlertView.h"
#import "sxlDataBase_Sqlite.h"
#import "sxlRequest_POST.h"//云端写入数据
#import "LBS_defines.h"
#import "CheckWLAN.h"
#import "SVProgressHUD.h"

#define KEYBOARD_HEIGHT  216
#define TOOL_HEIGHT 40
#define TOOL_IMAGE_HEIGHT 30
@interface FootRail_Create ()
{
    NSDictionary *jsonObjects_Cloud;
}
@property(nonatomic, strong)  UITextField *addressField;//用于检测网络状态
@end

@implementation FootRail_Create
@synthesize tool;
@synthesize editView;
@synthesize title_foot;
@synthesize mapTool;
@synthesize PushLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)ViewsOnToolBar
{
    //选项工具条
    tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, TOOL_HEIGHT)];
    tool.backgroundColor=[UIColor lightGrayColor];
    NSArray *imgTitles=[NSArray arrayWithObjects:@"keyboard_emotion",@"photo",@"voice",@"logo",@"unlock",@"keyboad_down", nil];
    for (NSInteger i=0; i<[imgTitles count]; i++) {
        UIButton *choiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
         choiceBtn.frame=CGRectMake(20+50*i, 5, 30, 30);
        [choiceBtn setImage:[UIImage imageNamed:[imgTitles objectAtIndex:i]] forState:UIControlStateNormal];
        choiceBtn.tag=101+i;
        [choiceBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
        [tool addSubview:choiceBtn];
    }
     [self.view addSubview:tool];
    [(UIButton *)[self.view viewWithTag:105] setEnabled:NO];
    [(UIButton *)[self.view viewWithTag:105] setHidden:YES];
    
    //创建显示地理位置信息的toolbar
    mapTool=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-40-35, ScreenWidth, 30)];
    mapTool.backgroundColor=[UIColor clearColor];
   /* UIImageView *img_map=[[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 15, 20)];
    img_map.image=[UIImage imageNamed:@"location_icon.png"];*/
    UIButton *locateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    locateBtn.frame=CGRectMake(10, 2, 15, 20);
    [locateBtn setImage:[UIImage imageNamed:@"location_icon.png"] forState:UIControlStateNormal];
    locateBtn.tag=111;
    [locateBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
    map_label=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, ScreenWidth, 25)];
    map_label.backgroundColor=[UIColor clearColor];
    map_label.textAlignment=NSTextAlignmentLeft;
    map_label.font=[UIFont systemFontOfSize:15];
    map_label.text=@"   正在定位....";
    //map_label.hidden=YES;
    locationActivityView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(8, 3, 20, 20)];
    [locationActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
  
    
    pictureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    pictureBtn.frame=CGRectMake(ScreenWidth-40, 0, 30, 30);
    pictureBtn.backgroundColor=[UIColor clearColor];
    [pictureBtn.layer setCornerRadius:3.0];
    [pictureBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [pictureBtn.layer setBorderWidth:1.0];
    pictureBtn.tag=107;
    pictureBtn.hidden=YES;
    [pictureBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
    
    img_chongdie=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-35, 0, 30, 30)];
    img_chongdie.backgroundColor=[UIColor clearColor];
    [img_chongdie.layer setCornerRadius:3.0];
    [img_chongdie.layer setBorderColor:[UIColor whiteColor].CGColor];
    img_chongdie.hidden=YES;
    [img_chongdie.layer setBorderWidth:1.0];
    [mapTool insertSubview:img_chongdie belowSubview:pictureBtn];
     [mapTool addSubview:pictureBtn];
    [mapTool addSubview:map_label];
    [mapTool addSubview:locateBtn];
    [mapTool insertSubview:locationActivityView aboveSubview:locateBtn];

    [self.view addSubview:mapTool];
    
    
}
-(void)LoadEditView
{
    //键盘弹出进行监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];//监听弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    editView=[[UITextView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-330)];
    editView.editable=YES;
    editView.textColor=[UIColor grayColor];
    editView.font=[UIFont systemFontOfSize:15];
    editView.pagingEnabled=YES;
    editView.delegate=self;
    editView.backgroundColor=[UIColor clearColor];
    editView.text=@"记录点难忘的事儿吧...";
    [self.view addSubview:editView];
    
    //添加一个label
    UILabel *c_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 50, 30)];
    c_label.backgroundColor=[UIColor clearColor];
    c_label.textColor=[UIColor orangeColor];
    c_label.text=@"标题:";
    [self.view insertSubview:c_label aboveSubview:editView];
    //添加标题输入框
    title_foot=[[JYTextField alloc]initWithFrame:CGRectMake(60, 70, 200, 30) cornerRadio:4.0 borderColor:[UIColor grayColor] borderWidth:0.4 lightColor:RGB(243, 168, 51) lightSize:8 lightBorderColor:RGB(235, 235, 235)];
    title_foot.returnKeyType=UIReturnKeyDefault;
    title_foot.borderStyle=UITextBorderStyleNone;
    title_foot.textColor=[UIColor blackColor];
    title_foot.font=[UIFont systemFontOfSize:15];
    title_foot.placeholder=@"起个有趣的名字吧...";
    title_foot.clearButtonMode=UITextFieldViewModeAlways;
    title_foot.delegate=self;
    title_foot.backgroundColor=[UIColor whiteColor];
    [title_foot becomeFirstResponder];
    [self.view insertSubview:title_foot aboveSubview:editView];
    //添加一条分割线
    /*UILabel *separateline=[[UILabel alloc]initWithFrame:CGRectMake(0, 105, ScreenWidth, 1.5)];
    
    separateline.backgroundColor=[UIColor lightGrayColor];
    //[self.view insertSubview:separateline aboveSubview:editView];*/
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 42)];
    img.image=[UIImage imageNamed:@"bg"];
    [self.view insertSubview:img aboveSubview:editView];
    

}
-(void)EnlargePhotos:(NSArray *)photos
{
    fullView=[[JWBlurView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [fullView setBlurAlpha:0.0];
    [fullView setBlurColor:[UIColor clearColor]];
    UITapGestureRecognizer *singTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOfMethod)];
    [fullView addGestureRecognizer:singTap];
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(20, 50, ScreenWidth-40, ScreenHeight-100)];
    scroll.pagingEnabled=YES;
    scroll.backgroundColor=[UIColor lightGrayColor];
    scroll.delegate=self;
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(scroll.frame.origin.x,scroll.frame.origin.y+scroll.frame.size.height-20 , ScreenWidth-40, 20)];
  
    [self.view addSubview:fullView];
    [fullView addSubview:scroll];
    [fullView addSubview:pageControl];
    
    [scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        scroll.contentSize=CGSizeMake(photos.count*scroll.frame.size.width, scroll.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            pageControl.numberOfPages=photos.count;
        });
        
        for (int i=0; i<photos.count; i++) {
            ALAsset *asset=photos[i];
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*scroll.frame.size.width, 0, scroll.frame.size.width, scroll.frame.size.height)];
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds=YES;
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [scroll addSubview:imgview];
            });
        }
    });

    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    if (![[[NSUserDefaults standardUserDefaults]  valueForKey:@"PushLabel"] isEqualToString:@"main"]) {
        UIButton *lockbtn=(UIButton *)[self.view viewWithTag:105];
        NSLog(@"11112222=%@",[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]);
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern] integerValue]!=1) {
            //设置成功
            [lockbtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
            IsSetPassword=YES;
         }else
        {
            [lockbtn setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
            IsSetPassword=NO;
        }

    }
   
}
#pragma mark------构造记载表情界面
-(void)CreateEmotionViewWithIsEmo:(BOOL)isEmo
{
    if (IsRecord) {
        //取消录音界面
        //[self LoadVoiceViewWithIsRecord:NO];
        [UIView animateWithDuration:0.5 animations:^{
            if (IsSpeaking) {
                [recordView commitRecording];//关闭录音
                IsSpeaking=NO;//重新检测是否正在录音
            }
            [recordView
             removeFromSuperview];
            tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT, ScreenWidth, TOOL_HEIGHT);
            mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35, ScreenWidth, 30);
            
        }completion:^(BOOL finished){
            IsRecord=NO;
        }];
        
        
    }

    if (isEmo) {
        [UIView animateWithDuration:0.5 animations:^{
            [self CancelKeyboard];
            tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT, ScreenWidth, TOOL_HEIGHT);
            mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35, ScreenWidth, 30);
            [emoView removeFromSuperview];
            
        }completion:^(BOOL finished){
            IsTopOnEmo=!isEmo;
        }];
        
        
        
    }else
    {//表情按键未点击
        
        [editView becomeFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
            [self CancelKeyboard];//键盘隐藏
            tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-KEYBOARD_HEIGHT, ScreenWidth, TOOL_HEIGHT);
            mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35-KEYBOARD_HEIGHT, ScreenWidth, 30);
            
            
        }completion:^(BOOL finished){
            IsTopOnEmo=!isEmo;
            emoView=[[TSEmojiView alloc]initWithFrame:CGRectMake(0, ScreenHeight-KEYBOARD_HEIGHT, ScreenWidth, KEYBOARD_HEIGHT)];
            emoView.backgroundColor=[UIColor whiteColor];
            emoView.layer.cornerRadius=3.0;
            emoView.layer.borderWidth=1.0;
            emoView.layer.borderColor=[UIColor grayColor].CGColor;
            emoView.delegate=self;
            [self.view addSubview:emoView];
            
        }];
    }
}
#pragma mark------构造录音界面
-(void)LoadVoiceViewWithIsRecord:(BOOL)isRecord
{
    //取消表情
    if (IsTopOnEmo) {
        // [self CreateEmotionViewWithIsEmo:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [emoView removeFromSuperview];
            tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT, ScreenWidth, TOOL_HEIGHT);
            mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35, ScreenWidth, 30);
            
        }completion:^(BOOL finished){
            IsTopOnEmo=NO;
        }];
        
    }

    if (isRecord) {
        //点击
        [UIView animateWithDuration:0.5 animations:^{
            [self CancelKeyboard];//键盘隐藏
            tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT, ScreenWidth, TOOL_HEIGHT);
            mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35, ScreenWidth, 30);
            if (IsSpeaking) {
                [recordView commitRecording];//关闭录音
                IsSpeaking=NO;//重新检测是否正在录音
            }
               [recordView removeFromSuperview];
            
        }completion:^(BOOL finished){
            IsRecord=!isRecord;
          
            
        }];
        
    }else
    {//未点击
        
        
        [UIView animateWithDuration:0.5 animations:^{
            [self CancelKeyboard];//键盘隐藏
            tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-KEYBOARD_HEIGHT, ScreenWidth, TOOL_HEIGHT);
            mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35-KEYBOARD_HEIGHT, ScreenWidth, 30);
            
            
        }completion:^(BOOL finished){
            IsRecord=!isRecord;
            recordView=[[FXRecordArcView alloc]initWithFrame:CGRectMake(0, ScreenHeight-KEYBOARD_HEIGHT, ScreenWidth, KEYBOARD_HEIGHT)];
            recordView.backgroundColor=[UIColor brownColor];
            recordView.alpha=0.88;
            recordView.delegate=self;
            [self.view addSubview:recordView];
            //录音按钮
            recordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            recordBtn.frame=CGRectMake((ScreenWidth-40)/2, 10, 40, 55);
            [recordBtn setImage:[UIImage imageNamed:@"record_start"] forState:UIControlStateNormal];
            recordBtn.tag=109;
            [recordBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
            [recordView addSubview:recordBtn];
            
            //视图
            playerBackgrpund=[[UIView alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, 50)];
            playerBackgrpund.backgroundColor=[UIColor clearColor];
            playerBackgrpund.hidden=YES;//初始化为隐藏
            //播放按钮
            playBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 5, 40, 40)];
            [playBtn setImage:[UIImage imageNamed:@"sound_play"] forState:UIControlStateNormal];
            [playBtn setImage:[UIImage imageNamed:@"sound_play_highlight"] forState:UIControlStateHighlighted];
            playBtn.tag=110;
            [playBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
            progressBar=[[ASValueTrackingSlider alloc]initWithFrame:CGRectMake(90, 10, 220, 30)];
            //[progressBar setThumbTintColor:[UIColor cyanColor]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterPercentStyle];
            [progressBar setNumberFormatter:formatter];
            progressBar.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
            
            progressBar.popUpViewAnimatedColors = @[[UIColor purpleColor], [UIColor redColor], [UIColor orangeColor]];
            [progressBar setValue:0.0];
            [progressBar addTarget:self action:@selector(handleProgressTapInSide:) forControlEvents:UIControlEventValueChanged];
            [playerBackgrpund addSubview:progressBar];
            [playerBackgrpund addSubview:playBtn];
            [recordView addSubview:playerBackgrpund];
            
            
            
        }];

        
    }
}
#pragma mark----------------定位Delegate
-(void)StartLocate
{
    if ([CheckWLAN CheckWLAN]) {
        if ([CLLocationManager locationServicesEnabled]) { // 检查定位服务是否可用
            [locationActivityView startAnimating];
        map_label.text=@"   正在定位....";
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter=0.5;
        [locationManager startUpdatingLocation]; // 开始定位
        }
    }else
    {
        [iToast make:@"网络未连接" duration:750];
        map_label.hidden=NO;
        map_label.text=@"无法定位";
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
           [locationActivityView stopAnimating];
         if (placemarks.count >0   )
         {
             NSLog(@"%@",placemarks);
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
             NSLog(@"11%@ loc=%f %f",plmark.name,newLocation.coordinate.latitude,newLocation.coordinate.longitude);
             map_label.font=[UIFont systemFontOfSize:12];
             map_label.text=plmark.name;
             LLcoordinate=newLocation;
             LocationStr=[NSString stringWithFormat:@"%@",plmark.name];
             
         }
     }];
    
    
    
}
// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [locationActivityView stopAnimating];
    map_label.text=@"无法定位!";
    NSLog(@"123===%@",[error description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //判断是否有录音文件
    HasRecord=NO;
    IsPlay=NO;
    //设置录音未开始
    IsSpeaking=NO;
    //设置录音按钮为点击
    IsRecord=NO;
    //设置表情按钮未点击
    IsTopOnEmo=NO;
    //初始化 最初没有对信息加密
    IsSetPassword=NO;
    //判断键盘是否弹出
    IsKeyboardUp=YES;
    RecordCount=[[NSUserDefaults standardUserDefaults] integerForKey:@"RecordCount"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    UIButton *finishedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    finishedBtn.frame=CGRectMake(0, 0, 50, 25);
    [finishedBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    finishedBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [finishedBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishedBtn.tag=100;
    [finishedBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:finishedBtn];
    self.navigationItem.rightBarButtonItem=right;
    UIButton *left_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    left_backBtn.frame=CGRectMake(0, 0, 30 , 30);
    [left_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [left_backBtn setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    left_backBtn.tag=108;
    [left_backBtn addTarget:self action:@selector(ClickOnFC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:left_backBtn];
    self.navigationItem.leftBarButtonItem=left;

    [self LoadEditView];
    [self ViewsOnToolBar];
    
    [self StartLocate];//已进入  就开始获取位置信息

}
- (NSString *)fullPathAtCache:(NSString *)fileName{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES != [fm fileExistsAtPath:path]) {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}
- (void)recordArcView:(FXRecordArcView *)arcView voiceRecorded:(NSString *)recordPath length:(float)recordLength{
    if (recordPath.length) {
        //初始化播放器
        HasRecord=YES;
        playerBackgrpund.hidden=NO;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[self fullPathAtCache:[NSString stringWithFormat:@"voice%d.wav",RecordCount]]] error:nil];
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];
        _audioPlayer.volume=0.8;

    }
    musicPath=[[NSString alloc]initWithString:recordPath];
    /*UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle: @"record"
                               message: [NSString stringWithFormat:@"录音地址：%@,  时常：%f",recordPath, recordLength]
                              delegate: nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alert show];*/
    
}

#pragma mark---------单击手势事件
-(void)singleTapOfMethod
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cameraIrisHollowClose";
    animation.subtype = kCATransitionFromBottom;
    [fullView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     [[self.view layer] addAnimation:animation forKey:@"animation"];
}
#pragma mark---------云存储和本地数据库存储方法
-(void)SendDataTo_CloudDataBase
{//password存储密码  tags 存储选择的标签
    //创建POI
    if ([CheckWLAN CheckWLAN]) {
        jsonObjects_Cloud=[[NSDictionary alloc]init];
        NSMutableDictionary *keys=[[NSMutableDictionary alloc]init];
        
        [keys setValue:title_foot.text forKey:LBS_Key_title];
        [keys setValue:map_label.text forKey:LBS_Key_ADDRESS];//暂定
        if (IsSetPassword) {
            [keys setValue:[[NSUserDefaults standardUserDefaults]objectForKey:kCurrentPattern] forKey:LBS_Key_PassWord];
        }else
        {
            [keys setValue:@"0" forKey:LBS_Key_PassWord];//表示没有设置密码
        }
        if (!Tag_label.length) {
            //Tag_label=[NSString stringWithFormat:@"NO"];
            [keys setValue:@"无" forKey:LBS_Key_tags];
        }else
        {
        [keys setValue:Tag_label forKey:LBS_Key_tags];
        }
        [keys setValue:[NSString stringWithFormat:@"%f",LLcoordinate.coordinate.latitude] forKey:LBS_Key_latitude];//暂定
        [keys setValue:[NSString stringWithFormat:@"%f",LLcoordinate.coordinate.longitude] forKey:LBS_Key_longitude];//暂定
        
        [keys setValue:@"1" forKey:LBS_Key_coord_type];
        [keys setValue:@"79080" forKey:LBS_Key_geotable_id];
        jsonObjects_Cloud=[[sxlRequest_POST sharedInstance]LBS_POST_RequestWithParams:keys RequestURl:LBS_Create_POI_URL RequestType:7];
        
        NSLog(@"返回的解析结果==%@",[jsonObjects_Cloud valueForKey:@"message"]);
        if ([[jsonObjects_Cloud valueForKey:@"message"] isEqualToString:@"成功"]) {
            //只有网络上传成功以后，才能进行本地数据存储
            [self SaveIntoSqlite];
        }else
        {
            [SVProgressHUD dismiss];
             NSLog(@"上传失败!");
            [iToast make:@"上传云端失败" duration:750];
        }
    }else
    {
        [iToast make:@"无法连接网络" duration:750];
    }
   
}
-(void)SaveIntoSqlite
{//包含  标题 内容 录音路径
    [[sxlDataBase_Sqlite sharedInstance] sxl_CreateTableOnDataBaseWithType:@"all"];
    BOOL IsOk=[[sxlDataBase_Sqlite sharedInstance]insertDataToDatabaseWithTitle:title_foot.text content:editView.text RecordURL:RecordPath];
    if (IsOk) {
        NSLog(@"存储标题 内容 录音路径成功");
        
        [[NSUserDefaults standardUserDefaults] setInteger:RecordCount forKey:@"RecordCount"];
    }
     BOOL ok;
    if (AllPhotos) {
        //如果图片数量不为空
        NSMutableArray *sqlite_imagesDatas=[[NSMutableArray alloc]init];
        for (int i=0; i<[AllPhotos count]; i++) {//保存图片
            ALAsset *asset=AllPhotos[i];
           // NSLog(@"image url==%@",asset.defaultRepresentation.url);
            //[imagesUrl addObject:[NSString stringWithFormat:@"%@",asset.defaultRepresentation.url]];
            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            NSData *imgData=UIImageJPEGRepresentation(image, 0.65);//压缩一下
            [sqlite_imagesDatas addObject:imgData];
        }
       // ALAsset *asset=AllPhotos[0];
      // NSArray *dataArray=[NSArray arrayWithObjects:imgData, nil];
        
        //插入
        [[sxlDataBase_Sqlite sharedInstance] sxl_CreateTableOnDataBaseWithType:@"imagedata"];
       
        ok=[[sxlDataBase_Sqlite sharedInstance]insertimageDatasToDatabaseWithTitle:title_foot.text imageDatas:sqlite_imagesDatas];
        if (ok) {
            NSLog(@"存储图片成功!");
        }
    }
    IsSaveToSqlite=ok&&IsOk;
}
#pragma mark---------点击事件
-(void)ClickOnFC:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {//完成按钮事件
            //判断输入文本是否为空
            
            if ([title_foot.text isEqualToString:@""]) {
                [self shake];
            }else if ([editView.text isEqualToString:@""]||[editView.text isEqualToString:@"记录点难忘的事儿吧..."])
            {
                //[self CancelKeyboard];
                DXAlertView *alert=[[DXAlertView alloc]initWithTitle:@"🌟小贴士🌟" contentText:@"美好的旅行更要留下难忘的记忆哟!" leftButtonTitle:nil rightButtonTitle:@"😄好😊"];
                [alert show];
                [self CancelKeyboard];
            } else
            {//满足条件
                [SVProgressHUD showWithStatus:@"上传中"];
                if (!HasRecord) {
                    NSLog(@"没有录音");
                    RecordPath=[NSString stringWithFormat:@""];
                }else
                {//需要保存一下
                    RecordPath=[self fullPathAtCache:[NSString stringWithFormat:@"voice%d.wav",RecordCount]];//获得录音的路径
                }
                [self SendDataTo_CloudDataBase];
                //[self SaveIntoSqlite];
                if (IsSaveToSqlite&&([[jsonObjects_Cloud valueForKey:@"message"]isEqualToString:@"成功"])) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                    [NSThread sleepForTimeInterval:1.0];//休眠
                    [self.navigationController popViewControllerAnimated:YES];
                    HasRecord=NO;//完成之后重新设置没有音频文件
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
                }
                //HasRecord=NO;//完成之后重新设置没有音频文件
            }
            
        }
            break;
        case 101:
        {//表情的按钮事件
            [self CreateEmotionViewWithIsEmo:IsTopOnEmo];
            
        }
            break;
        case 102:
        {//选择上传图片
            UIActionSheet *sheet;
            //需要判断是否支持相机拍照
            sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"手机拍照",@"手机相册选择", nil];
            
            [sheet showInView:self.view];
           
            
        }
            break;
        case 103:
        {//录音
           /* if (IsRecord) {
                
            }else
            {//录音按钮未点击
                [UIView animateWithDuration:0.5 animations:^{
                    [self CancelKeyboard];//键盘隐藏
                    tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-KEYBOARD_HEIGHT, ScreenWidth, TOOL_HEIGHT);
                    mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35-KEYBOARD_HEIGHT, ScreenWidth, 30);
                    
                    
                }completion:^(BOOL finished){
                    IsRecord=YES;
                    recordView=[[FXRecordArcView alloc]initWithFrame:CGRectMake(0, ScreenHeight-KEYBOARD_HEIGHT, ScreenWidth, KEYBOARD_HEIGHT)];
                    recordView.backgroundColor=[UIColor brownColor];
                    recordView.alpha=0.88;
                    recordView.delegate=self;
                    [self.view addSubview:recordView];
                }];
            }*/
            [self LoadVoiceViewWithIsRecord:IsRecord];
            
        }
            break;
        case 104:
        {//选择旅游标签&&构造弹出视图
        [self CancelKeyboard];//取消键盘
         NSArray *label_images=[[self getLabelImages] valueForKeyPath:@"label_imageNames"];
            CGPoint point =CGPointMake(185, tool.frame.origin.y+5);
            UIView *TagView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 100)];
            TagView.backgroundColor=[UIColor clearColor];
            for (int i=0; i<[label_images count]; i++) {
                 UIButton *label=[UIButton buttonWithType:UIButtonTypeCustom];
                if (i<7) {
                    label.frame=CGRectMake(10+40*i, 0, 30, 30);
                }else if (i>=7&&i<14)
                {
                    label.frame=CGRectMake(10+(i-7)*40, 35, 30, 30);
                }else
                {
                    label.frame=CGRectMake(10+(i-14)*40, 70, 30, 30);
                }
                [label setImage:[UIImage imageNamed:[label_images objectAtIndex:i]] forState:UIControlStateNormal];
                label.tag=1000+i;
                [label addTarget:self action:@selector(SetlabelImage:) forControlEvents:UIControlEventTouchUpInside];
                [TagView addSubview:label];
            }
            
            [PopoverView showPopoverAtPoint:point inView:self.view withTitle:@"为旅行做个标记吧!" withContentView:TagView  delegate:self];
        }
            break;
        case 105:
        {//笔记加密
            
            if (!IsSetPassword) {
                //如果没有设置密码
              TestViewController *lockView=[[TestViewController alloc]init];
           
                lockView.infoLabelStatus=InfoStatusFirstTimeSetting;
                lockView.title=@"加密ing";
               lockView.CancelBtn.hidden=YES;
                lockView.hidesBottomBarWhenPushed=YES;
                [self CancelKeyboard];//取消键盘弹出
                [self.navigationController pushViewController:lockView animated:YES];
                IsSetPassword=YES;
            }else
            {
                [(UIButton*)[self.view viewWithTag:105] setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
                IsSetPassword=NO;
                
                 [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:kCurrentPattern];
            }
            
           /*      BOOL isPatternSet = ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]) ? YES: NO;
                NSLog(@"123==%@",[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPattern]);
                if (isPatternSet)
                {//设置成功
                    UIButton *lockbtn=(UIButton*)[self.view viewWithTag:105];
                    [lockbtn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
                }*/
            
        }
            break;
        case 106:
        {//取消键盘按键
            if (IsKeyboardUp) {
                [self CancelKeyboard];
                IsKeyboardUp=NO;
            }else
            {
                [title_foot becomeFirstResponder];
                IsKeyboardUp=YES;
            }
            
        }
            break;
        case 107:
        {//查看多选的图片集
            [self CancelKeyboard];//取消键盘
            CATransition *animation = [CATransition animation];
            animation.delegate = self;
            animation.duration = 0.7;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            
            animation.type = @"cameraIrisHollowOpen";
            animation.subtype = kCATransitionFromBottom;
            /*UIView *scroll_imggallery=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            scroll_imggallery.backgroundColor=[UIColor lightGrayColor];
            [self.view addSubview:scroll_imggallery];*/
            [self EnlargePhotos:AllPhotos];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
            [[self.view layer] addAnimation:animation forKey:@"animation"];


        }
            break;
            
        case 108:
        {//退回
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 109:
        {//录音按钮
            if (IsSpeaking) {
            recordBtn.frame=CGRectMake((ScreenWidth-40)/2, 10, 40, 55);
               [recordBtn setImage:[UIImage imageNamed:@"record_start"] forState:UIControlStateNormal];
                //停止录音
                [recordView commitRecording];
                IsSpeaking=NO;
                
            }else
            {//开始录音
                RecordCount++;//点击数量加一
                playerBackgrpund.hidden=YES;//一重新录音就隐藏

                recordBtn.frame=CGRectMake((ScreenWidth-55)/2, 10, 55, 55);
               
                [recordBtn setImage:[UIImage imageNamed:@"record_stop"] forState:UIControlStateNormal];
                [recordBtn setImage:[UIImage imageNamed:@"record_stop_highlight"] forState:UIControlStateHighlighted];
                [recordView startForFilePath:[self fullPathAtCache:[NSString stringWithFormat:@"voice%d.wav",RecordCount]]];
                IsSpeaking=YES;
            }
        }
            break;
        case 110:
        {//录音的播放
            
            if (IsPlay) {
                //未播放
                [playBtn setImage:[UIImage imageNamed:@"sound_play"] forState:UIControlStateNormal];
                [playBtn setImage:[UIImage imageNamed:@"sound_play_highlight"] forState:UIControlStateHighlighted];
                [_audioPlayer pause];
                [self destoryTimer];//销毁
                [progressBar setEnabled:NO];
                IsPlay=!IsPlay;
            }else
            {//播放
                [playBtn setImage:[UIImage imageNamed:@"sound_stop"] forState:UIControlStateNormal];
                [playBtn setImage:[UIImage imageNamed:@"sound_stop_highlight"] forState:UIControlStateHighlighted];
                
                [_audioPlayer play];
                timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
                [progressBar setEnabled:YES];
                IsPlay=!IsPlay;
            }
        }
            break;
        case 111:
        {//地图重新定位
            [self StartLocate];
        }
            break;
        default:
            break;
    }
}
#pragma mark---------Textfield震动的方法
- (void)shake
{//when themeTextfield is null,it is shaking
	[title_foot shake:20 withDelta:5
           andSpeed:0.03
     shakeDirection:ShakeDirectionHorizontal];
}

#pragma mark---------添加旅行标签的方法
-(void)SetlabelImage:(UIButton *)sender
{
    UIButton *btn=(UIButton *)[self.view viewWithTag:104];
    [btn setImage:[UIImage imageNamed:[[[self getLabelImages]valueForKeyPath:@"label_imageNames"] objectAtIndex:sender.tag-1000]] forState:UIControlStateNormal];
    toastView=[[PopupView alloc]initWithFrame:CGRectMake(100, ScreenHeight-42, 0, 0)];
    toastView.ParentView=self.view;
    [self.view addSubview:toastView];
    [toastView setText:[[[self getLabelImages] valueForKeyPath:@"labelNames"] objectAtIndex:sender.tag-1000]];
    Tag_label=[NSString stringWithFormat:@"%@",[[[self getLabelImages] valueForKey:@"labelNames"] objectAtIndex:sender.tag-1000]];
   /* [self.view makeToast:[[[self getLabelImages] valueForKeyPath:@"labelNames"] objectAtIndex:sender.tag-1000]];*/
}
-(NSDictionary *)getLabelImages
{
    NSString *dataPath=[[NSBundle mainBundle]pathForResource:@"labelName" ofType:@"plist"];
    NSDictionary *labelData=[[NSDictionary alloc]initWithContentsOfFile:dataPath];
    return labelData;

}
#pragma mark- avaudioPlayer delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self destoryTimer];
    [progressBar setValue:0];
    [playBtn setImage:[UIImage imageNamed:@"sound_play"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"sound_play_highlight"] forState:UIControlStateHighlighted];
    [progressBar setEnabled:NO];
    IsPlay=NO;
   
}
-(void)handleProgressTapInSide:(id)sender
{//手动控制
    float currentValue = [(UISlider*)sender value];
    [_audioPlayer setCurrentTime:currentValue*_audioPlayer.duration];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];

}
-(void)updateProgress{
    //播放进度更新
    [progressBar setValue:_audioPlayer.currentTime/_audioPlayer.duration animated:YES];
}
-(void)destoryTimer{
    //销毁定时器   /*可能存在问题*/
    [timer invalidate];
    timer = nil;
}


#pragma mark - UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageControl.currentPage=floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
}

#pragma mark - 图片多项选择 Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    if (assets.count) {
        pictureBtn.hidden=NO;
        img_chongdie.hidden=NO;

        AllPhotos=[NSArray arrayWithArray:assets];//数组的替换
        if (assets.count==1) {
            //只选择了一张图片
            ALAsset *asset=assets[0];
            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [pictureBtn setImage:image forState:UIControlStateNormal];
        }else
        {
            NSMutableArray *imageArr=[[NSMutableArray alloc]init];
            for (int i=0; i<2; i++) {
                ALAsset *ass=assets[i];
                UIImage *image=[UIImage imageWithCGImage:ass.defaultRepresentation.fullScreenImage];
                [imageArr addObject:image];
                
            }
             [pictureBtn setImage:[imageArr objectAtIndex:0] forState:UIControlStateNormal];
            img_chongdie.image=[imageArr objectAtIndex:1];
        }
        
    }
   
    
}
#pragma mark - actionsheet delegate 判断是否支持相机与相册功能
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消");
            break;
        case 1:
        {
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {//支持
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                
                imagePickerController.delegate = self;
                
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:imagePickerController animated:YES completion:nil];

            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"当前不支持相机模式" message:nil delegate:self cancelButtonTitle:@"我知道咯!" otherButtonTitles:nil, nil];
                [alert show];
            }

        }
            break;
        case 2:
        {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 10;
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
             [self presentViewController:picker animated:YES completion:nil];

        }
            break;
        default:
            break;
    }
 }

#pragma mark-----emotionDelegate
- (void)didTouchEmojiView:(TSEmojiView*)emojiView touchedEmoji:(NSString*)str
{
    editView.text = [NSString stringWithFormat:@"%@%@", editView.text, str];
}
#pragma mark--------TextfieldDelagate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [editView resignFirstResponder];
    return YES;
}
#pragma mark--------TextViewDelagate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([editView.text isEqualToString:@"记录点难忘的事儿吧..."]) {
        editView.text=@"";
        editView.textColor=[UIColor blackColor];

    }
     return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([editView.text isEqualToString:@""]) {
        editView.text=@"记录点难忘的事儿吧...";
        editView.textColor=[UIColor grayColor];

    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    editView.textColor=[UIColor blackColor];
}
#pragma mark---------监听键盘事件
-(void)keyboardWillShow
{//弹出
    [(UIButton*)[self.view viewWithTag:106] setImage:[UIImage imageNamed:@"keyboard_down"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [emoView removeFromSuperview];
        [recordView removeFromSuperview];
        if (IsSpeaking) {
            [recordView commitRecording];//关闭录音
            IsSpeaking=NO;//重新检测是否正在录音
        }

        tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-KEYBOARD_HEIGHT, ScreenWidth, TOOL_HEIGHT);
        mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35-KEYBOARD_HEIGHT, ScreenWidth, 30);
        
    }completion:^(BOOL finished){
    }];

}
-(void)keyboardWillHide
{//隐藏
    [(UIButton*)[self.view viewWithTag:106] setImage:[UIImage imageNamed:@"keyboard_on"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        tool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT, ScreenWidth, TOOL_HEIGHT);
        mapTool.frame=CGRectMake(0, ScreenHeight-TOOL_HEIGHT-35, ScreenWidth, 30);
       // [emoView removeFromSuperview];
        
    }completion:^(BOOL finished){
    }];
    

}
-(void)CancelKeyboard
{
    [editView resignFirstResponder];
    [title_foot resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{//隐藏键盘的方法
	[self.view.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[UITextField class]]||[obj isKindOfClass:[UITextView class]]) {
			[obj resignFirstResponder];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
