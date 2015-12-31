//
//  Func_TwoDimensionView.h
//  记忆留痕
//
//  Created by kys-2 on 14-10-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXActionSheet.h"
@interface Func_TwoDimensionView : UIViewController<LXActionSheetDelegate>
{
    UIButton *rightBtn;//导航栏右边的按钮
    UIView *bckView;
    UIImageView *Code_imageView;
    
    NSDictionary *TDV_json;
    
    LXActionSheet *lxsheet;//sheet
    UIImage *TwoDimensionImage;//用于动态存储二维码image
}
-(void)initShareView;
-(void)GetTwo_DismensionView;
@end
