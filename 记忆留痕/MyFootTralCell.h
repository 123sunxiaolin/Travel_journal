//
//  MyFootTralCell.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-18.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFootTralCell : UITableViewCell
@property (nonatomic,strong) UILabel *TopSegment;//上段
@property (nonatomic,strong) UILabel *BottomSegment;//下段
@property (nonatomic,strong) UILabel *DateImage;//用于显示日
@property (nonatomic,strong) UILabel *YDatelabel;//显示年月
@property (nonatomic,strong) UILabel *AddressLabel;//显示显示详细地址信息
@property (nonatomic,strong) UILabel *TimeLabel;//精确时间信息
@property (nonatomic,strong) UILabel *SerNum;//走过的地点序列号
@end
