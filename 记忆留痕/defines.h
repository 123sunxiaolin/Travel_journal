//
//  defines.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#ifndef _____defines_h
#define _____defines_h
//判断系统版本、屏幕尺寸

#define IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define IOS7 [[UIDevice currentDevice].systemVersion doubleValue]>=7.0

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define CommonColor [UIColor colorWithRed:11/255.0 green:90/255.0 blue:172/255.0 alpha:1.0]

//加密
#define kCurrentPattern												@"KeyForCurrentPatternToUnlock"
#define kCurrentPatternTemp										@"KeyForCurrentPatternToUnlockTemp"
//
#define ITEM_SPACING 200
#define kDuration 0.7   // 动画持续时间(秒)
#endif
