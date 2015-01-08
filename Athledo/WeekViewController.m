
#import "WeekViewController.h"
#import "MAWeekView.h"
#import "MAEvent.h"
#import "MAEventKitDataSource.h"
#import "WebServiceClass.h"
#import "CalendarDayViewController.h"
#import "CalendarMonthViewController.h"
#import "MapViewController.h"
#import "WeekViewController.h"
#import "SWRevealViewController.h"
#import "AddCalendarEvent.h"

#define getEventTag 510
WebServiceClass *webservice;

// Uncomment the following line to use the built in calendar as a source for events:
//#define USE_EVENTKIT_DATA_SOURCE 1

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface WeekViewController(PrivateMethods)
@property (readonly) MAEvent *event;
@property (readonly) MAEventKitDataSource *eventKitDataSource;
@end

@implementation WeekViewController
@synthesize weekView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/* Implementation for the MAWeekViewDataSource protocol */

#ifdef USE_EVENTKIT_DATA_SOURCE

- (NSArray *)weekView:(MAWeekView *)weekView eventsForDate:(NSDate *)startDate {
    return [self.eventKitDataSource weekView:weekView eventsForDate:startDate];
}

#else

static int counter = 7 * 5;
SWRevealViewController *revealController;
UIBarButtonItem *revealButtonItem;;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Webservice call event
-(void)getEvents: (NSDate*)startDate :(NSDate *)endDate{
    
    // Local server
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;

    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=DATE_FORMAT_Y_M_D;
    NSString *startdate=[formatter stringFromDate:startDate];
    startdate=[startdate stringByAppendingString:@" 00:00:00"];
    NSString *enddate=[formatter stringFromDate:endDate];
    enddate=[enddate stringByAppendingString:@" 24:00:00"];

    formatter=nil;

    if ([SingaltonClass  CheckConnectivity]) {
    UserInformation *userInfo=[UserInformation shareInstance];

    // NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"start_date\":\"%@\",\"last_date\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,startdate,enddate];
    NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"start_date\":\"%@\",\"last_date\":\"%@\"}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid,startdate,enddate];

    [SingaltonClass addActivityIndicator:self.view];

    [webservice WebserviceCall:webServiceGetEvents :strURL :getEventTag];


    }else{

    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingaltonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
    case getEventTag:
    {
    [_eventDic removeAllObjects];

    if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
    {
    // Now we Need to decrypt data
    [SingaltonClass ShareInstance].isCalendarUpdate=FALSE;


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
    [SingaltonClass initWithTitle:@"" message:@"Events don't exist in this week" delegate:nil btn1:@"Ok"];

    }
    }
    }
    
    //[self weekView:objWeekView weekDidChange:WeekStartDate];
    [objWeekView reloadData];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title=NSLocalizedString(@"Week Events", @"");
    //WeekStartDate=nil;
    
    revealController = [self revealViewController];
    _eventDic=[[NSMutableArray alloc] init];
    
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
    
    
  [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIButton  *btnAddNew = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 25, 25)];
    UIImage *imageEdit=[UIImage imageNamed:@"add.png"];
    
    
    
    [btnAddNew addTarget:self action:@selector(AddNewEvent) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNew setBackgroundImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddNew];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    if (_eventDic.count == 0) {
        WeekEndDate =[self addDays:7 toDate:WeekStartDate];
        [self getEvents:WeekStartDate:WeekEndDate];
            
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
            addEvent.screentitle=@"Add Event";
            addEvent.strMoveControllerName=@"WeekViewController";
            [self.navigationController popToViewController:addEvent animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        AddCalendarEvent *addEvent=[[AddCalendarEvent alloc] initWithNibName:@"AddCalendarEvent" bundle:nil];
        addEvent.screentitle=@"Add Event";
        addEvent.strMoveControllerName=@"WeekViewController";
        [self.navigationController pushViewController:addEvent animated:NO];
    }
    
    
    //[self presentViewController:addEvent animated:YES completion:nil];
}
- (NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate {
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:originalDate options:0];
}
-(void)viewWillAppear:(BOOL)animated
{
   

    if ([SingaltonClass ShareInstance].isCalendarUpdate==TRUE) {

    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    if (_eventDic.count == 0) {
    WeekEndDate =[self addDays:7 toDate:WeekStartDate];
    [self getEvents:WeekStartDate:WeekEndDate];

    }
    }

    [self.navigationItem setHidesBackButton:YES animated:NO];
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:1];
    tabBar.delegate=self;
    [tabBar setSelectedItem:tabBarItem];
    [super viewWillAppear:animated];

   
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    //NSLog(@"tag %d",item.tag);
    
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
                // dayView.eventDic=_eventDic;
                [self.navigationController pushViewController:dayView animated:NO];
                
            }
            
            break;
        }
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
                CalendarMonthViewController *weekview = [[CalendarMonthViewController alloc]init];
                [self.navigationController pushViewController:weekview animated:NO];
                
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
                // mapView.eventDic=_eventDic;
                [self.navigationController pushViewController:mapView animated:NO];
                
            }
            
            
            break;
        }
            
        default:
            break;
    }
    
    
}


