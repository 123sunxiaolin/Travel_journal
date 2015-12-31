//
//  CommomThemeView.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-28.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommomThemeView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *commonTable;
    UIButton *RBtn;//刷新按钮
    
    //网络请求
    NSDictionary *common_objects_dic;
    NSMutableArray *common_nameArray;//美食的名称
    NSMutableArray *common_addressArray;//美食的地址
    NSMutableArray *common_detailUrl;//美食的连接地址
    NSMutableArray *common_detailUrlName;//链接名称

}
@property (nonatomic,strong) NSString *identifer;//标示符
@property (nonatomic,strong) NSString *lai_degree_common;//纬度
@property (nonatomic,strong) NSString *long_degree_common;//经度
-(void)loadDataFromApi_common;
-(void)initViewForStatus_Common;
@end
