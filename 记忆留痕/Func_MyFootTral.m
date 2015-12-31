//
//  Func_MyFootTral.m
//  记忆留痕
//
//  Created by kys-2 on 14-9-18.
//  Copyright (c) 2014年 sxl. All rights reserved.
//

#import "Func_MyFootTral.h"
#import "WXAnation.h"
#import "MyFootTralCell.h"
#import "defines.h"
#import "iToast.h"
@interface Func_MyFootTral ()
{
    NSMutableArray *mapAnnotationsArr;//存放大头针
    CLLocationDegrees latitude;//纬度
    CLLocationDegrees longitude;//经度
    WXAnation *map_ann1;//大头针1
    NSMutableArray *DayArray;//日
    NSMutableArray *MonthArray;//月
    NSMutableArray *YearArray;//年
    NSMutableArray *TimeArray;//精确时间
    
}
@end

@implementation Func_MyFootTral
@synthesize points = _points;
@synthesize mapView = _mapView;
@synthesize routeLine = _routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize locationManager = _locationManager;
@synthesize tral_dateArray;
@synthesize tral_tagArray;
@synthesize tral_addressArray;
@synthesize tral_CoordinateAray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initMapView
{
    //初始化 地图视图
    mapAnnotationsArr =[NSMutableArray array];
    // setup map view
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 200)];
    self.mapView.backgroundColor=[UIColor clearColor];
    self.mapView.layer.borderColor=[UIColor grayColor].CGColor;
    self.mapView.layer.borderWidth=3.0;
    self.mapView.layer.cornerRadius=5.0;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self.view addSubview:self.mapView];
    
    //TOOLBAR
    UIToolbar *myFoottralTool=[[UIToolbar alloc]initWithFrame:CGRectMake(00, 264, ScreenWidth, 30)];
    myFoottralTool.backgroundColor=[UIColor darkGrayColor];
    myFoottralTool.layer.borderColor=[UIColor whiteColor].CGColor;
    myFoottralTool.layer.cornerRadius=5.0;
    myFoottralTool.layer.borderWidth=2.0;
    UILabel *llabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, 90, 25)];
    llabel.font=[UIFont systemFontOfSize:15];
    llabel.textColor=[UIColor blackColor];
    llabel.text=@"⚓️我的位置:";
    myLocationStr=[[UILabel alloc]initWithFrame:CGRectMake(102, 2, 200, 25)];
    myLocationStr.font=[UIFont systemFontOfSize:13];
    myLocationStr.textColor=[UIColor orangeColor];
    myLocationStr.text=@"无法定位";
    [myFoottralTool addSubview:llabel];
    [myFoottralTool addSubview:myLocationStr];
    [self.view addSubview:myFoottralTool];
    
}
-(void)getDataResource
{//获得数据资源
    //加载大头针
    TimeArray=[[NSMutableArray alloc]init];
    DayArray=[[NSMutableArray alloc] init];
    MonthArray=[[NSMutableArray alloc] init];
    YearArray=[[NSMutableArray alloc] init];
    SerNumArray=[[NSMutableArray alloc]init];
    @try {
        for (int i=tral_CoordinateAray.count-1; i>=0; i--) {
            // 将经纬度传递给数组
            latitude=[[[tral_CoordinateAray objectAtIndex:i] objectAtIndex:1] doubleValue];//纬度
            longitude=[[[tral_CoordinateAray objectAtIndex:i] objectAtIndex:0] doubleValue];//经度
            CLLocationCoordinate2D aObject=CLLocationCoordinate2DMake(latitude, longitude);
            [self routeLine:aObject];//划线
            [self PutMkAnnSelected:aObject WithItemIndex:i];//添加大头针
            //将日期进行分组
            NSString *foot_DateStr=[NSString stringWithFormat:@"%@",[tral_dateArray objectAtIndex:i]];
            
            [YearArray addObject:[foot_DateStr substringWithRange:NSMakeRange(0, 4)]];
            NSString *mdStr=[foot_DateStr substringWithRange:NSMakeRange(5, 5)];
            [MonthArray addObject:[mdStr substringWithRange:NSMakeRange(0, 2)]];
            [DayArray addObject:[mdStr substringFromIndex:3]];
            [TimeArray addObject:[foot_DateStr substringFromIndex:11]];
            NSInteger num=tral_CoordinateAray.count-i;
            [SerNumArray addObject:[NSString stringWithFormat:@"%d",num]];//序列号
        }

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"myFootTral");
    }
    
}
-(void)firstStartLocating
{//开始定位
    if ([CLLocationManager locationServicesEnabled]) { // 检查定位服务是否可用
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter=0.5;
    [_locationManager startUpdatingLocation];
   
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self firstStartLocating];//获取地理信息
    [self initMapView];//加载地图
    [self getDataResource];//获得地图数据
    
    infoTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,294, self.view.frame.size.width,self.view.frame.size.height/2)];
    infoTableview.backgroundColor=[UIColor whiteColor];
    infoTableview.dataSource=self;
    infoTableview.delegate=self;
    [self.view addSubview:infoTableview];
    
    //
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"navbar_refresh"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"navbar_refreshhighlight"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(firstStartLocating) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.hidden=YES;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=right;


}
#pragma mark---------------添加指定位置上的大头针
-(void)PutMkAnnSelected:(CLLocationCoordinate2D)location   WithItemIndex:(NSInteger)index
{//添加指定位置上得大头针
    CLLocationCoordinate2D coordinateSelected;
    coordinateSelected.latitude=location.latitude ;//学生的纬度
    coordinateSelected.longitude=location.longitude;
    map_ann1 = [[WXAnation alloc] initWithCoordinate2D:coordinateSelected];
    map_ann1.title =[tral_addressArray objectAtIndex:index] ;
    map_ann1.subtitle = @"欢迎使用-记忆留痕";
    //设置一下显示范围
    MKCoordinateSpan span = {10,10};
    MKCoordinateRegion region = {coordinateSelected,span};
    [_mapView setRegion:region animated:YES];
    [mapAnnotationsArr addObject:map_ann1];
    [_mapView addAnnotations:mapAnnotationsArr];
}
#pragma mark - MKAnnotationView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"Annotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        //设置是否显示标题视图
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;// 设置该标注点动画显示
        annotationView.annotation=annotation;
        
    }
    
    return annotationView;
    
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // Initialize each view
    for (MKPinAnnotationView *mkaview in views)
    {
        
        mkaview.pinColor = MKPinAnnotationColorPurple ;//设置为紫色
        mkaview.rightCalloutAccessoryView = nil;
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgView.image=[UIImage imageNamed:@"foor_noTag"];
        mkaview.leftCalloutAccessoryView=imgView;
      }
   // NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
   // NSLog(@"annotation views: %@", views);
}
#pragma mark  定位成功时调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //地理信息反解码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks,NSError *error)
     {
         if (placemarks.count >0   )
         {
             CLPlacemark * plmark = [placemarks objectAtIndex:0];
            NSLog(@"%@",plmark.name);
             myLocationStr.text=plmark.name;
             rightBtn.hidden=YES;
          }
     }];
    
    foot_DistanceArray=[[NSMutableArray alloc]init];
    @try {
        //添加距离信息
        if (newLocation.horizontalAccuracy>=0)
        {
            NSString *DistanceStr;
            for (int i=tral_CoordinateAray.count-1; i>=0; i--) {
                
                NSString *latitudeStr=[[tral_CoordinateAray objectAtIndex:i] objectAtIndex:1];
                NSString *longitudeStr=[[tral_CoordinateAray objectAtIndex:i] objectAtIndex:0];
                CLLocation *Stud=[[CLLocation alloc]initWithLatitude:[latitudeStr doubleValue]longitude:[longitudeStr doubleValue]];
                CLLocationDistance delta=[newLocation distanceFromLocation:Stud];
                
                if (delta>=1000) {
                    DistanceStr=[NSString stringWithFormat:@"约%d千米远",(int)delta/1000];
                    NSLog(@"distance==%f千米",delta/1000);
                }else
                {
                    // NSInteger Delta2=[nsin];
                    NSLog(@"距离===%f米",delta);
                    DistanceStr=[NSString stringWithFormat:@"约%d米远",(int)delta];
                }
                [foot_DistanceArray addObject:DistanceStr];
                
            }
            
            [infoTableview reloadData];//刷新数据
        }

    }
    @catch (NSException *exception) {
        [iToast make:[NSString stringWithFormat:@"错误:%@",exception] duration:800];
    }
    @finally {
        NSLog(@"myfootTral");
    }
    
 }
