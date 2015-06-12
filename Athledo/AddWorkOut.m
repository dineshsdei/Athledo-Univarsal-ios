//
//  AddWorkOut.m
//  Athledo
//
//  Created by Smartdata on 8/14/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddWorkOut.h"
#import "AddWorkOutCell.h"
#import "WorkOutHistory.h"
#import "WorkOutView.h"
#import "SingletonClass.h"
#define FIELD_GAP isIPAD ? 30 :20
#define BOATCELL_INITIALHEIGHT isIPAD ? 120 : 95
#define TEXTFEILD_HEIGHT isIPAD ? 30 : 30

#define ATHLETEDATA @"athletedata"
#define GROUPDATA @"groupdata"
#define PLACEHOLDER_NAME @"Name"
#define KEY_NAME @"name"
#define KEY_GROUPMEMBERS @"member"
#define IS_SELECTED @"isSelected"
#define ATHLETE_NAME @"AthleteName"

static int LiftExerciseCount=0;
@interface AddWorkOut ()
{
    NSMutableArray *arrFieldsPlaceholder,*arrLiftPlaceholder,*arrCustomTagsPlaceholder,*arrExerciseType,*arrCellHeight,*arrWorkOutList,*arrCustomList,*UnitsArray;
    NSArray *arrLiftUnit;
    NSMutableDictionary *workOutDic,*selectedUnits,*WebWorkOutData,*GroupsAthleteDic;
    NSArray *arrTime;
    NSDictionary *LiftExerciseDic;
    NSArray *arrLiftExercise;
    NSArray *arrSetLineup;
    int toolBarPosition;
    BOOL isKeyBoard;
    UITextField *currentText;
    UITextView *txtViewCurrent;
    
    BOOL isWorkOut,isExercise,isWholeTeam,isAthletes,isGroups,isBoats,isBoatUser,isUnits,isCustomTag,isLiftUnit,isLiftExerciseName,isEditData,isTime;
    NSString *strPlaceHolder;
    WebServiceClass *webservice;
    UIToolbar *toolBar;
    UIDeviceOrientation orientation,CurrentOrientation;
    int boatCount;
}

@end
@implementation AddWorkOut
@synthesize objEditModeData;
#pragma mark UIViewController lifecycle method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isChangeWorkoutType=FALSE;
    scrollHeight=0;
    boatCount = 0;
    self.title = NSLocalizedString(KEY_WORKOUT, nil);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    arrLiftPlaceholder=[[NSMutableArray alloc] init];
    
    if (([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger)) {
        arrFieldsPlaceholder=[[NSMutableArray alloc] initWithObjects:KEY_WORKOUT_NAME,KEY_WORKOUT_DATE,KEY_WORKOUT_TYPE,KEY_CUSTOM_TAG,STR_ATHLETES,STR_EMAIL_NOTIFICATION,KEY_DESCRIPTION,WARMUPTIME,COOLDOWNTIME, nil];
    }else{
        arrFieldsPlaceholder=[[NSMutableArray alloc] initWithObjects:KEY_WORKOUT_NAME,KEY_WORKOUT_DATE,KEY_WORKOUT_TYPE,KEY_CUSTOM_TAG,STR_EMAIL_NOTIFICATION,KEY_DESCRIPTION,WARMUPTIME,COOLDOWNTIME, nil];
    }
    arrLiftUnit=[[NSArray alloc] initWithObjects:@"lbs",@"kg",@"%of 1RM",@"N/A", nil];
    arrTime=[[NSArray alloc] initWithObjects:@"05",@"10",@"15",@"20",@"30",@"25",@"35",@"40",@"45",@"50",@"55", nil];
    arrSetLineup = @[@"Select From Groups",@"Select Athletes"];
    workOutDic=[[NSMutableDictionary alloc] init];
    WebWorkOutData=[[NSMutableDictionary alloc] init];
    arrCustomList=[[NSMutableArray alloc] init];
    arrExerciseType=[[NSMutableArray alloc]init];
    selectedUnits = [[NSMutableDictionary alloc] init];
    UnitsArray=[[NSMutableArray alloc]init];
    NSMutableDictionary  *Data=[[NSMutableDictionary alloc] init];
    for (int i=0; i<arrFieldsPlaceholder.count; i++) {
        [workOutDic setObject:EMPTYSTRING forKey:[arrFieldsPlaceholder objectAtIndex:i]];
    }
    @try {
        if (objEditModeData) {
            isEditData=YES;
            // Open in edit mode
            switch ([[objEditModeData valueForKey:KEY_ASSIGNED] intValue]) {
                case 1:{
                    [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
                    break;
                }
                case 2:
                {
                    [workOutDic setObject:[objEditModeData valueForKey:STR_ATHLETES] forKey:STR_ATHLETES];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_WHOLE_TEAM];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
                    break;
                }
                case 3:
                {
                    [workOutDic setObject:[objEditModeData valueForKey:STR_GROUPS] forKey:STR_GROUPS];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_WHOLE_TEAM];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
                    break;
                }
                case 4:
                {
                    [workOutDic setObject:[objEditModeData valueForKey:STR_BOATS] forKey:@"Boats"];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_WHOLE_TEAM];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
                    [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
                    break;
                }
                    
                default:
                    break;
            }
            [workOutDic setObject:[objEditModeData valueForKey:KEY_ASSIGNED] forKey:KEY_ASSIGNED];
            [workOutDic setObject:[[objEditModeData valueForKey:STR_EMAIL_NOTIFICATION] intValue]== 1 ? @"Yes":@"No" forKey:STR_EMAIL_NOTIFICATION];
            [workOutDic setObject:[[objEditModeData valueForKey:WARMUPTIME] intValue]==0 ? EMPTYSTRING:[[objEditModeData valueForKey:WARMUPTIME] stringByAppendingString:STR_MINUTES] forKey:WARMUPTIME];
            [workOutDic setObject:[[objEditModeData valueForKey:COOLDOWNTIME] intValue]==0 ? EMPTYSTRING :[[objEditModeData valueForKey:COOLDOWNTIME] stringByAppendingString:STR_MINUTES]forKey:COOLDOWNTIME];
            [workOutDic setObject:[objEditModeData valueForKey:KEY_WORKOUT_NAME] forKey:KEY_WORKOUT_NAME];
            [workOutDic setObject:[objEditModeData valueForKey:KEY_DATE] forKey:KEY_WORKOUT_DATE];
            [workOutDic setObject:[objEditModeData valueForKey:KEY_DESCRIPTION] forKey:KEY_DESCRIPTION];
            [workOutDic setObject:[objEditModeData valueForKey:KEY_WORKOUT_TYPE] forKey:KEY_WORKOUT_TYPE];
            [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
            if ([[objEditModeData valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_INTERVAL]) {
                [workOutDic setObject:[objEditModeData valueForKey:WORKOUTTYPE_INTERVAL] forKey:KEY_HASH_OF_INTERVAL];
            }else if ([[objEditModeData valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT]){
                [workOutDic setObject:[objEditModeData valueForKey:STR_LIFT_TOTAL_TIME] forKey:KEY_TOTAL_TIME];
            }
            NSString *strtemp=[objEditModeData valueForKey:KEY_WORKOUT_TYPE];
            if (strtemp.length > 0 && ![[objEditModeData valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT] ) {
                NSString *code= [objEditModeData valueForKey:@"workout_type_id"];
                NSString *exercise_id= [objEditModeData valueForKey:KEY_EXERCISE_TYPE];
                [self getWorkOutUnit:code :exercise_id];
                [self ShowFieldsRegardingWorkOutType:strtemp];
            }
        }else{
            // Whole team and email Yes is by default selected
            [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
            [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
            [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [workOutDic setObject:STATUS_SELECTED forKey:KEY_ASSIGNED];
            [workOutDic setObject:@"Yes" forKey:STR_EMAIL_NOTIFICATION];
            [workOutDic setObject:[Data copy] forKey:KEY_CUSTOM_TAG];
            [workOutDic setObject:EMPTYSTRING forKey:KEY_TOTAL_TIME];
            Data=nil;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    arrWorkOutList=[[NSMutableArray alloc] init] ;
    arrCellHeight=[[NSMutableArray alloc] initWithObjects:@"70",@"70",@"70",@"70",@"70",@"100",@"70" ,nil];
    toolBarPosition = (([[UIScreen mainScreen] bounds].size.height >= 568)?300:210);
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, listPicker.frame.size.height);
    listPicker.tag=listPickerTag;
    listPicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, datePicker.frame.size.height)];
    datePicker.date = [NSDate date];
    datePicker.tag=datePickerTag;
    //[datePicker setHidden:YES];
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216)];
    pickerView.backgroundColor=[UIColor whiteColor];
    // pickerView.tag=MultipleSelectionPickerTag;
    pickerView.delegate=self;
    //pickerView.dataSource=self;
    [self.view addSubview:pickerView];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = toolBarTag;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    UIBarButtonItem *btnDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(Done)];
    UIToolbar *toolBarOne = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBarOne.tag = toolBar1Tag;
    
    toolBarOne.items = [NSArray arrayWithObjects:flex,flex,btnDone1,nil];
    [self.view addSubview:toolBarOne];
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SaveWorkOutData:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    if (isIPAD) {
        [self orientationChanged];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            if (iosVersion < 8) {
                [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22))];
                scrollHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                
                [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22))];
                scrollHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
            }
        }completion:^(BOOL finished){
        }];
    }];
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [self setMultipleSlectionPicker:NO];
        [self setDatePickerVisibleAt:NO];
        [self setPickerVisibleAt:NO:arrTime];
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height > 310 ? kbSize.width : kbSize.height+22))];
            
        }completion:^(BOOL finished){
        }];
    }];
    [self getWorkOutList];
    [self getGroupsAthletes];
    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}

