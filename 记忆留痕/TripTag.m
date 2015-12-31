//
//  TripTag.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-1.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "TripTag.h"
#import "ChineseToPinyin.h"
#import "UIColor+HTColor.h"
#import "fir_sec_thi_fot_detailView.h"
#import "LBS_defines.h"
#import "iToast.h"
#import "sxlRequest_GET.h"
#import "defines.h"
@interface TripTag ()

@end

@implementation TripTag
@synthesize sphereView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark----设置tab图标和文字
- (NSString *)tabImageName
{
	return @"second";
}

- (NSString *)tabTitle
{
	return @"景点热";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Trip_seach_bck"]];
    scenesArray=[[NSArray alloc]init];
    scenesArray=[[self gethotscenes] valueForKey:@"hotscenes"];
    if (ScreenHeight==568) {
         sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(0, 140-64, 320, 320)];
    }else
    {
    sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(0, 40, 320, 320)];
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i <[scenesArray count]; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[scenesArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lemonColor] forState:UIControlStateNormal];
        [btn
         setTitleColor:[UIColor sunflowerColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:20.];
        btn.frame = CGRectMake(0, 0, 80, 20);
        btn.tag=10+i;
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [sphereView addSubview:btn];
    }
    [sphereView setCloudTags:array];
    sphereView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sphereView];
}
- (void)buttonPressed:(UIButton *)btn
{
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2.5, 2.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [sphereView timerStart];
            
            NSDictionary *jsonobjects=[[NSDictionary alloc]init];
            @try {
                NSString *last=[NSString stringWithFormat:@"%@%@",CLW_HOTSCENE_URL,[ChineseToPinyin pinyinFromChiniseString:[scenesArray objectAtIndex:btn.tag-10]]];//合成后的URL
                NSLog(@"%@",last);

                jsonobjects=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:last];
                NSLog(@"json=%@",jsonobjects);
                if ([[jsonobjects valueForKey:@"status"] isEqualToString:@"Success"]) {
                    fir_sec_thi_fot_detailView *fview=[[fir_sec_thi_fot_detailView alloc]init];
                    fview.title=@"热门景点介绍";
                    fview.fstfd_UrlStr=last;
                    fview.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:fview animated:YES];

                }else{
                    [iToast make:@"暂无数据" duration:900];
                }
                
            }
            @catch (NSException *exception) {
                [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
            }
            @finally {
                NSLog(@"点击判断");
            }
        }];
    }];
    //NSLog(@"%@",[ChineseToPinyin pinyinFromChiniseString:@"香格里拉"]);
    /*动画结束以后  进行跳转*/
   
}
-(NSDictionary *)gethotscenes
{
    NSString *dataPath=[[NSBundle mainBundle]pathForResource:@"labelName" ofType:@"plist"];
    NSDictionary *labelData=[[NSDictionary alloc]initWithContentsOfFile:dataPath];
    return labelData;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
