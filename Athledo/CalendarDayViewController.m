//
//  CalendarDayViewController.m
//  Demo
//
//  Created by Devin Ross on 3/16/13.
//
//

#import "CalendarDayViewController.h"
#import "CalendarMonthViewController.h"
#import "MapViewController.h"
#import "WeekViewController.h"
#import "SWRevealViewController.h"
#import "CalenderEventDetails.h"
#import "AddCalendarEvent.h"

#define getEventTag 510

@implementation CalendarDayViewController

WebServiceClass *webservice;
SWRevealViewController *revealController;
UIBarButtonItem *revealButtonItem;;

- (NSUInteger) supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Webservice call event
-(void)getEvents :(NSString*)startDate :(NSString *)endDate{
    
    // Local server
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        [SingletonClass ShareInstance].isCalendarUpdate=FALSE;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"start_date\":\"%@\",\"last_date\":\"%@\"}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid,startDate,endDate];
        
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
            eventData=nil;
            [_eventDic removeAllObjects];
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                // Now we Need to decrypt data
                eventData =[MyResults objectForKey:@"data"];
                NSArray *arrKeys=[eventData allKeys ];
                for (int i=0; i<arrKeys.count; i++) {
                    
                    NSArray *arrValues=[eventData valueForKey:[arrKeys objectAtIndex:i] ];
                    
                    for (int j=0; j< arrValues.count; j++) {
                        
                        [_eventDic addObject:[arrValues objectAtIndex:j]];
                        
                    }
                }
                
            }else
            {
                [SingletonClass initWithTitle:@"" message:@"Events don't exist today" delegate:nil btn1:@"Ok"];
                
            }
        }
    }

    for (int i=0; i< _eventDic.count; i++) {
        
        if ([self TodayDate:[[_eventDic objectAtIndex:i]valueForKey:@"start_date"]]) {
            
            NSArray *arrtemp=@[[[_eventDic objectAtIndex:i]valueForKey:@"text"],[[_eventDic objectAtIndex:i] valueForKey:@"location"],[self setHours:[[_eventDic objectAtIndex:i]valueForKey:@"start_date"]], [self setMenutes:[[_eventDic objectAtIndex:i]valueForKey:@"start_date"]],[self setHours:[[_eventDic objectAtIndex:i]valueForKey:@"end_date"]], [self setMenutes:[[_eventDic objectAtIndex:i]valueForKey:@"end_date"]],[NSString stringWithFormat:@"%d",i]];
            
            [self.data addObject:arrtemp];
        }
        
    }
    
    [dayView reloadData];
}
#pragma change control frame when device rotate
- (void)orientationChanged
{
    if ((isIPAD)) {
        
        dayView.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        NSArray *arr= dayView.subviews;
        UIView *view=(UIView *)[arr objectAtIndex:1];
        UIScrollView *scrollview=(UIScrollView *)[arr objectAtIndex:0];
        scrollview.frame=CGRectMake(0,view.frame.origin.y, self.view.frame.size.width, view.frame.size.height);
        UILabel *lblTopContaint=(UILabel *)[arr objectAtIndex:2];
        
        view.frame=CGRectMake(view.frame.origin.x,view.frame.origin.y, self.view.frame.size.width, view.frame.size.height);
        lblTopContaint.frame=CGRectMake(lblTopContaint.frame.origin.x,lblTopContaint.frame.origin.y, self.view.frame.size.width, lblTopContaint.frame.size.height);
        
        UIDeviceOrientation orientation=[[SingletonClass ShareInstance] CurrentOrientation:self];
        if (orientation==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationLandscapeRight ) {
            
            tabBar.frame =CGRectMake(0, self.view.frame.size.height-(iosVersion < 8 ? 56 : 49), self.view.frame.size.width, 50);
        }else{
            
            tabBar.frame =CGRectMake(0, self.view.frame.size.height-(iosVersion < 8 ? 56 : 49), self.view.frame.size.width, 50);
        }
    }
}

// Uncomment if you want to show date on top of calendar view the uncomment code on TKCalendar view screen

