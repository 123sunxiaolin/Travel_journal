//
//  The_Traval_routine.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-23.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface The_Traval_routine : UIViewController
{
    
    //
    UIView *functionview;
    
    UILabel *ttitleStr;
    UILabel *CityNameLabel;//城市名称
    UILabel *datelabel;//日期
    UITextView *abstractTextview;//梗概
    UITextView *contentTextView;//内容
    
    //url
    NSDictionary *URL_jsonObjects;

    int StarCount;//星星的计数
    NSString *dateStr;
    NSString *contentStr;
    NSString *web_url;
    NSMutableArray *trip_type;
    //自定义旋转等待
    UIActivityIndicatorView *activityView;
    
}
@property (nonatomic ,strong) NSString *TTR_city;
@property (nonatomic,strong) NSString *Push_Tag;
@property (nonatomic,strong) NSArray *lai_long;
-(void)initDetailView_trip;
/*btnclick*/
-(void)btnClick:(UIButton *)sender;
@end
