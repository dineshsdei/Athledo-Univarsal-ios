//
//  MapViewController.m
//  Athledo
//
//  Created by Dinesh Kumar on 8/12/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//
#import "MyAnnotation.h"
#import "CalendarDayViewController.h"
#import "CalendarMonthViewController.h"
#import "MapViewController.h"
#import "WeekViewController.h"
#import "SWRevealViewController.h"

#define getEventTag 510

@interface MapViewController ()

@end

@implementation MapViewController
WebServiceClass *webservice;
SWRevealViewController *revealController;
UIBarButtonItem *revealButtonItem;;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Webservice call event
-(void)getEvents{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];
        
        [SingletonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetEvents :strURL :getEventTag];
        
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case getEventTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                // Now we Need to decrypt data
                [SingletonClass ShareInstance].isCalendarUpdate=FALSE;
                _eventDic =[MyResults objectForKey:@"data"];
                
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:3];
    tabBar.delegate=self;
    [tabBar setSelectedItem:tabBarItem];
    [super viewWillAppear:animated];
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    if ([SingletonClass ShareInstance].isCalendarUpdate==TRUE) {
        [self getEvents];
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray *arrController=[self.navigationController viewControllers];
    
    switch (item.tag) {
        case 2:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                if ([object isKindOfClass:[CalendarDayViewController class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            if (Status==FALSE)
            {
                CalendarDayViewController *dayView = [[CalendarDayViewController alloc]init];
                dayView.eventDic=(NSMutableArray *)_eventDic;
                if (_objNotificationData) {
                    dayView.objNotificationData=_objNotificationData;
                }
                [self.navigationController pushViewController:dayView animated:NO];
            }
            
            break;
        }
        case 1:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                
                if ([object isKindOfClass:[WeekViewController class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            
            if (Status==FALSE)
            {
                WeekViewController *weekView = [[WeekViewController alloc]initWithNibName:@"WeekViewController" bundle:[NSBundle mainBundle]];
                weekView.eventDic=(NSMutableArray *)_eventDic;
                if (_objNotificationData) {
                    weekView.objNotificationData=_objNotificationData;
                }
                [self.navigationController pushViewController:weekView animated:NO];
                
            }
            
            break;
        }case 0:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                
                if ([object isKindOfClass:[CalendarMonthViewController class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            
            if (Status==FALSE)
            {
                CalendarMonthViewController *monthview = [[CalendarMonthViewController alloc]init];
                if (_objNotificationData) {
                    monthview.objNotificationData=_objNotificationData;
                }
                [self.navigationController pushViewController:monthview animated:NO];
                
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=NSLocalizedString(@"Map Events", @"");
    revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Month" image:[UIImage imageNamed:@"mnth_icon2.png"] tag:0];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Week" image:[UIImage imageNamed:@"week_icon1.png"] tag:1];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"Today" image:[UIImage imageNamed:@"today_icon.png"] tag:2];;
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"tabmap_icon.png"] tag:3];
    
    [tabBarItems addObject:tabBarItem1];
    [tabBarItems addObject:tabBarItem2];
    [tabBarItems addObject:tabBarItem3];
    [tabBarItems addObject:tabBarItem4];
    
    tabBar.items = tabBarItems;
    
    mapTableView.backgroundColor=[UIColor clearColor];
    mapView.showsUserLocation=YES;
    
    //    locationManager=[[CLLocationManager alloc]init];
    //    [locationManager setDelegate:self];
    //    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    //    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //    [locationManager startUpdatingLocation];
    
    [self addAnnotationsOnMap:_eventDic];
    
}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}

#pragma mark - Map
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // try to dequeue an existing pin view first..
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    //pinView.animatesDrop=YES;
    pinView.canShowCallout=YES;
    // pinView.image = [UIImage imageNamed:@"redhome.png"];
    MyAnnotation *ann=annotation;
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    rightButton.tag = [ann tagNumber];
    [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}
-(void)showDetails:(id)sender
{
    UIButton *btn=sender;
    CalenderEventDetails *eventDetails=[[CalenderEventDetails alloc] init];
    eventDetails.eventDetailsDic=[_eventDic objectAtIndex:btn.tag];
    if (_objNotificationData) {
        eventDetails.objNotificationData=_objNotificationData;
    }
    [self.navigationController pushViewController:eventDetails animated:NO];
}

-(void)addAnnotationsOnMap:(NSArray *)arrOfAllIns
{
    int count = (int)(arrOfAllIns.count);
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:TIME_FORMAT_h_m_A];
     for (int i = 0; i<count; i++)
    {
        //NSArray *arrLatLong = [strLatLong componentsSeparatedByString:@","];
        NSDictionary *data=[arrOfAllIns objectAtIndex:i];
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = [[data valueForKey:@"lat"] doubleValue];
        theCoordinate.longitude = [[data valueForKey:@"lng"] doubleValue];
        [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
        NSDate *startdate=[df dateFromString:[data valueForKey:@"start_date"]];
        // NSDate *enddate=[df dateFromString:[data valueForKey:@"end_date"]];
        [df setDateFormat:DATE_FORMAT_M_D_Y_H_M];
        MyAnnotation *annotation = [[MyAnnotation alloc] init];
        // annotation.subtitle=[[data valueForKey:@"text"] stringByAppendingFormat:@"(%@-%@)",[df stringFromDate:startdate],[df stringFromDate: enddate ]] ;
        annotation.subtitle=[[data valueForKey:@"text"] stringByAppendingFormat:@" (%@)",[df stringFromDate:startdate]] ;
        annotation.title = [data valueForKey:@"name"];
        annotation.tagNumber= i;
        annotation.coordinate=theCoordinate;
        
        //  Add annotations in map
        [mapView addAnnotation:annotation];
        
    }
}
- (void)mapViewZoom:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        @try
        {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            MyAnnotation *annotation = [views objectAtIndex:0];
            CLLocationCoordinate2D location=annotation.coordinate;
            region.span=span;
            region.center=location;
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
        }
        @catch (NSException *exception)
        {
        }
    }
}

#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)standardMap:(id)sender {
    [mapView setMapType:MKMapTypeStandard];
}

- (IBAction)satelliteMap:(id)sender {
    [mapView setMapType:MKMapTypeSatellite];
}
@end
