//
//  WorkOutDetails.m
//  Athledo
//
//  Created by Smartdata on 9/24/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "WorkOutDetails.h"
#import "AddWorkOut.h"
#import "UIImageView+WebCache.h"
#import "WorkOutView.h"
#import "WorkOutDetailCell.h"
#define BTNBOAT_TAG 1000
#define BTNATHLETE_TAG 2000
@interface WorkOutDetails ()
{
    NSMutableArray *arrWorkOuts;
    NSArray *arrTime;
    NSMutableArray *arrNoOfRowInSection;
    CustomTextField *currentText;
    CustomTextField*mytextfiled;
    NSMutableArray *arrAllAthlete;
    NSMutableArray *arrAllAthleteData;
    NSMutableArray *arrAthleteName;
    NSMutableArray *arrAthleteExerciseName;
    NSMutableArray *arrAthleteExerciseSets;
    NSMutableArray *arrAvarageTimeDistance;
    NSMutableArray *arrRateTimeDistanceStatus;
    BOOL isRate,isDistance,isTime,isSplit,isSelectAthlete,isWatts,isHeartRate;
    UIToolbar *toolBar;
    int ViewY;
    int isKeyboard;
    UIDeviceOrientation CurrentOrientation;
    NSMutableArray *arrAvgTotalStatus;
    BOOL isEdit;
}

@end

