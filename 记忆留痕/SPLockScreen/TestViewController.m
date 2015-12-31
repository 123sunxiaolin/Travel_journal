//
//  TestViewController.m
//  SuQian
//
//  Created by Suraj on 24/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "TestViewController.h"
#import "NormalCircle.h"
#import "defines.h"
@interface TestViewController ()<LockScreenDelegate>

@property (nonatomic) NSInteger wrongGuessCount;
@end

@implementation TestViewController
@synthesize infoLabelStatus,wrongGuessCount,CancelBtn;

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
    // Do any additional setup after loading the view from its nib.
    CancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CancelBtn.frame=CGRectMake(ScreenWidth-60, 30, 50, 50);
    [CancelBtn.layer setBorderColor:[UIColor grayColor].CGColor];
    //[CancelBtn.layer setBorderWidth:2];
    [CancelBtn.layer setMasksToBounds:YES];
    //[btn.layer setMasksToBounds:YES];
    [CancelBtn.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    [CancelBtn setImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [CancelBtn addTarget:self action:@selector(ViewDownToHide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CancelBtn];
	self.view.backgroundColor = CommonColor;
}

-(void)ViewDownToHide
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{	
	[super viewDidAppear:animated];
	
	self.lockScreenView = [[SPLockScreen alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
	self.lockScreenView.center = self.view.center;
	self.lockScreenView.delegate = self;
	self.lockScreenView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.lockScreenView];
	
	self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight-150, self.view.frame.size.width, 20)];
	self.infoLabel.backgroundColor = [UIColor clearColor];
	self.infoLabel.font = [UIFont systemFontOfSize:16];
	self.infoLabel.textColor = [UIColor whiteColor];
	self.infoLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.infoLabel];
	
	[self updateOutlook];
	 
	
	// Test with Circular Progress
}


- (void)updateOutlook
{
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
			self.infoLabel.text = @"请绘制加密图案!";
			break;
		case InfoStatusConfirmSetting:
			self.infoLabel.text = @"确认绘制图案";
			break;
		case InfoStatusFailedConfirm:
			self.infoLabel.text = @"两次绘制的图案不一致，请重新绘制";
			break;
		case InfoStatusNormal:
			self.infoLabel.text = @"请输入解密图案";
			break;
		case InfoStatusFailedMatch:
			self.infoLabel.text = [NSString stringWithFormat:@"您已经%d次输入错误，请重试",self.wrongGuessCount];
			break;
		case InfoStatusSuccessMatch:
			self.infoLabel.text = @"Welcome !";
                   [[NSUserDefaults standardUserDefaults]setValue:@"submain" forKey:@"PushLabel"];
			break;
			
		default:
			break;
	}
	
}


#pragma -LockScreenDelegate

- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
	NSUserDefaults *stdDefault = [NSUserDefaults standardUserDefaults];
	NSLog(@"self status: %d",self.infoLabelStatus);
	switch (self.infoLabelStatus) {
		case InfoStatusFirstTimeSetting:
			[stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
			break;
		case InfoStatusFailedConfirm:
			[stdDefault setValue:patternNumber forKey:kCurrentPatternTemp];
			self.infoLabelStatus = InfoStatusConfirmSetting;
			[self updateOutlook];
			break;
		case InfoStatusConfirmSetting:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPatternTemp]]) {
				[stdDefault setValue:patternNumber forKey:kCurrentPattern];
				//[self dismissViewControllerAnimated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults]setValue:@"submain" forKey:@"PushLabel"];
                [self.navigationController popViewControllerAnimated:YES];
			}
			else {
				self.infoLabelStatus = InfoStatusFailedConfirm;
				[self updateOutlook];
			}
			break;
		case  InfoStatusNormal:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]]) //[self dismissViewControllerAnimated:YES completion:nil];
            {
                [[NSUserDefaults standardUserDefaults]setValue:@"submain" forKey:@"PushLabel"];
                [self.navigationController popViewControllerAnimated:YES];
            }

			else {
				self.infoLabelStatus = InfoStatusFailedMatch;
				self.wrongGuessCount ++;
				[self updateOutlook];
			}
			break;
		case InfoStatusFailedMatch:
			if([patternNumber isEqualToNumber:[stdDefault valueForKey:kCurrentPattern]])
            {//[self dismissViewControllerAnimated:YES completion:nil];
         
                [self.navigationController popViewControllerAnimated:YES];
            }

			else {
				self.wrongGuessCount ++;
				self.infoLabelStatus = InfoStatusFailedMatch;
				[self updateOutlook];
			}
			break;
		case InfoStatusSuccessMatch:
			//[self dismissViewControllerAnimated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults]setValue:@"reset" forKey:@"PushLabel"];
            //[self.navigationController popViewControllerAnimated:YES];
            [self updateOutlook];

			break;
			
		default:
			break;
	}
}

- (void)viewDidUnload {
	[self setInfoLabel:nil];
	[self setLockScreenView:nil];
	[super viewDidUnload];
}
@end
