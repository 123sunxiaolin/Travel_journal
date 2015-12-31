//
//  fir_sec_thi_fot_detailView.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-25.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fir_sec_thi_fot_detailView : UIViewController
{
    UIButton *ticketBtn;//门票价格
    UILabel *fstfd_ttitleStr;//
    UILabel *fstfd_POINameLabel;//景点名称
    UILabel *fstfd_datelabel;//日期
    UITextView *fstfd_abstractTextview;//梗概
    UITextView *fstfd_contentTextView;//内容
    
    //url
    NSDictionary *fstfd_URL_jsonObjects;
    NSString *ticket_attention_Name;//门票优惠名称
    NSString *fstfd_ticketStr;//门票信息
    NSString *fstfd_POI_nameStr;
    int fstfd_StarCount;//星星的计数
    NSString *fstfd_dateStr;//当前景点的日期
    NSString *fstfd_contentStr;//当前景点的详情
    NSString *fstfd_web_url;//景点的webview详情
    NSMutableArray *fstfd_trip_type;//

}
@property (nonatomic,strong)NSString *push_tag;//用于判定父视图的来源
@property (nonatomic,strong)NSString *fstfd_UrlStr;//传输的url字符串
-(void)fstfd_initDetailView_trip;
/*btnclick*/
-(void)fstfd_btnClick:(UIButton *)sender;

@end
