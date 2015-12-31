//
//  Detail_WebView.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-23.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "Detail_WebView.h"
#import "defines.h"
#import "iToast.h"
@interface Detail_WebView ()

@end

@implementation Detail_WebView
@synthesize webUrl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"weburl=%@",webUrl);
    UIWebView *detail=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    detail.backgroundColor=[UIColor colorWithRed:0.77 green:1.0 blue:0.66 alpha:1.0];
    detail.delegate=self;
    detail.scalesPageToFit=YES;//自动适合大小
    [detail loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    activity= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    activity.backgroundColor=[UIColor blackColor];
    [activity setCenter:self.view.center];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.hidesWhenStopped=YES;
    [detail addSubview:activity];
    [self.view addSubview:detail];
}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activity= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    activity.backgroundColor=[UIColor blackColor];
    [activity setCenter:self.view.center];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.hidesWhenStopped=YES;
    [view addSubview:activity];
    [activity startAnimating];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    
    [activity stopAnimating];
    activity.hidden=YES;
    //[activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activity stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    [iToast make:[error localizedDescription] duration:800];
    NSLog(@"%@",[error description]);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