- (void) viewDidLoad{
    
    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    
    [super viewDidLoad];
    self.data=[[NSMutableArray alloc] init];
    self.title = NSLocalizedString(@"Day Events", @"");
    self.view.backgroundColor=[UIColor whiteColor];
    revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    UIButton  *btnAddNew = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageEdit=[UIImage imageNamed:@"add.png"];
    btnAddNew.bounds = CGRectMake( 0, 0, imageEdit.size.width, imageEdit.size.height );    [btnAddNew addTarget:self action:@selector(AddNewEvent) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNew setBackgroundImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddNew];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    _eventDic=[[NSMutableArray alloc] init];
    
    //	self.data = @[
    //  @[@"Meeting with five random dudes", @"", @5, @0, @5, @30],
    //  @[@"Unlimited bread rolls got me sprung", @"Olive Garden", @7, @0, @12, @0],
    //  @[@"Fishy Fishy Fishfelayyyyyyyy", @"McDonalds", @6, @30, @6, @35],
    //  @[@"Turkey Time...... oh wait", @"Chick-fela", @14, s@0, @19, @0],
    //  @[@"Greet the king at the castle", @"Burger King", @19, @30, @30, @0]];
    
    // Last value for event tag for show in details
    
    UIDeviceOrientation orientation=[[SingletonClass ShareInstance] CurrentOrientation:self];
    if (orientation==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationLandscapeRight ) {
        
        self.dayView.frame=CGRectMake(self.dayView.frame.origin.x, self.dayView.frame.origin.y, self.dayView.frame.size.width, self.dayView.frame.size.height-47);
    }else{
        
        self.dayView.frame=CGRectMake(self.dayView.frame.origin.x, self.dayView.frame.origin.y, self.dayView.frame.size.width, self.dayView.frame.size.height-47);
    }
    
    // 113 height is (49+64) tabbar height and navigationBar height
    // tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-120, [UIScreen mainScreen].bounds.size.width, 50)];
    // UIDeviceOrientation orientation=[SingletonClass getOrientation];
    if (orientation==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationLandscapeRight )
    {
        tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width-(iosVersion < 8 ? 120 : 113), self.view.frame.size.height, 50)];
    }else{
        if (isIPAD) {
            tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-(iosVersion < 8 ? 120 : 113), self.view.frame.size.width, 50)];
        }else{
            tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-(113), self.view.frame.size.width, 50)];
        }
    }
    
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
    
    [self.view addSubview:tabBar];
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:DATE_FORMAT_Y_M_D];
    
    if (_strComeFrom !=nil) {
        
        [formater setDateFormat:DATE_FORMAT_Y_M_D];
        NSString *strdate=[formater stringFromDate:_CalendarDisplayDate];
        
        [self getEvents:[NSString stringWithFormat:@"%@ 00:00:00",strdate]:[NSString stringWithFormat:@"%@ 24:00:00",strdate]];
    }else{
        
        NSDate *todayDate=[NSDate date];
        _CalendarDisplayDate=todayDate;
        NSString *enddate=[formater stringFromDate:todayDate];
        enddate=[enddate stringByAppendingString:@" 00:00:00"];
        
        [self getEvents:enddate:[enddate stringByReplacingOccurrencesOfString:@"00:00:00" withString:@"24:00:00"]];
        
    }
}

-(void)AddNewEvent
{
    [CalendarEvent ShareInstance].strEventType=@"";
    [CalendarEvent ShareInstance].strRepeatSting=@"";
    [CalendarEvent ShareInstance].strEventEditBy=@"";
    [CalendarEvent ShareInstance].CalendarRepeatStatus=FALSE;
    
    
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[AddCalendarEvent class]])
        {
            Status=TRUE;
            AddCalendarEvent *addEvent=(AddCalendarEvent*)(object);
            addEvent.strMoveControllerName=@"CalendarDayViewController";
            [self.navigationController popToViewController:addEvent animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        AddCalendarEvent *addEvent=[[AddCalendarEvent alloc] initWithNibName:@"AddCalendarEvent" bundle:nil];
        addEvent.strMoveControllerName=@"CalendarDayViewController";
        [self.navigationController pushViewController:addEvent animated:NO];
        
    }
}

-(BOOL)TodayDate:(NSString *)eventdate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
    
    NSDate *startdate=[df dateFromString:eventdate];
    NSDate *todaydate=[NSDate date];
    [df setDateFormat:DATE_FORMAT_D_M_Y];
    
    NSString *Edate=[df stringFromDate:startdate];
    NSString *Today=[df stringFromDate:todaydate];
    
    if ([Edate isEqualToString:Today]) {
        
        return YES;
    }else{
        return YES;
    }
    
}

-(NSString *)setHours:(NSString *)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
    
    NSDate *startdate=[df dateFromString:date];
    [df setDateFormat:TIME_FORMAT_24h_m];
    NSString *hour=[df stringFromDate:startdate];
    
    NSArray *arr=[hour componentsSeparatedByString:@":"];
    hour=[arr objectAtIndex:0] ? [arr objectAtIndex:0] : @"";
    
    return hour;
}

