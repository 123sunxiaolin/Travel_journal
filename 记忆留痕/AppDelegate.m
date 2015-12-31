//
//  AppDelegate.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "AppDelegate.h"
#import "TimeLine.h"
#import "TripTag.h"
#import "Query.h"
#import "AKTabBarController.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboApi.h"
#import "GuideView.h"
@implementation AppDelegate
@synthesize tabBarController;
- (void)initializePlat
{
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];//新浪
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];//腾讯
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];//网易
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //用于加载视图
    [NSThread sleepForTimeInterval:9.0]; //延时2秒，以便用户看清楚启动页
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callbackFunction:)
                                                 name:@"welcomeview"
                                               object:nil];
    //增加表识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }


    [ShareSDK registerApp:@"iosv1101"];//注册key
    [self initializePlat];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //时光轴
    TimeLine *time=[[TimeLine alloc]init];
    time.title=@"时光轴";
    UINavigationController *firstNav=[[UINavigationController alloc]initWithRootViewController:time];
    firstNav.navigationBar.alpha=0.5;
    //景点热
    TripTag *tag=[[TripTag alloc]init];
    tag.title=@"景点热";
    UINavigationController *secondNav=[[UINavigationController alloc]initWithRootViewController:tag];
    [secondNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot_naving.png"] forBarMetrics:UIBarMetricsDefault];
    //旅行查
    Query *query=[[Query alloc]init];
    query.title=@"旅行查";
    UINavigationController *thirdNav=[[UINavigationController alloc]initWithRootViewController:query];
    [thirdNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot_naving.png"] forBarMetrics:UIBarMetricsDefault];
    //
    tabBarController=[[AKTabBarController alloc]initWithTabBarHeight:50];
    [tabBarController setMinimumHeightToDisplayTitle:40.0];
    [tabBarController setViewControllers:[NSMutableArray arrayWithObjects:firstNav,secondNav,thirdNav, nil]];
    [tabBarController setBackgroundImageName:@"noise-dark-gray.png"];
    [tabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
      if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
          GuideView *guide=[[GuideView alloc]init];
          self.window.rootViewController=guide;
          [[UIApplication sharedApplication] setStatusBarHidden:TRUE];

    }else
    {
         self.window.rootViewController=tabBarController;
    }
    [self.window makeKeyAndVisible];

    return YES;
}
-(void)callbackFunction:(NSNotification*)notification//接受通知
{
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    
    NSDictionary *dic;
    dic=[notification userInfo];
    NSString *info=[dic objectForKey:@"loadtag"];
    if ([info isEqualToString:@"firstload"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //时光轴
        TimeLine *time=[[TimeLine alloc]init];
        time.title=@"时光轴";
        UINavigationController *firstNav=[[UINavigationController alloc]initWithRootViewController:time];
        firstNav.navigationBar.alpha=0.5;
        //景点热
        TripTag *tag=[[TripTag alloc]init];
        tag.title=@"景点热";
        UINavigationController *secondNav=[[UINavigationController alloc]initWithRootViewController:tag];
        [secondNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot_naving.png"] forBarMetrics:UIBarMetricsDefault];
        //旅行查
        Query *query=[[Query alloc]init];
        query.title=@"旅行查";
        UINavigationController *thirdNav=[[UINavigationController alloc]initWithRootViewController:query];
        [thirdNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"foot_naving.png"] forBarMetrics:UIBarMetricsDefault];
        //
        tabBarController=[[AKTabBarController alloc]initWithTabBarHeight:50];
        [tabBarController setMinimumHeightToDisplayTitle:40.0];
        [tabBarController setViewControllers:[NSMutableArray arrayWithObjects:firstNav,secondNav,thirdNav, nil]];
        [tabBarController setBackgroundImageName:@"noise-dark-gray.png"];
        [tabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
        self.window.rootViewController=tabBarController;
        [self.window makeKeyAndVisible];

    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}//禁止横屏

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
