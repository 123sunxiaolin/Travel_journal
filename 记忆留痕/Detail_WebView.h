//
//  Detail_WebView.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-23.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Detail_WebView : UIViewController<UIWebViewDelegate>
{
     UIActivityIndicatorView *activity;
}
@property (nonatomic,strong)NSString *webUrl;
@end