- (MAEvent *)event {
	static int counter;
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:[NSString stringWithFormat:@"number %i", counter++] forKey:@"test"];
	
	MAEvent *event = [[MAEvent alloc] init];
	event.backgroundColor = [UIColor purpleColor];
	event.textColor = [UIColor whiteColor];
	event.allDay = NO;
	event.userInfo = dict;
	return event;
}
-(void)serviceCall
{
    
    WeekEndDate =[self addDays:7 toDate:WeekStartDate];
    [self getEvents:WeekStartDate:WeekEndDate];
}
-(void)weekView:(MAWeekView *)WeekView weekDidChange:(NSDate *)week
{
    
        WeekStartDate=week;
        objWeekView=WeekView;
    
        [self serviceCall];
    
    
}
- (NSArray *)weekView:(MAWeekView *)WeekView eventsForDate:(NSDate *)startDate {
	counter--;
    if(WeekStartDate==nil)
    {
        WeekStartDate=startDate;
        objWeekView=WeekView;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
     NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    for (int i=0; i< _eventDic.count; i++) {
        
//        NSDate *fromDate=[dateFormatter dateFromString: [[_eventDic objectAtIndex:i] valueForKey:@"start_date"]];
//        NSDate *toDate=[dateFormatter dateFromString: [[_eventDic objectAtIndex:i] valueForKey:@"end_date"]];
//         NSDate *CurrentDate=[dateFormatter dateFromString: [[_eventDic objectAtIndex:i] valueForKey:@"end_date"]];
//        
//        NSTimeInterval fromTime = [fromDate timeIntervalSinceReferenceDate];
//        NSTimeInterval toTime = [toDate timeIntervalSinceReferenceDate];
//        NSTimeInterval currTime = [CurrentDate timeIntervalSinceReferenceDate];
        
        NSString *startdate=[[[[_eventDic objectAtIndex:i] valueForKey:@"start_date"] componentsSeparatedByString:@" "] objectAtIndex:0];;
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day =1;
        NSDate *newDate = [calendar dateByAddingComponents:components toDate:startDate options:0];

        
        NSString *CalenderStartDate=[NSString stringWithFormat:@"%@",newDate];
        CalenderStartDate=[[CalenderStartDate componentsSeparatedByString:@" "] objectAtIndex:0];
        
        
        if([CalenderStartDate isEqualToString:startdate]){
            
            [arr addObject:[self event :i : startDate ]];
        }
    }
    	return arr;
}

#endif

- (MAEvent *)event : (int)index : (NSDate *)date {
	static int counter;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:dateFormatYearMonthDateHiphenWithTime];
    NSDate *startdate=[dateFormatter dateFromString:[[_eventDic objectAtIndex:index] valueForKey:@"start_date"]];
    NSDate *enddate=[dateFormatter dateFromString:[[_eventDic objectAtIndex:index] valueForKey:@"end_date"]];

    
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:[NSString stringWithFormat:@"number %i", counter++] forKey:@"test"];

	MAEvent *event = [[MAEvent alloc] init];
	event.backgroundColor = [UIColor purpleColor];
	event.textColor = [UIColor whiteColor];
    event.start=startdate;
    event.end=enddate;
    event.EventTag=index;
    
    //event.title=[[_eventDic objectAtIndex:index] valueForKey:@"name"];
   