@implementation WorkOutDetails
#pragma mark webservice delegate method
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    [SingletonClass deleteUnUsedLableFromTable:self.view];
    switch (Tag){
        case deleteWorkoutTag:{
            [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
            
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                // Now we Need to decrypt data
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been deleted successfully" delegate:self btn1:@"Ok" btn2:nil tagNumber:10];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout delete fail try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case ReassignWorkoutTag:{
            [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                // Now we Need to decrypt data
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been reassigned successfully." delegate:nil btn1:@"Ok"];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout reassign fail try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case getDetailDataTag:{
            if (([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT])) {
                
                if ([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]) {
                    [SingletonClass deleteUnUsedLableFromTable:self.view];
                    arrWorkOuts=[[MyResults valueForKey:DATA] valueForKey:KEY_WORKOUTATHLETE];
                    for (int i=0; i< arrWorkOuts.count; i++) {
                        
                        NSArray *tempExercise=[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETEEXERCISE];
                        if (([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) && [[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
                            [arrAllAthlete addObject:[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETENAME]];
                        }
                        for (int j=0; j < tempExercise.count; j++) {
                            [arrAthleteName addObject:[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETENAME]];
                            NSString *str = [[tempExercise objectAtIndex:j] valueForKey:KEY_EXERCISENAME] ?[[tempExercise objectAtIndex:j] valueForKey:KEY_EXERCISENAME]  : EMPTYSTRING;
                            if (str.length==0) {
                                [arrAthleteExerciseName addObject:EMPTYSTRING];
                            }else{
                                [arrAthleteExerciseName addObject:str];
                            }
                        }
                    }
                    if (([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) && [[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
                        //Reload table after select athlete name
                        arrAllAthleteData=[[NSMutableArray alloc] init];
                        arrAllAthleteData=[arrWorkOuts copy];
                    }else{
                        [table reloadData];
                    }
                }else{
                    
                    [scrollView addSubview:[SingletonClass ShowEmptyMessage:@"No workout details":scrollView] ];
                }
            }
            else if (([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL] )){
                if ([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]) {
                     [SingletonClass deleteUnUsedLableFromTable:self.view];
                    arrWorkOuts=[[MyResults valueForKey:DATA] valueForKey:KEY_WORKOUTATHLETE];
                    for (int i=0; i< arrWorkOuts.count; i++) {
                        [self CalculateAVG :i];
                    }
                    [table reloadData];
                }else{
                      [ scrollView addSubview:[SingletonClass ShowEmptyMessage:@"No workout details":scrollView] ];
                }
            }else{
                if ([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]) {
                     [SingletonClass deleteUnUsedLableFromTable:self.view];
                    arrWorkOuts=[[MyResults valueForKey:DATA] valueForKey:KEY_WORKOUTATHLETE];
                    table.delegate=self;
                    table.dataSource=self;
                    [table reloadData];
                }else{
                     [ scrollView addSubview:[SingletonClass ShowEmptyMessage:@"No workout details":scrollView] ];
                }
            }
            break;
        }
        case SaveDataTag:{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                // Now we Need to decrypt data
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout details has been saved successfully" delegate:nil btn1:@"Ok"];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Fail, try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case deleteNotificationTag:{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                // nothing doing here when notification response comes
            }
            break;
        }
    }
}
-(void)GetWorkoutData
{
    if ([SingletonClass  CheckConnectivity]) {
        if (_obj) {
            NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"workout_id\":\"%d\",\"team_id\":\"%d\"}",[UserInformation shareInstance].userId,[UserInformation shareInstance].userType,[[_obj objectForKey:KEY_WORKOUT_ID] intValue],[UserInformation shareInstance].userSelectedTeamid];
            [SingletonClass addActivityIndicator:self.view];
            [webservice WebserviceCall:WebServiceWorkoutDetails :strURL :getDetailDataTag];
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
#pragma mark UIViewController lifecycle method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLayoutSubviews {
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isEdit = YES;
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            isKeyboard=TRUE;
            if (iosVersion < 8) {
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolBar];
                scrollHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolBar];
                scrollHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
            }
        }completion:^(BOOL finished){
        }];
    }];
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            isKeyboard=FALSE;
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height > 310 ? kbSize.width : kbSize.height+22)) :toolBar];
            [self setContentOffsetOfTableDown];
            [scrollView setContentOffset:CGPointMake(0, 0) animated: YES];
        }completion:^(BOOL finished){
        }];
    }];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    // Do any additional setup after loading the view from its nib.
    btnSave.titleLabel.textColor=[UIColor whiteColor];
    isSelectAthlete=FALSE;
    
    self.title =@"Workout Detail";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    _lblCreatedBy.font=Textfont;
    _lblMeOrALl.font=Textfont;
    _lblSeasion.font=Textfont;
    _lblWorkoutDate.font=Textfont;
    _lblWorkOutName.font=Textfont;
    _lblWorkoutType.font=Textfont;
    
    _txtViewDescription.layer.borderWidth=.50;
    _txtViewDescription.layer.cornerRadius=10;
    _txtViewDescription.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _txtViewDescription.font=Textfont;
    ViewY=self.view.frame.origin.y;
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = toolBarTag;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    arrTime=[[NSArray alloc] initWithObjects:@"05",@"10",@"15",@"20",@"30",@"25",@"35",@"40",@"45",@"50",@"55", nil];
    
    arrNoOfRowInSection=[[NSMutableArray alloc] init];
    arrAthleteName=[[NSMutableArray alloc] init];
    arrAthleteExerciseName=[[NSMutableArray alloc] init];
    arrAthleteExerciseSets=[[NSMutableArray alloc] init];
    arrAvarageTimeDistance=[[NSMutableArray alloc] init];
    arrRateTimeDistanceStatus=[[NSMutableArray alloc] init];
    
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216);
    listPicker.tag=listPickerTag;
    listPicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    // if Add button in middle of view , uncomment code below
    
    //CGRect applicationFrame =isIPAD ? CGRectMake(200, 0, 260, 50) : CGRectMake(50, 0, 260, 50);
    // UIView * newView = [[UIView alloc] initWithFrame:applicationFrame] ;
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageDelete=[UIImage imageNamed:@"navDeleteBtn.png"];
    btnDelete.bounds = CGRectMake( 0, 0, imageDelete.size.width, imageDelete.size.height );
    [btnDelete addTarget:self action:@selector(DeleteWorkout:) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setImage:imageDelete forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemDelete = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageEdit=[UIImage imageNamed:@"edit.png"];
    btnEdit.bounds = CGRectMake( 0, 0, imageEdit.size.width, imageEdit.size.height );
    [btnEdit addTarget:self action:@selector(EditWorkout:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemEdit = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    UIButton *btnReassign =[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageReassign=[UIImage imageNamed:@"reassign.png"];
    btnReassign.bounds = CGRectMake( 0, 0, imageReassign.size.width, imageReassign.size.height );
    
    [btnReassign addTarget:self action:@selector(ReassignWorkout:) forControlEvents:UIControlEventTouchUpInside];
    [btnReassign setImage:imageReassign forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemReassign = [[UIBarButtonItem alloc] initWithCustomView:btnReassign];
    arrAvgTotalStatus=[[NSMutableArray alloc] init];
    if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemEdit,BarItemReassign,BarItemDelete,nil];
    }else if ([UserInformation shareInstance].userType == isAthlete && [UserInformation shareInstance].userId == [[_obj  objectForKey:KEY_USER_ID] intValue])
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemEdit,BarItemReassign,BarItemDelete,nil];
    }
    self.navigationItem.rightBarButtonItem.tintColor = NAVIGATION_COMPONENT_COLOR;
    if (_obj) {
        
        [_imgCreatedBy setImageWithURL:[NSURL URLWithString:[_obj valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        _imgCreatedBy.contentMode=UIViewContentModeScaleAspectFit;
        
        _lblCreatedBy.text=[_obj valueForKey:KEY_CREATED_BY];
        _lblWorkOutName.text=[_obj valueForKey:KEY_WORKOUT_NAME];
        _lblSeasion.text=[[_obj valueForKey:KEY_SEASON] isEqualToString:EMPTYSTRING] ? KEY_OFF_SEASON :[_obj valueForKey:KEY_SEASON] ;
        _lblWorkoutType.text=[_obj valueForKey:KEY_WORKOUT_TYPE];
        _lblWorkoutDate.text=[_obj valueForKey:KEY_DATE];
        _txtViewDescription.text=[_obj valueForKey:KEY_DESCRIPTION];
        
        if (([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger)) {
            
            _lblMeOrALl.text=@"to all";
        }else{
            
            _lblMeOrALl.text=@"to me";
        }
        if ([[_obj valueForKey:KEY_ASSIGNED] intValue] == ASSIGNED_TYPE_BOAT) {
            [self showBoatOptions];
        }
        else{
            _boatView.hidden = YES;
        }
    }
    if (([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) && [[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
        
        _tfSelectUserType.hidden=NO;
        _dropdownImageview.hidden=NO;
        arrAllAthlete=[[NSMutableArray alloc] init];
        
    }else{
        
        _tfSelectUserType.hidden=YES;
        _dropdownImageview.hidden=YES;
        
    }
    [self GetWorkoutData];
    scrollHeight=0;
    [self setContentOffsetOfTableDown:currentText table:table];
    
    if (_NotificationStataus) {
        [self DeleteNotificationFromWeb];
    }
    
}
#pragma mark Class Utility Function
-(void)clickEventOfBoatsAthletes:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == BTNBOAT_TAG){
        [btn setSelected:YES];
        [_btnAthletes setSelected:NO];
        isEdit = YES;
         [table reloadData];
    }
    else{
        [btn setSelected:YES];
        [_btnBoats setSelected:NO];
         isEdit = NO;
        [table reloadData];
    }
}
- (IBAction)SaveEvent:(id)sender {
    // if there are no values available or comes from web, then no data to save
    if (arrWorkOuts.count==0) {
        return;
    }
    if ([SingletonClass  CheckConnectivity]) {
        if (_obj) {
            if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]){
                [SingletonClass addActivityIndicator:self.view];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                [dict setObject:arrWorkOuts forKey:@"KEY_WORKOUTATHLETELift"];
                [webservice WebserviceCallwithDic:dict :webServiceSaveWorkOutDetails :SaveDataTag];
            }else{
                [SingletonClass addActivityIndicator:self.view];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                [dict setObject:arrWorkOuts forKey:KEY_WORKOUTATHLETE];
                [webservice WebserviceCallwithDic:dict :webServiceSaveWorkOutDetails :SaveDataTag];
            }
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}

-(void)doneClicked
{
    [self setContentOffsetOfTableDown];
    [[[UIApplication sharedApplication] keyWindow ] endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated: YES];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+350) :toolBar];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
    if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL])
    {
        for (int i=0; i< arrWorkOuts.count; i++) {
            [self CalculateAVG :i];
        }
        [table reloadData];
    }
}
+ (void)setContentOffsetOfScrollView:(id)textField table:(UIScrollView*)m_TableView {
    
    UIDeviceOrientation orientation=[SingletonClass getOrientation];
    int moveUp= (([[UIScreen mainScreen] bounds].size.height >= 568)?((orientation==UIDeviceOrientationLandscapeRight || orientation==UIDeviceOrientationLandscapeLeft)? 150 : 50):130);
    if (moveUp) {
        [m_TableView setContentOffset:CGPointMake(0, moveUp) animated: YES];
    }
}
-(void)setContentOffsetOfTableDown {
    int moveUp= (([[UIScreen mainScreen] bounds].size.height >= 568)?50:130);
    if (moveUp) {
        [table setContentOffset:CGPointMake(0, 0) animated: YES];
    }
}
- (void)setContentOffsetOfTableDown:(id)textField table:(UITableView*)m_TableView {
    
    UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
    NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
    if (scrollHeight==0) {
        scrollHeight=216;
    }
    CGSize keyboardSize = CGSizeMake(310,scrollHeight+70);
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    m_TableView.contentInset = contentInsets;
    m_TableView.scrollIndicatorInsets = contentInsets;
    [m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)UpdateCelldata
{
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:currentText.SectionIndex] valueForKey:KEY_UNITS];
    NSString*strPlaceholder=EMPTYSTRING;
    NSString *myString = currentText.placeholder;
    NSRange startRange = [myString rangeOfString:@"("];
    NSRange endRange = [myString rangeOfString:@")"];
    if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
        strPlaceholder = [myString substringWithRange:NSMakeRange(0,(startRange.location)-1)];
    }
    if ([strPlaceholder isEqualToString:KEY_DISTANCE]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrTemp.count inSection:currentText.SectionIndex];
        WorkOutDetailCell *cell=(WorkOutDetailCell *)[table cellForRowAtIndexPath:indexPath];
        CustomTextField *textfield=(CustomTextField *)[cell viewWithTag:1002];
        textfield.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
    }else  if ([strPlaceholder isEqualToString:KEY_TIME]) {
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:arrTemp.count+1 inSection:currentText.SectionIndex];
        WorkOutDetailCell *cell=(WorkOutDetailCell *)[table cellForRowAtIndexPath:indexPath1];
        CustomTextField *textfield=(CustomTextField *)[cell viewWithTag:1002];
        textfield.text=[[arrAvarageTimeDistance objectAtIndex:indexPath1.section] valueForKey:@"AVG_TIME"];
    }else  if ([myString isEqualToString:UNIT_RATE]) {
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:arrTemp.count+2 inSection:currentText.SectionIndex];
        WorkOutDetailCell *cell=(WorkOutDetailCell *)[table cellForRowAtIndexPath:indexPath2];
        CustomTextField *textfield=(CustomTextField *)[cell viewWithTag:1002];
        textfield.text=[[arrAvarageTimeDistance objectAtIndex:indexPath2.section] valueForKey:@"AVG_RATE"];
    }
}
-(void)updateLiftValue :(int)AthleteIndex :(NSString *)value : (int)rowindex : (int)sectionindex :(id)textField
{
    if (value ==nil) {
        return;
    }
    UITextField *txtfield=(UITextField *)textField;
    if ([txtfield.placeholder isEqualToString:STR_WEIGHT]) {
        [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:KEY_ATHLETEEXERCISE] objectAtIndex:sectionindex] valueForKey:@"exerciseDetail"] objectAtIndex:rowindex]setValue:value forKey:@"weight_value"];
    }else if ([txtfield.placeholder isEqualToString:@"Repetitions"]){
        [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:KEY_ATHLETEEXERCISE] objectAtIndex:sectionindex] valueForKey:@"exerciseDetail"] objectAtIndex:rowindex]setValue:value forKey:@"rep_value"];
    }
}
-(BOOL)CheckStatus :(NSString *)StrValues :(long)section
{
    if (StrValues ==nil) {
        return NO;
    }
    BOOL status=false;
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:section] valueForKey:KEY_UNITS];
    for (int i=0; i < arrTemp.count ; i++) {
        NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:i] allKeys];
        NSString *unitKey=EMPTYSTRING;
        unitKey= arrUnitKeys.count > 2 ? [arrUnitKeys objectAtIndex:2] : EMPTYSTRING;
        NSString *value;
        NSString *myString = unitKey;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(0,startRange.location)];
            value=[value stringByReplacingOccurrencesOfString:@" " withString:EMPTYSTRING];
        }
        if ([StrValues isEqualToString:UNIT_RATE] &&[myString isEqualToString:StrValues ] )
        {
            status=TRUE;
            return TRUE;
        }else if ([value isEqualToString:StrValues] ) {
            status=TRUE;
            return TRUE;
        }
    }
    return status;
}
-(int)CheckTimeDestanceRateExist:(long)section
{
    int count=0;
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:section] valueForKey:KEY_UNITS];
    count=(int)arrTemp.count;
    for (int i=0; i < arrTemp.count ; i++) {
        NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:i] allKeys];
        NSString *unitKey=EMPTYSTRING;
        unitKey=[arrUnitKeys objectAtIndex:2];
        NSString *value;
        NSString *myString = unitKey;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(0,startRange.location)];
            value=[value stringByReplacingOccurrencesOfString:@" " withString:EMPTYSTRING];
        }
        if (([value isEqualToString:KEY_TIME] ) && isTime==FALSE) {
            count=count+1;
            isTime=TRUE;
        }else  if ([value isEqualToString:KEY_DISTANCE] && isDistance==FALSE) {
            count=count+1;
            isDistance=TRUE;
        }else  if ([myString isEqualToString:UNIT_RATE] && isRate==FALSE) {
            count=count+1;
            isRate=TRUE;
        }else  if ([value isEqualToString:@"Split"] && isSplit==FALSE) {
            count=count+1;
            isSplit=TRUE;
        }else  if ([myString isEqualToString:UNIT_WATTS] && isWatts==FALSE) {
            count=count+1;
            isWatts=TRUE;
        }else  if ([myString isEqualToString:UNIT_HEARTRATE] && isHeartRate==FALSE) {
            count=count+1;
            isHeartRate=TRUE;
        }
    }
    return count;
}
-(void)CalculateAVG:(int)section
{
    float TotalDistance;
    float DistanceAVG;
    int DistanceCount;
    int TimeCount;
    
    float TotalRate=0;
    float RateAVG=0;
    int RateCount=0;
    
    float TotalHeartRate=0;
    float HeartRateAVG=0;
    int HeartRateCount=0;
    
    float TotalWatts=0;
    float WattsAVG=0;
    int WattsCount=0;
    
    NSString *TotalTime;
    NSString *TimeAVG;
    NSMutableArray *arrTotalTimeComponenet=[[NSMutableArray alloc] init];
    [arrTotalTimeComponenet removeAllObjects];
    [arrTotalTimeComponenet addObjectsFromArray:@[@"0",@"0",@"0",@"0"]];
    TotalTime=@"00:00:00:000";
    TimeAVG=@"00:00:00:000";
    DistanceAVG=0;
    TimeCount=0;
    DistanceCount=0;
    TotalDistance=0;
    int splitTimeCount=0;
    NSString *SplitTimeAVG=@"00:00:0";
    NSMutableArray *arrTotalSplitTimeComponenet=[[NSMutableArray alloc] init];
    [arrTotalSplitTimeComponenet removeAllObjects];
    [arrTotalSplitTimeComponenet addObjectsFromArray:@[@"0",@"0",@"0"]];
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:section] valueForKey:KEY_UNITS];
    for (int i=0; i < arrTemp.count ; i++) {
        NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:i] allKeys];
        NSString *unitKey=EMPTYSTRING;
        NSString *strTemp= arrUnitKeys.count > 2 ? [arrUnitKeys objectAtIndex:2] : EMPTYSTRING;
        unitKey=strTemp;
        NSString *values=[[[[arrWorkOuts objectAtIndex:section] valueForKey:KEY_UNITS] objectAtIndex:i] valueForKey:unitKey];
        NSString *value;
        NSString *myString = unitKey;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(startRange.location+1,(endRange.location - startRange.location)-1)];
        }
        if ([value isEqualToString:UNIT_METERS]) {
            TotalDistance=TotalDistance+[values intValue];
            DistanceCount++;
        }else if ([myString isEqualToString:UNIT_RATE]){
            TotalRate=TotalRate+([values intValue]);
            RateCount++;
            RateAVG=TotalRate/RateCount;
        }else if ([myString isEqualToString:UNIT_HEARTRATE]){
            TotalHeartRate=TotalHeartRate+([values intValue]);
            HeartRateCount++;
            HeartRateAVG=TotalHeartRate/HeartRateCount;
        }else if ([myString isEqualToString:UNIT_WATTS]){
            TotalWatts=TotalWatts+([values intValue]);
            WattsCount++;
            WattsAVG=TotalWatts/WattsCount;
        }else if ([value isEqualToString:UNIT_KILOMETERS]){
            TotalDistance=TotalDistance+([values intValue]*1000);
            DistanceCount++;
        }else if ([value isEqualToString:UNIT_MILES]){
            TotalDistance=TotalDistance+([values intValue]*1609.34);
            DistanceCount++;
        }else if ([value isEqualToString:UNIT_HH_MM_SS_SSS]){
            TimeCount=TimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            for (int i=0; i< TimeComponents.count; i++) {
                [arrTotalTimeComponenet replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", ([[arrTotalTimeComponenet objectAtIndex:i] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
        }else if ([value isEqualToString:UNIT_MM_SS_SSS]){
            TimeCount=TimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            for (int i=0; i< TimeComponents.count; i++) {
                int j=i+1;
                [arrTotalTimeComponenet replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d", ([[arrTotalTimeComponenet objectAtIndex:j] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
        }else if ([value isEqualToString:UNIT_SS_SSS]){
            TimeCount=TimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            for (int i=0; i< TimeComponents.count; i++) {
                int j=i+2;
                [arrTotalTimeComponenet replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d", ([[arrTotalTimeComponenet objectAtIndex:j] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
        }else if ([value isEqualToString:UNIT_MM_SS_S]){
            splitTimeCount=splitTimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            for (int i=0; i< TimeComponents.count; i++) {
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", ([[arrTotalSplitTimeComponenet objectAtIndex:i] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
        }
        if (TotalDistance > 0 && DistanceCount > 0) {
            DistanceAVG=TotalDistance/DistanceCount;
        }
        if (TotalTime > 0 &&  TimeCount > 0) {
            int ss=0,mm=0,sss=0,hh=0;
            sss=[[arrTotalTimeComponenet objectAtIndex:3] intValue]/TimeCount;
            if (sss > 1000) {
                sss=sss % 1000;
                ss=sss / 1000;
            }
            ss=[[arrTotalTimeComponenet objectAtIndex:2] intValue]/TimeCount;
            if (ss > 60) {
                ss=ss % 60;
                mm=mm / 60;
            }
            mm=[[arrTotalTimeComponenet objectAtIndex:1] intValue]/TimeCount;
            if (mm > 60) {
                mm=mm % 60;
                hh=mm / 60;
            }
            NSString *hh_temp = [NSString stringWithFormat:@"%d",hh];
            hh_temp = hh_temp.length == 1 ? [NSString stringWithFormat:@"0%d",hh] :[NSString stringWithFormat:@"%d",hh] ;
            
            NSString *mm_temp = [NSString stringWithFormat:@"%d",mm];
            mm_temp = mm_temp.length == 1 ? [NSString stringWithFormat:@"0%d",mm] :[NSString stringWithFormat:@"%d",mm] ;
            
            NSString *ss_temp = [NSString stringWithFormat:@"%d",ss];
            ss_temp = ss_temp.length == 1 ? [NSString stringWithFormat:@"0%d",ss] :[NSString stringWithFormat:@"%d",ss] ;
            TimeAVG=[NSString stringWithFormat:@"%@:%@:%@:%d", hh_temp,mm_temp,ss_temp,sss ];
        }
        if (splitTimeCount > 0) {
            int ss=00,mm=00,S=0;
            S=[[arrTotalSplitTimeComponenet objectAtIndex:2] intValue];
            if (S > 1000) {
                int  STemp=S%1000;
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",STemp]];
                ss=ss + (S / 1000);
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",ss+([[arrTotalSplitTimeComponenet objectAtIndex:1] intValue])]];
            }
            ss=[[arrTotalSplitTimeComponenet objectAtIndex:1] intValue];
            if (ss > 60) {
                int ssTemp=ss%60;
                NSString *str_temp = [NSString stringWithFormat:@"%d",ssTemp];
                str_temp = str_temp.length == 1 ? [NSString stringWithFormat:@"0%d",ssTemp] :[NSString stringWithFormat:@"%d",ssTemp] ;
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:1 withObject:str_temp];
                mm=mm+(ss/60);
                int mValue=[[arrTotalSplitTimeComponenet objectAtIndex:0] intValue];
                NSString *mm_temp = [NSString stringWithFormat:@"%d",mm];
                mm_temp = mm_temp.length == 1 ? [NSString stringWithFormat:@"0%d",mm] :[NSString stringWithFormat:@"%d",mm] ;
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",([mm_temp intValue])+(mValue)]];
            }
            mm=[[arrTotalSplitTimeComponenet objectAtIndex:0] intValue];
            int avgMM=([[arrTotalSplitTimeComponenet objectAtIndex:0] intValue]/splitTimeCount);
            int temp=([[arrTotalSplitTimeComponenet objectAtIndex:0] intValue]%splitTimeCount);
            int avSS=((temp*60)+[[arrTotalSplitTimeComponenet objectAtIndex:1] intValue])/splitTimeCount;
            int temp1=([[arrTotalSplitTimeComponenet objectAtIndex:1] intValue]%splitTimeCount);
            int avS=((temp1*1000)+[[arrTotalSplitTimeComponenet objectAtIndex:2] intValue])/splitTimeCount;
            
            NSString *avgMM_temp = [NSString stringWithFormat:@"%d",avgMM];
            avgMM_temp = avgMM_temp.length == 1 ? [NSString stringWithFormat:@"0%@",avgMM_temp] :[NSString stringWithFormat:@"%@",avgMM_temp] ;
            
            NSString *avSS_temp = [NSString stringWithFormat:@"%d",avSS];
            avSS_temp = avSS_temp.length == 1 ? [NSString stringWithFormat:@"0%@",avSS_temp] :[NSString stringWithFormat:@"%@",avSS_temp] ;
            
            SplitTimeAVG=[NSString stringWithFormat:@"%@:%@.%@", avgMM_temp,avSS_temp,[[NSString stringWithFormat:@"%d" ,avS ] substringWithRange:NSMakeRange(0,1)] ];
        }
    }
    NSString *hh_TotalTime =  [NSString stringWithFormat:@"%@",arrTotalTimeComponenet.count > 0 ?[arrTotalTimeComponenet objectAtIndex:0] : EMPTYSTRING];    hh_TotalTime = hh_TotalTime.length == 1 ? [NSString stringWithFormat:@"0%@",hh_TotalTime] :[NSString stringWithFormat:@"%@",hh_TotalTime] ;
    
    NSString *mm_TotalTime =  [NSString stringWithFormat:@"%@",arrTotalTimeComponenet.count > 1 ?[arrTotalTimeComponenet objectAtIndex:1] : EMPTYSTRING];
    mm_TotalTime = mm_TotalTime.length == 1 ? [NSString stringWithFormat:@"0%@",mm_TotalTime] :[NSString stringWithFormat:@"%@",mm_TotalTime] ;
    
    NSString *ss_TotalTime = [NSString stringWithFormat:@"%@",arrTotalTimeComponenet.count > 2 ?[arrTotalTimeComponenet objectAtIndex:2] : EMPTYSTRING];
    ss_TotalTime = ss_TotalTime.length == 1 ? [NSString stringWithFormat:@"0%@",ss_TotalTime] :[NSString stringWithFormat:@"%@",ss_TotalTime] ;
    
    NSString *sss_TotalTime = [NSString stringWithFormat:@"%@",arrTotalTimeComponenet.count > 3 ?[arrTotalTimeComponenet objectAtIndex:3] : EMPTYSTRING];
    
    NSDictionary *dicTemp=[[NSDictionary alloc] initWithObjectsAndKeys:TimeAVG,@"AVG_TIME",[NSString stringWithFormat:@"%@:%@:%@.%@", hh_TotalTime,mm_TotalTime,ss_TotalTime,sss_TotalTime],@"TOTAL_TIME",[NSString stringWithFormat:@"%f", DistanceAVG ],@"AVG_DISTANCE",[NSString stringWithFormat:@"%f", TotalDistance ],@"TOTAL_DISTANCE",[NSString stringWithFormat:@"%f", HeartRateAVG ],@"AVG_HEARTRATE",[NSString stringWithFormat:@"%f", TotalHeartRate ],@"TOTAL_HEARTRATE",[NSString stringWithFormat:@"%f",WattsAVG],@"AVG_WATTS",[NSString stringWithFormat:@"%f", TotalWatts ],@"TOTAL_WATTS",[NSString stringWithFormat:@"%f", RateAVG ],@"AVG_RATE",[NSString stringWithFormat:@"%f", TotalRate ],@"TOTAL_RATE",[NSString stringWithFormat:@"%@", SplitTimeAVG ],@"AVG_SPLIT",[NSString stringWithFormat:@"%@:%@.%@", [arrTotalSplitTimeComponenet objectAtIndex:0],[arrTotalSplitTimeComponenet objectAtIndex:1],[arrTotalSplitTimeComponenet objectAtIndex:2] ],@"TOTAL_SPLIT", nil];
    if (arrAvarageTimeDistance.count > section) {
        [arrAvarageTimeDistance replaceObjectAtIndex:section withObject: dicTemp ];
    }else{
        [arrAvarageTimeDistance addObject:dicTemp ];
    }
    dicTemp=nil;
    arrTotalTimeComponenet=nil;
}
-(void)updateValue :(NSString *)Key :(NSString *)value : (int)rowindex : (int)sectionindex{
    if (((Key == nil) || (value ==nil))) {
        return;
    }
    if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]){
        
        [[[[arrWorkOuts objectAtIndex:sectionindex] valueForKey:KEY_UNITS] objectAtIndex:rowindex] setValue:value forKey:Key];
    }else  if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL]){
        [[[[arrWorkOuts objectAtIndex:sectionindex] valueForKey:KEY_UNITS] objectAtIndex:rowindex] setValue:value forKey:Key];
    }else{
        if (rowindex == 0 || rowindex==1) {
            [[arrWorkOuts objectAtIndex:sectionindex] setValue:value forKey:Key];
        }else{
            [[[[arrWorkOuts objectAtIndex:sectionindex] valueForKey:KEY_UNITS] objectAtIndex:rowindex-2] setValue:value forKey:Key];
        }
    }
}
-(void)showPickerSeleted :(NSArray *)data{
    if (currentText.text.length > 0) {
        for (int i=0; i< data.count; i++) {
            if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                [listPicker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}
- (void)orientationChanged{
    [SingletonClass deleteUnUsedLableFromTable:self.view];
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+550) :toolBar];
    }
}
-(void)showBoatOptions
{
    if ([[_obj valueForKey:STR_WORKOUTTYPE] isEqualToString:WORKOUTTYPE_CARDIO] || [[_obj valueForKey:STR_WORKOUTTYPE] isEqualToString:WORKOUTTYPE_INTERVAL] || [[_obj valueForKey:STR_WORKOUTTYPE] isEqualToString:WORKOUTTYPE_OHTER]) {
        
        _boatView.hidden = NO;
        _btnAthletes.tag = BTNATHLETE_TAG;
        _btnBoats.tag = BTNBOAT_TAG;
        [_btnAthletes setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        [_btnAthletes setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateSelected];
        [_btnBoats setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        [_btnBoats setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateSelected];
        [_btnBoats addTarget:self action:@selector(clickEventOfBoatsAthletes:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAthletes addTarget:self action:@selector(clickEventOfBoatsAthletes:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBoats setSelected:YES];
    }else{
        _boatView.hidden = YES;
    }

}
-(void)FilterDataAccourdingAthlete:(NSString *)athleteName{
    @try {
        
        if (arrAthleteName.count > 0) {
            [arrAthleteName removeAllObjects];
        }
        if (arrAthleteExerciseName.count > 0) {
            [arrAthleteExerciseName removeAllObjects];
        }
        if (arrWorkOuts.count > 0) {
            [arrWorkOuts removeAllObjects];
        }
        
        for (int i=0; i< arrAllAthleteData.count; i++) {
            
            if ([[[arrAllAthleteData objectAtIndex:i] valueForKey:KEY_ATHLETENAME] isEqualToString:athleteName]) {
                NSArray *tempExercise=[[arrAllAthleteData objectAtIndex:i] valueForKey:KEY_ATHLETEEXERCISE];
                for (int j=0; j < tempExercise.count; j++) {
                    
                    [arrAthleteName containsObject:athleteName] ? :[arrAthleteName addObject:athleteName];
                    [arrAthleteExerciseName containsObject:[[tempExercise objectAtIndex:j] valueForKey:KEY_EXERCISENAME]] ? :[arrAthleteExerciseName addObject:[[tempExercise objectAtIndex:j] valueForKey:KEY_EXERCISENAME]];
                    [arrWorkOuts containsObject:[arrAllAthleteData objectAtIndex:i]] ? : [arrWorkOuts addObject:[arrAllAthleteData objectAtIndex:i]];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    [table reloadData];
}

-(void)DeleteWorkout:(id)sender{
    [SingletonClass initWithTitle:EMPTYSTRING message: @"Do you want to delete workout?" delegate:self btn1:@"No" btn2:@"Yes" tagNumber:1];
}
-(void)DeleteFromWeb{
    if ([SingletonClass  CheckConnectivity]) {
        if (_obj) {
            NSString *strURL = [NSString stringWithFormat:@"{\"workout_id\":\"%d\"}",[[_obj objectForKey:KEY_WORKOUT_ID] intValue]];
            [SingletonClass addActivityIndicator:self.view];
            [webservice WebserviceCall:webServiceDeleteWorkOut :strURL :deleteWorkoutTag];
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)DeleteNotificationFromWeb{
    //NOTE ---  type=(1=>announcement, 2=>event, 3=>workout)
    if ([SingletonClass  CheckConnectivity]) {
        if (_obj) {
            UserInformation *userInfo= [UserInformation shareInstance];
            NSString *strURL = [NSString stringWithFormat:@"{\"type\":\"%d\",\"parent_id\":\"%d\",\"team_id\":\"%d\",\"user_id\":\"%d\"}",3,[[_obj objectForKey:KEY_WORKOUT_ID] intValue],userInfo.userSelectedTeamid,userInfo.userId];
            [webservice WebserviceCall:webServiceDeleteNotification :strURL :deleteNotificationTag];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag==1) {
        [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
        [self DeleteFromWeb];
        
    }else  if (buttonIndex == 0 && alertView.tag==10){
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController){
            if ([object isKindOfClass:[WorkOutView class]]){
                Status=TRUE;
                [self.navigationController popToViewController:object animated:NO];
            }
        }
        if (Status==FALSE){
            WorkOutView *annView=[[WorkOutView alloc] init];
            [self.navigationController pushViewController:annView animated:NO];
        }
    }
}
-(void)EditWorkout:(id)sender{
    if (_obj) {
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController){
            if ([object isKindOfClass:[CalendarEvent class]]){
                Status=TRUE;
                AddWorkOut *edit=(AddWorkOut *)object;
                edit.objEditModeData=_obj;
                [self.navigationController popToViewController:edit animated:NO];
            }
        }
        if (Status==FALSE){
            AddWorkOut *edit=[[AddWorkOut alloc] initWithNibName:@"AddWorkOut" bundle:nil];
            edit.objEditModeData=_obj;
            [self.navigationController pushViewController:edit animated:NO];
        }
    }
}
-(void)ReassignWorkout:(id)sender{
    if ([SingletonClass  CheckConnectivity]) {
        if (_obj) {
            UserInformation *userInfo= [UserInformation shareInstance];
            NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"workout_id\":\"%d\",\"sport_id\":\"%d\",\"user_id\":\"%d\"}",userInfo.userSelectedTeamid,[[_obj objectForKey:KEY_WORKOUT_ID] intValue],userInfo.userSelectedSportid,[[_obj objectForKey:KEY_USER_ID] intValue]];
            [SingletonClass addActivityIndicator:self.view];
            [webservice WebserviceCall:webServiceReAssignWorkOut :strURL :ReassignWorkoutTag];
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    int noOfSection=0;
    if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
        // NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
        for (int i=0; i< arrWorkOuts.count; i++) {
            NSArray *AthleteExercise=  [[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETEEXERCISE] ;
            for (int j=0; j < AthleteExercise.count; j++) {
                NSArray *AthleteExerciseDetails=  [[AthleteExercise objectAtIndex:j]  valueForKey:@"exerciseDetail"];
                [arrNoOfRowInSection addObject:[NSString stringWithFormat:@"%lu",(unsigned long)AthleteExerciseDetails.count]];
            }
            noOfSection=(int)(noOfSection+AthleteExercise.count);
        }
        return noOfSection;
        
    }else if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL]) {
        return arrWorkOuts.count;
    }
    else{
        return arrWorkOuts.count;
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
        return [[arrNoOfRowInSection objectAtIndex:section] intValue];
    }else if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL]){
        isDistance=FALSE;
        isTime=FALSE;
        isRate=FALSE;
        isSplit=FALSE;
        isWatts = FALSE;
        isHeartRate = FALSE;
        
        NSArray *units=[[arrWorkOuts objectAtIndex:section] valueForKey:KEY_UNITS];
        [self CheckTimeDestanceRateExist:section];
        int increaseCount=0;
        if (isDistance) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:isDistance],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]] forKeys:@[KEY_DISTANCE,KEY_TIME,@"Split",UNIT_RATE,UNIT_WATTS,UNIT_HEARTRATE]];
            
            [arrAvgTotalStatus addObject:temp];
            [arrAvgTotalStatus addObject:temp];
            temp=nil;
            increaseCount = increaseCount+2;
        }
        if (isTime) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[NSNumber numberWithBool:isTime],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]] forKeys:@[KEY_DISTANCE,KEY_TIME,@"Split",UNIT_RATE,UNIT_WATTS,UNIT_HEARTRATE]];
            [arrAvgTotalStatus addObject:temp];
            [arrAvgTotalStatus addObject:temp];
            temp=nil;
            increaseCount = increaseCount+2;
        }
        if (isRate) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:isRate],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]] forKeys:@[KEY_DISTANCE,KEY_TIME,@"Split",UNIT_RATE,UNIT_WATTS,UNIT_HEARTRATE]];
            [arrAvgTotalStatus addObject:temp];
            [arrAvgTotalStatus addObject:temp];
            temp=nil;
            increaseCount = increaseCount+2;
        }
        if (isHeartRate) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:isHeartRate]] forKeys:@[KEY_DISTANCE,KEY_TIME,@"Split",UNIT_RATE,UNIT_WATTS,UNIT_HEARTRATE]];
            [arrAvgTotalStatus addObject:temp];
            [arrAvgTotalStatus addObject:temp];
            temp=nil;
            increaseCount = increaseCount+2;
        }
        if (isWatts) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:isWatts],[NSNumber numberWithBool:NO]] forKeys:@[KEY_DISTANCE,KEY_TIME,@"Split",UNIT_RATE,UNIT_WATTS,UNIT_HEARTRATE]];
            
            [arrAvgTotalStatus addObject:temp];
            [arrAvgTotalStatus addObject:temp];
            temp=nil;
            increaseCount = increaseCount+2;
        }
        if (isSplit) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:isSplit],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]] forKeys:@[KEY_DISTANCE,KEY_TIME,@"Split",UNIT_RATE,UNIT_WATTS,UNIT_HEARTRATE]];
            
            [arrAvgTotalStatus addObject:temp];
            //[arrAvgTotalStatus addObject:temp];
            temp=nil;
            increaseCount = increaseCount+1;
        }
        return units.count+increaseCount;
    }
    else{
        NSArray *units=[[arrWorkOuts objectAtIndex:section] valueForKey:KEY_UNITS];
        return units.count+2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    @try {
        if (cell == nil) {
            cell=[[WorkOutDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier indexPath:indexPath delegate:self WorkOutType:[_obj valueForKey:KEY_WORKOUT_TYPE]:0];
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            cell.userInteractionEnabled = isEdit;
        }
        if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
            CustomTextField *txtFieldRepitition=(CustomTextField *)[cell viewWithTag:1001];
            CustomTextField *txtFieldWeight=(CustomTextField *)[cell viewWithTag:1002];
            UILabel *lblExerciseName=(UILabel *)[cell viewWithTag:1003];
            UILabel *lblSets=(UILabel *)[cell viewWithTag:1004];
            txtFieldRepitition.textColor=[UIColor darkGrayColor];
            
            int AthleteIndex=0;
            int AthleteExerciseIndex=0;
            // Code for set Athlete index
            NSString *athleteName=EMPTYSTRING;
            NSString *athleteExerciseName=EMPTYSTRING;
            athleteName=[arrAthleteName objectAtIndex:indexPath.section];
            athleteExerciseName=[arrAthleteExerciseName objectAtIndex:indexPath.section] ? [arrAthleteExerciseName objectAtIndex:indexPath.section]: EMPTYSTRING;
            for (int i=0; i< arrWorkOuts.count; i++) {
                if ([[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETENAME] isEqualToString:athleteName]) {
                    AthleteIndex=i;
                    break;
                }
            }
            // Code for set Athlete exercise index which is matches with Athlete name
            for (int i=0; i< arrWorkOuts.count; i++) {
                NSArray *tempExercise=[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETEEXERCISE];
                for (int j=0; j < tempExercise.count; j++){
                    [arrAthleteName addObject:[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETENAME]];
                    if ([[[tempExercise objectAtIndex:j] valueForKey:KEY_EXERCISENAME] isEqualToString:athleteExerciseName] && [[[arrWorkOuts objectAtIndex:i] valueForKey:KEY_ATHLETENAME] isEqualToString:athleteName] ){
                        AthleteExerciseIndex = j;
                        break;
                    }
                }
            }
            txtFieldWeight.liftAthleteIndex=AthleteIndex;
            txtFieldRepitition.liftAthleteIndex=AthleteIndex;
            txtFieldWeight.liftExerciseIndex=AthleteExerciseIndex;
            txtFieldRepitition.liftExerciseIndex=AthleteExerciseIndex;
            txtFieldWeight.SectionIndex=(int)indexPath.section;
            txtFieldWeight.RowIndex=(int)indexPath.row;
            txtFieldRepitition.SectionIndex=(int)indexPath.section;
            txtFieldRepitition.RowIndex=(int)indexPath.row;
            txtFieldRepitition.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repetitions" attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor] ,NSFontAttributeName :WorkOutDetailFont}];
            txtFieldRepitition.textAlignment=NSTextAlignmentCenter;
            txtFieldWeight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:STR_WEIGHT attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor] ,NSFontAttributeName :WorkOutDetailFont}];
            txtFieldWeight.text=  [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:KEY_ATHLETEEXERCISE] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"weight_value"]?[[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:KEY_ATHLETEEXERCISE] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"weight_value"] :EMPTYSTRING;
            
            txtFieldWeight.textAlignment=NSTextAlignmentCenter;
            txtFieldRepitition.text=  [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:KEY_ATHLETEEXERCISE] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"rep_value"] ? [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:KEY_ATHLETEEXERCISE] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"rep_value"] : EMPTYSTRING;
            
            if (indexPath.row==0) {
                lblExerciseName.text=STR_SETS;
            }
            else{
                lblExerciseName.text=EMPTYSTRING;
            }
            lblSets.text=[NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        }
        else  if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL]){
            CustomTextField *txtFieldLeftHeader=(CustomTextField *)[cell viewWithTag:1001];
            CustomTextField *txtField=(CustomTextField *)[cell viewWithTag:1002];
            txtField.borderStyle=UITextBorderStyleRoundedRect;
            txtField.userInteractionEnabled=YES;
            txtField.textAlignment=NSTextAlignmentCenter;
            
            txtField.SectionIndex=(int)indexPath.section;
            txtField.RowIndex=(int)indexPath.row;
            
            NSArray *arrTemp=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:KEY_UNITS];
            
            if (arrTemp.count > indexPath.row){
                NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:indexPath.row] allKeys];
                NSString *unitKey=EMPTYSTRING;
                if(arrUnitKeys.count > 2){
                    unitKey=[arrUnitKeys objectAtIndex:2];
                    NSString *str=[NSString stringWithFormat:@"%@", [[[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:KEY_UNITS] objectAtIndex:indexPath.row] valueForKey:KEY_INTERVAL_COUNT] ];
                    str=[str stringByAppendingString:[NSString stringWithFormat:@" %@",unitKey]];
                    
                    txtFieldLeftHeader.text=str;
                    txtFieldLeftHeader.textColor=[UIColor darkGrayColor];
                    txtField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:unitKey attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName : WorkOutDetailFont}];
                    txtField.text=[[[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:KEY_UNITS] objectAtIndex:indexPath.row] valueForKey:unitKey];
                    txtField=nil;
                    txtFieldLeftHeader=nil;
                }
            }else{
                
                NSArray *units=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:KEY_UNITS];
                if (indexPath.row==units.count+0) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:0];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ((indexPath.row==units.count+1) ) {
                    
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:1];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                        
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else   if ((indexPath.row==units.count+2) ) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:2];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                      txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+3) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:3];
                    
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                       txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                  }
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                       txtFieldLeftHeader.text=@"Average Rate";
                       txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                  }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count + 4 ) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:4];
                  if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                       txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                  }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+5 ) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:5];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font= WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                        
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                        
                    }
                }
                else if ( indexPath.row==units.count+6 ) {
                    
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:6];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+7) {
                    
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:7];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+8 ) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:8];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                   
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+9) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:9];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                   
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+10 ) {
                    
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:10];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+11) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:11];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                }
                else if ( indexPath.row==units.count+12 ) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:6];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled=NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Total Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"TOTAL_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S))";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                }
                else if ( indexPath.row==units.count+13) {
                    NSDictionary *tempdic=[arrAvgTotalStatus objectAtIndex:7];
                    if ([[tempdic valueForKey:KEY_DISTANCE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Distance(Meters)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:KEY_TIME] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    
                    if ([[tempdic valueForKey:UNIT_RATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:UNIT_WATTS] intValue] == 1) {
                        txtFieldLeftHeader.text = @"Average Watts";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_WATTS"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:UNIT_HEARTRATE] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Heart Rate";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_HEARTRATE"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                    if ([[tempdic valueForKey:@"Split"] intValue] == 1) {
                        txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                        txtFieldLeftHeader.font = WorkOutDetailFont;
                        txtField.borderStyle=UITextBorderStyleNone;
                        txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                        txtField.textAlignment=NSTextAlignmentCenter;
                        txtField.userInteractionEnabled = NO;
                    }
                }
            }
        }else{
            CustomTextField *txtFieldLeftHeader=(CustomTextField *)[cell viewWithTag:1001];
            CustomTextField *txtField=(CustomTextField *)[cell viewWithTag:1002];
            txtFieldLeftHeader.textColor=[UIColor darkGrayColor];
            txtField.textAlignment=NSTextAlignmentCenter;
            txtField.SectionIndex=(int)indexPath.section;
            txtField.RowIndex=(int)indexPath.row;
            if (indexPath.row == 0) {
                txtField.text=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:WARMUPTIME];
                txtFieldLeftHeader.text=WARMUPTIME;
                txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:WARMUPTIME attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor] ,NSFontAttributeName :WorkOutDetailFont}];
            }else if (indexPath.row==1){
                txtField.text=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:COOLDOWNTIME];
                txtFieldLeftHeader.text=COOLDOWNTIME;
                txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:COOLDOWNTIME attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName : WorkOutDetailFont }];
            }else{
                NSArray *arrTemp=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:KEY_UNITS];
                NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:indexPath.row-2] allKeys];
                NSString *unitKey=EMPTYSTRING;
                NSString *strTemp=[arrUnitKeys objectAtIndex:0];
                if ([strTemp isEqualToString:@"id"]) {
                    unitKey=[arrUnitKeys objectAtIndex:1];
                }else{
                    unitKey=[arrUnitKeys objectAtIndex:0];
                }
                txtFieldLeftHeader.text=unitKey;
                txtField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:unitKey attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName :WorkOutDetailFont}];
                txtField.text=[[[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:KEY_UNITS] objectAtIndex:indexPath.row-2] valueForKey:unitKey];
            }
            txtField = nil;
            txtFieldLeftHeader = nil;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return isIPAD ? 60 : 50.0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    @try {
        if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT]) {
            NSString *str =  [NSString stringWithFormat:@"%@ (%@)",arrAthleteName.count > section ? [arrAthleteName objectAtIndex:section] : EMPTYSTRING,arrAthleteExerciseName.count > section ? [arrAthleteExerciseName objectAtIndex:section] : EMPTYSTRING ] ? [NSString stringWithFormat:@"%@ (%@)",arrAthleteName.count > section ? [arrAthleteName objectAtIndex:section] : EMPTYSTRING,arrAthleteExerciseName.count > section ? [arrAthleteExerciseName objectAtIndex:section] : EMPTYSTRING ] : EMPTYSTRING;
            return str;
        }else if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL]){
            NSString *str = [[arrWorkOuts objectAtIndex:section] valueForKey:KEY_ATHLETENAME] ? [[arrWorkOuts objectAtIndex:section] valueForKey:KEY_ATHLETENAME]: EMPTYSTRING;
            return str ;
        }else
        {
            NSString *str = [[arrWorkOuts objectAtIndex:section] valueForKey:@"Name"] ? [[arrWorkOuts objectAtIndex:section] valueForKey:@"Name"] : EMPTYSTRING;
            return str;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width/2, isIPAD ? 60 : 50.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, ((headerView.frame.size.height/2) - (isIPAD ? 20 : 15) ), tableView.bounds.size.width/2-5, isIPAD ? 40 : 30)];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    label.backgroundColor = [UIColor clearColor];
    label.font = Textfont;
    UITextView *txtviewNotes = [[UITextView alloc] initWithFrame:CGRectMake((OtherField_X)+(OtherField_W), isIPAD ? 5.0 : 5.0, OtherField_W, isIPAD ? 50 : 40)];
    NSString *strTemp = EMPTYSTRING;
    arrWorkOuts.count > section ? strTemp =[[arrWorkOuts objectAtIndex:section] valueForKey:@"note"] : EMPTYSTRING;
    txtviewNotes.text = (strTemp.length > 0 ?[[arrWorkOuts objectAtIndex:section] valueForKey:@"note"] :@"Add Note");
    txtviewNotes.textColor = LightGrayColor;
    txtviewNotes.autocorrectionType = UITextAutocorrectionTypeNo;
    txtviewNotes.layer.borderWidth = .50;
    txtviewNotes.layer.cornerRadius = 5.0;
    txtviewNotes.layer.borderColor = LightGrayColor.CGColor;
    txtviewNotes.font = Textfont;
    txtviewNotes.tag = section;
    txtviewNotes.delegate = self;
    headerView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    [headerView addSubview:label];
    [headerView addSubview:txtviewNotes];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return isIPAD ? 45 : 35.0;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
}

