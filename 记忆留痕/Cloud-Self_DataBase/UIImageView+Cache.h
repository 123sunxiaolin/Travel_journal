//
//  UIImageView+Cache.h
//  LoadImage
//
//  Created by zdy on 13-8-18.
//  Copyright (c) 2013年 ZDY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)<NSURLConnectionDelegate>
//两个接口都能实现加载数据
- (void)setImageWithUrl:(NSString*)url;
- (void)setImageWithRequest:(NSString *)url;
@end