////  Event Title
    
    // Uncoment if you want date on title of event 
   
    /*
    NSString *strStartdate=[[_eventDic objectAtIndex:index] valueForKey:@"start_date"];
    
    NSDate *displaydate=[dateFormatter dateFromString:strStartdate];
    
    NSString *strEnddate=[[_eventDic objectAtIndex:index] valueForKey:@"end_date"];
    
    NSDate *displayEnddate=[dateFormatter dateFromString:strEnddate];

     [dateFormatter setDateFormat:TIME_FORMAT_h_m_A];
     */
    
    //event.title=[[[dateFormatter stringFromDate:displaydate] stringByAppendingString:[NSString stringWithFormat:@"-%@",[dateFormatter stringFromDate:displayEnddate]]] stringByAppendingString:[NSString stringWithFormat:@" Name:%@", [[_eventDic objectAtIndex:index]valueForKey:@"name"] ] ];
   
    event.title=[[_eventDic objectAtIndex:index]valueForKey:@"text"];
//
	event.allDay = NO;
	event.userInfo = [_eventDic objectAtIndex:index];
    
 
   
   //Event Time
    
    NSArray *startTimeComp=[[[[[_eventDic objectAtIndex:index] valueForKey:@"start_date"] componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    
    //NSLog(@"date %d",[[startTimeComp objectAtIndex:0] intValue]);
    
    [components setHour:[[startTimeComp objectAtIndex:0] intValue]];
    [components setMinute:[[startTimeComp objectAtIndex:1] intValue]];
    [components setSecond:[[startTimeComp objectAtIndex:2] intValue]];
    
    event.start = [CURRENT_CALENDAR dateFromComponents:components];
     NSArray *endTimeComp=[[[[[_eventDic objectAtIndex:index] valueForKey:@"end_date"] componentsSeparatedByString:@" "] objectAtIndex:1] componentsSeparatedByString:@":"];
   
    [components setHour:[[endTimeComp objectAtIndex:0] intValue]];
    [components setMinute:[[endTimeComp objectAtIndex:1] intValue]];
     [components setSecond:[[endTimeComp objectAtIndex:1] intValue]];
    
    event.end = [CURRENT_CALENDAR dateFromComponents:components];
    
    
     event.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(244/255.0) blue:(253/255.0) alpha:1];
  //  event.textColor=[UIColor colorWithRed:(0/255.0) green:(114/255.0) blue:(158/255.0) alpha:1];
    event.textColor=[UIColor darkGrayColor];
	return event;
}

- (MAEventKitDataSource *)eventKitDataSource {
    if (!_eventKitDataSource) {
        _eventKitDataSource = [[MAEventKitDataSource alloc] init];
    }
    return _eventKitDataSource;
}

/* Implementation for the MAWeekViewDelegate protocol */

- (void)weekView:(MAWeekView *)weekView eventTapped:(MAEvent *)event {

	
    //NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
//	NSString *eventInfo = [NSString stringWithFormat:@"Description:%@", [event.userInfo objectForKey:@"text"]];
//	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
//                                                    message:eventInfo delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Edit",@"Delete",nil];
//	[alert show];
    
   
    
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[CalenderEventDetails class]])
        {
            Status=TRUE;
            CalenderEventDetails *eventDetails=(CalenderEventDetails*)(object);
            eventDetails.eventDetailsDic=[_eventDic objectAtIndex:event.EventTag];
            eventDetails.strMoveControllerName=@"WeekViewController";

            
            [self.navigationController popToViewController:eventDetails animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        CalenderEventDetails *eventDetails=[[CalenderEventDetails alloc] init];
        eventDetails.eventDetailsDic=[_eventDic objectAtIndex:event.EventTag];
        eventDetails.strMoveControllerName=@"WeekViewController";
        
        [self.navigationController pushViewController:eventDetails animated:NO];
    }

    
    
}

- (void)weekView:(MAWeekView *)weekView eventDragged:(MAEvent *)event {
	//NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
//	NSString *eventInfo = [NSString stringWithFormat:@"Description:%@", [event.userInfo objectForKey:@"text"]];
//	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
//                                                    message:eventInfo delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Edit",@"Delete",nil];
//	[alert show];
    
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[CalenderEventDetails class]])
        {
            Status=TRUE;
            CalenderEventDetails *eventDetails=(CalenderEventDetails*)(object);
            eventDetails.eventDetailsDic=[_eventDic objectAtIndex:event.EventTag];
            eventDetails.strMoveControllerName=@"WeekViewController";
            
            
            [self.navigationController popToViewController:eventDetails animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        CalenderEventDetails *eventDetails=[[CalenderEventDetails alloc] init];
        eventDetails.eventDetailsDic=[_eventDic objectAtIndex:event.EventTag];
        eventDetails.strMoveControllerName=@"WeekViewController";
        
        [self.navigationController pushViewController:eventDetails animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	}


@end
        
