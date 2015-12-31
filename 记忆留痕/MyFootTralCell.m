//
//  MyFootTralCell.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-18.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "MyFootTralCell.h"
/*cellHeight=50.0*/
@implementation MyFootTralCell
@synthesize TopSegment,BottomSegment,DateImage,YDatelabel,AddressLabel,TimeLabel,SerNum;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       YDatelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 80)];
        YDatelabel.backgroundColor=[UIColor clearColor];
        YDatelabel.numberOfLines=0;
        YDatelabel.textColor=[UIColor blackColor];
        YDatelabel.font=[UIFont systemFontOfSize:15];
        CGFloat dateImageWidth=30.0;
        CGFloat lineWidth=5.0;
        TopSegment=[[UILabel alloc]initWithFrame:CGRectMake(50+(dateImageWidth-lineWidth)/2, 0, 3, 15)];
        TopSegment.backgroundColor=[UIColor lightGrayColor];
        DateImage=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 30, 30)];
        DateImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"myfootcell_circle_day_index.png"]];
        DateImage.textAlignment=NSTextAlignmentCenter;
        DateImage.textColor=[UIColor blackColor];
        DateImage.font=[UIFont boldSystemFontOfSize:15];
        BottomSegment=[[UILabel alloc]initWithFrame:CGRectMake(TopSegment.frame.origin.x, 40, 3, 15+30)];
        BottomSegment.backgroundColor=[UIColor lightGrayColor];
        
        AddressLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 6, 200, 40)];
        AddressLabel.backgroundColor=[UIColor clearColor];
        AddressLabel.textColor=[UIColor blackColor];
        AddressLabel.font=[UIFont systemFontOfSize:16];
        SerNum=[[UILabel alloc] initWithFrame:CGRectMake(320-30, 5, 25, 25)];//序列号
        SerNum.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"myfootcell_circle"]];
        SerNum.font=[UIFont systemFontOfSize:15];
        SerNum.textAlignment=NSTextAlignmentCenter;//居中
        SerNum.textColor=[UIColor orangeColor];
        TimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 40, 200, 30)];
        TimeLabel.backgroundColor=[UIColor clearColor];
        TimeLabel.font=[UIFont systemFontOfSize:11];
        TimeLabel.textColor=[UIColor orangeColor];
        [self addSubview:TopSegment];
        [self addSubview:DateImage];
        [self addSubview:BottomSegment];
        [self addSubview:YDatelabel];
        [self addSubview:AddressLabel];
        [self addSubview:TimeLabel];
        [self addSubview:SerNum];
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