#pragma mark- UITextview Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView.text isEqualToString:@"Add Note"] ? textView.text = EMPTYSTRING : EMPTYSTRING;
    [WorkOutDetails setContentOffsetOfScrollView:textView table:scrollView];
    [self setContentOffsetOfTableDown:textView table:table];
    textView.delegate = self;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    // textView.text.length == 0  ? textView.text = @"Add Note" : EMPTYSTRING;
    NSInteger index = textView.tag;
    [[arrWorkOuts objectAtIndex:index] setValue:textView.text forKey:@"note"];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.keyboardType = UIKeyboardTypeDefault;
    return YES;
}

#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    isSelectAthlete=[textField.placeholder isEqualToString:@"Select athlete"] ? YES:NO ;
    currentText=(CustomTextField *)textField;
    textField.keyboardType=UIKeyboardTypePhonePad;
    [WorkOutDetails setContentOffsetOfScrollView:textField table:scrollView];
    [self setContentOffsetOfTableDown:textField table:table];
    if([textField.placeholder isEqualToString:WARMUPTIME] || [textField.placeholder isEqualToString:COOLDOWNTIME] || [textField.placeholder isEqualToString:@"Select athlete"] )
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if (arrAllAthlete.count==0 && [textField.placeholder isEqualToString:@"Select athlete"]) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated: YES];
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Athlete doesn't exist" delegate:nil btn1:@"Ok"];
        }else
        {
            if (arrTime.count==0) {
            }else
            {
                [listPicker reloadAllComponents];
                [listPicker selectRow:0 inComponent:0 animated:YES];
                [self showPickerSeleted:arrTime];
                [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
            }
        }
        return NO;
    }else{
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
-(NSString *)EntervalueInCorrectFormate:(NSString *)Key :(NSString *)value : (int)rowindex : (int)sectionindex
{
    @try {
        NSString *correctValue = EMPTYSTRING;
        NSString *PlaceholderValue = EMPTYSTRING;
        NSString *myString = Key;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            PlaceholderValue = [myString substringWithRange:NSMakeRange(startRange.location+1,(endRange.location - startRange.location)-1)];
        }
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            NSString *CheeckType = [myString substringWithRange:NSMakeRange(0,(startRange.location)-1)];
            if ([CheeckType isEqualToString:KEY_DISTANCE] || [myString isEqualToString:UNIT_RATE] || [myString isEqualToString:@"Repetitions"]) {
                return value;
            }
        }else{
            if ([myString isEqualToString:UNIT_RATE] || [myString isEqualToString:@"Repetitions"] || [myString isEqualToString:STR_WEIGHT] ) {
                return value;
            }
        }
        value=[value stringByReplacingOccurrencesOfString:@":" withString:EMPTYSTRING];
        value=[value stringByReplacingOccurrencesOfString:@"." withString:EMPTYSTRING];
        const char *c = [PlaceholderValue UTF8String];
        const char *arrValue = [value UTF8String];
        for (int i=0; i< PlaceholderValue.length; i++) {
            if (c[i]==':') {
                correctValue=[correctValue stringByAppendingString:@":"];
            }else if (c[i]=='.')
            {
                correctValue=[correctValue stringByAppendingString:@"."];
            }else{
                correctValue=[correctValue stringByAppendingString:@"0"];
            }
        }
        NSString *strTemp=correctValue;
        if ([ PlaceholderValue isEqualToString:UNIT_HH_MM_SS_SSS]) {
            switch (value.length) {
                case 0:{
                    return @"00:00:00.000";
                    break;
                }
                case 1:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"0%c:00:00.000",arrValue[0]]];
                    return strTemp;
                    break;
                }
                case 2:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:00:00.000",arrValue[0],arrValue[1]]];
                    return strTemp;
                }
                case 3:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:0%c:00.000",arrValue[0],arrValue[1],arrValue[2]]];
                    return strTemp;
                }
                case 4:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:%c%c:00.000",arrValue[0],arrValue[1],arrValue[2],arrValue[3]]];
                    return strTemp;
                }
                case 5:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:%c%c:0%c.000",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4]]];
                    return strTemp;
                }
                case 6:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:%c%c:%c%c.000",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4],arrValue[5]]];
                    return strTemp;
                }
                case 7:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:%c%c:%c%c.00%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4],arrValue[5],arrValue[6]]];
                    return strTemp;
                }
                case 8:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:%c%c:%c%c.0%c%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4],arrValue[5],arrValue[6],arrValue[7]]];
                    return strTemp;
                }
                case 9:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,12) withString:[NSString stringWithFormat:@"%c%c:%c%c:%c%c.%c%c%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4],arrValue[5],arrValue[6],arrValue[7],arrValue[8]]];
                    return strTemp;
                }
                default:
                    break;
            }
        }else  if ([PlaceholderValue isEqualToString:UNIT_MM_SS_SSS])
        {
            switch (value.length) {
                case 0:{
                    return @"00:00.000";
                    break;
                }
                case 1:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"0%c:00.000",arrValue[0]]];
                    return strTemp;
                    break;
                }
                case 2:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"%c%c:00.000",arrValue[0],arrValue[1]]];
                    return strTemp;
                }
                case 3:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"%c%c:0%c.000",arrValue[0],arrValue[1],arrValue[2]]];
                    return strTemp;
                }
                case 4:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"%c%c:%c%c.000",arrValue[0],arrValue[1],arrValue[2],arrValue[3]]];
                    return strTemp;
                }
                case 5:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"%c%c:%c%c.00%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4]]];
                    return strTemp;
                }
                case 6:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"%c%c:%c%c:0%c%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4],arrValue[5]]];
                    return strTemp;
                }
                case 7:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:[NSString stringWithFormat:@"%c%c:%c%c.%c%c%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4],arrValue[5],arrValue[6]]];
                    return strTemp;
                }
                default:
                    break;
            }
            
        }else  if ([ PlaceholderValue isEqualToString:UNIT_MM_SS_S])
        {
            switch (value.length) {
                case 0:{
                    return @"00:00.0";
                    break;
                }
                case 1:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:[NSString stringWithFormat:@"0%c:00.0",arrValue[0]]];
                    return strTemp;
                    break;
                }
                case 2:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:[NSString stringWithFormat:@"%c%c:00.0",arrValue[0],arrValue[1]]];
                    return strTemp;
                }
                case 3:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:[NSString stringWithFormat:@"%c%c:0%c.0",arrValue[0],arrValue[1],arrValue[2]]];
                    return strTemp;
                }
                case 4:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:[NSString stringWithFormat:@"%c%c:%c%c.0",arrValue[0],arrValue[1],arrValue[2],arrValue[3]]];
                    return strTemp;
                }
                case 5:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,7) withString:[NSString stringWithFormat:@"%c%c:%c%c.%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4]]];
                    return strTemp;
                }
                default:
                    break;
            }
            
        }else  if ([ PlaceholderValue isEqualToString:UNIT_SS_SSS])
        {
            switch (value.length) {
                case 0:{
                    return @"00.000";
                    break;
                }
                case 1:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,6) withString:[NSString stringWithFormat:@"0%c.000",arrValue[0]]];
                    return strTemp;
                    break;
                }
                case 2:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,6) withString:[NSString stringWithFormat:@"%c%c.000",arrValue[0],arrValue[1]]];
                    return strTemp;
                }
                case 3:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,6) withString:[NSString stringWithFormat:@"%c%c.00%c",arrValue[0],arrValue[1],arrValue[2]]];
                    return strTemp;
                }
                case 4:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,6) withString:[NSString stringWithFormat:@"%c%c.0%c%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3]]];
                    return strTemp;
                }
                case 5:{
                    strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(0,6) withString:[NSString stringWithFormat:@"%c%c.%c%c%c",arrValue[0],arrValue[1],arrValue[2],arrValue[3],arrValue[4]]];
                    return strTemp;
                }
                default:
                    break;
            }
        }else {
            strTemp = value ;
        }
        return strTemp;
    }
    @catch (NSException *exception) {
        return EMPTYSTRING;
    }
    @finally {
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    @try {
        CustomTextField *Mytext=(CustomTextField *)textField;
        Mytext.text = [self EntervalueInCorrectFormate:Mytext.placeholder :Mytext.text :Mytext.RowIndex :Mytext.SectionIndex];
        if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT])
        {
            [self updateLiftValue:Mytext.liftAthleteIndex :Mytext.text :Mytext.RowIndex :Mytext.liftExerciseIndex:textField];
        }else  if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_INTERVAL])
        {
            [self updateValue:Mytext.placeholder :Mytext.text :Mytext.RowIndex :Mytext.SectionIndex];
            [self CalculateAVG :Mytext.SectionIndex];
            mytextfiled=Mytext;
            // Update cell textfield data for show avarage
            [self performSelector:@selector(UpdateCelldata) withObject:nil afterDelay:0];
        }else{
            [self updateValue:Mytext.placeholder :Mytext.text :Mytext.RowIndex :Mytext.SectionIndex];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
    if (!stringIsValid) {
        return NO;
    }
    CustomTextField *LocalTxtFeild=(CustomTextField *)textField;
    if ([string isEqualToString:EMPTYSTRING]) {
    }else if ([[_obj valueForKey:KEY_WORKOUT_TYPE] isEqualToString:WORKOUTTYPE_LIFT])
    {
        int textfieldcount=(int)textField.text.length;
        if (textfieldcount==3 && [textField.placeholder isEqualToString:STR_WEIGHT]) {
            return NO;
        }else    if (textfieldcount==2 && [textField.placeholder isEqualToString:@"Repetitions"]){
            return NO;
        }
    }else{
        // This code not work for lift and interval ( in both case method work updateLiftValue)
        NSString *value=EMPTYSTRING;
        NSString *myString = textField.placeholder;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(startRange.location+1,(endRange.location - startRange.location)-1)];
        }
        const char *c = [value UTF8String];
        int strTraverselength=(int)textField.text.length;
        if ([value isEqualToString:UNIT_MILES]) {
            strTraverselength=2;
        }else if ([value isEqualToString:UNIT_METERS]){
            strTraverselength=9;
        }else if ([value isEqualToString:UNIT_KILOMETERS]){
            strTraverselength=2;
        }else if ([value isEqualToString:UNIT_MILES]){
            strTraverselength=2;
        }else if ([value isEqualToString:EMPTYSTRING]){
            strTraverselength=3;
        }else{
            strTraverselength=(int)value.length;
        }
        int textfieldcount=(int)textField.text.length;
        if (strTraverselength==textField.text.length) {
            return NO;
        }
        if (c[textfieldcount]==':') {
            textField.text= [textField.text stringByAppendingString:@":"];
        }else if (c[textfieldcount]=='.'){
            textField.text= [textField.text stringByAppendingString:@"."];
        }
        [self updateValue:LocalTxtFeild.placeholder :LocalTxtFeild.text :LocalTxtFeild.RowIndex :LocalTxtFeild.SectionIndex];
    }
    return YES;
}

