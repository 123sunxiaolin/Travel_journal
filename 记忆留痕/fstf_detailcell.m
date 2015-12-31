//
//  fstf_detailcell.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-24.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "fstf_detailcell.h"
#import "defines.h"
@implementation fstf_detailcell
@synthesize cell_label,cellimg;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellimg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 50)];
        cellimg.image=[UIImage imageNamed:@"fstf_cellBg"];
        cell_label=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, 200, 40)];
        cell_label.font=[UIFont systemFontOfSize:18];
        [cellimg addSubview:cell_label];
        [self addSubview:cellimg];
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
