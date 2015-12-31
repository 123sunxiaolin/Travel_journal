//
//  first_sec_third_forth.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-24.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "first_sec_third_forth.h"
#import "defines.h"
#import "LBS_defines.h"
#import "CheckWLAN.h"
#import "SVProgressHUD.h"
#import "sxlRequest_GET.h"
#import "iToast.h"
#import "Detail_WebView.h"
#import "fir_sec_thi_fot_detailView.h"
@interface first_sec_third_forth ()

@end

@implementation first_sec_third_forth
@synthesize ccity,sernum,pushTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initWithView
{
    if ([pushTag isEqualToString:@"TimeLine"]) {
        detailTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }else
    {
        detailTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    }
    
    /*UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageView.image=[UIImage imageNamed:@"tableBck"];
    detailTableview.backgroundView=imageView;*/
    
    detailTableview.backgroundColor=[UIColor whiteColor];
    detailTableview.delegate=self;
    detailTableview.dataSource=self;
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth , 100)];
    _textView.font=[UIFont systemFontOfSize:17];
    _textView.textColor=[UIColor orangeColor];
    if ([description length]<50) {
          _textView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_contentBck"]];
    }else
    {
          _textView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"detail_contentBck_second"]];
    }
  
    /*[_textView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_textView.layer setBorderWidth:2.0];
    [_textView.layer setCornerRadius:5.0];*/
    _textView.text=[NSString stringWithFormat: @"                            Tips\n  %@",description];
    _textView.editable=NO;
    if ([description isEqualToString:@""]) {
        detailTableview.tableHeaderView=nil;
    }else
    {
        detailTableview.tableHeaderView=_textView;
    }
   
    [self.view addSubview:detailTableview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD show];
    [self getdataFromAPI_fstf];//进行网络请求
    //[self initWithView];
    self.view.backgroundColor=[UIColor lightGrayColor];
    //right
    /*UIButton *DBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DBtn.frame=CGRectMake(0, 0, 30, 30);
    [DBtn setImage:[UIImage imageNamed:@"navbar_refresh.png"] forState:UIControlStateNormal];
    [DBtn setImage:[UIImage imageNamed:@"navbar_refreshhighlight.png"] forState:UIControlStateHighlighted];
    DBtn.layer.cornerRadius=5.0;
    [DBtn addTarget:self action:@selector(getdataFromAPI_fstf) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:DBtn];
    self.navigationItem.rightBarButtonItem=right;*/
}
-(void)getdataFromAPI_fstf
{
    if ([CheckWLAN CheckWLAN]) {
        URL_jsonObjects_fstf=[[NSDictionary alloc]init];
        NSString *city_utf=[ccity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *lastURl=[NSString stringWithFormat:@"%@%@&ak=%@",CLW_TRIP_ROUTINE_URL,city_utf,LBS_ak];
        NSLog(@"url==%@",lastURl);
        
        URL_jsonObjects_fstf=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:lastURl];
        NSLog(@"json==%@",URL_jsonObjects_fstf);
        
        if (!URL_jsonObjects_fstf.count) {
            [SVProgressHUD dismiss];
            [iToast make:@"云端获取数据失败" duration:1000];
        }else
        {//有数据的时候
            nameArray=[[NSMutableArray alloc]init];
            urlArray=[[NSMutableArray alloc]init];
            NSArray *itemSArray=[[NSArray alloc]init];
            @try {
                [SVProgressHUD showSuccessWithStatus:@"OK"];
                NSDictionary *dataDic=[[NSDictionary alloc]init];
                int num=[sernum intValue];
                 dataDic=[[[URL_jsonObjects_fstf valueForKey:@"result"] valueForKey:@"itineraries"] objectAtIndex:num];
                NSLog(@"%@",dataDic);
                description=[NSString stringWithFormat:@"%@",[dataDic valueForKey:@"description"] ];//获得描述
                for (int i=0; i<[[dataDic valueForKey:@"itineraries"] count]; i++) {
                    //第一级
                for (int j=0; j<[[[[dataDic valueForKey:@"itineraries"] objectAtIndex:i] valueForKey:@"path"] count]; j++) {
                    NSString *stringcc=[[NSString alloc]init];
                    itemSArray=[[[dataDic valueForKey:@"itineraries"] objectAtIndex:i] valueForKey:@"path"] ;
                    NSLog(@"pppppp=%@",[[itemSArray objectAtIndex:j]valueForKey:@"name"]);
                    if ([[[itemSArray objectAtIndex:j] valueForKey:@"name"] length]) {
                        stringcc=[[itemSArray objectAtIndex:j] valueForKey:@"name"];
                        
                    }else
                    {
                        
                       stringcc=[NSString stringWithFormat:@"点击获取更多"];
                    }
                    /*当名字没有的情况*/
                    [nameArray addObject:stringcc];
                    
                    //添加URL
                    [urlArray addObject:[[[itemSArray objectAtIndex:j] valueForKey:@"detail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                }
                NSLog(@"%@",urlArray);
                [detailTableview reloadData];
                [self initWithView];//加载视图
                
                
            }
            @catch (NSException *exception) {
                [iToast make:[NSString stringWithFormat:@"获取数据 错误:%@",exception] duration:800];
                
            }
            @finally {
                NSLog(@"获取数据");
            }
        }
    }else
    {
        
        [SVProgressHUD dismiss];
        [iToast make:@"云端获取数据失败" duration:700];
    }
    
}

#pragma mark----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[NSSet setWithArray:nameArray] count];//去重
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    /*[cell.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.layer setBorderWidth:3.0];
    [cell.layer setCornerRadius:5.0];*/
    if (indexPath.section%2==0) {
        cell.imageView.image=[UIImage imageNamed:@"cell_more"];
    }else
    {
        cell.imageView.image=[UIImage imageNamed:@"tabbar_compose_camera"];
    }
    
    //cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.text=[nameArray objectAtIndex:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *jsonobjects=[[NSDictionary alloc]init];
    @try {
        jsonobjects=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:[urlArray objectAtIndex:indexPath.section]];
        NSLog(@"json=%@",jsonobjects);
        if ([[jsonobjects valueForKey:@"status"] isEqualToString:@"Success"]) {
            //访问成功
            fir_sec_thi_fot_detailView *fstyd=[[fir_sec_thi_fot_detailView alloc]init];
            fstyd.fstfd_UrlStr=[urlArray objectAtIndex:indexPath.section];
            fstyd.title=@"景点详情";
            if ([pushTag isEqualToString:@"TimeLine"])
            {
                fstyd.push_tag=[NSString stringWithFormat:@"TimeLine"];
            }

            fstyd.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:fstyd  animated:YES];
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
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