#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isSelectAthlete  ) {
        if (_tfSelectUserType.text.length==0) {
            _tfSelectUserType.text=arrAllAthlete.count > 0 ?[arrAllAthlete objectAtIndex:0] : @"";
            [self FilterDataAccourdingAthlete:currentText.text];
        }
        return [arrAllAthlete count];
    }else
    {
        if (currentText.text.length==0 && ([currentText.placeholder isEqualToString:WARMUPTIME] || [currentText.placeholder isEqualToString:COOLDOWNTIME] )) {
            currentText.text=[arrTime objectAtIndex:0];
            [self updateValue:currentText.placeholder :currentText.text :currentText.RowIndex :currentText.SectionIndex];
        }
        return [arrTime count];
    }
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    if (isSelectAthlete) {
        str = [arrAllAthlete objectAtIndex:row];
        if (currentText.text.length==0) {
            currentText.text=[arrAllAthlete objectAtIndex:row] ;
            [self FilterDataAccourdingAthlete:currentText.text];
        }
    }else
    {
        str = [arrTime objectAtIndex:row];
        if (currentText.text.length==0 && ([currentText.placeholder isEqualToString:WARMUPTIME] || [currentText.placeholder isEqualToString:COOLDOWNTIME] )) {
            currentText.text=[arrTime objectAtIndex:row] ;
            [self updateValue:currentText.placeholder :currentText.text :currentText.RowIndex :currentText.SectionIndex];
        }
    }
    NSArray *arr = [str componentsSeparatedByString:KEY_TRIPLE_STAR];
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isSelectAthlete) {
        currentText.text=[arrAllAthlete objectAtIndex:row] ;
        [self FilterDataAccourdingAthlete:currentText.text];
    }else
    {
        currentText.text=[arrTime objectAtIndex:row] ;
        [self updateValue:currentText.placeholder :currentText.text :currentText.RowIndex :currentText.SectionIndex];
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
