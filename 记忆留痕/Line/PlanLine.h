//
//  PlanLine.h
//  Testhuitu
//
//  Created by gg on 7/1/13.
//  Copyright (c) 2013 sunland.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MakeLine.h"
@interface PlanLine : NSObject<MakeLine>

@property (assign, nonatomic)id<MakeLine> delegate;
-(void)setImageView:(UIImageView *)imageview setlineWidth:(float)lineWidth setColorRed:(float)colorR ColorBlue:(float)colorB ColorGreen:(float)colorG Alp:(float)alp setBeginPointX:(int)x BeginPointY:(int)y setOverPointX:(int)ox OverPointY:(int)oy;
@end
