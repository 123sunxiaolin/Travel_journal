//
//  TL_DetailView.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-16.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import "iCarousel.h"
#import "ASValueTrackingSlider.h"//滑动条
#import "PopoverView.h"//弹出气泡视图
#import "WXAnation.h"
#import "LXActionSheet.h"
@interface TL_DetailView : UIViewController<iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,AVAudioPlayerDelegate,PopoverViewDelegate,MKMapViewDelegate,LXActionSheetDelegate>
{
    BOOL hasDataInSqlite;//判断数据库是否有数据
    int updateCount;//用于记录动画的循环次数
    UILabel *content;//消息内容
    UIImageView *sound_gif;//播放动画
    UIButton *sound_PlayBtn;//播放按钮
    NSArray *soundGif_Array;//动画图片数组
    AVAudioPlayer *ft_audioPlayer;//播放器
    ASValueTrackingSlider *ft_progressBar;//播放进度条
    NSTimer *ft_timer;//定时器
    NSTimer *soundGif_timer;//控制语音播放动画


    iCarousel *photoCarousel;//图片浏览器
    NSMutableArray *photoCount_sqlite;//图片数量
    
    //地图
    MKMapView* my_mapView;
    WXAnation *map_ann;//大头针
    UIButton *moreBtn;
    NSString *currentLocationStr;//当前坐标下的地理位置信息
    LXActionSheet *detail_sheet;//sheet
   // NSArray *array_str_image;
}
@property (nonatomic,strong) NSString *TitleStr;//标题
@property (nonatomic,strong) NSString *AddressStr;//地址
@property (nonatomic,strong) NSString *DateStr;//日期
@property (nonatomic,strong) NSArray *locationStr;//位置经纬度
@property (nonatomic,strong) NSString *IsSound;//是否有录音
-(void)initViewForDetail;//加载详细视图
/*点击事件*/
-(void)BtnClickedOnDetailView:(UIButton *)sender;
/*播放语音时 呈现的动画效果*/
-(void)ShowAnimationOnSoundPlay;
-(void)initmapViewOnPopoverView;
@end
