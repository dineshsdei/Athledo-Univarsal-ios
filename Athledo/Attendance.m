//
//  Attendance.m
//  Athledo
//
//  Created by Dinesh Kumar on 4/21/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//
#import "Attendance.h"

@interface Attendance ()
{
    NSArray *dicListData;
    NSArray *serviceListData;
}
@end
@implementation Attendance
#pragma mark UIViewController life cycle method
-(void)viewDidDisappear:(BOOL)animated
{
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getAthleteList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    
    self.title = @"Attendance";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SaveAttendance) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableview Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dicListData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ATTENDANCECELL";
    static NSString *CellNib = @"AttendanceCell";
    AttendanceCell *cell = (AttendanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (AttendanceCell *)[nib objectAtIndex:0];
        cell.contentView.userInteractionEnabled = YES;
        cell.tag = indexPath.row;
        
        UIDeviceOrientation oreintation = [[SingletonClass ShareInstance] CurrentOrientation:self];
        if (!(oreintation == UIDeviceOrientationPortrait ) && (isIPAD)) {
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, cell.frame.size.height);
        }
    }
    @try {
        [cell.leftUserImage setImageWithURL:[NSURL URLWithString:[[dicListData objectAtIndex:indexPath.row] valueForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        cell.leftUserImage.layer.masksToBounds = YES;
        cell.leftUserImage.layer.cornerRadius=(cell.leftUserImage.frame.size.width)/2;
        cell.leftUserImage.layer.borderWidth=2.0f;
        cell.leftUserImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [cell.rightUserImage setImageWithURL:[NSURL URLWithString:[[dicListData objectAtIndex:indexPath.row] valueForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        cell.rightUserImage.layer.masksToBounds = YES;
        cell.rightUserImage.layer.cornerRadius=(cell.rightUserImage.frame.size.width)/2;
        cell.rightUserImage.layer.borderWidth=2.0f;
        cell.rightUserImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        cell.leftLblName.text = [[dicListData objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.leftLblName.font = Textfont;
        
        cell.rightLblName.text = [[dicListData objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.rightLblName.font = Textfont;
        
        cell.leftUserImage.hidden =YES;
        cell.rightUserImage.hidden =YES;
        cell.leftLblName.hidden =YES;
        cell.rightLblName.hidden =YES;
        cell.rightUtilityButtons = [self rightButtons : indexPath.section];
        cell.leftUtilityButtons = [self leftButton : indexPath.section];
        cell.delegate = self;
        
        if ([[[dicListData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue] == NO) {
            
            cell.rightUserImage.hidden =NO;
            cell.rightLblName.hidden =NO;
            cell.cellUtilityButtonState = kCellStateRight;
            cell.cellCurrentStatus = kCellStateRight;
            [cell showRightUtilityButtonsAnimated:YES];
            
        }else  if ([[[dicListData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue] == YES){
            cell.leftUserImage.hidden =NO;
            cell.leftLblName.hidden =NO;
            cell.cellUtilityButtonState = kCellStateLeft;
            cell.cellCurrentStatus = kCellStateLeft ;
            [cell showLeftUtilityButtonsAnimated:YES];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    [cell.layer addSublayer:[self Line:CGPointMake(0, 0) :CGPointMake([[UIScreen mainScreen] bounds].size.width, 0)]] ;
    if (indexPath.row == dicListData.count-1) {
        [cell.layer addSublayer:[self Line:CGPointMake(0, cell.frame.size.height) :CGPointMake([[UIScreen mainScreen] bounds].size.width, cell.frame.size.height)]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isIPAD)
    {
        return 70;
    }else{
        return 60;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    cell.cellCurrentStatus = state;
}
- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell
{
    if(cell.cellCurrentStatus == kCellStateCenter)
    {
        [self ChangeCell:cell];
    }else  if(cell.cellCurrentStatus == kCellStateLeft)
    {
        [self ChangeCell:cell];
    }else  if(cell.cellCurrentStatus == kCellStateRight)
    {
        [self ChangeCell:cell];
    }
}
-(void)ChangeCellField:(SWTableViewCell *)cell
{
    AttendanceCell *tempCell = (AttendanceCell *)cell;
    
    if (cell.cellUtilityButtonState == kCellStateLeft) {
        
        [[dicListData objectAtIndex:cell.tag] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
        
        tempCell.leftLblName.hidden = NO;
        tempCell.leftUserImage.hidden = NO;
        tempCell.rightLblName.hidden = YES;
        tempCell.rightUserImage.hidden = YES;
    }else  if (cell.cellUtilityButtonState == kCellStateRight) {
        
        [[dicListData objectAtIndex:cell.tag] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        tempCell.leftLblName.hidden = YES;
        tempCell.leftUserImage.hidden = YES;
        tempCell.rightLblName.hidden = NO;
        tempCell.rightUserImage.hidden = NO;
    }
}
-(void)ChangeCell:(SWTableViewCell*)cell
{
    if (cell.cellUtilityButtonState == kCellStateLeft) {
        [self ChangeCellField:cell];
        [cell showLeftUtilityButtonsAnimated:NO];
        cell.cellUtilityButtonState = kCellStateRight;
    }else  if (cell.cellUtilityButtonState == kCellStateRight) {
        [self ChangeCellField:cell];
        [cell showRightUtilityButtonsAnimated:NO];
        cell.cellUtilityButtonState = kCellStateLeft;
    }
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
}
#pragma mark Webservice call event
-(void)SaveAttendance{
    
    if ([SingletonClass  CheckConnectivity]) {
        
        if (dicListData.count ==0) {
            return;
        }
        
        UserInformation *userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [SingletonClass addActivityIndicator:self.view];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedTeamid] forKey:@"team_id"];
        [dict setObject:dicListData forKey:@"attendance"];
        [webservice WebserviceCallwithDic:dict :webServiceSaveAttendance :SaveAttendanceTag];
    
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}
-(void)getAthleteList{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        
        NSString *strURL = [NSString stringWithFormat:@"{\"sport_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userSelectedSportid,userInfo.userSelectedTeamid];
        
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetAttendance :strURL :getAttendanceTag];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];

    switch (Tag)
    {
        case getAttendanceTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                // Now we Need to decrypt data
                [SingletonClass deleteUnUsedLableFromTable:_tableView];
                dicListData =[MyResults objectForKey:@"attendanceData"];
                [_tableView reloadData];
            }else
            {
                dicListData = nil;
                [_tableView addSubview:[SingletonClass ShowEmptyMessage:@"NO PRACTICE"]];
                [_tableView reloadData];
            }
            break;
        }
        case SaveAttendanceTag:
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                 [SingletonClass initWithTitle:@"" message:@"Attendance has been saved successfully." delegate:nil btn1:@"Ok"];
            }
            break;
        }
    }
}
#pragma mark Class Utility method Method
//this method call, when user rotate your device
- (void)orientationChanged
{
    [_tableView reloadData];
}
-( CAShapeLayer *)Line:(CGPoint)start_Point :(CGPoint)end_Point
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(end_Point.x, end_Point.y)];
    [path addLineToPoint:CGPointMake(start_Point.x, start_Point.y)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor darkGrayColor] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    return shapeLayer;
}
- (NSArray *)rightButtons :(NSInteger)btnTag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:225.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"Tick.png"] :(int)btnTag];
    return rightUtilityButtons;
}
- (NSArray *)leftButton :(NSInteger)btnTag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:225.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"UnTick.png"] :(int)btnTag];
    
    return rightUtilityButtons;
}
@end
