//
//  FutureWeatherCell.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-21.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "FutureWeatherCell.h"

@implementation FutureWeatherCell
@synthesize weather_label,F_imageView,temperatureLabel,Windlabel,Datelabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //1
        F_imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 35)];
        F_imageView.backgroundColor=[UIColor clearColor];
        
        //2
        temperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 65, 20)];
        temperatureLabel.textColor=[UIColor blackColor];
        temperatureLabel.font=[UIFont systemFontOfSize:13];
        //3
        weather_label=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
        weather_label.textColor=[UIColor blackColor];
        weather_label.font=[UIFont boldSystemFontOfSize:20];
        //4
        Windlabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 50, 100, 20)];
        Windlabel.textColor=[UIColor blackColor];
        Windlabel.textAlignment=NSTextAlignmentLeft;
        Windlabel.font=[UIFont systemFontOfSize:16];
        //5
        Datelabel=[[UILabel alloc]initWithFrame:CGRectMake(260, 20, 60, 40)];
        Datelabel.textColor=[UIColor lightGrayColor];
        Datelabel.font=[UIFont systemFontOfSize:20];
        [self addSubview:F_imageView];
        [self addSubview:temperatureLabel];
        [self addSubview:weather_label];
        [self addSubview:Windlabel];
        [self addSubview:Datelabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
