//
//  PracticeLog.m
//  Athledo
//
//  Created by Smartdata on 5/11/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//
#import "PracticeLog.h"
#import "PracticeCell.h"
#import "PracticeLogDetail.h"
#define PRACTICE_CELL_HEIGHT (isIPAD) ? 60 : 50
#define ADD_PRACTICE_ICON_SIZE (isIPAD) ? 35 : 35
@interface PracticeLog (){
    SWRevealViewController *revealController;
    UIBarButtonItem *revealButtonItem;
    NSString *strCurrentMonth;
    NSMutableDictionary *arrPracticeData;
    NSMutableArray *startDateArr;
    NSMutableArray *endDateArr;
    NSMutableArray *eventArrDic;
    NSArray *PracticeOnDate;
    NSDate *currentSelectedDate;
}
@end
@implementation PracticeLog
#pragma mark UIViewController life cycle method
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    eventArrDic=[[NSMutableArray alloc] init];
    startDateArr=[[NSMutableArray alloc] init];
    endDateArr=[[NSMutableArray alloc] init];
    strCurrentMonth = EMPTYSTRING;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.monthView selectDate:[NSDate date]];
    [self orientationChanged];
    [SingletonClass ShareInstance].isPracticeLogUpdate = FALSE;
    self.title=NSLocalizedString(@"Practice", EMPTYSTRING);
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (isIPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    if ([SingletonClass ShareInstance].isPracticeLogUpdate && _comesFromMenuStatus == TRUE) {
        strCurrentMonth= @"";
        [self.monthView selectDate:[NSDate date]];
        [self orientationChanged];
    }
    currentSelectedDate = [NSDate date];
    [super viewWillAppear:animated];
    //[self.view addGestureRecognizer:revealController.panGestureRecognizer];
    //[self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    [self SetNavigationBarProperty];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma Class Utility method
-(UIButton *)addPracticeLogButton{
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-((ADD_PRACTICE_ICON_SIZE)+((isIPAD )? 10 :5)),2,ADD_PRACTICE_ICON_SIZE,ADD_PRACTICE_ICON_SIZE)];
    [btnSave addTarget:self action:@selector(addPracticeLog) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setImage:[UIImage imageNamed:@"addPractice.png"] forState:UIControlStateNormal];
    return btnSave;
}
-(void)addPracticeLog{
    currentSelectedDate = [self.monthView dateSelected];
    if (currentSelectedDate != nil) {
        AddPracticeLog *addPracticeView = [[AddPracticeLog alloc] initWithNibName:@"AddPracticeLog" bundle:nil];
        addPracticeView.strScreenTitle = @"Add Practice";
        addPracticeView.objEditPracticeData = nil;
        addPracticeView.addPracticeOnDate = currentSelectedDate;
        [self.navigationController pushViewController:addPracticeView animated:YES];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Please select practice date" delegate:self btn1:@"Ok"];
    }
}
-(void)SetNavigationBarProperty{
    revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
}
#pragma mark MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=DATE_FORMAT_dd_MMM_yyyy;
    NSDate *newDate1 = [lastDate dateByAddingTimeInterval:60*60*24*12];
    NSString *strLastdate=[formatter stringFromDate:newDate1];
    NSArray *arrComponents=[strLastdate componentsSeparatedByString:@" "];
    
    if (![[arrComponents objectAtIndex:1] isEqualToString:strCurrentMonth]) {
        formatter.dateFormat=DATE_FORMAT_Y_M_D;
        
        NSString *strStartDate = [formatter stringFromDate:startDate];
        NSString *strEndDate = [formatter stringFromDate:lastDate];
        strCurrentMonth=[arrComponents objectAtIndex:1];
        [self getPracticeListData:strStartDate:strEndDate];
    }else
    {
        [self MarkCalendarDataForStartDate:startDate endDate:lastDate];
    }
    return self.dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
    currentSelectedDate = date;
    [self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
    currentSelectedDate = nil;
    [super calendarMonthView:mv monthDidChange:d animated:animated];
    [self.tableView reloadData];
}
#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *ar = [self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", [self.monthView dateSelected] ] ];
    if(ar == nil) return 0;
    return [ar count];
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PRACTICE_CELL";
    static NSString *CellNibName = @"PracticeCell";
    PracticeCell *cell = (PracticeCell *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    @try {
        if (cell == nil)
        {
            NSArray *arrNib = [[NSBundle mainBundle] loadNibNamed:CellNibName owner:self options:nil];
            cell = [arrNib objectAtIndex:0];
            PracticeOnDate = [self.dataDictionary valueForKey:[NSString stringWithFormat:@"%@", [self.monthView dateSelected] ] ];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
            NSDate *time = [df dateFromString:[[[PracticeOnDate objectAtIndex:indexPath.row] valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[[PracticeOnDate objectAtIndex:indexPath.row] valueForKey:@"start_time"]]];
            [df setDateFormat:TIME_FORMAT_h_m_A];
            cell.lblPracticeTime.text = [df stringFromDate:time];
            cell.lblPracticeTime.font = Textfont;
            cell.lblPracticeDesc.text = [[[PracticeOnDate objectAtIndex:indexPath.row] valueForKey:@"description"] isKindOfClass:[NSString class]] ? [[PracticeOnDate objectAtIndex:indexPath.row] valueForKey:@"description"]  : @"";
            cell.lblPracticeDesc.font = Textfont;
            cell.lblPracticeTime.textColor = GrayColor;
            cell.lblPracticeDesc.textColor = GrayColor;
            df = nil;
            cell.rightUtilityButtons = [self rightButtons:indexPath.row];
            cell.delegate = self;
        }
        if (indexPath.row==0) {
            [cell.layer addSublayer:[self Line:CGPointMake(0, 0) :CGPointMake([[UIScreen mainScreen] bounds].size.width+500, 0)]] ;
        }
        tv.separatorStyle=UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.layer addSublayer:[self Line:CGPointMake(0, cell.frame.size.height) :CGPointMake([[UIScreen mainScreen] bounds].size.width+500, cell.frame.size.height)]] ;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return cell;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:[self addPracticeLogButton]];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    BOOL seasonStatus =FALSE;
    NSDate *selectedDate =currentSelectedDate;
    if (selectedDate !=nil ) {
        seasonStatus=[self CheckDateIsBetweenSeason:selectedDate];
    }
    if(seasonStatus && ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger )){
        return (ADD_PRACTICE_ICON_SIZE)+5;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PracticeLogDetail *practiceDetails = [[PracticeLogDetail alloc] initWithNibName:@"PracticeLogDetail" bundle:nil];
    practiceDetails.objEditPracticeData = indexPath.row < PracticeOnDate.count ?[[PracticeOnDate objectAtIndex:indexPath.row] mutableCopy] : nil;
    [self.navigationController pushViewController:practiceDetails animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PRACTICE_CELL_HEIGHT;
}
#pragma mark Class Utility method
-(BOOL)CheckDateIsBetweenSeason:(NSDate *)currentDate{
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:DATE_FORMAT_Y_M_D];
    BOOL SeasonStatus = FALSE;
    NSString *currentDay = [[[dateformater stringFromDate:currentDate] componentsSeparatedByString:@"-"] objectAtIndex:2];
    NSArray *arr = [self.dataDictionary allValues];
    for (int i=0; i<arr.count; i++) {
        NSArray *arrtemp = [arr objectAtIndex:i];
        for (int j=0; j<arrtemp.count; j++) {
            NSString *seasonSdate = [[arrtemp objectAtIndex: j] valueForKey:@"week_start_date"];
            NSString *seasonEdate = [[arrtemp objectAtIndex: j] valueForKey:@"week_end_date"];
            NSString *Sday = seasonSdate.length > 0 ? [[seasonSdate componentsSeparatedByString:@"-"] objectAtIndex:2] : @"";
            NSString *Eday = seasonEdate.length > 0 ? [[seasonEdate componentsSeparatedByString:@"-"] objectAtIndex:2] : @"";
            if (([currentDay intValue] >= [Sday intValue]) && ([currentDay intValue] <= [Eday intValue])) {
                SeasonStatus = TRUE;
                if (SeasonStatus == TRUE) {
                    [SingletonClass deleteUnUsedLableFromTable:self.tableView];
                    return SeasonStatus;
                }
            }
        }
    }
    if (SeasonStatus == FALSE) {
        [SingletonClass deleteUnUsedLableFromTable:self.tableView];
        [self.tableView addSubview:[SingletonClass ShowEmptyMessage:@"No Season" :self.tableView]];
    }
    return SeasonStatus;
}
- (void) MarkCalendarDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
    // this function sets up dataArray & dataDictionary
    // dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
    // dataDictionary: has items that are associated with date keys (for tableview)
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
                NSString *strCalenderDate=[NSString stringWithFormat:@"%@",d];
                [dateFormatter setDateFormat:DATE_FORMAT_Y_M_D];
                strCalenderDate=[dateFormatter stringFromDate:d];
                if ([startDate isEqualToString:strCalenderDate])
                {
                    NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
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
            }else{
                [self.dataArray addObject:@YES];
            }
            NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
            info.day++;
            d = [NSDate dateWithDateComponents:info];
            if([d compare:end]==NSOrderedDescending){
                break;
            }
        }
        dateFormatter=nil;
    }
}
- (NSArray *)rightButtons :(NSInteger)btnTag{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"edit.png"] :(int)btnTag];
    return rightUtilityButtons;
}
-(void)editPracticeLog:(UIButton *)btn{
    AddPracticeLog *addPracticeView;
    if ([UserInformation shareInstance].userType == isManeger || [UserInformation shareInstance].userType == isCoach) {
        addPracticeView = [[AddPracticeLog alloc] initWithNibName:@"AddPracticeLog" bundle:nil];
    }else{
        addPracticeView = [[AddPracticeLog alloc] initWithNibName:@"AddPracticeNoteByAthlete" bundle:nil];
    }
    addPracticeView.strScreenTitle = @"Edit Practice";
    addPracticeView.objEditPracticeData = btn.tag < PracticeOnDate.count ?[[PracticeOnDate objectAtIndex:btn.tag] mutableCopy] : nil;
    [self.navigationController pushViewController:addPracticeView animated:YES];
}
-(CAShapeLayer *)Line:(CGPoint)start_Point :(CGPoint)end_Point{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(end_Point.x, end_Point.y)];
    [path addLineToPoint:CGPointMake(start_Point.x, start_Point.y)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor darkGrayColor] CGColor];
    shapeLayer.lineWidth = .25;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    return shapeLayer;
}
#pragma SWTableviewCell Delegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:0];
    switch (index) {
        case 0:{
            [self editPracticeLog:btn];
            break;
        }
        default:
            break;
    }
}
#pragma change control frame when device rotate
- (void)orientationChanged{
    [self.monthView AssignViewWidthBoxWidth:[[SingletonClass ShareInstance] CurrentOrientation:self]];
    [self.monthView RefreshView];
    [self.tableView reloadData];
}
#pragma mark WebService Comunication Method
-(void)getPracticeListData :(NSString *)startDate :(NSString *)endDate{
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"type\":\"%d\",\"user_id\":\"%d\",\"team_id\":\"%d\",\"date_from\":\"%@\",\"date_to\":\"%@\"}",userInfo.userType,userInfo.userId,userInfo.userSelectedTeamid,startDate,endDate];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetPracticeData :strURL :getPracticeTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
   
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
    [SingletonClass ShareInstance].isPracticeLogUpdate = FALSE;
    switch (Tag){
        case getPracticeTag :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                 arrPracticeData.count > 0 ? [arrPracticeData removeAllObjects] : @"";
                arrPracticeData = [MyResults valueForKey:@"practiceData"];
                [eventArrDic removeAllObjects];
                [startDateArr removeAllObjects];
                [endDateArr removeAllObjects];
                [self.dataDictionary removeAllObjects];
                [self.dataArray removeAllObjects];
                
                NSArray *arrKeys=[arrPracticeData allKeys ];
                for (int i=0; i<arrKeys.count; i++){
                    if ([[arrPracticeData valueForKey:[arrKeys objectAtIndex:i] ] isKindOfClass:[NSArray class]]) {
                        NSArray *arrValues=[arrPracticeData valueForKey:[arrKeys objectAtIndex:i] ];
                        for (int j=0; j< arrValues.count; j++){
                            [eventArrDic addObject:[arrValues objectAtIndex:j]];
                            [startDateArr addObject:[[arrValues objectAtIndex:j] valueForKey:@"week_current_date"]];
                        }
                    }
                }
            }
            [self.monthView reloadData];
            [self.tableView reloadData];
            [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
    }
}
@end
