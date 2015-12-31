//
//  CommomThemeView.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-28.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "CommomThemeView.h"
#import "sxlRequest_GET.h"
#import "defines.h"
#import "LBS_defines.h"
#import "SVProgressHUD.h"
#import "CheckWLAN.h"
#import "iToast.h"
#import "Detail_WebView.h"
@interface CommomThemeView ()

@end

@implementation CommomThemeView
@synthesize lai_degree_common,long_degree_common,identifer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initViewForStatus_Common
{
    commonTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    commonTable.backgroundColor=[UIColor whiteColor];
    commonTable.delegate=self;
    commonTable.dataSource=self;
    [self.view addSubview:commonTable];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadDataFromApi_common];
    
    RBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    RBtn.frame=CGRectMake(0, 0, 30, 30);
    [RBtn setImage:[UIImage imageNamed:@"navbar_refresh.png"] forState:UIControlStateNormal];
    [RBtn setImage:[UIImage imageNamed:@"navbar_refreshhighlight.png"] forState:UIControlStateHighlighted];
    RBtn.layer.cornerRadius=5.0;
    [RBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:RBtn];
    self.navigationItem.rightBarButtonItem=right;

}
-(void)refresh
{//刷新  方法
    [commonTable removeFromSuperview];
    
    [self loadDataFromApi_common];
    commonTable.frame=CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    [commonTable reloadData];
}
-(void)loadDataFromApi_common
{
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    
    if ([CheckWLAN CheckWLAN]) {
        common_objects_dic=[[NSDictionary alloc]init];
        NSString *key_utf=[identifer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//UTF编码
        NSString *lastURl=[NSString stringWithFormat:@"%@%@,%@&keyWord=%@&ak=%@",CLW_THE_BEST_SCENE_URL,long_degree_common ,lai_degree_common,key_utf,LBS_ak];
        NSLog(@"url==%@",lastURl);
        
        common_objects_dic=[[sxlRequest_GET sharedInstance]LBS_GET_RequestWithRequestURl:lastURl];
        NSLog(@"json==%@",common_objects_dic);
        if (!common_objects_dic.count) {
            [SVProgressHUD dismiss];
            [iToast make:@"云端获取数据失败" duration:1000];
        }else
        {//有数据的时候
            common_nameArray=[[NSMutableArray alloc]init];
            common_addressArray=[[NSMutableArray alloc]init];
            common_detailUrl=[[NSMutableArray alloc]init];
            @try {
                for (int i=0; i<[[common_objects_dic valueForKey:@"pointList"] count]; i++) {
                    [common_nameArray addObject:[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"name"]];//景点名称
                    [common_addressArray addObject:[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"address"]];//景点地址
                    
                    
                    /*最佳风景的时候  解析过程中进行判断，将携程网进数组*/
                if ([identifer isEqualToString:@"风景区"]) {
                    
                    if ([[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:0] valueForKey:@"url"]) {
                        //判断是否有详细的URL

                    NSString *theDetailUrl=[[NSString alloc]init];
                     for (int j=0; j<[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] count]; j++) {
                     NSString *urlName=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:j] valueForKey:@"name"];
                     
                     if ([urlName isEqualToString:@"携程网"]) {
                     theDetailUrl=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:j] valueForKey:@"url"];
                     break;//跳出循环
                     
                     }else if ([urlName isEqualToString:@"百度旅游"])
                     {
                     theDetailUrl=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:j] valueForKey:@"url"];
                     continue;//跳出循环
                     
                     
                     }else if ([urlName isEqualToString:@"去哪儿"])
                     {
                     theDetailUrl=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:j] valueForKey:@"url"];
                     continue;//跳出循环
                     
                     }else if ([urlName isEqualToString:@"大众点评"])
                     {
                     theDetailUrl=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:j] valueForKey:@"url"];
                     continue;//跳出循环
                     }
                     else
                     {
                     theDetailUrl=@"http://lvyou.baidu.com";
                     continue;//跳出循环
                     
                     }
                         
                     }
                    [common_detailUrl addObject:theDetailUrl];
                    }else
                    {
                         [common_detailUrl addObject:@"http://lvyou.baidu.com"];
                    }
                }else if([identifer isEqualToString:@"超市"]||[identifer isEqualToString:@"咖啡厅"])
                    {//超市  咖啡厅
                        NSString *url=[[NSString alloc]init];
                        if ([[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:0] valueForKey:@"url"]) {
                            url=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:0] valueForKey:@"url"];
                        }else
                        {
                            url=@"http://www.dianping.com";
                        }
                        [common_detailUrl addObject:url];
                    }else
                    {//不是风景区的时候
                        NSString *url=[[NSString alloc]init];
                        if([[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:0] valueForKey:@"url"]) {
                            url=[[[[[[common_objects_dic valueForKey:@"pointList"] objectAtIndex:i] valueForKey:@"additionalInformation"] valueForKey:@"link"] objectAtIndex:0] valueForKey:@"url"];
                        }else
                        {
                            url=@"http://bj.xiaomishu.com/#bd=baidu_map";
                        }
                        [common_detailUrl addObject:url];

                    }
                    
                    
               
    }
                
            [SVProgressHUD showSuccessWithStatus:@"OK"];//显示加载成功
            [self initViewForStatus_Common];//加载数据
                
            }
            @catch (NSException *exception) {
                [iToast make:[NSString stringWithFormat:@"获取数据 错误:%@",exception] duration:800];
                NSLog(@"%@",exception);
                
            }
            @finally {
                NSLog(@"获取数据");
            }
        }
    }else
    {
        
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        [iToast make:@"云端获取数据失败" duration:700];
    }
    
}
#pragma mark----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return common_nameArray.count;//去重
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
    if (indexPath.section%2==0) {
        cell.imageView.image=[UIImage imageNamed:@"cell_more"];
    }else
    {
        cell.imageView.image=[UIImage imageNamed:@"tabbar_compose_camera"];
    }
    
    //cell.backgroundColor=[UIColor whiteColor];
    @try {
        cell.textLabel.text=[common_nameArray objectAtIndex:indexPath.section];
        cell.detailTextLabel.text=[common_addressArray objectAtIndex:indexPath.section];    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:1000];
    }
    @finally {
        NSLog(@"table");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Detail_WebView *webview=[[Detail_WebView alloc]init];
    webview.title=@"详情";
    webview.webUrl=[common_detailUrl objectAtIndex:indexPath.section];
    webview.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webview animated:YES];
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
