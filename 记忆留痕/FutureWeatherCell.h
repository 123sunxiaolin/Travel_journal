//
//  FutureWeatherCell.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-21.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FutureWeatherCell : UITableViewCell
@property (nonatomic,strong) UIImageView *F_imageView;//显示未来几天的天气图标
@property(nonatomic,strong) UILabel *weather_label;//天气情况
@property (nonatomic,strong) UILabel *temperatureLabel;//温度范围
@property (nonatomic,strong) UILabel *Windlabel;//风力情况
@property (nonatomic,strong) UILabel *Datelabel;//日期
@end
