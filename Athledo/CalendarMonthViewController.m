

#define getEventTag 110
#define CellHeight 90

#import "WebServiceClass.h"
#import "SWRevealViewController.h"

#import "CalendarDayViewController.h"
#import "CalendarMonthViewController.h"
#import "MapViewController.h"
#import "WeekViewController.h"
#import "AddCalendarEvent.h"



int tagNumber;
WebServiceClass *webservice;
NSMutableArray *startDateArr;
NSMutableArray *endDateArr;

NSMutableArray *eventArrDic;
NSDictionary *eventData;
int tabBar_Y;
int tbl_Y;
SWRevealViewController *revealController;
UIBarButtonItem *revealButtonItem;;

#pragma mark - CalendarMonthViewController
@implementation CalendarMonthViewController

- (NSUInteger) supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.title=NSLocalizedString(@"Back", @"");
    
}
#pragma mark View Lifecycle
- (void) viewDidLoad{
    [super viewDidLoad];
    
    
    strCurrentMonth=@"";
    
    self.title=NSLocalizedString(@"Month Events", @"");
    
    eventArrDic=[[NSMutableArray alloc] init];
    startDateArr=[[NSMutableArray alloc] init];
    endDateArr=[[NSMutableArray alloc] init];
    revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    //self.title = NSLocalizedString(@"Calendar", @"");
    self.monthView.frame=CGRectMake(0, 0, 1024, 265);
    [self.monthView selectDate:[NSDate date]];
    //[self.monthView setAutoresizesSubviews:YES];
   // [self.monthView setAutoresizingMask: UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin];
     
    //self.tableView.backgroundColor=[UIColor clearColor];
    
    UIButton  *btnAddNew = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 25, 25)];
    UIImage *imageEdit=[UIImage imageNamed:@"add.png"];
    
    
    
    [btnAddNew addTarget:self action:@selector(AddNewEvent) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNew setBackgroundImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddNew];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    // 113 height is (49+64) tabbar height and navigationBar height
    tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-113, self.view.frame.size.width, 50)];
    
    self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.view.frame.size.width, self.tableView.frame.size.height-tabBar.frame.size.height);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Month" image:[UIImage imageNamed:@"mnth_icon2.png"] tag:0];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Week" image:[UIImage imageNamed:@"week_icon.png"] tag:1];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"Today" image:[UIImage imageNamed:@"today_icon.png"] tag:2];;
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"tabmap_icon.png"] tag:3];
    
    [tabBarItems addObject:tabBarItem1];
    [tabBarItems addObject:tabBarItem2];
    [tabBarItems addObject:tabBarItem3];
    [tabBarItems addObject:tabBarItem4];
    
    tabBar.items = tabBarItems;
    tabBar.delegate=self;
    
    [self.view addSubview:tabBar];
    
    if (strCurrentMonth.length > 0) {
        
        [self getEvents:SelectedMonthStart:SelectedMonthEnd];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    self.title=NSLocalizedString(@"Month Events", @"");
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:0];
    tabBar.delegate=self;
    [tabBar setSelectedItem:tabBarItem];
    
    if (strCurrentMonth.length > 0 ) {
        
        [self getEvents:SelectedMonthStart:SelectedMonthEnd];
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
                mapView.eventDic=eventArrDic;
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

-(void)AddNewEvent
{
    [CalendarEvent ShareInstance].strEventType=@"";
    [CalendarEvent ShareInstance].strRepeatSting=@"";
    [CalendarEvent ShareInstance].strEventEditBy=@"";
    [CalendarEvent ShareInstance].CalendarRepeatStatus=FALSE;
    [CalendarEvent ShareInstance].strEventAddOrEdit=@"Add";
    
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[AddCalendarEvent class]])
        {
            Status=TRUE;
            AddCalendarEvent *temp=(AddCalendarEvent *)object;
            temp.screentitle=@"Add Event";
            temp.eventDetailsDic=nil;
            temp.strMoveControllerName=@"CalendarMonthViewController";
            
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        AddCalendarEvent *addEvent=[[AddCalendarEvent alloc] initWithNibName:@"AddCalendarEvent" bundle:nil];
        addEvent.screentitle=@"Add Event";
        addEvent.eventDetailsDic=nil;
        addEvent.strMoveControllerName=@"CalendarMonthViewController";
        [self.navigationController pushViewController:addEvent animated:NO];
    }
    //[self presentViewController:addEvent animated:YES completion:nil];
}

