//
//  TimeLine.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "MakeLine.h"
#import "DDPageControl.h"
#import "CheckWLAN.h"
@interface TimeLine : UIViewController<MakeLine,UIScrollViewDelegate>
{
    UIScrollView  *HeadScrollView;//滑动显示功能界面
    UIPageControl *pageControl;//页控件
    NSMutableArray *SlideImgArray;//存储图片
    UILabel *HintLabel;//动态推送消息
    NSArray *flagArr;//功能数组
    NSArray *infoArr;//动态消息
    UILabel *FlagLabel;//功能标签
    //网络获取数据
    NSDictionary *jsonObjects;//解析的数据
    int size_number;
    UIButton *No_loadBtn;//未加载按钮
    NSMutableArray *get_titleArray;//title
    NSMutableArray *get_AddressArray;//address
    NSMutableArray *get_dateArray;//date
    NSMutableArray *get_tagArray;//tag
    NSMutableArray *get_CoordinateArray;//coordinate
    NSString * IsHasRecord;//判断是否有录音
    
    
   
}

-(void)initHeadView;

/*------****------构造时光轴----***----*/
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView_line;
@property (strong, nonatomic) UIButton *monthButton;
@property (strong, nonatomic) UIImageView *massageView;
@property NSInteger a;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) UIImageView *massageImageView;
//@property (strong, nonatomic) NSMutableArray *photoImageViewArray;

//@property (strong, nonatomic) UILabel *labelMode;
//@property (strong, nonatomic) UILabel *monthlabel;

//动态array
@property (strong, nonatomic) NSMutableArray *massageViewArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *TagArray;//用于存储tag 没有上传的  显示星星
//@property (strong, nonatomic) NSMutableArray *allPhotoArrayArray;
@property (strong, nonatomic) UIImageView * animationImageView;
@property NSInteger y;
@property (strong, nonatomic) UIImageView *AddimageView;
//@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) CATransition *animation1;
@property (strong, nonatomic) NSMutableArray *arrayMonths;
@property NSInteger b;
@property (strong, nonatomic) UIImageView *line;
@property (strong, nonatomic) UIImageView *line1;
@property (nonatomic,strong) UIImageView *pictureView;
@property (strong, nonatomic)UIImageView *locationIcon;//地理位置图标
@property (strong, nonatomic)UILabel *locationLabel;
@property (nonatomic,strong) UIImageView *hasRecordIcon;

@property (nonatomic,strong) NSMutableArray *cellbtnArray;
@property (nonatomic,strong) NSMutableArray *pswStatusArr;
@property (nonatomic,strong) NSMutableArray *DatalabelArray;//日期标签

@property (strong, nonatomic)  UIButton *stealthButton;
@property NSInteger c;
-(void)DrawlineAndLoadViews;

/*点击事件的方法*/
-(void)BtnClickOnTimeLine:(UIButton *)sender;
/*解析云端数据*/
-(void)getDataFromCloud;
/*获取当前地理位置信息*/
//-(void)getLocationPositionForWeather;
@end