// 定位失败时调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"定位错误==%@",[error description]);
    if ([error description])
    {
        [iToast make:@"定位失败\n请检查网络或设定模拟器中的自定位置" duration:1800];
        rightBtn.hidden=NO;
        
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mapView = nil;
	self.routeLine = nil;
	self.routeLineView = nil;
}


#pragma mark ---------Map View

- (void)configureRoutes
{
    // define minimum, maximum points
	MKMapPoint northEastPoint = MKMapPointMake(0.f, 0.f);
	MKMapPoint southWestPoint = MKMapPointMake(0.f, 0.f);
	
	// create a c array of points.
	MKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * _points.count);
    
	// for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < _points.count; idx++)
	{
        
        CLLocation *location = [_points objectAtIndex:idx];
        latitude  = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
		// create our coordinate and add it to the correct spot in the array
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		
		// if it is the first point, just use them, since we have nothing to compare to yet.
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		} else {
			if (point.x > northEastPoint.x)
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x)
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y)
				southWestPoint.y = point.y;
		}
        
		pointArray[idx] = point;
	}
	
    if (self.routeLine) {
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [MKPolyline polylineWithPoints:pointArray count:_points.count];
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
	}
    
    // clear the memory allocated earlier for the points
	free(pointArray);
    
    /*
     double width = northEastPoint.x - southWestPoint.x;
     double height = northEastPoint.y - southWestPoint.y;
     
     _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
     
     // zoom in on the route.
     [self.mapView setVisibleMapRect:_routeRect];
     */
}