#pragma mark webservice method
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    @try {
        [SingletonClass RemoveActivityIndicator:self.view];
        switch (Tag){
            case AddCustomTag:{
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                    [arrCustomList insertObject:currentText.text atIndex:0];
                    int customtagId=[[MyResults  objectForKey:DATA] intValue];
                    // add custom tag in dic for show in picker
                    NSArray *customTagValues;
                    NSArray *customTagKeys;
                    [[workOutDic objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]] ? customTagValues =[[workOutDic objectForKey:KEY_CUSTOM_TAG] allValues] :EMPTYSTRING;
                    [[workOutDic objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]] ?customTagKeys =[[workOutDic objectForKey:KEY_CUSTOM_TAG] allKeys] : EMPTYSTRING;
                    NSMutableDictionary *Tempdic=[[NSMutableDictionary alloc] init];
                    for (int i=0 ; i< customTagValues.count;i++) {
                        [Tempdic setObject:[customTagValues objectAtIndex:i] forKey:[customTagKeys objectAtIndex:i]];
                    }
                    [Tempdic setObject:@"0" forKey:currentText.text];
                    [workOutDic setObject:[Tempdic copy] forKey:KEY_CUSTOM_TAG];
                    // add custom tag and its id  in dic for next use
                    NSArray *customTagValues1;
                    NSArray *customTagKeys1;
                    [[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]]  ? customTagValues1=[[WebWorkOutData objectForKey:KEY_CUSTOM_TAG]  allValues] : EMPTYSTRING;
                    [[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]] ? customTagKeys1=[[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] allKeys] : EMPTYSTRING;
                    
                    NSMutableDictionary *Tempdic1=[[NSMutableDictionary alloc] init];
                    for (int i=0 ; i< customTagValues1.count;i++) {
                        [Tempdic1 setObject:[customTagValues1 objectAtIndex:i] forKey:[customTagKeys1 objectAtIndex:i]];
                    }
                    
                    [Tempdic1 setObject:currentText.text forKey:[NSString stringWithFormat:@"%d",customtagId]];
                    
                    [WebWorkOutData setObject:[Tempdic1 copy] forKey:KEY_CUSTOM_TAG];
                    Tempdic1=nil;
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Custom tag has been added successfully" delegate:nil btn1:@"Ok"];
                    
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                break;
            }
            case DeleteCustomTag:{
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                    [arrCustomList removeObject:currentText.text];
                    NSArray *customTagValues=[[workOutDic objectForKey:KEY_CUSTOM_TAG] allValues];
                    NSArray *customTagKeys=[[workOutDic objectForKey:KEY_CUSTOM_TAG] allKeys];
                    NSMutableDictionary *Tempdic=[[NSMutableDictionary alloc] init];
                    for (int i=0 ; i< customTagValues.count;i++) {
                        
                        if (![[customTagKeys objectAtIndex:i] isEqualToString:currentText.text]) {
                            
                            [Tempdic setObject:[customTagValues objectAtIndex:i] forKey:[customTagKeys objectAtIndex:i]];
                        }
                    }
                    [workOutDic setObject:[Tempdic copy] forKey:KEY_CUSTOM_TAG];
                    Tempdic=nil;
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Custom tag has been removed successfully" delegate:nil btn1:@"Ok"];
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                break;
            }
            case AddExerciseTypeTag:{
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                    [arrExerciseType insertObject:currentText.text atIndex:0];
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Exercise Type has been added successfully" delegate:nil btn1:@"Ok"];
                    
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                
                break;
            } case DeleteExerciseTypeTag:{
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                    [arrExerciseType removeObject:currentText.text];
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Exercise Type has been removed successfully" delegate:nil btn1:@"Ok"];
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                break;
            } case AddWorkoutTag:{
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been saved successfully" delegate:self btn1:@"Ok" btn2:nil tagNumber:AddWorkoutTag];
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                break;
            }case GetGroupsAthletesTag:{
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                    GroupsAthleteDic = MyResults;
                    
                    NSArray *arrGroups=[GroupsAthleteDic valueForKey:GROUPDATA];
                    for (int i=0; i<arrGroups.count; i++) {
                        [[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
                    }
                    
                    NSArray *arrAthleteName=[[GroupsAthleteDic valueForKey:ATHLETEDATA] allKeys];
                    NSArray *arrAthleteId=[[GroupsAthleteDic valueForKey:ATHLETEDATA] allValues];
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (int i=0; i<arrAthleteName.count; i++) {
                        [arr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[arrAthleteName objectAtIndex:i],ATHLETE_NAME,[arrAthleteId objectAtIndex:i],@"id",[NSNumber numberWithBool:NO],IS_SELECTED, nil]];
                    }
                    [GroupsAthleteDic setValue:arr forKey:ATHLETEDATA];
                }
                break;
            }
            default:
                break;
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
-(void)httpResponseReceived:(NSData *)webResponse : (int)Tag{
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    // Now remove the Active indicator
    [SingletonClass RemoveActivityIndicator:self.view];
    // Now we Need to decrypt data
    NSError *error=nil;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    if (Tag == GetWorkOutUnitTag){
        if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            NSDictionary *tepm=[myResults  objectForKey:DATA];
            if (![tepm isEqual:EMPTYSTRING]){
                [WebWorkOutData setObject:[myResults  objectForKey:DATA] forKey:KEY_UNIT];
                if (isEditData) {
                    [self getUnitArryValues:KEY_UNIT];
                }
            }
        }
    }else if (Tag ==GetWorkOutListTag){
        //First time we get these fields data-> Workout Unit ,WorkOut Type,Custom Tags Tag,liftUnits,groups,athletes
        if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            WebWorkOutData=[myResults  objectForKey:DATA];
            [[WebWorkOutData objectForKey:@"Lift Excercise"] isKindOfClass:[NSDictionary class]] ?  LiftExerciseDic=[WebWorkOutData objectForKey:@"Lift Excercise"] : EMPTYSTRING;
            LiftExerciseDic.count > 0 ? arrLiftExercise = [LiftExerciseDic allValues] : EMPTYSTRING ;
            NSArray *tempWorkout;
            [[WebWorkOutData objectForKey:KEY_WORKOUT_TYPE] isKindOfClass:[NSDictionary class]] ?  tempWorkout=[[WebWorkOutData objectForKey:KEY_WORKOUT_TYPE] allValues] : EMPTYSTRING;
            
            for (int i=0 ; i< tempWorkout.count;i++) {
                
                [arrWorkOutList addObject:[tempWorkout objectAtIndex:i]];
            }
            NSArray *customTags;
            NSArray *customKeys;
            [[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]]  ? customTags=[[WebWorkOutData objectForKey:KEY_CUSTOM_TAG]  allValues] : EMPTYSTRING;
            [[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]] ? customKeys=[[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] allKeys] : EMPTYSTRING;
            NSMutableDictionary *Tempdic=[[NSMutableDictionary alloc] init];
            for (int i=0 ; i< customTags.count;i++) {
                
                @try {
                    
                    if (isEditData) {
                        
                        // In Edit mode objEditModeData object contails keys in string form that's for matching keys code
                        NSArray *temp=[objEditModeData objectForKey:KEY_CUSTOM_TAG];
                        if ([temp containsObject:[customKeys objectAtIndex:i]] ) {
                            [Tempdic setObject:STATUS_SELECTED forKey:[customTags objectAtIndex:i]];
                            [workOutDic setObject:[ [workOutDic valueForKey :KEY_CUSTOM_TAG] stringByAppendingFormat:@",%@", [customTags objectAtIndex:i] ] forKey:KEY_CUSTOM_TAG];
                        }else{
                            [Tempdic setObject:@"0" forKey:[customTags objectAtIndex:i]];
                        }
                    }else{
                        
                        [Tempdic setObject:@"0" forKey:[customTags objectAtIndex:i]];
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }
            if (arrCustomList.count == 0) {
                [workOutDic setObject:[Tempdic copy] forKey:KEY_CUSTOM_TAG];
                Tempdic=nil;
            }
            // For delete funtionality of custom tag
            NSArray *customTag;
            [[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] isKindOfClass:[NSDictionary class]] ? customTag=[[WebWorkOutData objectForKey:KEY_CUSTOM_TAG] allValues] : EMPTYSTRING;
            
            if (arrCustomList.count  >0 ) {
                
                [arrCustomList removeAllObjects];
            }
            
            for (int i=0 ; i< customTag.count;i++) {
                
                [arrCustomList addObject:[customTag objectAtIndex:i]];
            }
            // when at perticular key is no value in WebWorkOutData then allvalues method due to crash thats by use the method
            NSArray *ExerciseType;
            NSArray *Exerciseid;
            [[WebWorkOutData objectForKey:KEY_EXERCISE] isKindOfClass:[NSDictionary class]] ?  ExerciseType =[[WebWorkOutData objectForKey:KEY_EXERCISE] allValues] :EMPTYSTRING;
            [[WebWorkOutData objectForKey:KEY_EXERCISE] isKindOfClass:[NSDictionary class]] ?  Exerciseid=[[WebWorkOutData objectForKey:KEY_EXERCISE] allKeys] : EMPTYSTRING;
            BOOL ArrStatus=FALSE;
            if (arrExerciseType.count  >0 ) {
                ArrStatus=TRUE;
                [arrExerciseType removeAllObjects];
            }
            for (int i=0 ; i< ExerciseType.count;i++) {
                //if-> In Edit Mode
                if (isEditData) {
                    NSString *excersisecode=[objEditModeData objectForKey:KEY_EXERCISE_TYPE];
                    if ([[Exerciseid objectAtIndex:i] isEqualToString:excersisecode] ){
                        [workOutDic setObject:[ExerciseType objectAtIndex:i] forKey:KEY_EXERCISE_TYPE];
                    }
                    [arrExerciseType addObject:[ExerciseType objectAtIndex:i]];
                }
                else{
                    [arrExerciseType addObject:[ExerciseType objectAtIndex:i]];
                }
            }
            //in Edit mode Athletes or groups values
            @try {
                if (isEditData) {
                    switch ([[objEditModeData valueForKey:KEY_ASSIGNED] intValue]) {
                        case 1:{
                            break;
                        }
                        case 2:{
                            [self getUnitArryValues :STR_ATHLETES];
                            break;
                        }
                        case 3:{
                            [self getUnitArryValues :STR_GROUPS];
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
                
            }
        }
        [[WebWorkOutData objectForKey:KEY_LIFT_UNIT] isKindOfClass:[NSDictionary class]] ? arrLiftUnit=[[WebWorkOutData objectForKey:KEY_LIFT_UNIT] allValues] :EMPTYSTRING;
        // IN Case Edit data
        if (isEditData) {
            if ([[objEditModeData valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT]){
                NSArray *tempLiftdata=[self LiftDataWithUnitValue:[objEditModeData valueForKey:WORKOUTTYPE_LIFT]];
                [arrLiftPlaceholder addObjectsFromArray:tempLiftdata];
                [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
                [self ShowFieldsRegardingWorkOutType:WORKOUTTYPE_LIFT];
            }
        }
    }else if (Tag ==AddWorkOutLiftTag){
        if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been saved successfully" delegate:self btn1:@"Ok" btn2:nil tagNumber:AddWorkoutTag];
        }else{
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
        }
    }
}

#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (isWorkOut) {
        return [arrWorkOutList count];
        
    }
    else  if (isLiftUnit){
        return [arrLiftUnit count];
    }
    else  if (isCustomTag){
        return [arrCustomList count];
    }
    else  if (isTime){
        return [arrTime count];
    }
    else  if (isLiftExerciseName){
        return [arrLiftExercise count];
    }
    else  if (isBoats){
        return [arrSetLineup count];
    }
    else{
        return [arrExerciseType count];
    }
    
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    if (isWorkOut) {
        str= [arrWorkOutList objectAtIndex:row];
        if (currentText.text.length ==0) {
            isChangeWorkoutType=TRUE;
            currentText=[self TextfieldInCellAtSection:2:0:KEY_WORKOUT_TYPE];
            currentText.text=[arrWorkOutList objectAtIndex:row];
        }
    }else  if (isLiftUnit)
    {
        str = [arrLiftUnit objectAtIndex:row];
        currentText.text.length==0 ? currentText.text=str : EMPTYSTRING;
    }else  if (isCustomTag)
    {
        str = [arrCustomList objectAtIndex:row];
        currentText.text.length==0 ? currentText.text=str : EMPTYSTRING;
    }else  if (isTime)
    {
        str = [arrTime objectAtIndex:row];
        currentText.text.length==0 ? currentText.text=[[arrTime objectAtIndex:0] stringByAppendingString:STR_MINUTES]:str;
    }else  if (isLiftExerciseName)
    {
        str = [arrLiftExercise objectAtIndex:row];
        currentText.text.length==0 ? currentText.text = str : EMPTYSTRING  ;
    }else  if (isBoats)
    {
        str =arrSetLineup.count > row ? [arrSetLineup objectAtIndex:row] : @"";
        
        if ([[workOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]] && currentText.text.length==0) {
            currentText.text.length==0 ? currentText.text = str : EMPTYSTRING  ;
            NSMutableArray *arrtemp = [workOutDic valueForKey:STR_BOATS];
            arrtemp.count > currentText.tag ? [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:currentText.tag] setValue:currentText.text forKey:STRKEY_SETLINEUP] : @"";
        }
    }else{
        str = [arrExerciseType objectAtIndex:row];
        currentText.text.length==0 ? currentText.text=str : str;
    }
    NSArray *arr = [str componentsSeparatedByString:KEY_TRIPLE_STAR];
    return [arr objectAtIndex:0];
}
-(UITextField *)TextfieldInCellAtSection :(int)section :(int)row :(NSString*)placeHolder{
    UITextField *textfield;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell=[tableview cellForRowAtIndexPath:newIndexPath];
    NSArray *cellfields;
    if (iosVersion < 8) {
        cellfields=[cell subviews] ;
        cellfields=[[cellfields objectAtIndex:0] subviews];
    }else{
        cellfields=[cell subviews];
    }
    for (id obj in cellfields ) {
        if ([obj isKindOfClass:[UITextField class]]) {
            textfield=obj;
            if ([textfield.placeholder isEqualToString:placeHolder]) {
                return textfield;
            }
        }
    }
    return textfield;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (isWorkOut) {
        if (currentText.text.length > 0) {
            [self DeleteExistingFieldsRegardingWorkOutType : currentText.text];
        }
        isChangeWorkoutType=TRUE;
        currentText=[self TextfieldInCellAtSection :2 :0:KEY_WORKOUT_TYPE];
        currentText.text=[arrWorkOutList objectAtIndex:row];
        
    }
    else  if (isLiftUnit){
        currentText.text=[arrLiftUnit objectAtIndex:row];
    }
    else  if (isCustomTag){
        currentText.text=[arrCustomList objectAtIndex:row];
        
    }
    else  if (isTime){
        currentText.text=[[arrTime objectAtIndex:row] stringByAppendingString:STR_MINUTES];
    }
    else  if (isLiftExerciseName){
        currentText.text=[arrLiftExercise objectAtIndex:row];
    }
    else  if ([currentText.placeholder isEqualToString:SETLINEUP_PLACEHOLDER]){
        currentText.text=[arrSetLineup objectAtIndex:row];
        if ([[workOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *arrtemp = [workOutDic valueForKey:STR_BOATS];
            arrtemp.count > currentText.tag ? [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:currentText.tag] setValue:currentText.text forKey:STRKEY_SETLINEUP] : @"";
        }
        [self ReloadDataOfTabbleSection:5];
        currentText=[self TextfieldInCellAtSection:5:boatCount:SETLINEUP_PLACEHOLDER];
        currentText.text=[[[workOutDic valueForKey:STR_BOATS] objectAtIndex:currentText.tag]valueForKey:STRKEY_SETLINEUP];
    }
    else{
        currentText.text=[arrExerciseType objectAtIndex:row];
        if ([[currentText.text uppercaseString] isEqualToString:EXERCISE_ROWING]) {
            [workOutDic setObject:STR_ROWING forKey:KEY_EXERCISE_TYPE];
            [self SetDicValue:STR_WHOLE_TEAM];
        }
        else  {
            [workOutDic setObject:EMPTYSTRING forKey:KEY_EXERCISE_TYPE];
        }
        [self ReloadDataOfTabbleSection:5];
    }
}
#pragma mark ALPickerView delegate methods
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
    return [UnitsArray count];
}
- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    return [UnitsArray objectAtIndex:row];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionGroupForRow:(NSInteger)row {
    return [[selectedUnits objectForKey:[UnitsArray objectAtIndex:row]] boolValue];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    //NSLog(EMPTYSTRING);
    return [[selectedUnits objectForKey:[UnitsArray objectAtIndex:row]] boolValue];
}
- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    // Check whether all rows are checked or only one
    if (row == -1)
        for (id key in [selectedUnits allKeys])
        {
            [selectedUnits setObject:[NSNumber numberWithBool:YES] forKey:key];
            if(isBoatUser)
            {  // when All selected
                [self checkedAthleteOrGroupStatus:key];
            }
        }
    else
        [selectedUnits setObject:[NSNumber numberWithBool:YES] forKey:[UnitsArray objectAtIndex:row]];
    [self saveMultiPickerValues];
    if(isBoatUser)
    {
        [self saveAthletesOrGroupsData:currentText];
        (row != -1) ? [self checkedAthleteOrGroupStatus:[UnitsArray objectAtIndex:row]] :@"";
    }
}
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    // Check whether all rows are unchecked or only one
    if (row == -1)
    {
        for (id key in [selectedUnits allKeys]){
            [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:key];
            if(isBoatUser){
                [self saveMultiPickerValues];
                [self saveAthletesOrGroupsData:currentText];
                [self unCheckedAthleteOrGroupStatus:key:currentText.tag];
            }
        }
    }
    else
    {
        [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:[UnitsArray objectAtIndex:row]];
    }
    
    [self saveMultiPickerValues];
    if(isBoatUser && row != -1){
        [self saveAthletesOrGroupsData:currentText];
        [self unCheckedAthleteOrGroupStatus:[UnitsArray objectAtIndex:row]:currentText.tag];
    }
}
-(void)saveMultiPickerValues
{
    if ([strPlaceHolder isEqualToString:KEY_UNIT] && isUnits==YES)
    {   currentText.text = [self PickerSlectedValues:selectedUnits];
    }else if ([strPlaceHolder isEqualToString:STR_WHOLE_TEAM] && isWholeTeam==YES)
    {  currentText.text = [self PickerSlectedValues:selectedUnits];
        [workOutDic setObject:STATUS_SELECTED forKey:KEY_ASSIGNED];
        
    }else if ([strPlaceHolder isEqualToString:STR_ATHLETES] && isAthletes==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
        [workOutDic setObject:@"2" forKey:KEY_ASSIGNED];
        [self ReloadDataOfTabbleSection:5];
        
        
    }else if ([strPlaceHolder isEqualToString:STR_GROUPS] && isGroups==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
        [workOutDic setObject:@"3" forKey:KEY_ASSIGNED];
        [self ReloadDataOfTabbleSection:5];
        
        
    }else if ([strPlaceHolder isEqualToString:KEY_UNIT] && isUnits==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
    }else if ([strPlaceHolder isEqualToString:KEY_CUSTOM_TAG] && isCustomTag==YES)
    {
        currentText.text=[self PickerSlectedValues:selectedUnits];
        
        [self ReloadDataOfTabbleSection:3];
    }else if(isBoatUser)
    {
        currentText.text=[self PickerSlectedBoatUserValues:selectedUnits];
    }
}
-(NSString *)PickerSlectedBoatUserValues:(NSMutableDictionary *)pickerData
{
    @try {
        
        if ([pickerData isEqual:EMPTYSTRING] || pickerData.count==0) {
            
            return EMPTYSTRING;
        }
        
        NSArray *arrKeys=[pickerData allKeys];
        NSArray *arrValues=[pickerData allValues];
        
        NSString *values=EMPTYSTRING;
        
        for (int i=0; i<arrValues.count; i++) {
            
            if ([[arrValues objectAtIndex:i] intValue]==1){
                //if (i < arrValues.count-1 )
                values =[values stringByAppendingString:[NSString stringWithFormat:@"%@,", arrKeys[i] ] ];
            }
        }
        return values;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(NSString *)PickerSlectedValues:(NSMutableDictionary *)pickerData
{
    @try {
        
        if ([pickerData isEqual:EMPTYSTRING] || pickerData.count==0) {
            
            return EMPTYSTRING;
        }
        
        NSArray *arrKeys=[pickerData allKeys];
        NSArray *arrValues=[pickerData allValues];
        
        NSString *values=EMPTYSTRING;
        
        for (int i=0; i<arrValues.count; i++) {
            
            if ([[arrValues objectAtIndex:i] intValue]==1){
                if (i < arrValues.count-1 )
                    values =[values stringByAppendingString:[NSString stringWithFormat:@"%@,", arrKeys[i] ] ];
                else
                    values =[values stringByAppendingString:[NSString stringWithFormat:@"%@", arrKeys[i] ] ];
            }
        }
        [workOutDic setObject:[pickerData copy] forKey:strPlaceHolder];
        return values;
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
#pragma mark setcontent offset
-(void)setContaintOffset:(id)control
{
    UITextField *textfield;
    UITextView *textView;
    if ([control isKindOfClass:[UITextField class]]) {
        textfield = (UITextField *)control;
        
        [UIView animateWithDuration:.29f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            tableview.contentOffset = CGPointMake(0, textfield.frame.origin.y-(100));
        } completion:^(BOOL finish){}];
    }else if ([control isKindOfClass:[UITextView class]]) {
        textView = (UITextView *)control;
        [UIView animateWithDuration:.29f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            tableview.contentOffset = CGPointMake(0, textView.frame.origin.y-(10));
        } completion:^(BOOL finish){}];
    }
}


- (void)setContentOffsetDown:(id)textField table:(UITableView*)m_TableView {
    [m_TableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)setContentOffset:(id)textField table:(UITableView*)m_TableView {
    UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
    NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
    // Get the text fields location
    // CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:m_TableView];
    
    UITextField *txtField = (UITextField*)textField;
    
    if (scrollHeight == PickerHeight) {
        scrollHeight=KeyboardMinHeight;
    }
    
    int moveup = MIN(SCREEN_HEIGHT ,(scrollHeight+txtField.frame.size.height+(toolBarHeight+navBarHeight))) ;
    CGSize keyboardSize = CGSizeMake(320,moveup > 0 ? moveup : 0 );
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
- (void)moveUpSuggetionField:(id)textField table:(UITableView*)m_TableView {
    AddWorkOutCell *theTextFieldCell = (AddWorkOutCell *)[textField superview];
    NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
    // Get the text fields location
    CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:m_TableView];
    
    UITextField *txtField = (UITextField*)textField;
    if (scrollHeight==162) {
        scrollHeight=216;
    }
    
    int moveup = MIN(SCREEN_HEIGHT , point.y - (scrollHeight-txtField.frame.size.height)) ;
    CGSize keyboardSize = CGSizeMake(320,moveup > 0 ? moveup : 0 );
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
#pragma mark- UITextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    @try {
        isKeyBoard=FALSE;
        strPlaceHolder = nil;
        if (currentText !=nil && ![currentText.placeholder isEqualToString:BOATNAME_PLACEHOLDER]){
            [self doneClicked];
        }
        [self setContentOffset:textField table:tableview];
        currentText=textField;
        isExercise=[textField.placeholder isEqualToString:KEY_EXERCISE_TYPE] ? YES : NO ;
        isCustomTag=[textField.placeholder isEqualToString:KEY_CUSTOM_TAG] ? YES : NO ;
        isWorkOut=[textField.placeholder isEqualToString:KEY_WORKOUT_TYPE] ? YES : NO ;
        isLiftUnit=[textField.placeholder isEqualToString:STR_UNIT_DOT] ? YES : NO ;
        isLiftExerciseName=[textField.placeholder isEqualToString:PLACEHOLDER_NAME] ? YES : NO ;
        isBoats=[textField.placeholder isEqualToString:SETLINEUP_PLACEHOLDER] ? YES : NO ;
        isTime=([textField.placeholder isEqualToString:WARMUPTIME] || [textField.placeholder isEqualToString:COOLDOWNTIME]) ? YES : NO ;
        isBoatUser =([textField.placeholder isEqualToString:STR_ENTER_ATHLETENAME] || [textField.placeholder isEqualToString:STR_ENTER_GROUPNAME]) ? YES : NO ;
        
        if([textField.placeholder isEqualToString:@"Enter Tag Name"] || [textField.placeholder isEqualToString:KEY_EXERCISE_TYPE]  )
        {
            UIPickerView *picker =[[SingletonClass ShareInstance] AddPickerView:self.view];
            picker.delegate =self;
            [picker reloadComponent:0];
            textField.inputView = picker;
            return YES;
        }
        if([textField.placeholder isEqualToString:KEY_DESCRIPTION]||[textField.placeholder isEqualToString:KEY_UNIT] || [textField.placeholder isEqualToString:KEY_HASH_OF_INTERVAL])
        {
            if([textField.placeholder isEqualToString:KEY_HASH_OF_INTERVAL]  )
            {
                textField.keyboardType=UIKeyboardTypeNumberPad;
            }
        }
        if([textField.placeholder isEqualToString:KEY_WORKOUT_DATE]  )
        {
            [textField resignFirstResponder];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [self setDatePickerVisibleAt:YES];
            if(currentText.text.length==0)
                [self dateChange];
            return NO;
            
        }else if ([textField.placeholder isEqualToString:WARMUPTIME]|| [textField.placeholder isEqualToString:COOLDOWNTIME] || [textField.placeholder isEqualToString:KEY_TOTAL_TIME] )
        {
            [textField resignFirstResponder];
            if ([textField.placeholder isEqualToString:KEY_TOTAL_TIME]) {
                datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
                [self setDatePickerVisibleAt:YES];
                if(currentText.text.length==0)
                    [self dateChange];
            }else{
                
                if (arrTime.count==0) {
                    
                }else
                {
                    [listPicker reloadAllComponents];
                    [listPicker selectRow:0 inComponent:0 animated:YES];
                    [self setPickerVisibleAt:YES:arrTime];
                }
            }
            return NO;
        }
        if([textField.placeholder isEqualToString:KEY_WORKOUT_TYPE] ||  [textField.placeholder isEqualToString:STR_UNIT_DOT])
        {
            [textField resignFirstResponder];
            if([textField.placeholder isEqualToString:KEY_WORKOUT_TYPE]){
                // [listPicker reloadComponent:0];
                if (arrWorkOutList.count==0) {
                    
                }else
                {
                    [listPicker reloadAllComponents];
                    [listPicker selectRow:0 inComponent:0 animated:YES];
                    [self setPickerVisibleAt:YES:arrWorkOutList];
                }
            }else if ([textField.placeholder isEqualToString:STR_UNIT_DOT])
            {
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                if (arrLiftUnit.count==0) {
                }else
                {
                    [listPicker reloadAllComponents];
                    [listPicker selectRow:0 inComponent:0 animated:YES];
                    [self setPickerVisibleAt:YES:arrLiftUnit];
                    
                }
            }
            return NO;
        }
        
        // if condition for -> workout Type is Lift , then its components like textfield event
        // else conditon for textField placeholder is unit for other workout type
        
        if (([textField.placeholder isEqualToString:PLACEHOLDER_NAME] ||[textField.placeholder isEqualToString:STR_SETS]||[textField.placeholder isEqualToString:STR_REPS]||[textField.placeholder isEqualToString:STR_WEIGHT]) && arrLiftPlaceholder.count > 0) {
            
            isKeyBoard=TRUE;
            if ([textField.placeholder isEqualToString:PLACEHOLDER_NAME]) {
                
                /////
                [listPicker reloadAllComponents];
                [listPicker selectRow:0 inComponent:0 animated:YES];
                arrLiftExercise.count > 0 ? [self setPickerVisibleAt:YES:arrLiftExercise] : EMPTYSTRING;
                return NO;
                ////
                
            }else{
                
                textField.keyboardType=UIKeyboardTypeNumberPad;
            }
        }else if([textField.placeholder isEqualToString:KEY_UNIT]   )
        {
            [textField resignFirstResponder];
            
            [self selectUnits];
            
            return NO;
            
        }else if([textField.placeholder isEqualToString:KEY_CUSTOM_TAG]   )
        {
            [textField resignFirstResponder];
            
            if (arrCustomList.count == 0) {
                
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Please add custom tag first" delegate:nil btn1:@"Ok"];
            }else
            {
                [self selectCustomTags];
            }
            return NO;
        }
        if([textField.placeholder isEqualToString:SETLINEUP_PLACEHOLDER]   )
        {
            currentText = textField;
            UIPickerView *Picker = [[SingletonClass ShareInstance] AddPickerView:self.view];
            Picker.delegate = self;
            [self showSelectedValue :arrSetLineup :Picker];
            textField.inputView = Picker;
        }
        
        if ([textField.placeholder isEqualToString:STR_ENTER_ATHLETENAME] || [textField.placeholder isEqualToString:STR_ENTER_GROUPNAME]) {
            
            currentText =textField;
            [self fetchAthletesSynchronously];
            if (UnitsArray.count > 0) {
                [self setMultipleSlectionPicker:YES];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"No data found" delegate:nil btn1:@"Ok"];
            }
            
            return NO;
        }
        return YES;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:BOATNAME_PLACEHOLDER]) {
        if ([[workOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *arrtemp = [workOutDic valueForKey:STR_BOATS];
            arrtemp.count > textField.tag ? [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:textField.tag] setValue:textField.text forKey:STRKEY_BOATNAME] : @"";
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}

#pragma mark- UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return (arrFieldsPlaceholder.count);
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5 && [[[workOutDic valueForKey:EXERCISE_TYPE] lowercaseString] isEqualToString:[EXERCISE_ROWING lowercaseString]]) {
        
        return 1 + boatCount;
    }
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier =[NSString stringWithFormat:@"Cell%d %d",(int)(indexPath.section), (int)(indexPath.row)];
    AddWorkOutCell * cell=nil;
    
    if (cell == nil )
    {
        cell=[[AddWorkOutCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier indexPath:indexPath cellFields:arrFieldsPlaceholder liftFields:arrLiftPlaceholder:workOutDic:LiftExerciseCount:self];
        cell.delegate=self;
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:KEY_DESCRIPTION])
    {
        return isIPAD ? 110 : 80;
    }
    else if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:STR_EMAIL_NOTIFICATION]){
        return isIPAD ? 90 : 65.0;
    }
    else if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:STR_ATHLETES])
    {
        if ([[workOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]] && !(indexPath.row==0)) {
            NSMutableArray *arrTemp = [workOutDic valueForKey:STR_BOATS];
            if (arrTemp.count >= indexPath.row) {
                
                if (![[[[workOutDic valueForKey:STR_BOATS] objectAtIndex:indexPath.row-1] valueForKey:STRKEY_SETLINEUP] isEqualToString:EMPTYSTRING]) {
                    
                    return ((BOATCELL_INITIALHEIGHT) + (FIELD_GAP) + (TEXTFEILD_HEIGHT));
                }
                else
                    return BOATCELL_INITIALHEIGHT;
            }
            else
                return BOATCELL_INITIALHEIGHT;
        }
        else{
            return isIPAD ? 100 : 65.0;
        }
        
    }
    else if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:KEY_EXERCISE]){
        return isIPAD ? 160 : 120;
        
    }
    else{
        return isIPAD ? 80 : 50.0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark Web service Calling Method
-(void)getGroupsAthletes
{
    webservice =[WebServiceClass shareInstance];
    webservice.delegate = self;
    NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\"}",[UserInformation shareInstance].userSelectedTeamid];
    [webservice WebserviceCall:webserviceGetGroupsAthlete :strURL :GetGroupsAthletesTag];
    
}
-(void)getWorkOutList{
    
    @try {
        
        if ([SingletonClass  CheckConnectivity]) {
            
            UserInformation *userInfo=[UserInformation shareInstance];
            // [SingletonClass addActivityIndicator:self.view];
            NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceGetWorkOutdropdownList]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSMutableData *data = [NSMutableData data];
            
            [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
            [request setHTTPBody:data];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       
                                       if (data!=nil)
                                       {
                                           [self httpResponseReceived : data :GetWorkOutListTag];
                                       }else{
                                       }
                                   }];
        }else{
            
            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(void)getWorkOutUnit : (NSString *)WorkOutType : (NSString *)Exercise{
    
    if ([SingletonClass  CheckConnectivity]) {
        
        NSString *strURL = [NSString stringWithFormat:@"{\"workout_type\":\"%@\",\"excercise_type\":\"%@\"}",WorkOutType,Exercise];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceGetWorkOutUnitList]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *data = [NSMutableData data];
        
        [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
        [request setHTTPBody:data];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (data!=nil)
                                   {
                                       [self httpResponseReceived : data :GetWorkOutUnitTag];
                                   }else{
                                       [SingletonClass RemoveActivityIndicator:self.view];
                                   }
                               }];
    }else{
        
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}

