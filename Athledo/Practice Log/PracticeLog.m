//
//  PracticeLog.m
//  Athledo
//
//  Created by Smartdata on 5/11/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//
#import "PracticeLog.h"
#import "PracticeCell.h"
#define PRACTICE_CELL_HEIGHT (isIPAD) ? 60 : 50
#define ADD_PRACTICE_ICON_SIZE (isIPAD) ? 35 : 35
@interface PracticeLog (){
    SWRevealViewController *revealController;
    UIBarButtonItem *revealButtonItem;
    NSMutableArray *eventArrDic;
}
@end
@implementation PracticeLog
#pragma mark UIViewController life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Practice", EMPTYSTRING);
    [self getPracticeListData];
    [self.monthView selectDate:[NSDate date]];
    [self orientationChanged];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //[self.view addGestureRecognizer:revealController.panGestureRecognizer];
    //[self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    [self SetNavigationBarProperty];
    [self.tableView addSubview:[self addPracticeLogButton]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma Class Utility method
-(UIButton *)addPracticeLogButton
{
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-(ADD_PRACTICE_ICON_SIZE+5),5,ADD_PRACTICE_ICON_SIZE,ADD_PRACTICE_ICON_SIZE)];
    [btnSave addTarget:self action:@selector(addPracticeLog) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setImage:[UIImage imageNamed:@"addPractice.png"] forState:UIControlStateNormal];
    return btnSave;
}
-(void)addPracticeLog
{
    AddPracticeLog *addPracticeView = [[AddPracticeLog alloc] initWithNibName:@"AddPracticeLog" bundle:nil];
    [self.navigationController pushViewController:addPracticeView animated:YES];
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
    [self generateRandomDataForStartDate:startDate endDate:lastDate];
    return self.dataArray;
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
    [self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
    [super calendarMonthView:mv monthDidChange:d animated:animated];
    [self.tableView reloadData];
}
- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
    
    self.dataArray = [NSMutableArray array];
    self.dataDictionary = [NSMutableDictionary dictionary];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    //dateFormatter.timeZone=[NSTimeZone timeZoneForSecondsFromGMT:0];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:start];
    
    NSDate *d = [cal dateFromComponents:comp];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    while(YES){
        
        NSInteger r = arc4random();
        if(r % 3==1){
            (self.dataDictionary)[d] = @[@"Item one",@"Item two"];
            [self.dataArray addObject:@YES];
            
        }else if(r%4==1){
            (self.dataDictionary)[d] = @[@"Item one"];
            [self.dataArray addObject:@YES];
        }else
            [self.dataArray addObject:@NO];
        
        NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
        info.day++;
        d = [NSDate dateWithDateComponents:info];
        if([d compare:end]==NSOrderedDescending) break;
    }
}
#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PRACTICE_CELL";
    static NSString *CellNibName = @"PracticeCell";
    PracticeCell *cell = (PracticeCell *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *arrNib = [[NSBundle mainBundle] loadNibNamed:CellNibName owner:self options:nil];
        cell = [arrNib objectAtIndex:0];
        
        if (indexPath.row == 0) {
            cell.lblPracticeDesc.hidden = YES;
            cell.lblPracticeTime.hidden = YES;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:dateFormatYearMonthDateHiphenWithTime];
            [df setDateFormat:TIME_FORMAT_h_m_A];
            cell.lblPracticeTime.text = @"7 AM";
            cell.lblPracticeTime.font = Textfont;
            cell.lblPracticeDesc.text = @"Testing";
            cell.lblPracticeDesc.font = Textfont;
            cell.lblPracticeTime.textColor = GrayColor;
            cell.lblPracticeDesc.textColor = GrayColor;
            df = nil;
            cell.rightUtilityButtons = [self rightButtons:indexPath.row];
        }
    }
    tv.separatorStyle=UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.layer addSublayer:[self Line:CGPointMake(0, cell.frame.size.height) :CGPointMake([[UIScreen mainScreen] bounds].size.width, cell.frame.size.height)]] ;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return PRACTICE_CELL_HEIGHT;
}
#pragma mark Class Utility method
- (NSArray *)rightButtons :(NSInteger)btnTag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"edit.png"] :(int)btnTag];
    return rightUtilityButtons;
}
-(void)editPracticeLog:(UIButton *)btn
{
    
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
        case 0:
        {
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

-(void)getPracticeListData{
    
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetPracticeData :strURL :getPracticeTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
    switch (Tag){
        case getPracticeTag :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                
            }else{
                [self.tableView addSubview:[SingletonClass ShowEmptyMessage:@"No records":self.tableView ]] ;
            }
            break;
        }
    }
}


@end