-(NSString *)setMenutes:(NSString *)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
    
    NSDate *startdate=[df dateFromString:date];
    [df setDateFormat:TIME_FORMAT_24h_m];
    NSString *minutes=[df stringFromDate:startdate];
    
    NSArray *arr=[minutes componentsSeparatedByString:@":"];
    minutes=[arr objectAtIndex:1] ? [arr objectAtIndex:1] : @"";
    
    return minutes;
}
- (void) viewWillAppear:(BOOL)animated{
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [super viewWillAppear:animated];
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:2];
    tabBar.delegate=self;
    [tabBar setSelectedItem:tabBarItem];
    self.navigationController.navigationBar.hairlineDividerView.hidden = YES;
    self.dayView.daysBackgroundView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
    
    if ([SingletonClass ShareInstance].isCalendarUpdate) {
        
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSDate *todayDate=[NSDate date];
        NSDateFormatter *formater=[[NSDateFormatter alloc] init];
        [formater setDateFormat:DATE_FORMAT_Y_M_D];
        NSString *enddate=[formater stringFromDate:todayDate];
        enddate=[enddate stringByAppendingString:@" 00:00:00"];
        
        [self getEvents:enddate:[enddate stringByReplacingOccurrencesOfString:@"00:00:00" withString:@"24:00:00"]];
    }
    if (isIPAD)
        [self orientationChanged];
}
- (NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate {
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:originalDate options:0];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray *arrController=[self.navigationController viewControllers];
    
    switch (item.tag) {
        case 0:
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
                CalendarMonthViewController *weekView = [[CalendarMonthViewController alloc]init];
                if (_objNotificationData) {
                    weekView.objNotificationData=_objNotificationData;
                }
                [self.navigationController pushViewController:weekView animated:NO];
                
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
                WeekViewController *weekView = [[WeekViewController alloc]init];
                if (_objNotificationData) {
                    weekView.objNotificationData=_objNotificationData;
                }
                [self.navigationController pushViewController:weekView animated:NO];
                
            }
            
            break;
        }case 3:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                
                if ([object isKindOfClass:[MapViewController class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            
            if (Status==FALSE)
            {
                MapViewController *mapView = [[MapViewController alloc]init];
                mapView.eventDic=_eventDic;
                if (_objNotificationData) {
                    mapView.objNotificationData=_objNotificationData;
                }
                [self.navigationController pushViewController:mapView animated:NO];
                
            }
            break;
        }
            
        default:
            break;
    }
    
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hairlineDividerView.hidden = NO;
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark TKCalendarDayViewDelegate

- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
    
    if (!dayView) {
        
        dayView=calendarDayTimeline;
        dayView.currentDay=_CalendarDisplayDate;
        [dayView _updateDateLabel];
        [self orientationChanged];
    }
    
    if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending) return @[];
    if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending) return @[];
    
    NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:calendarDayTimeline.calendar.timeZone];
    info.second = 0;
    NSMutableArray *ret = [NSMutableArray array];
    
    
    for(NSArray *ar in self.data){
        
        TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
        if(event == nil) event = [TKCalendarDayEventView eventView];
        
        event.identifier = nil;
        event.titleLabel.text = ar[0];
        event.locationLabel.text = ar[1];
        
        info.hour = [ar[2] intValue];
        info.minute = [ar[3] intValue];
        event.startDate = [NSDate dateWithDateComponents:info];
        
        info.hour = [ar[4] intValue];
        info.minute = [ar[5] intValue];
        event.endDate = [NSDate dateWithDateComponents:info];
        
        event.EventTag=[ar[6] intValue];
        [ret addObject:event];
        
    }
    return ret;
    
}
- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        if ([object isKindOfClass:[CalenderEventDetails class]])
        {
            Status=TRUE;
            CalenderEventDetails *eventDetails=(CalenderEventDetails*)(object);
            eventDetails.eventDetailsDic=[_eventDic objectAtIndex:eventView.EventTag];
            eventDetails.strMoveControllerName=@"CalendarDayViewController";
            if (_objNotificationData) {
                eventDetails.objNotificationData=_objNotificationData;
            }
            [self.navigationController popToViewController:eventDetails animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        CalenderEventDetails *eventDetails=[[CalenderEventDetails alloc] init];
        eventDetails.eventDetailsDic=[_eventDic objectAtIndex:eventView.EventTag];
        eventDetails.strMoveControllerName=@"CalendarDayViewController";
        if (_objNotificationData) {
            eventDetails.objNotificationData=_objNotificationData;
        }
        [self.navigationController pushViewController:eventDetails animated:NO];
    }
}
@end