#pragma mark Class Utility method
-(void)saveAthletesOrGroupsData:(UITextField *)textField
{
    @try {
        if ([textField.placeholder isEqualToString:STR_ENTER_GROUPNAME] ) {
            //NSMakeRange method used for remove , at the last position of string otherwise one blank object added in arry
            NSString *strAthletes =  textField.text;
            NSArray *componentsString = [strAthletes componentsSeparatedByString:@","];
            strAthletes = componentsString.count > 1 ? [textField.text stringByReplacingCharactersInRange:NSMakeRange(textField.text.length-1, 1) withString:@""] : textField.text;
            componentsString = strAthletes.length > 0 ?[strAthletes componentsSeparatedByString:@","] : @[];
            
            [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:textField.tag] setValue:componentsString forKey:STR_GROUPS];
        }
        else if([textField.placeholder isEqualToString:STR_ENTER_ATHLETENAME])
        {
            //NSMakeRange method used for remove , at the last position of string otherwise one blank object added in arry
            NSString *strAthletes =  textField.text;
            NSArray *componentsString = [strAthletes componentsSeparatedByString:@","];
            strAthletes = componentsString.count > 1 ? [textField.text stringByReplacingCharactersInRange:NSMakeRange(textField.text.length-1, 1) withString:@""] : textField.text;
            componentsString =strAthletes.length > 0 ? [strAthletes componentsSeparatedByString:@","] : @[];
            
            [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:textField.tag] setValue:componentsString forKey:STR_ATHLETES];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
-(void)unCheckedAthleteOrGroupStatus :(NSString *)uncheckValue :(int)index
{
    @try {
        NSMutableArray *arrtemp = [workOutDic valueForKey:STR_BOATS];
        NSString *strSetLineUp = [[arrtemp objectAtIndex:index] valueForKey:STRKEY_SETLINEUP];
        if ([strSetLineUp isEqualToString:STR_SELECTATHLETES]) {
            
            NSArray *arrAthleteData = [GroupsAthleteDic valueForKey:ATHLETEDATA] ;
            for (int j=0; j< arrAthleteData.count; j++) {
                NSString *strAthletenameFromData = [[arrAthleteData objectAtIndex:j] valueForKey:ATHLETE_NAME];
                if ([uncheckValue isEqualToString:strAthletenameFromData]) {
                    
                    // Update status of AthleteName data
                    [[[GroupsAthleteDic valueForKey:ATHLETEDATA] objectAtIndex:j] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
                    
                }
            }
            ////////// Update status of groupdata if athlete exist in group ///////////////
            
            NSArray *arrGroupData = [GroupsAthleteDic valueForKey:GROUPDATA];
            for (int i=0; i< arrGroupData.count; i++) {
                
                NSArray *arrMember = [[[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:i] valueForKey:KEY_GROUPMEMBERS] allKeys] ;
                int selectedCountInGroup = 0;
                for (int j=0; j< arrMember.count; j++) {
                    
                    NSArray *arrAthleteData = [GroupsAthleteDic valueForKey:ATHLETEDATA] ;
                    
                    for (int m=0; m< arrAthleteData.count; m++) {
                        
                        NSString *strAthletenameFromData = [[arrAthleteData objectAtIndex:m] valueForKey:ATHLETE_NAME];
                        
                        if ((([[arrMember objectAtIndex:j] isEqualToString:strAthletenameFromData] ) && ([[arrAthleteData objectAtIndex:m] valueForKey:IS_SELECTED] == [NSNumber numberWithBool:NO]))) {
                            // set is_selected no if all group member not selected
                            selectedCountInGroup = selectedCountInGroup+1;
                        }
                    }
                    
                }
                
                if (selectedCountInGroup == arrMember.count) {
                    [[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
                }
                
            }
        }
        else  if ([strSetLineUp isEqualToString:STR_SELECTFROMGROUPS]){
            NSArray *arrGroupData = [GroupsAthleteDic valueForKey:GROUPDATA] ;
            for (int j=0; j< arrGroupData.count; j++) {
                NSString *strAthletenameFromData = [[arrGroupData objectAtIndex:j] valueForKey:KEY_NAME];
                if ([uncheckValue isEqualToString:strAthletenameFromData]) {
                    
                    // Update status of AthleteName data
                    [[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:j] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
                    NSArray *arrMember = [[[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:j] valueForKey:KEY_GROUPMEMBERS] allKeys] ;
                    for (int k=0; k< arrMember.count; k++) {
                        
                        NSArray *arrAthleteData = [GroupsAthleteDic valueForKey:ATHLETEDATA] ;
                        
                        for (int m=0; m< arrAthleteData.count; m++) {
                            
                            NSString *strAthletenameFromData = [[arrAthleteData objectAtIndex:m] valueForKey:ATHLETE_NAME];
                            
                            if ((([[arrMember objectAtIndex:k] isEqualToString:strAthletenameFromData] ))) {
                                [[[GroupsAthleteDic valueForKey:ATHLETEDATA] objectAtIndex:m] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
-(void)checkedAthleteOrGroupStatus:(NSString *)checkValue
{
    @try {
        if ([currentText.placeholder isEqualToString:STR_ENTER_ATHLETENAME]) {
            NSArray *arrAthleteData = [GroupsAthleteDic valueForKey:ATHLETEDATA] ;
            for (int i=0; i< arrAthleteData.count; i++) {
                NSString *strAthletename = [[arrAthleteData objectAtIndex:i] valueForKey:ATHLETE_NAME];
                if ([strAthletename isEqualToString:checkValue]) {
                    // Update status of AthleteName data
                    [[[GroupsAthleteDic valueForKey:ATHLETEDATA] objectAtIndex:i] setValue:[NSNumber numberWithBool:YES] forKey:IS_SELECTED];
                }
            }
            ////////// Update status of groupdata if athlete exist in group ///////////////
            NSArray *arrGroupData = [GroupsAthleteDic valueForKey:GROUPDATA];
            for (int i=0; i< arrGroupData.count; i++) {
                
                NSArray *arrMember = [[[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:i] valueForKey:KEY_GROUPMEMBERS] allKeys] ;
                
                for (int j=0; j< arrMember.count; j++) {
                    if ([[arrMember objectAtIndex:j] isEqualToString:checkValue]) {
                        
                        [[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:i] setValue:[NSNumber numberWithBool:YES] forKey:IS_SELECTED];
                    }
                    
                }
                
            }
            
            ////////////////////////////////////////
        }
        else  if ([currentText.placeholder isEqualToString:STR_ENTER_GROUPNAME]){
            
            NSArray *arrGroupData = [GroupsAthleteDic valueForKey:GROUPDATA] ;
            for (int j=0; j< arrGroupData.count; j++) {
                NSString *strGroupName = [[arrGroupData objectAtIndex:j] valueForKey:KEY_NAME];
                
                if ([strGroupName isEqualToString:checkValue]) {
                    //[[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:j] setValue:[NSNumber numberWithBool:YES] forKey:IS_SELECTED];
                    
                    NSArray *arrAthleteData = [GroupsAthleteDic valueForKey:ATHLETEDATA] ;
                    NSArray *arrMember = [[[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:j] valueForKey:KEY_GROUPMEMBERS] allKeys] ;
                    
                    for (int k=0; k< arrMember.count; k++) {
                        // set yes of Athlete
                        for (int l=0; l< arrAthleteData.count; l++) {
                            if ([[arrMember objectAtIndex:k] isEqualToString:[[arrAthleteData objectAtIndex:l] valueForKey:ATHLETE_NAME]]) {
                                
                                [[[GroupsAthleteDic valueForKey:ATHLETEDATA] objectAtIndex:l] setValue:[NSNumber numberWithBool:YES] forKey:IS_SELECTED];
                            }
                            
                        }
                        
                        // set yes of group where group member exists
                        for (int n=0; n< arrGroupData.count; n++) {
                            NSArray *arrSubMember = [[[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:n] valueForKey:KEY_GROUPMEMBERS] allKeys] ;
                            for (int nn=0; nn< arrSubMember.count; nn++) {
                                if ([[arrSubMember objectAtIndex:nn] isEqualToString:[arrMember objectAtIndex:k]]) {
                                    [[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:n] setValue:[NSNumber numberWithBool:YES] forKey:IS_SELECTED];
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)showSelectedValue :(NSArray *)data :(UIPickerView*)picker
{
    if (currentText.text.length > 0) {
        for (int i=0; i< data.count; i++) {
            if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                [picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
    
}

-(void)SetDicValue:(NSString*)key
{
    if ([key isEqualToString:STR_WHOLE_TEAM]) {
        [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
        [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
        [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
        [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
        [self setAllBoatDataNo];
    }
    else if ([key isEqualToString:STR_ATHLETES])
    {
        [workOutDic setObject:EMPTYSTRING forKey:STR_WHOLE_TEAM];
        [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
        [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
        [self setAllBoatDataNo];
    }
    else if ([key isEqualToString:STR_GROUPS])
    {
        [workOutDic setObject:EMPTYSTRING forKey:STR_WHOLE_TEAM];
        [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
        [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
        [self setAllBoatDataNo];
        
    }
    else if ([key isEqualToString:STR_BOATS])
    {
        [workOutDic setObject:EMPTYSTRING forKey:STR_WHOLE_TEAM];
        [workOutDic setObject:EMPTYSTRING forKey:STR_ATHLETES];
        [workOutDic setObject:EMPTYSTRING forKey:STR_GROUPS];
        NSMutableArray *arrBaots;
        if ([[workOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
            [[workOutDic valueForKey:STR_BOATS] addObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",STRKEY_BOATNAME,@"",STRKEY_SETLINEUP,@[@""],STR_ATHLETES,@[@""],STR_GROUPS, nil]];
        }else{
            arrBaots = [[NSMutableArray alloc] initWithObjects:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",STRKEY_BOATNAME,@"",STRKEY_SETLINEUP,@[@""],STR_ATHLETES,@[@""],STR_GROUPS, nil], nil];
            [workOutDic setObject:arrBaots forKey:STR_BOATS];
        }
        
    }
}
-(void)ReloadDataOfTabbleSection:(int)sectionIndex
{
    NSRange range = NSMakeRange(sectionIndex, sectionIndex);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [tableview reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}
- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [pickerView removeFromSuperview];
        pickerView=nil;
        if ((orientation==UIDeviceOrientationLandscapeRight || (orientation==UIDeviceOrientationLandscapeLeft))) {
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(512,1050, 1024, 216)];
        }else
        {
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height+350, self.view.frame.size.width, 216)];
        }
        pickerView.backgroundColor=[UIColor whiteColor];
        // pickerView.tag=-(MultipleSelectionPickerTag);
        pickerView.delegate=self;
        [self.view addSubview:pickerView];
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+500):toolBar];
        
    }
    [tableview reloadData];
}

-(void)Done
{
    [self Done:CGPointMake(self.view.frame.size.width, self.view.frame.size.height+50)];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self setContentOffsetDown:currentText table:tableview];
}
-(void)Done :(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [self.view viewWithTag:toolBar1Tag].center = point;
    [UIView commitAnimations];
}

-(void)saveDicData
{
    if ((currentText && (![currentText.placeholder isEqualToString:KEY_UNIT] && ![currentText.placeholder isEqualToString:KEY_CUSTOM_TAG] )) && (arrLiftPlaceholder.count ==0 || [currentText.placeholder isEqualToString:KEY_TOTAL_TIME]|| [currentText.placeholder isEqualToString:KEY_WORKOUT_NAME]|| [currentText.placeholder isEqualToString:KEY_WORKOUT_DATE] || [currentText.placeholder isEqualToString:KEY_DESCRIPTION]|| [currentText.placeholder isEqualToString:WARMUPTIME]|| [currentText.placeholder isEqualToString:COOLDOWNTIME] ))
    {
        [workOutDic setObject:currentText.text forKey:currentText.placeholder];
        
    }else if([currentText.placeholder isEqualToString:PLACEHOLDER_NAME] || [currentText.placeholder isEqualToString:STR_SETS] || [currentText.placeholder isEqualToString:STR_REPS]||[currentText.placeholder isEqualToString:STR_UNIT_DOT]||[currentText.placeholder isEqualToString:STR_WEIGHT]) {
        
        if ([currentText.placeholder isEqualToString:STR_UNIT_DOT]) {
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:KEY_UNIT];
        }else{
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:currentText.placeholder];
        }
        [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
    }
    if(([currentText.placeholder isEqualToString:KEY_WORKOUT_TYPE]  ) )
    {
        if (currentText.text.length > 0) {
            NSString *code= [self KeyForValue:KEY_WORKOUT_TYPE :currentText.text];
            [self getWorkOutUnit:code :EMPTYSTRING];
            [self ShowFieldsRegardingWorkOutType:currentText.text];
        }
        
    }else if([strPlaceHolder isEqualToString:STR_ATHLETES] || [strPlaceHolder isEqualToString:STR_GROUPS] )
    {
        // If nothing is selected from picker
        
        if ([[workOutDic objectForKey:STR_ATHLETES] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:STR_ATHLETES] ) {
            
            [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
        }
        if ([[workOutDic objectForKey:STR_GROUPS] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:STR_GROUPS] ) {
            [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
        }
    }
    if ((currentText) && !([currentText.placeholder isEqualToString:PLACEHOLDER_NAME]||[currentText.placeholder isEqualToString:STR_SETS] || [currentText.placeholder isEqualToString:STR_REPS]||[currentText.placeholder isEqualToString:STR_WEIGHT])) {
        
        [currentText resignFirstResponder];
        
    }
    currentText=nil;
}
-(void)doneClicked
{
    if ((currentText && (![currentText.placeholder isEqualToString:KEY_UNIT] && ![currentText.placeholder isEqualToString:KEY_CUSTOM_TAG] )) && (arrLiftPlaceholder.count ==0 || [currentText.placeholder isEqualToString:KEY_TOTAL_TIME]|| [currentText.placeholder isEqualToString:KEY_WORKOUT_NAME]|| [currentText.placeholder isEqualToString:KEY_WORKOUT_DATE] || [currentText.placeholder isEqualToString:KEY_DESCRIPTION]|| [currentText.placeholder isEqualToString:WARMUPTIME]|| [currentText.placeholder isEqualToString:COOLDOWNTIME] ))
    {
        [workOutDic setObject:currentText.text forKey:currentText.placeholder];
        
    }else if([currentText.placeholder isEqualToString:PLACEHOLDER_NAME] || [currentText.placeholder isEqualToString:STR_SETS] || [currentText.placeholder isEqualToString:STR_REPS]||[currentText.placeholder isEqualToString:STR_UNIT_DOT]||[currentText.placeholder isEqualToString:STR_WEIGHT]) {
        
        if ([currentText.placeholder isEqualToString:STR_UNIT_DOT]) {
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:KEY_UNIT];
        }else{
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:currentText.placeholder];
        }
        [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
    }
    
    if(([currentText.placeholder isEqualToString:KEY_EXERCISE_TYPE]  ) )
    {
        NSString *workoutType= [workOutDic valueForKey:KEY_WORKOUT_TYPE];
        NSString *code= [self KeyForValue:KEY_WORKOUT_TYPE :workoutType];
        
        NSString *ExerciseCode= [self KeyForValue:KEY_EXERCISE :currentText.text];
        
        [self getWorkOutUnit:code :ExerciseCode];
        
    }
    if(([currentText.placeholder isEqualToString:KEY_WORKOUT_TYPE]  ) )
    {
        if (currentText.text.length > 0) {
            if (isChangeWorkoutType==TRUE)
            {
                [workOutDic setValue:EMPTYSTRING forKey:KEY_EXERCISE_TYPE];
                NSString *code= [self KeyForValue:KEY_WORKOUT_TYPE :currentText.text];
                [self getWorkOutUnit:code :EMPTYSTRING];
                [self ShowFieldsRegardingWorkOutType:currentText.text];
                isChangeWorkoutType=FALSE;
            }
        }
        
    }else if([strPlaceHolder isEqualToString:STR_ATHLETES] || [strPlaceHolder isEqualToString:STR_GROUPS] )
    {
        // If nothing is selected from picker
        if ([[workOutDic objectForKey:STR_ATHLETES] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:STR_ATHLETES] ) {
            [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
        }
        
        if ([[workOutDic objectForKey:STR_GROUPS] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:STR_GROUPS] ) {
            
            [workOutDic setObject:STATUS_SELECTED forKey:STR_WHOLE_TEAM];
        }
    }
    
    if ((currentText) && !([currentText.placeholder isEqualToString:PLACEHOLDER_NAME]||[currentText.placeholder isEqualToString:STR_SETS] || [currentText.placeholder isEqualToString:STR_REPS]||[currentText.placeholder isEqualToString:STR_WEIGHT])) {
        [self setContentOffsetDown:currentText table:tableview];
    }else
    {
        
    }
    
    [UIView beginAnimations:@"tblMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.29f];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self setDatePickerVisibleAt:NO];
    [self setPickerVisibleAt:NO:arrTime];
    [self setMultipleSlectionPicker:NO];
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50)];
    
    [UIView commitAnimations];
    
    if ( isChangeWorkoutType==TRUE) {
        [self ShowFieldsRegardingWorkOutType:currentText.text];
        isChangeWorkoutType=FALSE;
    }
    
}

-(void)DeleteExistingFieldsRegardingWorkOutType : (NSString *)workOutType
{
    
    if ([workOutType isEqualToString:WORKOUTTYPE_CARDIO]) {
        [arrFieldsPlaceholder removeObject:KEY_EXERCISE_TYPE];
        [arrFieldsPlaceholder removeObject:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
        
    }else if ( [workOutType isEqualToString:WORKOUTTYPE_CORE])
    {
        [arrFieldsPlaceholder removeObject:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
    }else  if ( [workOutType isEqualToString:WORKOUTTYPE_STRETCHING] )
    {
        [arrFieldsPlaceholder removeObject:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_OHTER]) {
        
        [arrFieldsPlaceholder removeObject:KEY_EXERCISE_TYPE];
        [arrFieldsPlaceholder removeObject:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_OHTER]) {
        
        [arrFieldsPlaceholder removeObject:KEY_EXERCISE_TYPE];
        [arrFieldsPlaceholder removeObject:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_INTERVAL] ) {
        
        [arrFieldsPlaceholder removeObject:KEY_EXERCISE_TYPE];
        [arrFieldsPlaceholder removeObject:KEY_HASH_OF_INTERVAL];
        [arrFieldsPlaceholder removeObject:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_UNIT];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_HASH_OF_INTERVAL];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_LIFT]) {
        LiftExerciseCount=0;
        [arrFieldsPlaceholder removeObject:KEY_EXERCISE];
        [arrFieldsPlaceholder removeObject:KEY_TOTAL_TIME];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_EXERCISE];
        [workOutDic setObject:EMPTYSTRING forKey:KEY_TOTAL_TIME];
        [arrLiftPlaceholder removeAllObjects];
        
    }
    
    [tableview reloadData];
}

-(void)ShowFieldsRegardingWorkOutType : (NSString *)workOutType
{
    @try {
        
        if (![arrFieldsPlaceholder containsObject:KEY_EXERCISE_TYPE] && [workOutType isEqualToString:WORKOUTTYPE_CARDIO] )
        {   boatCount=0;
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [arrFieldsPlaceholder insertObject:KEY_EXERCISE_TYPE atIndex:4];
            [arrFieldsPlaceholder insertObject:KEY_UNIT atIndex:arrFieldsPlaceholder.count];
            
        }else  if ( [workOutType isEqualToString:WORKOUTTYPE_CORE] )
        {    boatCount=0;
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [arrFieldsPlaceholder insertObject:KEY_UNIT atIndex:arrFieldsPlaceholder.count];
        }else  if ( [workOutType isEqualToString:WORKOUTTYPE_STRETCHING] )
        {    boatCount=0;
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [arrFieldsPlaceholder insertObject:KEY_UNIT atIndex:arrFieldsPlaceholder.count];
            
        }else if ([workOutType isEqualToString:WORKOUTTYPE_OHTER]) {
            boatCount=0;
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [arrFieldsPlaceholder insertObject:KEY_EXERCISE_TYPE atIndex:4];
            [arrFieldsPlaceholder insertObject:KEY_UNIT atIndex:arrFieldsPlaceholder.count];
            
        }else if ([workOutType isEqualToString:WORKOUTTYPE_INTERVAL]) {
            boatCount=0;
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            [arrFieldsPlaceholder insertObject:KEY_EXERCISE_TYPE atIndex:4];
            [arrFieldsPlaceholder insertObject:KEY_UNIT atIndex:arrFieldsPlaceholder.count];
            [arrFieldsPlaceholder insertObject:KEY_HASH_OF_INTERVAL atIndex:arrFieldsPlaceholder.count-1];
            
        }else if ([workOutType isEqualToString:WORKOUTTYPE_LIFT]) {
            boatCount=0;
            [workOutDic setObject:EMPTYSTRING forKey:STR_BOATS];
            if (!isEditData) {
                [arrFieldsPlaceholder insertObject:KEY_EXERCISE atIndex:arrFieldsPlaceholder.count];
                if (arrLiftPlaceholder.count==0) {
                    [arrFieldsPlaceholder insertObject:KEY_TOTAL_TIME atIndex:arrFieldsPlaceholder.count-1];
                }
                [workOutDic setValue:EMPTYSTRING forKeyPath:KEY_TOTAL_TIME];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:EMPTYSTRING,PLACEHOLDER_NAME,EMPTYSTRING,STR_SETS,EMPTYSTRING,STR_REPS,EMPTYSTRING,STR_WEIGHT,EMPTYSTRING,STR_UNIT_DOT, nil];
                [arrLiftPlaceholder addObject:dic];
                dic=nil;
            }
            else{
                if (arrLiftPlaceholder.count==0) {
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:EMPTYSTRING,PLACEHOLDER_NAME,EMPTYSTRING,STR_SETS,EMPTYSTRING,STR_REPS,EMPTYSTRING,STR_WEIGHT,EMPTYSTRING,STR_UNIT_DOT, nil];
                    [arrLiftPlaceholder addObject:dic];
                    [workOutDic setValue:EMPTYSTRING forKeyPath:KEY_TOTAL_TIME];
                    dic=nil;
                    [arrFieldsPlaceholder insertObject:KEY_TOTAL_TIME atIndex:arrFieldsPlaceholder.count];
                }
                for (int i=0; i< arrLiftPlaceholder.count; i++) {
                    [arrFieldsPlaceholder insertObject:KEY_EXERCISE atIndex:arrFieldsPlaceholder.count];
                }
                isEditData=FALSE;
            }
        }
        [tableview reloadData];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [self.view viewWithTag:toolBarTag].center = point;
    [UIView commitAnimations];
}

-(void)setMultipleSlectionPicker :(BOOL)ShowHide
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {
        point.y=self.view.frame.size.height-(pickerView.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(pickerView.frame.size.height/2)-22)];
    }else{
        point.y=self.view.frame.size.height+(pickerView.frame.size.height/2);
    }
    pickerView.center = point;
    [UIView commitAnimations];
}
-(void)setDatePickerVisibleAt :(BOOL)ShowHide
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint Point;
    Point.x=self.view.frame.size.width/2;
    if (ShowHide) {
        Point.y=self.view.frame.size.height-(datePicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(Point.x,Point.y-(datePicker.frame.size.height/2)-22)];
        
    }else{
        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        Point.y=self.view.frame.size.height+(datePicker.frame.size.height/2);
    }
    [self.view viewWithTag:datePickerTag].center = Point;
    [UIView commitAnimations];
}

-(void)setPickerVisibleAt :(BOOL)ShowHide :(NSArray*)data
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    if (ShowHide) {
        if (currentText.text.length > 0) {
            for (int i=0; i< data.count; i++) {
                if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                    [listPicker selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }
        point.y=self.view.frame.size.height-(listPicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(listPicker.frame.size.height/2)-22)];
    }else{
        point.y=self.view.frame.size.height+(listPicker.frame.size.height/2);
    }
    [self.view viewWithTag:listPickerTag].center = point;
    [UIView commitAnimations];
}
-(void)dateChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if([currentText.placeholder isEqualToString:KEY_WORKOUT_DATE]  ){
        df.dateFormat = @"MMM-dd-YYYY";
        currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    }else if ([currentText.placeholder isEqualToString:KEY_TOTAL_TIME] ){
        if ( [currentText.placeholder isEqualToString:KEY_TOTAL_TIME]) {
            df.dateFormat = @"HH:mm";
            currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
            [currentText.text isEqualToString:@"00:00"] ? currentText.text=@"00:01":EMPTYSTRING;
        }
    }else if ([currentText.placeholder isEqualToString:@"Enter Tag Name"])
    {
    }
}

-(void)AthletesCheckBoxEvent:(id)sender
{
    currentText=nil;
    UIButton *btn=sender;
    if (btn.selected == YES) {
        return;
    }
    UITableViewCell *tableview1=(UITableViewCell *)[sender superview];
    NSArray *subview=[tableview1 subviews];
    for (int i=0 ;i < subview.count ;i++)
    {
        id temp=[subview objectAtIndex:i];
        if ([temp isKindOfClass:[UIButton class]])
        {
            UIButton *bb=temp;
            bb.selected=NO;
            [bb setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        }
    }
    if (btn.selected)
    {
        btn.selected=NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    }else
    {
        btn.selected=YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    }
    switch (btn.tag) {
        case 2000:
        {
            boatCount = 0;
            strPlaceHolder=STR_WHOLE_TEAM;
            [self SetDicValue:STR_WHOLE_TEAM];
            [self ReloadDataOfTabbleSection:5];
            break;
        }
        case 2001:
        {
            boatCount = 0;
            strPlaceHolder=STR_ATHLETES;
            [self SetDicValue:STR_ATHLETES];
            [self ReloadDataOfTabbleSection:5];
            break;
        }
        case 2002:
        {
            boatCount = 0;
            strPlaceHolder=STR_GROUPS;
            [self SetDicValue:STR_GROUPS];
            [self ReloadDataOfTabbleSection:5];
            break;
        }
        case 2003:
        {
            strPlaceHolder=STR_BOATS;
            [self SetDicValue:STR_BOATS];
            boatCount = 1;
            [self ReloadDataOfTabbleSection:5];
            break;
        }
        default:
            break;
            
    }
    isWholeTeam=[strPlaceHolder isEqualToString:STR_WHOLE_TEAM] ? YES : NO ;
    isAthletes=[strPlaceHolder isEqualToString:STR_ATHLETES] ? YES : NO ;
    isGroups=[strPlaceHolder isEqualToString:STR_GROUPS] ? YES : NO ;
    isBoats=[strPlaceHolder isEqualToString:STR_BOATS] ? YES : NO ;
    isUnits=[strPlaceHolder isEqualToString:KEY_UNIT] ? YES : NO ;
    isCustomTag=[strPlaceHolder isEqualToString:KEY_CUSTOM_TAG] ? YES : NO ;
    [self SetValuesforShowInMultiPicker];
    if (!(isWholeTeam ) && !(isBoats ) )
    {
        if ((UnitsArray.count > 0)) {
            [pickerView reloadAllComponents];
            [self setMultipleSlectionPicker:YES];
        }else
        {
            btn.selected=NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
            [SingletonClass initWithTitle:EMPTYSTRING message:[NSString stringWithFormat:@"NO %@",strPlaceHolder] delegate:nil btn1:@"Ok"];
        }
    }
}
-(void)selectUnits
{
    strPlaceHolder=KEY_UNIT;
    
    isWholeTeam=[strPlaceHolder isEqualToString:STR_WHOLE_TEAM] ? YES : NO ;
    isAthletes=[strPlaceHolder isEqualToString:STR_ATHLETES] ? YES : NO ;
    isGroups=[strPlaceHolder isEqualToString:STR_GROUPS] ? YES : NO ;
    isUnits=[strPlaceHolder isEqualToString:KEY_UNIT] ? YES : NO ;
    isCustomTag=[strPlaceHolder isEqualToString:KEY_CUSTOM_TAG] ? YES : NO ;
    [self SetValuesforShowInMultiPicker];
    [pickerView reloadAllComponents];
    [self setMultipleSlectionPicker:YES];
    
}
-(void)selectCustomTags
{
    strPlaceHolder=KEY_CUSTOM_TAG;
    isWholeTeam=[strPlaceHolder isEqualToString:STR_WHOLE_TEAM] ? YES : NO ;
    isAthletes=[strPlaceHolder isEqualToString:STR_ATHLETES] ? YES : NO ;
    isGroups=[strPlaceHolder isEqualToString:STR_GROUPS] ? YES : NO ;
    isUnits=[strPlaceHolder isEqualToString:KEY_UNIT] ? YES : NO ;
    isCustomTag=[strPlaceHolder isEqualToString:KEY_CUSTOM_TAG] ? YES : NO ;
    
    [self SetValuesforShowInMultiPicker];
    [pickerView reloadAllComponents];
    [self setMultipleSlectionPicker:YES];
}
-(void)SetValuesforShowInMultiPicker
{
    [UnitsArray removeAllObjects];
    [selectedUnits removeAllObjects];
    
    NSMutableDictionary *tempDic=[[NSMutableDictionary alloc] init];
    
    if (isWholeTeam) {
        
        [workOutDic setObject:@"1" forKey:KEY_ASSIGNED];
        
    }else if (isAthletes)
    {
        [workOutDic setObject:@"2" forKey:KEY_ASSIGNED];
        
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        if (tempDic.count > 0) {
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
            
        }else{
            [self getUnitArryValues :STR_ATHLETES];
        }
        
    }else if (isGroups)
    {
        [workOutDic setObject:@"3" forKey:KEY_ASSIGNED];
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        if (tempDic.count > 0) {
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
            
        }else{
            [self getUnitArryValues :STR_GROUPS];
        }
        
    }else if (isBoats)
    {
        [workOutDic setObject:@"4" forKey:KEY_ASSIGNED];
    }else if (isUnits)
    {
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        
        if (tempDic.count > 0) {
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
            
        }else{
            
            [self getUnitArryValues :KEY_UNIT];
        }
    }else if (isCustomTag)
    {
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        if (tempDic.count > 0) {
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
        }else{
            [self getUnitArryValues :KEY_CUSTOM_TAG];
        }
    }
}

-(void)getUnitArryValues : (NSString *)Key
{
    @try {
        if (isEditData && ![[objEditModeData valueForKey:Key] isEqual:EMPTYSTRING]) {
            [tableview reloadData];
            [UnitsArray removeAllObjects];
            [selectedUnits removeAllObjects];
        }
        NSDictionary *dic=[WebWorkOutData objectForKey:Key];
        NSArray *tempArr=[dic allValues];
        NSArray *tempKeys=[dic allKeys];
        for (id temp in tempArr) {
            [UnitsArray addObject:temp];
        }
        for (int i=0;i< UnitsArray.count;i++){
            // In Edit Mode
            if (isEditData && ![[objEditModeData valueForKey:Key] isEqual:EMPTYSTRING]) {
                NSArray *temp;
                if (![[objEditModeData valueForKey:Key] isEqual:EMPTYSTRING]) {
                    temp =[objEditModeData objectForKey:Key];
                }
                if (temp.count > 0) {
                    
                    if ([temp containsObject:[tempKeys objectAtIndex:i]] )
                    {
                        [selectedUnits setObject:[NSNumber numberWithBool:YES] forKey:[UnitsArray objectAtIndex:i]];
                        strPlaceHolder=Key;
                        NSString *str= [self PickerSlectedValues:selectedUnits];
                        NSLog(@"%@",str);
                    }else{
                        [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:[UnitsArray objectAtIndex:i]];
                        strPlaceHolder=Key;
                        NSString *str= [self PickerSlectedValues:selectedUnits];
                        NSLog(@"%@",str);
                    }
                }else{
                    strPlaceHolder=Key;
                    NSString *str= [self PickerSlectedValues:selectedUnits];
                    NSLog(@"%@",str);
                    [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:[UnitsArray objectAtIndex:i]];
                }
            }else{
                [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:[UnitsArray objectAtIndex:i]];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
#pragma mark CellDelegate method
-(void)setAllBoatDataNo
{
    NSMutableArray *arrAthleteData = [GroupsAthleteDic valueForKey:ATHLETEDATA];
    NSMutableArray *arrGroupData = [GroupsAthleteDic valueForKey:GROUPDATA];
    for (int i=0; i<arrAthleteData.count; i++) {
        [[[GroupsAthleteDic valueForKey:ATHLETEDATA] objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
    }
    for (int i=0; i<arrGroupData.count; i++) {
        [[[GroupsAthleteDic valueForKey:GROUPDATA] objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:IS_SELECTED];
    }
    
}
-(void)DisableEditing
{
    for (int row=1; row< boatCount; row++) {
        UITextField *textfield;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:5];
        UITableViewCell *cell=[tableview cellForRowAtIndexPath:newIndexPath];
        // cell.userInteractionEnabled = NO;
        NSArray *cellfields;
        if (iosVersion < 8) {
            cellfields=[cell subviews] ;
            cellfields=[[cellfields objectAtIndex:0] subviews];
        }else{
            cellfields=[cell subviews];
        }
        for (id obj in cellfields ) {
            if ([obj isKindOfClass:[UITextField class]]) {
                textfield=obj;
                textfield.backgroundColor = LightGrayColor;
                textfield.userInteractionEnabled = NO;
            }
            
            if ([obj isKindOfClass:[UIButton class]] && (row > 1)) {
                UIButton *btnfield=obj;
                btnfield.userInteractionEnabled = NO;
            }
        }
        
    }
    
}
-(void)addBoat:(id)sender{
    
    NSArray *arrBoats = [workOutDic valueForKey:STR_BOATS];
    if ((arrBoats.count > boatCount-1)) {
        NSDictionary *dicBoatData;
        dicBoatData = [arrBoats objectAtIndex:boatCount-1];
        NSString *strName = [dicBoatData valueForKey:STRKEY_BOATNAME];
        NSString *strSetLineup = [dicBoatData valueForKey:STRKEY_SETLINEUP];
        NSArray *arrType;
        if ([strSetLineup isEqualToString:STR_SELECTATHLETES])
            arrType = [dicBoatData valueForKey:STR_ATHLETES];
        else
            arrType = [dicBoatData valueForKey:STR_GROUPS];
        NSString *strType = arrType.count > 0 ? [arrType objectAtIndex:0] : @"";
        //Check for empty Text box
        NSString *strError = EMPTYSTRING;
        if(strName.length < 1 ){
            strError = @"Please enter boat name";
        }
        else if(strSetLineup.length < 1 ){
            strError = @"Please select setlineup";
        } else if(strType.length ==0 ){
            strError = @"Please select groups/athletes";
        }
        if(strError.length > 2 ){
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            return;
        }
    }
    boatCount = boatCount + 1;
    [self SetDicValue:STR_BOATS];
    [self ReloadDataOfTabbleSection:5];
    // [self DisableEditing];
}
-(void)deleteBoat:(id)sender{
    boatCount = boatCount > 0 ? boatCount - 1 : boatCount;
    UIButton *btn =sender;
    int index = btn.tag;
    if ([[workOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *arrtemp = [workOutDic valueForKey:STR_BOATS];
        NSString *strSetLineUp = [[arrtemp objectAtIndex:index] valueForKey:STRKEY_SETLINEUP];
        if ([strSetLineUp isEqualToString:STR_SELECTATHLETES]) {
            NSArray *arrAthletes = [[arrtemp objectAtIndex:index] valueForKey:STR_ATHLETES];
            for (int i=0; i<arrAthletes.count; i++) {
                
                [self unCheckedAthleteOrGroupStatus:[arrAthletes objectAtIndex:i]:index];
            }
        }
        else
        {
            NSArray *arrGroups = [[arrtemp objectAtIndex:index] valueForKey:STR_GROUPS];
            for (int i=0; i<arrGroups.count; i++) {
                
                [self unCheckedAthleteOrGroupStatus:[arrGroups objectAtIndex:i]:index];
            }
        }
        arrtemp.count > btn.tag ? [[workOutDic valueForKey:STR_BOATS] removeObjectAtIndex:btn.tag] : @"";
        
    }
    [self ReloadDataOfTabbleSection:5];
}
-(void)addCustomTag:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Add Custom Tag"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=AddcustomAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=KEY_CUSTOM_TAG;
    currentText=textField;
    [alertView show];
    alertView=nil;
}

-(void)addExercise:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Add Exercise Type"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=AddexerciseAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=KEY_EXERCISE_TYPE;
    currentText=textField;
    [alertView show];
    alertView=nil;
}
-(void)deleteExercise:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Remove Exercise Type"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Delete", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=DeleteexerciseAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=KEY_EXERCISE_TYPE;
    isWorkOut=NO;
    isExercise=YES;
    isCustomTag=NO;
    [listPickerRemoveTag reloadComponent:0];
    [textField setInputView:listPickerRemoveTag];
    if (iosVersion >= 8) {
        [listPickerRemoveTag removeFromSuperview];
    }
    [listPickerRemoveTag setBackgroundColor:[UIColor whiteColor] ];
    currentText=textField;
    [alertView show];
    alertView=nil;
}
-(void)deleteExerciseSection:(id)sender{
    UIButton *btn=sender;
    [arrFieldsPlaceholder removeObjectAtIndex:arrFieldsPlaceholder.count-1];
    [arrLiftPlaceholder removeObjectAtIndex:btn.tag];
    [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
    [tableview reloadData];
}
-(void)addExerciseSection:(id)sender{
    [self ShowFieldsRegardingWorkOutType:WORKOUTTYPE_LIFT];
}
-(NSString *)GetCode :(NSMutableDictionary *)pickerData :(NSString *)Tag
{
    @try {
        if ([pickerData isEqual:EMPTYSTRING] || pickerData.count==0) {
            return EMPTYSTRING;
        }
        NSArray *arrKeys=[pickerData allKeys];
        NSArray *arrValues;
        NSString *values=EMPTYSTRING;
        if ([pickerData allValues]) {
            arrValues=[pickerData allValues];
            for (int i=0; i<arrValues.count; i++) {
                if ([[arrValues objectAtIndex:i] intValue]==1){
                    if (i < arrValues.count){
                        values=[values stringByAppendingString:[self KeyForValue:Tag :[arrKeys objectAtIndex:i]] ];
                    }
                    values=[values stringByAppendingString:@","];
                }
            }
            if (values.length > 0) {
                values=[values stringByReplacingCharactersInRange:NSMakeRange(values.length-1, 1) withString:EMPTYSTRING];
            }
        }
        return values;
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}
-(NSString *)IdForValues :(NSDictionary *)dic :(NSString *)value{
    if (dic.count == 0) {
        return EMPTYSTRING;
    }
    NSArray *arrKeys = [dic allKeys];
    NSArray *arrValues = [dic allValues] ;
    NSString *KeyId = EMPTYSTRING;
    for (int i=0; i<arrValues.count; i++) {
        if ([[arrValues objectAtIndex:i] isEqualToString:value])
        {
            KeyId = [arrKeys objectAtIndex:i];
        }
    }
    return KeyId;
}
-(NSString *)KeyForValue :(NSString *)superKey :(NSString *)SubKey
{
    @try {
        if ([WebWorkOutData isEqual:EMPTYSTRING] || WebWorkOutData.count==0) {
            return EMPTYSTRING;
        }
        NSArray *arrValues;
        NSArray *arrkeys;
        [[WebWorkOutData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ?  arrValues=[[WebWorkOutData objectForKey:superKey] allValues] :EMPTYSTRING;
        [[WebWorkOutData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ? arrkeys=[[WebWorkOutData objectForKey:superKey] allKeys] : EMPTYSTRING;
        NSString *strValue=EMPTYSTRING;
        for (int i=0; i<arrValues.count; i++) {
            if ([[arrValues objectAtIndex:i] isEqualToString:SubKey]){
                strValue=[arrkeys objectAtIndex:i];
                break;
            }
        }
        return strValue;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

-(NSString *)ValueForKey :(NSString *)superKey :(NSString *)SubKey
{
    @try {
        if ([WebWorkOutData isEqual:EMPTYSTRING] || WebWorkOutData.count==0) {
            return EMPTYSTRING;
        }
        NSArray *arrValues;
        NSArray *arrkeys;
        [[WebWorkOutData objectForKey:superKey] isKindOfClass: [NSDictionary class]] ? arrValues =[[WebWorkOutData objectForKey:superKey] allValues] : EMPTYSTRING;
        [[WebWorkOutData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ? arrkeys=[[WebWorkOutData objectForKey:superKey] allKeys] : EMPTYSTRING;
        NSString *strValue=EMPTYSTRING;
        for (int i=0; i<arrValues.count; i++) {
            if ([[arrkeys objectAtIndex:i] isEqualToString:SubKey]){
                strValue=[arrValues objectAtIndex:i];
                break;
            }
        }
        return strValue;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
-(void)SaveWorkOutData:(id)sender{
    [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
    self.navigationItem.leftBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    @try {
        int assigned=[[workOutDic objectForKey:KEY_ASSIGNED] intValue];
        NSString *strAthletesIds=EMPTYSTRING,*strGroupsIds=EMPTYSTRING,*strWholeTeam=EMPTYSTRING;
        switch (assigned){
            case 1:{
                strWholeTeam=[workOutDic objectForKey:STR_WHOLE_TEAM];
                break;
            }
            case 2:{
                strAthletesIds=[self GetCode:[workOutDic objectForKey:STR_ATHLETES] :STR_ATHLETES];
                break;
            }
            case 3:{
                strGroupsIds=[self GetCode:[workOutDic objectForKey:STR_GROUPS] :STR_GROUPS];
                break;
            }
            default:
                break;
        }
        NSString *strCustomTagsIds=[self GetCode:[workOutDic objectForKey:KEY_CUSTOM_TAG] :KEY_CUSTOM_TAG];
        NSString *strExerciseIds=[self KeyForValue:KEY_EXERCISE :[workOutDic objectForKey:KEY_EXERCISE_TYPE]];
        NSString *strWorkOutTypeIds=[self KeyForValue:KEY_WORKOUT_TYPE :[workOutDic objectForKey:KEY_WORKOUT_TYPE]];
        NSString *strWorkOutName=[workOutDic objectForKey:KEY_WORKOUT_NAME];
        NSString *strWorkOutDate=[workOutDic objectForKey:KEY_WORKOUT_DATE];
        NSString *strWorkOutEmail=[[workOutDic valueForKey:STR_EMAIL_NOTIFICATION] isEqualToString: @"Yes"] ?[NSString stringWithFormat:@"%@",STATUS_SELECTED] :[NSString stringWithFormat:@"%@",@"0"];
        NSString *strWorkOutDes=[workOutDic objectForKey:KEY_DESCRIPTION];
        NSString *strWormUpTime=[workOutDic objectForKey:WARMUPTIME];
        strWormUpTime=[strWormUpTime stringByReplacingOccurrencesOfString:@"Minutes" withString:EMPTYSTRING];
        NSString *strCoolDownTime=[workOutDic objectForKey:COOLDOWNTIME];
        strCoolDownTime=[strCoolDownTime stringByReplacingOccurrencesOfString:@"Minutes" withString:EMPTYSTRING];
        
        NSString *strInterval=EMPTYSTRING;
        NSString *strUnitsIds=EMPTYSTRING;
        
        if ([[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_INTERVAL]) {
            
            if (![[workOutDic valueForKey:KEY_HASH_OF_INTERVAL] isKindOfClass:[NSNull class]]) {
                
                if([[workOutDic valueForKey:KEY_HASH_OF_INTERVAL] intValue ] < 2){
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Please Enter # of intervals greater than one" delegate:nil btn1:@"Ok"];
                    return;
                }else
                    strInterval=[NSString stringWithFormat:@"%@",[workOutDic valueForKey:KEY_HASH_OF_INTERVAL] ];
            }
        }
        NSString *strTotalTime=EMPTYSTRING;
        BOOL LiftExerciseStatus;
        
        if ([[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT]) {
            
            if (![[workOutDic valueForKey:KEY_TOTAL_TIME] isKindOfClass:[NSNull class]]) {
                strTotalTime=[NSString stringWithFormat:@"%@",[workOutDic valueForKey:KEY_TOTAL_TIME] ];
            }
            
            NSArray *arr = [workOutDic valueForKey:WORKOUTTYPE_LIFT];
            for (int i=0; i< arr.count ; i++) {
                NSString *strName = [[[workOutDic valueForKey:WORKOUTTYPE_LIFT] objectAtIndex:i] valueForKey:PLACEHOLDER_NAME];
                if (strName.length ==0) {
                    LiftExerciseStatus = FALSE ;
                }else{
                    LiftExerciseStatus = TRUE ;
                }
            }
            
        }else{
            strUnitsIds=[self GetCode:[workOutDic valueForKey:KEY_UNIT]:KEY_UNIT];
        }
        if (strWorkOutTypeIds.length > 0) {
            switch (1) {
                case 1:{
                    //Check for empty Text box
                    NSString *strError = EMPTYSTRING;
                    if(strWorkOutName.length < 1 ){
                        strError = @"Please enter workout name";
                    }
                    else if(strWorkOutDate.length < 1 ){
                        strError = @"Please enter workout date";
                    } else if(strWorkOutTypeIds.length < 1 ){
                        strError = @"Please enter workout type";
                    }else if((strUnitsIds.length < 1 ) && ![[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT]){
                        strError = @"Please select units";
                    }else if(assigned == 0 || ( [strAthletesIds isEqualToString:EMPTYSTRING] && assigned==2)||([strGroupsIds isEqualToString:EMPTYSTRING] && assigned==3) || ( [strWholeTeam isEqualToString:EMPTYSTRING] && assigned==1 ))
                    {
                        strError = @"Please select Athletes/Groups/WholeTeam ";
                    }else if(strWorkOutDes.length <  1){
                        strError = @"Please enter workout Description";
                    }else if(strInterval.length <  1 && [[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_INTERVAL] ){
                        strError = @"Please enter # of Interval";
                    }else if([[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT] && LiftExerciseStatus == FALSE){
                        strError = @"Please enter Exercise Name";
                    }
                    
                    if(strError.length > 2 ){
                        self.navigationItem.rightBarButtonItem.enabled=YES;
                        [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                        return;
                    }else{
                        
                        if ([SingletonClass  CheckConnectivity]) {
                            
                            [SingletonClass addActivityIndicator:self.view];
                            NSString *strWorkOutId=EMPTYSTRING;
                            if (objEditModeData) {
                                strWorkOutId=[objEditModeData valueForKey:KEY_WORKOUT_ID];
                            }
                            if ([[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_INTERVAL]) {
                                strInterval=[workOutDic objectForKey:KEY_HASH_OF_INTERVAL];
                            }
                            NSString *strURL =EMPTYSTRING;
                            if (![[workOutDic valueForKey:KEY_WORKOUT_TYPE] isEqual:WORKOUTTYPE_LIFT]) {
                                strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\",\"user_id\":\"%d\",\"user_type\":\"%d\",\"Workout Id\":\"%@\",\"Workout Name\":\"%@\",\"CoolDown Time\":\"%@\",\"WarmUp Time\":\"%@\",\"Custom Tags\":\"%@\",\"Description\":\"%@\",\"Email Notification\":\"%@\",\"Date\":\"%@\",\"Exercise Type\":\"%@\",\"Unit\":\"%@\",\"Workout Type\":\"%@\",\"assigned\":\"%d\",\"Athletes\":\"%@\",\"Groups\":\"%@\",\"Interval\":\"%@\"}",[UserInformation shareInstance].userSelectedTeamid,[UserInformation shareInstance].userSelectedSportid,[UserInformation shareInstance].userId,[UserInformation shareInstance].userType,strWorkOutId,strWorkOutName,strCoolDownTime,strWormUpTime,strCustomTagsIds,strWorkOutDes,strWorkOutEmail,strWorkOutDate,strExerciseIds,strUnitsIds,strWorkOutTypeIds,assigned,strAthletesIds,strGroupsIds,strInterval];
                                
                                [webservice WebserviceCall:webUrlAddWorkOut :strURL :AddWorkoutTag];
                                
                            }else{
                                
                                NSArray *tempLiftdata=[self LiftDataWithUnitCode:[workOutDic valueForKeyPath:WORKOUTTYPE_LIFT]];
                                
                                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userSelectedTeamid] forKey:KEY_TEAM_ID];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userSelectedSportid] forKey:KEY_SPORT_ID];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userId] forKey:KEY_USER_ID];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userType] forKey:KEY_USER_TYPE];
                                [dic setObject:strWorkOutId forKey:KEY_WORKOUT_ID];
                                [dic setObject:strWorkOutName forKey:KEY_WORKOUT_NAME];
                                [dic setObject:strCoolDownTime forKey:COOLDOWNTIME];
                                [dic setObject:strWormUpTime forKey:WARMUPTIME];
                                [dic setObject:strCustomTagsIds forKey:KEY_CUSTOM_TAG];
                                [dic setObject:strWorkOutDes forKey:KEY_DESCRIPTION];
                                [dic setObject:strWorkOutEmail forKey:STR_EMAIL_NOTIFICATION];
                                [dic setObject:strWorkOutDate forKey:KEY_DATE];
                                [dic setObject:strWorkOutTypeIds forKey:KEY_WORKOUT_TYPE];
                                [dic setObject:[NSString stringWithFormat:@"%d",assigned] forKey:KEY_ASSIGNED];
                                [dic setObject:strAthletesIds forKey:STR_ATHLETES];
                                [dic setObject:strGroupsIds forKey:STR_GROUPS];
                                [dic setObject:EMPTYSTRING forKey:WORKOUTTYPE_INTERVAL];
                                [dic setObject:EMPTYSTRING forKey:KEY_EXERCISE_TYPE];
                                [dic setObject:strTotalTime forKey:STR_LIFT_TOTAL_TIME];
                                
                                if (tempLiftdata) {
                                    [dic setObject:tempLiftdata forKey:WORKOUTTYPE_LIFT];
                                }else{
                                    
                                    [dic setObject:EMPTYSTRING forKey:WORKOUTTYPE_LIFT];
                                }
                                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
                                
                                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webUrlAddWorkOut]];
                                [request setHTTPMethod:@"POST"];
                                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                                
                                NSMutableData *data = [NSMutableData data];
                                
                                [data appendData:jsonData];
                                [request setHTTPBody:data];
                                [NSURLConnection sendAsynchronousRequest:request
                                                                   queue:[NSOperationQueue mainQueue]
                                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                           
                                                           if (data!=nil)
                                                           {
                                                               [self httpResponseReceived : data : AddWorkOutLiftTag];
                                                           }else{
                                                               self.navigationItem.leftBarButtonItem.enabled=YES;
                                                               self.navigationItem.rightBarButtonItem.enabled=YES;
                                                               [SingletonClass RemoveActivityIndicator:self.view];
                                                           }
                                                           
                                                       }];
                                
                            }
                            
                        }else{
                            self.navigationItem.rightBarButtonItem.enabled=YES;
                            
                            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
                        }
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
            
        }else{
            self.navigationItem.rightBarButtonItem.enabled=YES;
            
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Please select workout type" delegate:nil btn1:@"Ok"];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
-(NSMutableArray  *)LiftDataWithUnitCode:(NSMutableArray *)data{
    @try {
        
        for (int i=0 ; i< data.count ;i++){
            NSDictionary *temp=[data objectAtIndex:i];
            NSString *strvalue=[temp valueForKey:KEY_UNIT];
            NSString *code=[self KeyForValue:KEY_LIFT_UNIT :strvalue];
            [temp setValue:code forKey:KEY_UNIT];
            NSString *strId = [self IdForValues:LiftExerciseDic:[temp valueForKey:PLACEHOLDER_NAME]];
            [temp setValue:strId forKey:@"id"];
            [data replaceObjectAtIndex:i withObject:temp];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return data;
}
-(NSMutableArray  *)LiftDataWithUnitValue:(NSMutableArray *)data{
    for (int i=0 ; i< data.count ;i++){
        NSDictionary *temp=[data objectAtIndex:i];
        NSString *strvalue=[temp valueForKey:KEY_UNIT];
        NSString *code=[self ValueForKey:KEY_LIFT_UNIT :strvalue];
        [temp setValue:code forKey:KEY_UNIT];
        [data replaceObjectAtIndex:i withObject:temp];
    }
    return data;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // if(iosVersion <= 8)
    // [self setToolbarVisibleAt:CGPointMake(160, 600)];
    if (alertView.tag == AddcustomAlertTag && buttonIndex==1) {
        if (currentText.text.length > 0) {
            [SingletonClass addActivityIndicator:self.view];
            NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\",\"tag_name\":\"%@\"}",[UserInformation shareInstance].userSelectedTeamid,[UserInformation shareInstance].userSelectedSportid,currentText.text];
            [webservice WebserviceCall:webUrlAddCustomTag :strURL :AddCustomTag];
            
        }else{
        }
        
    }else if (alertView.tag ==DeletecustomAlertTag && buttonIndex==1){
        if ([arrCustomList containsObject:currentText.text]) {
            if (currentText.text.length > 0) {
                [self getWorkOutList];
                [SingletonClass addActivityIndicator:self.view];
                NSString *customId=[self KeyForValue:KEY_CUSTOM_TAG :currentText.text];
                NSString *strURL = [NSString stringWithFormat:@"{\"workoutcustom_id\":\"%@\"}",customId];
                [webservice WebserviceCall:webUrlDeleteCustomTag :strURL :DeleteCustomTag];
            }
        }else{
            [SingletonClass initWithTitle:EMPTYSTRING message:@"No Custom Tag Found!" delegate:nil btn1:@"Ok"];
        }
        
    }else if (alertView.tag == AddexerciseAlertTag && buttonIndex==1)
    {
        if (currentText.text.length > 0) {
            
            [SingletonClass addActivityIndicator:self.view];
            NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\",\"excercise_name\":\"%@\"}",[UserInformation shareInstance].userSelectedTeamid,[UserInformation shareInstance].userSelectedSportid,currentText.text];
            [webservice WebserviceCall:webUrlAddExerciseType :strURL :AddExerciseTypeTag];
        }
    }else if (alertView.tag ==DeleteexerciseAlertTag && buttonIndex==1)
    {
        if (currentText.text.length > 0){
            if ([arrExerciseType containsObject:currentText.text]) {
                //  [arrExerciseType removeObject:currentText.text];
                [self getWorkOutList];
                [SingletonClass addActivityIndicator:self.view];
                NSString *exerciseId=[self KeyForValue:KEY_EXERCISE :currentText.text];
                NSString *strURL = [NSString stringWithFormat:@"{\"workoutexcercise_id\":\"%@\"}",exerciseId];
                [webservice WebserviceCall:webUrlDeleteExerciseType :strURL :DeleteExerciseTypeTag];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"No Exercise Name Found!" delegate:nil btn1:@"Ok"];
            }
        }
    }else if(alertView.tag == AddWorkoutTag){
        
        if (buttonIndex == 0) {
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
}
-(void)deleteCustomTag:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Remove Custom Tag"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Delete", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=DeletecustomAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=KEY_CUSTOM_TAG;
    isWorkOut=NO;
    isExercise=NO;
    isCustomTag=YES;
    [listPickerRemoveTag reloadComponent:0];
    [textField setInputView:listPickerRemoveTag];
    
    if (iosVersion >=8) {
        [listPickerRemoveTag removeFromSuperview];
    }
    currentText=textField;
    // Add arrow image in textfield
    UIImage *image;
    
    image=[UIImage imageNamed:@"arrow.png"];
    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
    imageview.frame=CGRectMake(textField.frame.size.width-imageview.frame.size.width, textField.frame.origin.x,imageview.frame.size.width, imageview.frame.size.height);
    [textField addSubview:imageview];
    [alertView show];
}

-(void)EmailCheckBoxEvent:(id)sender
{
    
    UIButton *btn=sender;
    if (btn.tag==1000) {
        [workOutDic setObject:@"Yes" forKey:STR_EMAIL_NOTIFICATION];
    }else{
        [workOutDic setObject:@"No" forKey:STR_EMAIL_NOTIFICATION];
    }
    UITableViewCell *tableview1=(UITableViewCell *)[sender superview];
    NSArray *subview=[tableview1 subviews];
    for (int i=0 ;i < subview.count ;i++)
    {
        id temp=[subview objectAtIndex:i];
        if ([temp isKindOfClass:[UIButton class]])
        {
            UIButton *bb=temp;
            bb.selected=NO;
            [bb setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        }
    }
    if (btn.selected){
        btn.selected=NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    }else{
        btn.selected=YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchAthletesSynchronously
{
    @try {
        if ([currentText.placeholder isEqualToString:STR_ENTER_ATHLETENAME]) {
            [UnitsArray removeAllObjects];
            [selectedUnits removeAllObjects];
            // In Edit Mode
            if (currentText.text.length > 0) {
                NSArray *arrAthleteName = [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:currentText.tag] valueForKey:STR_ATHLETES];
                for (int i=0; i< arrAthleteName.count; i++) {
                    
                    [UnitsArray addObject:[arrAthleteName objectAtIndex:i]];
                    [selectedUnits setValue:[NSNumber numberWithBool:YES] forKey:[arrAthleteName objectAtIndex:i]];
                }
            }
            // In Add Mode
            NSArray *arrAthleteName = [GroupsAthleteDic valueForKey:ATHLETEDATA];
            for (int i=0; i< arrAthleteName.count; i++) {
                
                if([[arrAthleteName objectAtIndex:i] valueForKey:IS_SELECTED] == [NSNumber numberWithBool:NO]){
                    [UnitsArray addObject:[[arrAthleteName objectAtIndex:i] valueForKey:ATHLETE_NAME]];
                    [selectedUnits setValue:[NSNumber numberWithBool:NO] forKey:[[arrAthleteName objectAtIndex:i] valueForKey:ATHLETE_NAME]];
                }
            }
            [pickerView reloadAllComponents];
        }
        else  if ([currentText.placeholder isEqualToString:STR_ENTER_GROUPNAME]){
            [UnitsArray removeAllObjects];
            [selectedUnits removeAllObjects];
            if (currentText.text.length > 0) {
                NSArray *arrGroupName = [[[workOutDic valueForKey:STR_BOATS] objectAtIndex:currentText.tag] valueForKey:STR_GROUPS];
                for (int i=0; i< arrGroupName.count; i++) {
                    [UnitsArray addObject:[arrGroupName objectAtIndex:i]];
                    [selectedUnits setValue:[NSNumber numberWithBool:YES] forKey:[arrGroupName objectAtIndex:i]];
                }
            }
            NSArray *arrGroupName = [GroupsAthleteDic valueForKey:GROUPDATA];
            for (int i=0; i< arrGroupName.count; i++) {
                if([[arrGroupName objectAtIndex:i] valueForKey:IS_SELECTED] == [NSNumber numberWithBool:NO]){
                    [UnitsArray addObject:[[arrGroupName objectAtIndex:i] valueForKey:KEY_NAME]];
                    [selectedUnits setValue:[NSNumber numberWithBool:NO] forKey:[[arrGroupName objectAtIndex:i] valueForKey:KEY_NAME]];
                }
            }
            [pickerView reloadAllComponents];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
}

@end
