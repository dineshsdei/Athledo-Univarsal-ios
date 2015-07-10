//
//  WorkOutHistory.m
//  Athledo
//
//  Created by Smartdata on 8/25/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//
#import "WorkOutHistory.h"
#import "WorkOutView.h"
#import "DashBoardCell.h"
#import "WorkoutHistoryDetails.h"
#define History_key_season @"Season"
#define History_Placeholder_select_season @"Select Season"
#define History_Placeholder_select_workout_type @"Select Workout Type"
#define History_Placeholder_select_athlete @"Select Athlete"
#define History_key_name @"name"
#define History_key_date KEY_date

#define HISTORYCELL_HEIGHT isIPAD ? 60 :50

@interface WorkOutHistory ()
{
    BOOL isSeasons;
    BOOL isWorkOutType;
    BOOL isAthletes;
    UITextField *currentText;
    NSArray *arrWorkOut;
    NSArray *arrSeasons;
    NSMutableArray *arrAthletes;
    BOOL isKeyBoard;
    WebServiceClass *webservice;
    NSDictionary *DicData;
    NSString *seasonId;
    NSString *workoutId;
    NSString *AthleteId;
    NSMutableArray *arrSearchData;
    BOOL isPicker;
    NSDateFormatter *formater;
    UIToolbar *toolBar;
    UIDeviceOrientation CurrentOrientation;
}
@end
@implementation WorkOutHistory
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark- UIPickerView Delegate method
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (isSeasons) {
        if (currentText.text.length==0) {
            currentText.text=[arrSeasons objectAtIndex:0];
            seasonId=[self KeyForValue:History_key_season:currentText.text];
        }
        return [arrSeasons count];
    }else if (isWorkOutType){
        if (currentText.text.length==0) {
            currentText.text=[arrWorkOut objectAtIndex:0];
            workoutId=[self KeyForValue:KEY_WORKOUT_TYPE:currentText.text];
        }
        return [arrWorkOut count];
    }else if (isAthletes){
        if (currentText.text.length==0) {
            currentText.text=[arrAthletes objectAtIndex:0];
            AthleteId=[self KeyForValue:STR_ATHLETES:currentText.text];
        }
        return [arrAthletes count];
    }else
        return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    if (isWorkOutType) {
        str= [arrWorkOut objectAtIndex:row];
    }else  if (isAthletes){
        str = [arrAthletes objectAtIndex:row];
    }else if (isSeasons){
        str = [arrSeasons objectAtIndex:row];
    }
    NSArray *arr = [str componentsSeparatedByString:KEY_TRIPLE_STAR]; //For State, But will not effect to other
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (isWorkOutType) {
        currentText.text=arrWorkOut.count > row ? [arrWorkOut objectAtIndex:row] : [arrWorkOut objectAtIndex:row-1] ;
        workoutId=[self KeyForValue:KEY_WORKOUT_TYPE:currentText.text];
    }else  if (isAthletes){
        currentText.text=arrAthletes.count > row ? [arrAthletes objectAtIndex:row] : [arrAthletes objectAtIndex:row-1] ;
        AthleteId=[self KeyForValue:STR_ATHLETES:currentText.text];
    }else if (isSeasons){
        currentText.text=arrSeasons.count > row ? [arrSeasons objectAtIndex:row] : [arrSeasons objectAtIndex:row-1] ;
        seasonId=[self KeyForValue:History_key_season:currentText.text];
    }
}
-(IBAction)Workoutlist:(id)sender{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController) {
        if ([object isKindOfClass:[WorkOutView class]]){
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }
    if (Status==FALSE){
        WorkOutView *addNew=[[WorkOutView alloc] init];
        [self.navigationController pushViewController:addNew animated:NO];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLayoutSubviews {
    if (  isPicker==TRUE) {
        listPicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-listPicker.frame.size.height/2);
    }
}
- (void)orientationChanged{
     [SingletonClass deleteUnUsedLableFromTable:tableview];
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        isPicker=FALSE;
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+500):toolBar];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isIPAD){
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}
- (void)viewDidLoad{
    self.title = NSLocalizedString(@"Workout History", nil);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    AthleteId=EMPTYSTRING;
    workoutId=EMPTYSTRING;
    seasonId=EMPTYSTRING;
    
    if (isIPAD) {
        _txtFieldWorkoutType.layer.cornerRadius=5;
        _txtFieldWorkoutType.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
        _txtFieldWorkoutType.leftViewMode = UITextFieldViewModeAlways;
        _txtFieldWorkoutType.layer.borderWidth=.5;
        _txtFieldWorkoutType.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _txtFieldSeason.layer.cornerRadius=5;
        _txtFieldSeason.layer.borderWidth=.5;
        _txtFieldSeason.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _txtFieldSeason.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
        _txtFieldSeason.leftViewMode = UITextFieldViewModeAlways;
        _txtFieldAthlete.layer.borderWidth=.5;
        _txtFieldAthlete.layer.cornerRadius=5;
        _txtFieldAthlete.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _txtFieldAthlete.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
        _txtFieldAthlete.leftViewMode = UITextFieldViewModeAlways;
    }
    isPicker=FALSE;
    formater=[[NSDateFormatter alloc] init];
    [formater setDateFormat:DATE_FORMAT_Y_M_D];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrWorkOut =[[NSArray alloc] init];
    arrSeasons =[[NSArray alloc] init];
    arrSearchData=MUTABLEARRAY;
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216);
    listPicker.tag=listPickerTag;
    listPicker.delegate=self;
    listPicker.dataSource=self;
    listPicker.backgroundColor=[UIColor whiteColor];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = toolBarTag;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil];
    [self getSeasonOrWorkoutOrAthletesData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [tableview addGestureRecognizer:tap];
}
-(void)didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:tableview];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:tapLocation];
    WorkoutHistoryDetails *workoutDetails=[[WorkoutHistoryDetails alloc] init];
    if (arrSearchData.count > 0) {
        workoutDetails.obj=[[[arrSearchData objectAtIndex:indexPath.section] valueForKey:KEY_WORKOUT]copy];
        [self.navigationController pushViewController:workoutDetails animated:YES];
    }
}
-(void)getSeasonOrWorkoutOrAthletesData{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        [SingletonClass addActivityIndicator:self.view];
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [webservice WebserviceCall:webServiceGetWorkOutdropdownList :strURL :getDataTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(NSString *)KeyForValue :(NSString *)superKey :(NSString *)SubKey{
    NSArray *arrValues;
    NSArray *arrkeys;
    [[DicData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ? arrValues=[[DicData objectForKey:superKey] allValues] : EMPTYSTRING;
    [[DicData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ?  arrkeys=[[DicData objectForKey:superKey] allKeys] : EMPTYSTRING;
    
    NSString *strValue=EMPTYSTRING;
    for (int i=0; i<arrValues.count; i++) {
        if ([[arrValues objectAtIndex:i] isEqualToString:SubKey]){
            strValue=[arrkeys objectAtIndex:i];
            break;
        }
    }
    return strValue;
}
-(IBAction)getSearchData{
    isPicker=FALSE;
    [self doneClicked];
    if ([SingletonClass  CheckConnectivity]) {
        [SingletonClass addActivityIndicator:self.view];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"season_id\":\"%@\",\"workout_type_id\":\"%@\",\"user_id\":\"%@\"}",[UserInformation shareInstance].userSelectedTeamid,seasonId,workoutId,AthleteId];
        [webservice WebserviceCall:webUrlSearchHistory :strURL :getSearchDataTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass deleteUnUsedLableFromTable:tableview];
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag){
        case getDataTag:{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                DicData=[MyResults  objectForKey:DATA];
                // check if nsdictionary object then find allvalues otherwise  this EMPTYSTRING statement execute . it do nothing
                [[[MyResults  objectForKey:DATA] objectForKey:KEY_WORKOUT_TYPE] isKindOfClass:[NSDictionary class]] ? arrWorkOut=[[[MyResults  objectForKey:DATA] objectForKey:KEY_WORKOUT_TYPE] allValues] : EMPTYSTRING;
                [[[MyResults  objectForKey:DATA] valueForKey:STR_ATHLETES] isKindOfClass:[NSDictionary class]] ? arrAthletes=[NSMutableArray arrayWithArray:[[[MyResults  objectForKey:DATA] valueForKey:STR_ATHLETES] allValues]] : EMPTYSTRING;
                [[[MyResults  objectForKey:DATA] objectForKey:History_key_season] isKindOfClass:[NSDictionary class]] ?  arrSeasons=[[[MyResults  objectForKey:DATA] objectForKey:History_key_season] allValues] :EMPTYSTRING;
                [arrAthletes addObject:STR_WHOLE_TEAM];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case getSearchDataTag:{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                [SingletonClass deleteUnUsedLableFromTable:self.view];
                [arrSearchData removeAllObjects];
                [arrSearchData addObjectsFromArray:[MyResults  objectForKey:DATA] ];
                if (arrSearchData.count==0) {
                    [tableview addSubview:[SingletonClass ShowEmptyMessage:@"No workout history":tableview]];
                }
                [tableview reloadData];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        default:
            break;
    }
}
-(void)doneClicked{
    // if condition -> for not Lift workout
    isPicker=FALSE;
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50):toolBar];
}
-(void)showPickerSelectedText :(NSArray*)data{
    if (currentText.text.length > 0) {
        for (int i=0; i< data.count; i++) {
            if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                [listPicker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}
#pragma mark- UITextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentText=textField;
    isSeasons=[textField.placeholder isEqualToString:History_Placeholder_select_season] ? YES : NO ;
    isWorkOutType=[textField.placeholder isEqualToString:History_Placeholder_select_workout_type] ? YES : NO ;
    isAthletes=[textField.placeholder isEqualToString:History_Placeholder_select_athlete] ? YES : NO ;
    isPicker=FALSE;
    if (isAthletes) {
        isPicker=TRUE;
        arrAthletes.count > 0 ? EMPTYSTRING:[SingletonClass initWithTitle:EMPTYSTRING message:@"Athletes are not exist" delegate:nil btn1:@"Ok"];
        if (arrAthletes.count==0){
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50):toolBar];
            [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        }else{
            [listPicker reloadAllComponents];
            [self showPickerSelectedText:arrAthletes];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        }
    }else if(isWorkOutType){
        isPicker=TRUE;
        arrWorkOut.count > 0 ? EMPTYSTRING:[SingletonClass initWithTitle:EMPTYSTRING message:@"Workouts are not exist" delegate:nil btn1:@"Ok"];
        if (arrWorkOut.count==0){
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50):toolBar];
            [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        }else{
            [listPicker reloadAllComponents];
            [self showPickerSelectedText:arrWorkOut];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        }
    }else if(isSeasons){
        isPicker=TRUE;
        arrSeasons.count > 0 ? EMPTYSTRING:[SingletonClass initWithTitle:EMPTYSTRING message:@"Seasons data are not exist" delegate:nil btn1:@"Ok"];
        if (arrSeasons.count==0){
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50):toolBar];
            [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        }else{
            [listPicker reloadAllComponents];
            [self showPickerSelectedText:arrSeasons];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        }
    }
    [textField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrSearchData.count;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"HistoryCell";
    static NSString *CellNib = @"HistoryCell";
    HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (HistoryCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        // [cell.contentView setUserInteractionEnabled:NO];
    }
    cell.lblWorkoutName.textColor=[UIColor grayColor];
    cell.lblWorkoutName.font = Textfont;
    if (![[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:KEY_WORKOUT] valueForKey:History_key_name] isKindOfClass:[NSNull class]]) {
        cell.lblWorkoutName.text=[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:KEY_WORKOUT] valueForKey:History_key_name];
    }
    cell.lblWorkoutDate.textColor=[UIColor lightGrayColor];
   cell.lblWorkoutDate.font = SmallTextfont;
    if (![[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:KEY_WORKOUT] valueForKey:History_key_date] isKindOfClass:[NSNull class]]) {
        
        NSDate *date=[formater dateFromString:[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:KEY_WORKOUT] valueForKey:History_key_date]];
        [formater setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
        cell.lblWorkoutDate.text=[formater stringFromDate:date];
        [formater setDateFormat:DATE_FORMAT_Y_M_D];
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HISTORYCELL_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPat{
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
