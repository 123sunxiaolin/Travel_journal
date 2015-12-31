//
//  Func_MyFootTral.h
//  记忆留痕
//
//  Created by kys-2 on 14-9-18.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "defines.h"
@interface Func_MyFootTral : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
	// the map view
	MKMapView* _mapView;
	
    // routes points
    NSMutableArray* _points;
    
	// the data representing the route points.
	MKPolyline* _routeLine;
	
	// the view we create for the line on the map
	MKPolylineView* _routeLineView;
	
	// the rect that bounds the loaded points
	MKMapRect _routeRect;
    
    // location manager
    CLLocationManager* _locationManager;
    
    // current location
    CLLocation* _currentLocation;
    
    //tableView
    UITableView *infoTableview;
    //MY Location infomation
    UILabel *myLocationStr;
    NSMutableArray *foot_DistanceArray;//存储距离信息
    NSMutableArray *SerNumArray;//用于存储序列号
    UIButton *rightBtn;//刷新按钮
}
//交互
@property (nonatomic,strong) NSArray *tral_dateArray;//时间数组
@property (nonatomic,strong) NSArray *tral_tagArray;//标签数组
@property (nonatomic,strong) NSArray *tral_addressArray;//地址信息数组
@property (nonatomic,strong) NSArray *tral_CoordinateAray;//地理位置数组

//mapview
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) NSMutableArray* points;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic, retain) CLLocationManager* locationManager;

-(void) configureRoutes;
-(void)firstStartLocating;//开始进行定位
@end
