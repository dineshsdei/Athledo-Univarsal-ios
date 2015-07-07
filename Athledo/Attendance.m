//
//  Attendance.m
//  Athledo
//
//  Created by Smartdata on 4/21/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//
#import "Attendance.h"
#define ALERTVIEW_WEIGHT (iosVersion >= 8) ? 250 : 220
#define REASON_FIELD_X_Y (iosVersion >= 8) ? 10 : 2
#define ATTENDENCECELL_HEIGHT isIPAD ? 70 : 60

@interface Attendance (){
    NSMutableArray *dicListData;
    NSArray *serviceListData;
    UIBarButtonItem *ButtonItem;
    NSArray *arrAbsenceReason;
    UITextField *currentTextField;
    UIAlertView *alertViewReason;
    UIView *ReasonAlertBG;
    NSInteger AbsentReasonIndex;
}
@end
@implementation Attendance
#pragma mark UIViewController life cycle method
-(void)viewDidDisappear:(BOOL)animated{
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAthleteList];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    dicListData = MUTABLEARRAY;
    arrAbsenceReason = @[@"Injured",@"Sick",@"Emergency",@"Class/Exam",@"InExcused",@"Other"];
    if (isIPAD){
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    self.title = @"Attendance";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor = NAVIGATION_COMPONENT_COLOR;
    self.navigationItem.rightBarButtonItem.tintColor = NAVIGATION_COMPONENT_COLOR;
    self.navigationController.navigationBar.tintColor = NAVIGATION_COMPONENT_COLOR;
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SaveAttendance) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    [self showHideFields:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableview Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dicListData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ATTENDANCECELL";
    static NSString *CellNib = @"AttendanceCell";
    AttendanceCell *cell = (AttendanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (AttendanceCell *)[nib objectAtIndex:0];
        cell.contentView.userInteractionEnabled = YES;
        UIDeviceOrientation oreintation = [[SingletonClass ShareInstance] CurrentOrientation:self];
        if (!(oreintation == UIDeviceOrientationPortrait ) && (isIPAD)) {
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, cell.frame.size.height);
        }
    }
    @try {
        cell.tag = indexPath.row;
        [cell.leftUserImage setImageWithURL:[NSURL URLWithString:[[dicListData objectAtIndex:indexPath.row] valueForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        cell.leftUserImage.layer.masksToBounds = YES;
        cell.leftUserImage.layer.cornerRadius = (cell.leftUserImage.frame.size.width)/2;
        cell.leftUserImage.layer.borderWidth = 2.0f;
        cell.leftUserImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [cell.rightUserImage setImageWithURL:[NSURL URLWithString:[[dicListData objectAtIndex:indexPath.row] valueForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        cell.rightUserImage.layer.masksToBounds = YES;
        cell.rightUserImage.layer.cornerRadius = (cell.rightUserImage.frame.size.width)/2;
        cell.rightUserImage.layer.borderWidth = 2.0f;
        cell.rightUserImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.leftLblName.text = [[dicListData objectAtIndex:indexPath.row] valueForKey:Key_name];
        cell.leftLblName.font = Textfont;
        cell.rightLblName.text = [[dicListData objectAtIndex:indexPath.row] valueForKey:Key_name];
        cell.rightLblName.font = Textfont;
        cell.leftUserImage.hidden = YES;
        cell.rightUserImage.hidden = YES;
        cell.leftLblName.hidden = YES;
        cell.rightLblName.hidden = YES;
        cell.rightUtilityButtons = [self rightButtons : indexPath.section];
        cell.leftUtilityButtons = [self leftButton : indexPath.section];
        cell.delegate = self;
        if ([[[dicListData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue] == NO) {
            cell.rightUserImage.hidden = NO;
            cell.rightLblName.hidden = NO;
            cell.cellUtilityButtonState = kCellStateRight;
            cell.cellCurrentStatus = kCellStateRight;
            [cell showRightUtilityButtonsAnimated:YES];
        }else  if ([[[dicListData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue] == YES){
            cell.leftUserImage.hidden = NO;
            cell.leftLblName.hidden = NO;
            cell.cellUtilityButtonState = kCellStateLeft;
            cell.cellCurrentStatus = kCellStateLeft ;
            [cell showLeftUtilityButtonsAnimated:YES];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    [cell.layer addSublayer:[self Line:CGPointMake(0, 0) :CGPointMake([[UIScreen mainScreen] bounds].size.width+500, 0)]] ;
    if (indexPath.row == dicListData.count-1) {
        [cell.layer addSublayer:[self Line:CGPointMake(0, cell.frame.size.height) :CGPointMake([[UIScreen mainScreen] bounds].size.width+500, cell.frame.size.height)]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return ATTENDENCECELL_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state{
    cell.cellCurrentStatus = state;
}
- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell{
    if(cell.cellCurrentStatus == kCellStateCenter){
        [self ChangeCell:cell];
    }else  if(cell.cellCurrentStatus == kCellStateLeft){
        [self ChangeCell:cell];
    }else  if(cell.cellCurrentStatus == kCellStateRight){
        [self ChangeCell:cell];
    }
}
-(void)ChangeCellField:(SWTableViewCell *)cell{
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
        [self RemoveOldReason:cell];
    }
}
-(void)ChangeCell:(SWTableViewCell*)cell{
    
    if (cell.cellUtilityButtonState == kCellStateLeft) {
        [self ReasonForAbsent:cell];
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
#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrAbsenceReason count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (currentTextField.text.length == 0) {
        currentTextField.text=[arrAbsenceReason objectAtIndex:0];
         [[dicListData objectAtIndex:AbsentReasonIndex] setValue:[self GetReasonId:currentTextField.text] forKey:REASON_ID];
    }
    NSString *str = [arrAbsenceReason objectAtIndex:row];
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    currentTextField.text=[arrAbsenceReason objectAtIndex:row];
    if ([currentTextField.text isEqualToString:@"Other"]) {
        [[dicListData objectAtIndex:AbsentReasonIndex] setValue:[self GetReasonId:currentTextField.text] forKey:REASON_ID];
        UITextField *otherReasonField = (UITextField *)[ReasonAlertBG viewWithTag:OtherReasonTextField_Tag];
        otherReasonField.hidden = NO;
    }else{
        [[dicListData objectAtIndex:AbsentReasonIndex] setValue:[self GetReasonId:currentTextField.text] forKey:REASON_ID];
        UITextField *otherReasonField = (UITextField *)[ReasonAlertBG viewWithTag:OtherReasonTextField_Tag];
        otherReasonField.hidden = YES;
    }
}
#pragma mark Webservice call event
-(void)SaveAttendance{
    if ([SingletonClass  CheckConnectivity]) {
        if (dicListData.count == 0) {
            return;
        }
        UserInformation *userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [SingletonClass addActivityIndicator:self.view];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedTeamid] forKey:KEY_TEAM_ID];
        [dict setObject:dicListData forKey:@"attendance"];
        [webservice WebserviceCallwithDic:dict :webServiceSaveAttendance :SaveAttendanceTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
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
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    switch (Tag){
        case getAttendanceTag:{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                // Now we Need to decrypt data
                [self showHideFields:NO];
                [SingletonClass deleteUnUsedLableFromTable:_tableView];
                dicListData =[MyResults objectForKey:@"attendanceData"];
                [_tableView reloadData];
            }else{
                dicListData = nil;
                [self showHideFields:YES];
                [_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No practice scheduled today":_tableView]];
                [_tableView reloadData];
            }
             [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
        case SaveAttendanceTag:{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Attendance has been saved successfully." delegate:nil btn1:@"Ok"];
            }
             [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
    }
}
#pragma mark Class Utility method Method
-(void)RemoveOldReason:(id)sender{
    SWTableViewCell *cell = (SWTableViewCell *)sender;
    [[dicListData objectAtIndex:cell.tag] setObject:EMPTYSTRING forKey:REASON_ID];
    [[dicListData objectAtIndex:cell.tag] setObject:EMPTYSTRING forKey:REASON_TEXT];
}
-(NSString *)GetReasonId:(NSString *)reason{
    NSDictionary *dicReasonData = ABSENT_REASONS;
    NSString *reasonId = [dicReasonData valueForKey:reason];
    return reasonId ;
}
-(void)ReasonForAbsent:(id)sender{
    SWTableViewCell *cell = (SWTableViewCell *)sender;
    if ([[[dicListData objectAtIndex:cell.tag] objectForKey:REASON_ID] isEqualToString:@""]) {
        AbsentReasonIndex = cell.tag;
        UIPickerView *reasonPicker = [[SingletonClass ShareInstance] AddPickerView:self.view];
        reasonPicker.delegate = self;
        reasonPicker.backgroundColor = [UIColor whiteColor];
        alertViewReason = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        ReasonAlertBG = [[UIView alloc] initWithFrame:CGRectMake(REASON_FIELD_X_Y, 0, (ALERTVIEW_WEIGHT), 80)];
        ReasonAlertBG.tag = ReasonTextField_BG_Tag;
        UITextField *txtFieldReason = [[UITextField alloc] initWithFrame:CGRectMake(REASON_FIELD_X_Y, REASON_FIELD_X_Y, ReasonAlertBG.frame.size.width, 30)];
        txtFieldReason.layer.cornerRadius = CornerRadius;
        txtFieldReason.layer.borderWidth = BORDERWIDTH;
        txtFieldReason.layer.borderColor = BORDERCOLOR;
        txtFieldReason.placeholder = @"Select reason";
        txtFieldReason.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        txtFieldReason.autocorrectionType = UITextAutocapitalizationTypeNone;
        txtFieldReason.inputView = reasonPicker;
        [txtFieldReason becomeFirstResponder];
        UIImage *image;
        image=[UIImage imageNamed:@"arrow.png"];
        UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
        imageview.frame=CGRectMake(txtFieldReason.frame.size.width-40, 5,20, 20);
        [txtFieldReason addSubview:imageview];
        currentTextField = txtFieldReason;
        UITextField *txtFieldOtherReason = [[UITextField alloc] initWithFrame:CGRectMake(REASON_FIELD_X_Y, txtFieldReason.frame.size.height+(REASON_FIELD_X_Y)+5, ALERTVIEW_WEIGHT, txtFieldReason.frame.size.height)];
        txtFieldOtherReason.layer.cornerRadius = CornerRadius;
        txtFieldOtherReason.layer.borderWidth = BORDERWIDTH;
        txtFieldOtherReason.layer.borderColor = BORDERCOLOR;
        txtFieldOtherReason.tag = OtherReasonTextField_Tag;
        txtFieldOtherReason.placeholder = @"Enter other reason";
        txtFieldOtherReason.hidden = YES;
        txtFieldOtherReason.delegate = self;
        txtFieldOtherReason.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
        [ReasonAlertBG addSubview:txtFieldReason];
        [ReasonAlertBG addSubview:txtFieldOtherReason];
        [alertViewReason setValue:ReasonAlertBG forKey:@"accessoryView"];
        [alertViewReason show];
    }
}
-(void)showHideFields:(BOOL)responseStatus{
    UIView *view = [self.view viewWithTag:ATTENDANCE_DRAG_VIEW];
    view.hidden = responseStatus;
    if(responseStatus){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.navigationItem.rightBarButtonItem = ButtonItem;
    }
}
//this method call, when user rotate your device
- (void)orientationChanged{
    [SingletonClass deleteUnUsedLableFromTable:_tableView];
    [_tableView reloadData];
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
- (NSArray *)rightButtons :(NSInteger)btnTag{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:225.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"Tick.png"] :(int)btnTag];
    return rightUtilityButtons;
}
- (NSArray *)leftButton :(NSInteger)btnTag{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:225.0/255.0 alpha:1.0] icon:[UIImage imageNamed:@"UnTick.png"] :(int)btnTag];
    return rightUtilityButtons;
}
#pragma mark UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    if ([textField.placeholder isEqualToString:@"Enter Other reason"]) {
         [[dicListData objectAtIndex:AbsentReasonIndex] setValue:textField.text forKey:REASON_TEXT];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.view endEditing:YES];
    if ([currentTextField.placeholder isEqualToString:@"Enter other reason"]) {
        [[dicListData objectAtIndex:AbsentReasonIndex] setValue:currentTextField.text forKey:REASON_TEXT];
    }
}
@end