#pragma mark MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=DATE_FORMAT_dd_MMM_yyyy;
    
    NSDate *newDate1 = [lastDate dateByAddingTimeInterval:60*60*24*12];
    NSString *strLastdate=[formatter stringFromDate:newDate1];
    
    NSArray *arrComponents=[strLastdate componentsSeparatedByString:@" "];
    
    if (![[arrComponents objectAtIndex:1] isEqualToString:strCurrentMonth]) {
        strCurrentMonth=[arrComponents objectAtIndex:1];
        SelectedMonthStart=startDate;
        SelectedMonthEnd=lastDate;
        [self getEvents:startDate:lastDate];
    }
    formatter=nil;
    [self MarkCalendarDataForStartDate:startDate endDate:lastDate];
    
    return self.dataArray;
}

-(void)siftValues
{
    for (int i=0; i< self.dataArray.count-1 ; i++) {
        
        [self.dataArray replaceObjectAtIndex:i withObject:[self.dataArray objectAtIndex:(i+1)]];
    }
    
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
    // Show table on below to calendar ,Uncomment below line or reload table
    //[self.tableView reloadData];
    
    // Move on dayview calendar
    if(self.dataDictionary.count > 0)
    {
        CalendarDayViewController *dayView = [[CalendarDayViewController alloc]init];
        NSLog(@"data for key %@",[self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", date ]]);
        //dayView.eventDic=[self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", date ]];
        dayView.eventDic=nil;
        dayView.strComeFrom=@"MonthView";
        dayView.CalendarDisplayDate=date;
        if (_objNotificationData) {
            dayView.objNotificationData=_objNotificationData;
        }
        [self.navigationController pushViewController:dayView animated:NO];
    }
    
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
    [super calendarMonthView:mv monthDidChange:d animated:animated];
    
    [self.tableView reloadData];
}


#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //NSArray *ar = self.dataDictionary[[self.monthView dateSelected]];
    NSArray *ar = [self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", [self.monthView dateSelected] ] ];
    if(ar == nil) return 0;
    return [ar count];
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    //NSArray *ar = self.dataDictionary[[self.monthView dateSelected]];
    NSArray *ar = [self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", [self.monthView dateSelected] ] ];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
    NSDate *displaydate=[df dateFromString:[[ar objectAtIndex:0] valueForKey:@"start_date"]];
    
    [df setDateFormat:TIME_FORMAT_h_m_A];
    
    cell.textLabel.text = [[df stringFromDate:displaydate] stringByAppendingString:[NSString stringWithFormat:@" %@", [[ar objectAtIndex:indexPath.row]valueForKey:@"text"] ] ];
    cell.textLabel.font = Textfont;
    cell.detailTextLabel.text=[[ar objectAtIndex:indexPath.row]valueForKey:@"name"];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor grayColor];
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    tv.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(0,CellHeight-2, self.view.frame.size.width, 1)];
    img1.image=[UIImage imageNamed:@"menu_sep.png"];
    
    [cell addSubview:img1];
    
    //cell.accessoryType=UITableViewCellAccessoryDetailButton;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSArray *ar = self.dataDictionary[[self.monthView dateSelected]];
    NSArray *ar = [self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", [self.monthView dateSelected] ] ];
    
    
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[CalenderEventDetails class]])
        {
            Status=TRUE;
            CalenderEventDetails *temp=(CalenderEventDetails *)object;
            temp.eventDetailsDic=[ar objectAtIndex:indexPath.row];
            temp.strMoveControllerName=@"CalendarMonthViewController";
            if (_objNotificationData) {
                temp.objNotificationData=_objNotificationData;
            }
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
    if (Status==FALSE)
    {
        CalenderEventDetails *eventDetails=[[CalenderEventDetails alloc] init];
        eventDetails.eventDetailsDic=[ar objectAtIndex:indexPath.row];
        eventDetails.strMoveControllerName=@"CalendarMonthViewController";
        if (_objNotificationData) {
            eventDetails.objNotificationData=_objNotificationData;
        }
        [self.navigationController pushViewController:eventDetails animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}
-(NSInteger)NoOFDaysBetween :(NSString *)strStartDate :(NSString *)strEndDate
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:DATE_FORMAT_M_D_Y];
    NSDate *startDate = [f dateFromString:strStartDate];
    NSDate *endDate = [f dateFromString:strEndDate];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return components.day;
}

-(NSMutableArray *)DatesBetween : (NSString *)startdate :(NSString *)enddate
{
    NSMutableArray *arrdates=[[NSMutableArray alloc] init];
    NSArray *arr=[startdate componentsSeparatedByString:@"-"];
    
    
    for (int i=0; i< [self NoOFDaysBetween: startdate:enddate]; i++) {
        
        [arrdates addObject:[NSString stringWithFormat:@"%@-%d-%@",[arr objectAtIndex:0],[[arr objectAtIndex:1] intValue]+i,[arr objectAtIndex:2]]];
    }
    return arrdates;
}
-(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

- (void) MarkCalendarDataForStartDate:(NSDate*)start endDate:(NSDate*)end
{
    // this function sets up dataArray & dataDictionary
    // dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
    // dataDictionary: has items that are associated with date keys (for tableview)
    
    
    //NSLog(@"Delegate Range: %@ %@ %@",start,end,@([start daysBetweenDate:end]));
    
    if (startDateArr.count > 0) {
        
        self.dataArray = [NSMutableArray array];
        self.dataDictionary = [NSMutableDictionary dictionary];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        
        NSDate *d = start;
        while(YES){
            
            BOOL MatchStatus=FALSE;
            
            for (int i=0; i< eventArrDic.count; i++) {
                
                [dateFormatter setDateFormat:dateFormatYearMonthDateHiphenWithTime];
                NSString *startDate=[startDateArr objectAtIndex:i];
                NSDate *startdate=[dateFormatter dateFromString:startDate];
                
                NSString *endDate=[endDateArr objectAtIndex:i];
                NSDate *enddate=[dateFormatter dateFromString:endDate];
                
                NSString *strCalenderDate=[NSString stringWithFormat:@"%@",d];
                NSDate *calenderdate=[dateFormatter dateFromString:strCalenderDate];
                
                
                [dateFormatter setDateFormat:DATE_FORMAT_M_D_Y];
                
                startDate=[dateFormatter stringFromDate:startdate];
                endDate=[dateFormatter stringFromDate:enddate];
                
                strCalenderDate=[dateFormatter stringFromDate:calenderdate];
                
                if([self date:[dateFormatter dateFromString:strCalenderDate] isBetweenDate:[dateFormatter dateFromString:startDate] andDate:[dateFormatter dateFromString:endDate]])
                    // if ([startDate isEqualToString:strCalenderDate] || [endDate isEqualToString:strCalenderDate])
                {
                    
                    NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
                    info.day--;
                    NSDate *temp = [NSDate dateWithDateComponents:info];
                    
                    if ( [self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", temp]]) {
                        
                        NSArray *arr=[self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", temp ]];
                        
                        NSMutableArray *arr1=[NSMutableArray arrayWithArray:arr];
                        [arr1 addObject:[eventArrDic objectAtIndex:i]];
                        [self.dataDictionary setObject:arr1 forKey:[NSString stringWithFormat:@"%@", temp]];
                        
                    }else{
                        
                        NSArray *arr=[[NSArray alloc] initWithObjects:[eventArrDic objectAtIndex:i], nil];
                        [self.dataDictionary setObject:arr forKey:[NSString stringWithFormat:@"%@", temp]];
                        
                    }
                    
                    MatchStatus=TRUE;
                    
                }
                
            }
            
            if (!MatchStatus) {
                
                [self.dataArray addObject:@NO];
                
            }else
            {
                
                [self.dataArray addObject:@YES];
                
            }
            
            NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
            info.day++;
            d = [NSDate dateWithDateComponents:info];
            if([d compare:end]==NSOrderedDescending)
            {
                break;
            }
        }
        dateFormatter=nil;
        // Shift back by 1 index array because api shown event next day
        [self siftValues];
    }
    
}

#pragma mark Webservice call event
-(void)getEvents :(NSDate*)startDate :(NSDate *)endDate{
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
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"start_date\":\"%@\",\"last_date\":\"%@\"}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid,startdate,enddate];
        
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
            [eventArrDic removeAllObjects];
            [startDateArr removeAllObjects];
            [endDateArr removeAllObjects];
            [self.dataDictionary removeAllObjects];
            [self.dataArray removeAllObjects];
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                // Now we Need to decrypt data
                //[SingaltonClass ShareInstance].isCalendarUpdate=FALSE;
                
                // eventArrDic =[MyResults objectForKey:@"data"];
                eventData =[MyResults objectForKey:@"data"];
                if(eventData.count == 0)
                {
                    return;
                }
                NSArray *arrKeys=[eventData allKeys ];
                
                for (int i=0; i<arrKeys.count; i++) {
                    
                    NSArray *arrValues=[eventData valueForKey:[arrKeys objectAtIndex:i] ];
                    
                    for (int j=0; j< arrValues.count; j++) {
                        
                        [eventArrDic addObject:[arrValues objectAtIndex:j]];
                        [startDateArr addObject:[[arrValues objectAtIndex:j] valueForKey:@"start_date"]];
                        [endDateArr addObject:[[arrValues objectAtIndex:j] valueForKey:@"end_date"]];
                    }
                }
            }
        }
    }
    
    [self.monthView reloadData];
    [self.tableView reloadData];
}




@end
