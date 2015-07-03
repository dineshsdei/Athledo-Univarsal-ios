//
//  CalenderEventDetails.m
//  Athledo
//
//  Created by Smartdata on 9/10/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "CalenderEventDetails.h"
#import "AddCalendarEvent.h"

@interface CalenderEventDetails ()
{
    WebServiceClass *webservice;
}

@end

@implementation CalenderEventDetails

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
- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Event Details", EMPTYSTRING);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 25, 25)];
    UIImage *imageEdit=[UIImage imageNamed:@"edit.png"];
    [btnEdit addTarget:self action:@selector(editEventDetails) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setBackgroundImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
    NSDate *startdate=[df dateFromString:[_eventDetailsDic valueForKey:@"start_date"]];
    NSDate *enddate=[df dateFromString:[_eventDetailsDic valueForKey:@"actual_end_date"]];
    
    [df setDateFormat:DATE_FORMAT_M_D_Y_H_M];
    
    NSString *strStartDate=[df stringFromDate:startdate];
    NSString *strEndDate=[df stringFromDate:enddate];
    
    _lblEndDate.font=Textfont;
    _lblEventDescription.font=Textfont;
    _lblEventDescription.layer.borderWidth=.50;
    _lblEventDescription.layer.cornerRadius=10;
    _lblEventDescription.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _lblEventTitle.font=Textfont;
    _lblEventLocation.font=Textfont;
    _lblStartDate.font=Textfont;
    _lblRepeat.font=Textfont;
    
    if (_eventDetailsDic) {
        
        if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
            self.navigationItem.rightBarButtonItem = ButtonItem;
            self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
        }else if ([UserInformation shareInstance].userType == isAthlete && [UserInformation shareInstance].userId == [[_eventDetailsDic  objectForKey:KEY_USER_ID] intValue])
        {
            self.navigationItem.rightBarButtonItem = ButtonItem;
            self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
        }
        
        _lblEventTitle.text=[_eventDetailsDic valueForKey:@"text"];
        _lblEventDescription.text=[_eventDetailsDic valueForKey:Key_name];
        // [_lblEventDescription setNumberOfLines:0];
        // [_lblEventDescription sizeToFit];
        _lblEventLocation.text=[_eventDetailsDic valueForKey:@"location"];
        _lblStartDate.text=strStartDate;
        // if reccurrence type
        NSString *str=!([[_eventDetailsDic valueForKey:@"rec_type"] isEqual:[NSNull null]]) ?[_eventDetailsDic valueForKey:@"rec_type"] : EMPTYSTRING;
        _lblRepeat.text=@"Never";
        if (str.length > 0) {
            int event_length=[[_eventDetailsDic valueForKey:@"event_length"] intValue];
            NSDate *enddate=[startdate dateByAddingTimeInterval:event_length];
            _lblEndDate.text=[df stringFromDate:enddate];
            const char *c = str.length > 0 ? [str UTF8String] : [EMPTYSTRING  UTF8String];
            if (c[0]=='d') {
                _lblRepeat.text=EVENTTYPE_DAILY;
            }else  if (c[0]=='w') {
                _lblRepeat.text=EVENTTYPE_WEEKLY;
            }else  if (c[0]=='m') {
                _lblRepeat.text=EVENTTYPE_MONTHLY;
            }else  if (c[0]=='y') {
                _lblRepeat.text=EVENTTYPE_YEARLY;
            }
        }else{
            _lblEndDate.text=strEndDate;
        }
    }
    if (_objNotificationData) {
        if (_objNotificationData)
        {
            NSArray *arrTemp=[_objNotificationData valueForKey:@"events"];
            if ([arrTemp containsObject:[_eventDetailsDic valueForKey:@"event_id"]])
            {
                [self DeleteNotificationFromWeb];
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([CalendarEvent ShareInstance].strRepeatSting.length > 0) {
        NSString *str=[CalendarEvent ShareInstance].strRepeatSting;
        const char *c = str.length > 0 ? [str UTF8String] : [EMPTYSTRING  UTF8String];
        if (c[0]=='d') {
            _lblRepeat.text=EVENTTYPE_DAILY;
        }else  if (c[0]=='w') {
            _lblRepeat.text=EVENTTYPE_WEEKLY;
        }else  if (c[0]=='m') {
            _lblRepeat.text=EVENTTYPE_MONTHLY;
        }else  if (c[0]=='y') {
            _lblRepeat.text=EVENTTYPE_YEARLY;
        }
    }
    
    [super viewWillAppear:animated];
}

-(void)DeleteNotificationFromWeb
{
    //NOTE ---  type=(1=>announcement, 2=>event, 3=>workout)
    webservice=[WebServiceClass shareInstance];
    webservice.delegate=self;
    if ([SingletonClass  CheckConnectivity]) {
        if (_objNotificationData) {
            UserInformation *userInfo= [UserInformation shareInstance];
            NSString *strURL = [NSString stringWithFormat:@"{\"type\":\"%d\",\"parent_id\":\"%d\",\"team_id\":\"%d\",\"user_id\":\"%d\"}",2,[[_eventDetailsDic valueForKey:@"event_id"] intValue],userInfo.userSelectedTeamid,userInfo.userId];
            [webservice WebserviceCall:webServiceDeleteNotification :strURL :deleteNotificationTag];
        }
    }else{
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
    {
        
    }
}
-(void)editEventDetails
{
    [CalendarEvent ShareInstance].strEventAddOrEdit=@"Edit";
    if ([_lblRepeat.text isEqualToString:@"Never"]) {
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController)
        {
            if ([object isKindOfClass:[CalendarEvent class]])
            {
                Status=TRUE;
                [CalendarEvent ShareInstance].CalendarRepeatStatus=FALSE;
                AddCalendarEvent *addEvent=(AddCalendarEvent *)(object);
                addEvent.eventDetailsDic=_eventDetailsDic;
                addEvent.screentitle=@"Edit Event";
                addEvent.strMoveControllerName=_strMoveControllerName;
                [self.navigationController popToViewController:addEvent animated:NO];
            }
        }
        if (Status==FALSE)
        {
            [CalendarEvent ShareInstance].CalendarRepeatStatus=FALSE;
            AddCalendarEvent *addEvent=[[AddCalendarEvent alloc] initWithNibName:@"AddCalendarEvent" bundle:nil];
            addEvent.eventDetailsDic=_eventDetailsDic;
            addEvent.screentitle=@"Edit Event";
            addEvent.strMoveControllerName=_strMoveControllerName;
            [self.navigationController pushViewController:addEvent animated:NO];
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Do you want to edit the whole set of repeated events?" delegate:self btn1:@"Cancel" btn2:@"Edit Occurrence" btn3:@"Edit Series" tagNumber:101];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }else if (buttonIndex==1)
    {
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController)
        {
            if ([object isKindOfClass:[CalendarEvent class]])
            {
                Status=TRUE;
                [CalendarEvent ShareInstance].CalendarRepeatStatus=TRUE;
                AddCalendarEvent *addEvent=(AddCalendarEvent *)(object);
                addEvent.eventDetailsDic=_eventDetailsDic;
                addEvent.screentitle=@"Edit Event";
                addEvent.strMoveControllerName=_strMoveControllerName;
                [CalendarEvent ShareInstance].strEventEditBy=@"Edit Occurrence";
                
                [self.navigationController popToViewController:addEvent animated:NO];
            }
        }
        
        if (Status==FALSE)
        {
            [CalendarEvent ShareInstance].CalendarRepeatStatus=TRUE;
            AddCalendarEvent *addEvent=[[AddCalendarEvent alloc] initWithNibName:@"AddCalendarEvent" bundle:nil];
            addEvent.eventDetailsDic=_eventDetailsDic;
            addEvent.screentitle=@"Edit Event";
            addEvent.strMoveControllerName=_strMoveControllerName;
            [CalendarEvent ShareInstance].strEventEditBy=@"Edit Occurrence";
            [self.navigationController pushViewController:addEvent animated:NO];
        }
    }else if (buttonIndex==2)
    {
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController)
        {
            if ([object isKindOfClass:[CalendarEvent class]])
            {
                Status=TRUE;
                [CalendarEvent ShareInstance].CalendarRepeatStatus=TRUE;
                AddCalendarEvent *addEvent=(AddCalendarEvent *)(object);
                addEvent.eventDetailsDic=_eventDetailsDic;
                addEvent.screentitle=@"Edit Event";
                addEvent.strMoveControllerName=_strMoveControllerName;
                [CalendarEvent ShareInstance].strEventEditBy=@"Edit Series";
                [self.navigationController popToViewController:object animated:NO];
            }
        }
        if (Status==FALSE)
        {
            [CalendarEvent ShareInstance].CalendarRepeatStatus=TRUE;
            AddCalendarEvent *addEvent=[[AddCalendarEvent alloc] init];
            addEvent.eventDetailsDic=_eventDetailsDic;
            addEvent.screentitle=@"Edit Event";
            addEvent.strMoveControllerName=_strMoveControllerName;
            [CalendarEvent ShareInstance].strEventEditBy=@"Edit Series";
            [self.navigationController pushViewController:addEvent animated:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
