//
//  FootRail_Create.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-2.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TSEmojiView.h"
#import "ZYQAssetPickerController.h"
#import "JWBlurView.h"//麻面视图
#import "FXRecordArcView.h"//录音界面
#import "ASValueTrackingSlider.h"//滑动条
#import "PopoverView.h"//弹出视图
#import "PopupView.h"


@class JYTextField;
@interface FootRail_Create : UIViewController<TSEmojiViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,FXRecordArcViewDelegate,AVAudioPlayerDelegate,PopoverViewDelegate,CLLocationManagerDelegate>
{
    BOOL IsTopOnEmo;//判断表情按钮是否被点击
    BOOL IsSetPassword;//是否设置密码
    TSEmojiView *emoView;//表情视图
    UILabel *map_label;//显示当前位置信息
    UIButton *pictureBtn;//图片按钮
    UIImageView *img_chongdie;//设置重叠图片
    NSArray *AllPhotos;//缓存一下选择的图片&&判断是否选择图片
    
    /*图片查看*/
    JWBlurView *fullView;
    UIScrollView *scroll;
    UIPageControl *pageControl;
    
    /*录音*/
    BOOL IsRecord;//判断是否弹出录音界面
    BOOL IsSpeaking;//判断是否点击开始录制按钮
    BOOL IsPlay;//判断是否播放
    FXRecordArcView *recordView;
    UIButton *recordBtn;
    UIButton *playBtn;
    AVAudioPlayer *_audioPlayer;//播放器
    NSString *musicPath;//录音的路径
    NSTimer *timer;//定时器
    UIView *playerBackgrpund;//呈现录音播放的视图
    ASValueTrackingSlider *progressBar;//播放进度
    PopupView *toastView;
    NSInteger RecordCount;//用于创建
    
    BOOL HasRecord;//用于判断是否有录音文件
    BOOL IsLinkedToNet;//判断是否连接上网络
    BOOL IsSaveToSqlite;//判断存储到本地数据库是否成功
    NSString *Tag_label;//用于存储选择的标签名称
    NSString *RecordPath;//用于临时存储录音的路径
    CLLocationManager *locationManager;//定位
    UIActivityIndicatorView *locationActivityView;//用于加载地图信息
    CLLocation *LLcoordinate;//存储
    NSString *LocationStr;//位置信息
    
    //键盘弹出
    BOOL IsKeyboardUp;
}
@property (nonatomic,strong)UITextView *editView;//新鲜事的输入
@property (nonatomic,strong)JYTextField *title_foot;//标题的输入
@property (nonatomic,strong) UIView *mapTool;//加载位置信息
@property (nonatomic,strong) UIToolbar *tool;//视图下方的选项条
@property (nonatomic,strong) NSString *PushLabel;//用于确定从哪个界面push进来的
-(void)ViewsOnToolBar;//构造工具条
-(void)LoadEditView;//加载主页面

/*点击事件*/
-(void)ClickOnFC:(UIButton*)sender;

-(void)keyboardWillShow;//监听键盘的弹出
-(void)keyboardWillHide;//监听键盘的隐藏
-(void)CancelKeyboard;//取消键盘
-(void)EnlargePhotos:(NSArray*)photos;//放大所选择的相片
-(void)singleTapOfMethod;
/*加载表情界面*/
-(void)CreateEmotionViewWithIsEmo:(BOOL)isEmo;
/*构造录音界面的方法*/
-(void)LoadVoiceViewWithIsRecord:(BOOL)isRecord;
/*滑条控制录音的播放*/
-(void)handleProgressTapInSide:(id)sender;
/*添加旅行标签的方法*/
-(void)SetlabelImage:(UIButton*)sender;
/*返回标签的数据*/
-(NSDictionary *)getLabelImages;
@end