#pragma mark -------MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
	MKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 10;
        
		overlayView = self.routeLineView;
	}
	
	return overlayView;
}


-(void)routeLine:(CLLocationCoordinate2D)locations
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locations.latitude
                                                      longitude:locations.longitude];
    // check the zero point
    if  (locations.latitude == 0.0f ||
         locations.longitude == 0.0f)
        return;
    
    // check the move distance
    if (_points.count > 0) {
        CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
        if (distance < 5)
            return;
    }
    
    if (nil == _points) {
        _points = [[NSMutableArray alloc] init];
    }
    
    [_points addObject:location];
    _currentLocation = location;
    
    NSLog(@"points: %@", _points);
    
    [self configureRoutes];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(locations.latitude, locations.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
}

#pragma mark----UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tral_dateArray.count;
    
}
-(CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    MyFootTralCell *cell = (MyFootTralCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyFootTralCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.userInteractionEnabled=NO;
    if (indexPath.row==0) {
        [cell.TopSegment setHidden:YES];
    }
    else
    {
        [cell.TopSegment setHidden:NO];
    }
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    cell.DateImage.text=[NSString stringWithFormat:@"%@",[DayArray objectAtIndex:indexPath.row]];//日
    NSString *monthStr=[[NSString alloc]init];
    monthStr=[MonthArray objectAtIndex:indexPath.row];
    NSString *yearStr=[NSString stringWithFormat:@"%@",[YearArray objectAtIndex:indexPath.row]];
    cell.YDatelabel.text=[NSString stringWithFormat:@"  %@月\n%@年",monthStr,yearStr];
    cell.SerNum.text=[SerNumArray objectAtIndex:indexPath.row];
    cell.AddressLabel.text=[tral_addressArray objectAtIndex:[tral_addressArray count]-indexPath.row-1];
    if ([foot_DistanceArray count]>0) {
        cell.TimeLabel.text=[NSString stringWithFormat:@"%@  %@",[foot_DistanceArray objectAtIndex:indexPath.row],[TimeArray objectAtIndex:indexPath.row]];
    }else
    {
        cell.TimeLabel.text=[NSString stringWithFormat:@"暂无距离信息  %@",[TimeArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
