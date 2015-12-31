//
//  first_sec_third_forth.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-24.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface first_sec_third_forth : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *detailTableview;
    UITextView *_textView;
    //url
    NSDictionary *URL_jsonObjects_fstf;
    NSString *description;
    NSMutableArray *nameArray;
    NSMutableArray *urlArray;
}
@property(nonatomic,strong) NSString *pushTag;//判断父视图的来源
@property(nonatomic ,strong)NSString *ccity;
@property (nonatomic,strong) NSString *sernum;
-(void)initWithView;//构造视图
@end
