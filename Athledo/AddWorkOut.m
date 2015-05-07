//
//  AddWorkOut.m
//  Athledo
//
//  Created by Dinesh Kumar on 8/14/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "AddWorkOut.h"
#import "AddWorkOutCell.h"
#import "WorkOutHistory.h"
#import "WorkOutView.h"
#import "SingletonClass.h"

static int LiftExerciseCount=0;
@interface AddWorkOut ()
{
    NSMutableArray *arrFieldsPlaceholder;
    NSMutableArray *arrLiftPlaceholder;
    
    NSMutableArray *arrCustomTagsPlaceholder;
    
    NSMutableArray *arrExerciseType;
    NSArray *arrLiftUnit;
    NSMutableArray *arrCellHeight;
    
    NSMutableArray *arrWorkOutList;
    NSMutableArray *arrCustomList;
    NSMutableArray *UnitsArray;
    NSMutableDictionary *workOutDic;
    NSMutableDictionary *selectedUnits;
    NSMutableDictionary *WebWorkOutData;
    NSArray *arrTime;
    NSDictionary *LiftExerciseDic;
    NSArray *arrLiftExercise;
    
    int toolBarPosition;
    BOOL isKeyBoard;
    UITextField *currentText;
    UITextView *txtViewCurrent;
    
    BOOL isWorkOut;
    BOOL isExercise;
    BOOL isWholeTeam;
    BOOL isAthletes;
    BOOL isGroups;
    BOOL isUnits;
    BOOL isCustomTag;
    BOOL isLiftUnit;
    BOOL isLiftExerciseName;
    
    BOOL isEditData;
    
    BOOL isTime;
    
    NSString *strPlaceHolder;
    
    WebServiceClass *webservice;
    UIToolbar *toolBar;
    UIDeviceOrientation orientation;
    UIDeviceOrientation CurrentOrientation;
    
    
    
}

@end

@implementation AddWorkOut
@synthesize objEditModeData;

#pragma mark UIViewController lifecycle method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    self.title = NSLocalizedString(@"Workout", nil);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    arrLiftPlaceholder=[[NSMutableArray alloc] init];
    
    if (([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger)) {
        arrFieldsPlaceholder=[[NSMutableArray alloc] initWithObjects:@"Workout Name",@"Workout Date",@"Workout Type",@"Custom Tags",@"Athletes",@"Email Notification",@"Description",WARMUPTIME,COOLDOWNTIME, nil];
        //BTNSave
    }else{
        
        arrFieldsPlaceholder=[[NSMutableArray alloc] initWithObjects:@"Workout Name",@"Workout Date",@"Workout Type",@"Custom Tags",@"Email Notification",@"Description",WARMUPTIME,COOLDOWNTIME, nil];
    }
    
    arrLiftUnit=[[NSArray alloc] initWithObjects:@"lbs",@"kg",@"%of 1RM",@"N/A", nil];
    
    arrTime=[[NSArray alloc] initWithObjects:@"05",@"10",@"15",@"20",@"30",@"25",@"35",@"40",@"45",@"50",@"55", nil];
    
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
            
            switch ([[objEditModeData valueForKey:@"assigned"] intValue]) {
                case 1:
                {
                    [workOutDic setObject:@"1" forKey:@"Whole Team"];
                    [workOutDic setObject:EMPTYSTRING forKey:@"Athletes"];
                    [workOutDic setObject:EMPTYSTRING forKey:@"Groups"];
                    break;
                }
                case 2:
                {
                    [workOutDic setObject:[objEditModeData valueForKey:@"Athletes"] forKey:@"Athletes"];
                    [workOutDic setObject:EMPTYSTRING forKey:@"Whole Team"];
                    [workOutDic setObject:EMPTYSTRING forKey:@"Groups"];
                    break;
                }
                case 3:
                {
                    [workOutDic setObject:[objEditModeData valueForKey:@"Groups"] forKey:@"Groups"];
                    [workOutDic setObject:EMPTYSTRING forKey:@"Whole Team"];
                    [workOutDic setObject:EMPTYSTRING forKey:@"Athletes"];
                    break;
                }
                    
                default:
                    break;
            }
            
            
            [workOutDic setObject:[objEditModeData valueForKey:@"assigned"] forKey:@"assigned"];
            
            [workOutDic setObject:[[objEditModeData valueForKey:@"Email Notification"] intValue]== 1 ? @"Yes":@"No" forKey:@"Email Notification"];
            
            [workOutDic setObject:[[objEditModeData valueForKey:WARMUPTIME] intValue]==0 ? EMPTYSTRING:[[objEditModeData valueForKey:WARMUPTIME] stringByAppendingString:@" Minutes"] forKey:WARMUPTIME];
            
            [workOutDic setObject:[[objEditModeData valueForKey:COOLDOWNTIME] intValue]==0 ? EMPTYSTRING :[[objEditModeData valueForKey:COOLDOWNTIME] stringByAppendingString:@" Minutes"]forKey:COOLDOWNTIME];
            [workOutDic setObject:[objEditModeData valueForKey:@"Workout Name"] forKey:@"Workout Name"];
            [workOutDic setObject:[objEditModeData valueForKey:@"Date"] forKey:@"Workout Date"];
            [workOutDic setObject:[objEditModeData valueForKey:@"Description"] forKey:@"Description"];
            [workOutDic setObject:[objEditModeData valueForKey:@"Workout Type"] forKey:@"Workout Type"];
            [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
            
            if ([[objEditModeData valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_INTERVAL]) {
                
                [workOutDic setObject:[objEditModeData valueForKey:WORKOUTTYPE_INTERVAL] forKey:@"# of Intervals"];
                
            }else if ([[objEditModeData valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT])
            {
                [workOutDic setObject:[objEditModeData valueForKey:@"Lift Total Time"] forKey:@"Total Time"];
            }
            
            NSString *strtemp=[objEditModeData valueForKey:@"Workout Type"];
            
            if (strtemp.length > 0 && ![[objEditModeData valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT] ) {
                
                NSString *code= [objEditModeData valueForKey:@"workout_type_id"];
                NSString *exercise_id= [objEditModeData valueForKey:@"Exercise Type"];
                
                [self getWorkOutUnit:code :exercise_id];
                
                [self ShowFieldsRegardingWorkOutType:strtemp];
            }
        }else{
            // Whole team and email Yes is by default selected
            [workOutDic setObject:@"1" forKey:@"Whole Team"];
            [workOutDic setObject:EMPTYSTRING forKey:@"Athletes"];
            [workOutDic setObject:EMPTYSTRING forKey:@"Groups"];
            [workOutDic setObject:@"1" forKey:@"assigned"];
            [workOutDic setObject:@"Yes" forKey:@"Email Notification"];
            [workOutDic setObject:[Data copy] forKey:@"Custom Tags"];
            [workOutDic setObject:EMPTYSTRING forKey:@"Total Time"];
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
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
        //[self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height > 310 ? kbSize.width : kbSize.height+22))];
            
        }completion:^(BOOL finished){
            
        }];
        
    }];

    [self getWorkOutList];
    
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
        
        switch (Tag)
        {
            case AddCustomTag:
            {
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    [arrCustomList insertObject:currentText.text atIndex:0];
                    int customtagId=[[MyResults  objectForKey:DATA] intValue];
                    // add custom tag in dic for show in picker
                    NSArray *customTagValues;
                    NSArray *customTagKeys;
                    [[workOutDic objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]] ? customTagValues =[[workOutDic objectForKey:@"Custom Tags"] allValues] :EMPTYSTRING;
                    [[workOutDic objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]] ?customTagKeys =[[workOutDic objectForKey:@"Custom Tags"] allKeys] : EMPTYSTRING;
                    NSMutableDictionary *Tempdic=[[NSMutableDictionary alloc] init];
                    for (int i=0 ; i< customTagValues.count;i++) {
                        [Tempdic setObject:[customTagValues objectAtIndex:i] forKey:[customTagKeys objectAtIndex:i]];
                    }
                    [Tempdic setObject:@"0" forKey:currentText.text];
                    [workOutDic setObject:[Tempdic copy] forKey:@"Custom Tags"];
                    // add custom tag and its id  in dic for next use
                    NSArray *customTagValues1;
                    NSArray *customTagKeys1;
                    
                    [[WebWorkOutData objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]]  ? customTagValues1=[[WebWorkOutData objectForKey:@"Custom Tags"]  allValues] : EMPTYSTRING;
                    
                    [[WebWorkOutData objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]] ? customTagKeys1=[[WebWorkOutData objectForKey:@"Custom Tags"] allKeys] : EMPTYSTRING;
                    
                    NSMutableDictionary *Tempdic1=[[NSMutableDictionary alloc] init];
                    for (int i=0 ; i< customTagValues1.count;i++) {
                        
                        [Tempdic1 setObject:[customTagValues1 objectAtIndex:i] forKey:[customTagKeys1 objectAtIndex:i]];
                        
                    }
                    
                    [Tempdic1 setObject:currentText.text forKey:[NSString stringWithFormat:@"%d",customtagId]];
                    
                    [WebWorkOutData setObject:[Tempdic1 copy] forKey:@"Custom Tags"];
                    Tempdic1=nil;
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Custom tag has been added successfully" delegate:nil btn1:@"Ok"];
                    
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                
                break;
            }
            case DeleteCustomTag:
            {
                
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    [arrCustomList removeObject:currentText.text];
                    
                    NSArray *customTagValues=[[workOutDic objectForKey:@"Custom Tags"] allValues];
                    NSArray *customTagKeys=[[workOutDic objectForKey:@"Custom Tags"] allKeys];
                    NSMutableDictionary *Tempdic=[[NSMutableDictionary alloc] init];
                    for (int i=0 ; i< customTagValues.count;i++) {
                        
                        if (![[customTagKeys objectAtIndex:i] isEqualToString:currentText.text]) {
                            
                            [Tempdic setObject:[customTagValues objectAtIndex:i] forKey:[customTagKeys objectAtIndex:i]];
                        }
                    }
                    
                    [workOutDic setObject:[Tempdic copy] forKey:@"Custom Tags"];
                    Tempdic=nil;
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Custom tag has been removed successfully" delegate:nil btn1:@"Ok"];
                    
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                break;
            }
            case AddExerciseTypeTag:
            {
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    [arrExerciseType insertObject:currentText.text atIndex:0];
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Exercise Type has been added successfully" delegate:nil btn1:@"Ok"];
                    
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                
                break;
            } case DeleteExerciseTypeTag:
            {
                
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    [arrExerciseType removeObject:currentText.text];
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Exercise Type has been removed successfully" delegate:nil btn1:@"Ok"];
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
                }
                
                break;
            } case AddWorkoutTag:
            {
                
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been saved successfully" delegate:self btn1:@"OK" btn2:nil tagNumber:AddWorkoutTag];
                }else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
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
-(void)httpResponseReceived:(NSData *)webResponse : (int)Tag
{
    self.navigationItem.leftBarButtonItem.enabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    
    // Now remove the Active indicator
    [SingletonClass RemoveActivityIndicator:self.view];
    // Now we Need to decrypt data
    
    NSError *error=nil;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    if (Tag == GetWorkOutUnitTag)
    {
        if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS])
        {
            NSDictionary *tepm=[myResults  objectForKey:DATA];
            
            if (![tepm isEqual:EMPTYSTRING])
            {
                [WebWorkOutData setObject:[myResults  objectForKey:DATA] forKey:@"Unit"];
                if (isEditData) {
                    [self getUnitArryValues:@"Unit"];
                }
            }
        }
    }else if (Tag ==GetWorkOutListTag)
    {
        //First time we get these fields data-> Workout Unit ,WorkOut Type,Custom Tags Tag,liftUnits,groups,athletes
        if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS])
        {
            WebWorkOutData=[myResults  objectForKey:DATA];
             [[WebWorkOutData objectForKey:@"Lift Excercise"] isKindOfClass:[NSDictionary class]] ?  LiftExerciseDic=[WebWorkOutData objectForKey:@"Lift Excercise"] : EMPTYSTRING;
            LiftExerciseDic.count > 0 ? arrLiftExercise = [LiftExerciseDic allValues] : EMPTYSTRING ;
            NSArray *tempWorkout;
            [[WebWorkOutData objectForKey:@"Workout Type"] isKindOfClass:[NSDictionary class]] ?  tempWorkout=[[WebWorkOutData objectForKey:@"Workout Type"] allValues] : EMPTYSTRING;
            
            for (int i=0 ; i< tempWorkout.count;i++) {
                
                [arrWorkOutList addObject:[tempWorkout objectAtIndex:i]];
            }
            NSArray *customTags;
            NSArray *customKeys;
            [[WebWorkOutData objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]]  ? customTags=[[WebWorkOutData objectForKey:@"Custom Tags"]  allValues] : EMPTYSTRING;
            [[WebWorkOutData objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]] ? customKeys=[[WebWorkOutData objectForKey:@"Custom Tags"] allKeys] : EMPTYSTRING;
            NSMutableDictionary *Tempdic=[[NSMutableDictionary alloc] init];
            for (int i=0 ; i< customTags.count;i++) {
                
                @try {
                    
                    if (isEditData) {
                        
                        // In Edit mode objEditModeData object contails keys in string form that's for matching keys code
                        NSArray *temp=[objEditModeData objectForKey:@"Custom Tags"];
                        if ([temp containsObject:[customKeys objectAtIndex:i]] ) {
                            [Tempdic setObject:@"1" forKey:[customTags objectAtIndex:i]];
                            [workOutDic setObject:[ [workOutDic valueForKey :@"Custom Tags"] stringByAppendingFormat:@",%@", [customTags objectAtIndex:i] ] forKey:@"Custom Tags"];
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
                [workOutDic setObject:[Tempdic copy] forKey:@"Custom Tags"];
                Tempdic=nil;
            }
            // For delete funtionality of custom tag
            NSArray *customTag;
            [[WebWorkOutData objectForKey:@"Custom Tags"] isKindOfClass:[NSDictionary class]] ? customTag=[[WebWorkOutData objectForKey:@"Custom Tags"] allValues] : EMPTYSTRING;
            
            if (arrCustomList.count  >0 ) {
                
                [arrCustomList removeAllObjects];
            }
            
            for (int i=0 ; i< customTag.count;i++) {
                
                [arrCustomList addObject:[customTag objectAtIndex:i]];
            }
            // when at perticular key is no value in WebWorkOutData then allvalues method due to crash thats by use the method
            NSArray *ExerciseType;
            NSArray *Exerciseid;
            [[WebWorkOutData objectForKey:@"Exercise"] isKindOfClass:[NSDictionary class]] ?  ExerciseType =[[WebWorkOutData objectForKey:@"Exercise"] allValues] :EMPTYSTRING;
            [[WebWorkOutData objectForKey:@"Exercise"] isKindOfClass:[NSDictionary class]] ?  Exerciseid=[[WebWorkOutData objectForKey:@"Exercise"] allKeys] : EMPTYSTRING;
            BOOL ArrStatus=FALSE;
            if (arrExerciseType.count  >0 ) {
                ArrStatus=TRUE;
                [arrExerciseType removeAllObjects];
            }
            for (int i=0 ; i< ExerciseType.count;i++) {
                
                //if-> In Edit Mode
                if (isEditData) {
                    
                    NSString *excersisecode=[objEditModeData objectForKey:@"Exercise Type"];
                    
                    
                    if ([[Exerciseid objectAtIndex:i] isEqualToString:excersisecode] )
                    {
                        [workOutDic setObject:[ExerciseType objectAtIndex:i] forKey:@"Exercise Type"];
                    }
                    [arrExerciseType addObject:[ExerciseType objectAtIndex:i]];
                }else
                {
                    [arrExerciseType addObject:[ExerciseType objectAtIndex:i]];
                    
                }
            }
            
            //in Edit mode Athletes or groups values
            
            @try {
                if (isEditData) {
                    switch ([[objEditModeData valueForKey:@"assigned"] intValue]) {
                        case 1:
                        {
                            
                            break;
                        }
                        case 2:
                        {
                            [self getUnitArryValues :@"Athletes"];
                            
                            break;
                        }
                        case 3:
                        {
                            [self getUnitArryValues :@"Groups"];
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
        
        [[WebWorkOutData objectForKey:@"Lift Unit"] isKindOfClass:[NSDictionary class]] ? arrLiftUnit=[[WebWorkOutData objectForKey:@"Lift Unit"] allValues] :EMPTYSTRING;
        // IN Case Edit data
        if (isEditData) {
            
            if ([[objEditModeData valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT])
            {
                NSArray *tempLiftdata=[self LiftDataWithUnitValue:[objEditModeData valueForKey:WORKOUTTYPE_LIFT]];
                [arrLiftPlaceholder addObjectsFromArray:tempLiftdata];
                [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
                [self ShowFieldsRegardingWorkOutType:WORKOUTTYPE_LIFT];
            }
        }
        
    }else if (Tag ==AddWorkOutLiftTag)
    {
        if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS])
        {
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been saved successfully" delegate:self btn1:@"OK" btn2:nil tagNumber:AddWorkoutTag];
            
        }else{
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
        }
    }
}

#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isWorkOut) {
        return [arrWorkOutList count];
        
    }else  if (isLiftUnit)
    {
        return [arrLiftUnit count];
    }else  if (isCustomTag)
    {
        return [arrCustomList count];
    }else  if (isTime)
    {
        return [arrTime count];
    }else  if (isLiftExerciseName)
    {
        return [arrLiftExercise count];
    }else
    {
        return [arrExerciseType count];
    }
    
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    if (isWorkOut) {
        
        str= [arrWorkOutList objectAtIndex:row];
        
        if (currentText.text.length ==0) {
            isChangeWorkoutType=TRUE;
            currentText=[self TextfieldInCellAtSection:3];
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
        currentText.text.length==0 ? currentText.text=[[arrTime objectAtIndex:0] stringByAppendingString:@" Minutes"]:str;
    }else  if (isLiftExerciseName)
    {
        str = [arrLiftExercise objectAtIndex:row];
        currentText.text.length==0 ? currentText.text = str : EMPTYSTRING  ;
    }else
    {
        str = [arrExerciseType objectAtIndex:row];
        currentText.text.length==0 ? currentText.text=str : str;
    }
    
    
    NSArray *arr = [str componentsSeparatedByString:@"****"];
    
    return [arr objectAtIndex:0];
}

-(UITextField *)TextfieldInCellAtSection:(int)section
{
    UITextField *textfield;
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    
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
            
            return textfield;
            
        }
    }
    
    return textfield;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (isWorkOut) {
        
        if (currentText.text.length > 0) {
            
            [self DeleteExistingFieldsRegardingWorkOutType : currentText.text];
        }
        isChangeWorkoutType=TRUE;
        currentText=[self TextfieldInCellAtSection:3];
        currentText.text=[arrWorkOutList objectAtIndex:row];
        
    }else  if (isLiftUnit)
    {
        currentText.text=[arrLiftUnit objectAtIndex:row];
        
    }else  if (isCustomTag)
    {
        currentText.text=[arrCustomList objectAtIndex:row];
        
    }else  if (isTime)
    {
        currentText.text=[[arrTime objectAtIndex:row] stringByAppendingString:@" Minutes"];
    }else  if (isLiftExerciseName)
    {
        currentText.text=[arrLiftExercise objectAtIndex:row];
    }else
    {
        currentText.text=[arrExerciseType objectAtIndex:row];
        
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
            [selectedUnits setObject:[NSNumber numberWithBool:YES] forKey:key];
    else
        [selectedUnits setObject:[NSNumber numberWithBool:YES] forKey:[UnitsArray objectAtIndex:row]];
    
    
    [self saveMultiPickerValues];
    
    
}


- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    // Check whether all rows are unchecked or only one
    if (row == -1)
        for (id key in [selectedUnits allKeys])
            [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:key];
    else
        [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:[UnitsArray objectAtIndex:row]];
    
    
    [self saveMultiPickerValues];
    
    
    
}


-(void)saveMultiPickerValues
{
    if ([strPlaceHolder isEqualToString:@"Unit"] && isUnits==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
    }else if ([strPlaceHolder isEqualToString:@"Whole Team"] && isWholeTeam==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
        [workOutDic setObject:@"1" forKey:@"assigned"];
        
    }else if ([strPlaceHolder isEqualToString:@"Athletes"] && isAthletes==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
        [workOutDic setObject:@"2" forKey:@"assigned"];
        
    }else if ([strPlaceHolder isEqualToString:@"Groups"] && isGroups==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
        [workOutDic setObject:@"3" forKey:@"assigned"];
        
    }else if ([strPlaceHolder isEqualToString:@"Unit"] && isUnits==YES)
    {
        currentText.text = [self PickerSlectedValues:selectedUnits];
    }else if ([strPlaceHolder isEqualToString:@"Custom Tags"] && isCustomTag==YES)
    {
        currentText.text=[self PickerSlectedValues:selectedUnits];
        
        NSRange range = NSMakeRange(3, 3);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [tableview reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
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
            
            if ([[arrValues objectAtIndex:i] intValue]==1)
            {
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
- (void)setContentOffsetDown:(id)textField table:(UITableView*)m_TableView {
    
    [m_TableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)setContentOffset:(id)textField table:(UITableView*)m_TableView {
    
    
    UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
    
    NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
    
    // Get the text fields location
    CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:m_TableView];
    
    if (point.y > 250) {
        
        if (scrollHeight==0) {
            scrollHeight=216;
        }
    }
    CGSize keyboardSize = CGSizeMake(320,scrollHeight+44);
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


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    @try {
        isKeyBoard=FALSE;
        
        
        if (currentText) {
            [self doneClicked];
        }
        
        [self setContentOffset:textField table:tableview];
        currentText=textField;
        
        isExercise=[textField.placeholder isEqualToString:@"Exercise Type"] ? YES : NO ;
        isCustomTag=[textField.placeholder isEqualToString:@"Custom Tags"] ? YES : NO ;
        isWorkOut=[textField.placeholder isEqualToString:@"Workout Type"] ? YES : NO ;
        isLiftUnit=[textField.placeholder isEqualToString:@"Unit."] ? YES : NO ;
        isLiftExerciseName=[textField.placeholder isEqualToString:@"Name"] ? YES : NO ;
        isTime=([textField.placeholder isEqualToString:WARMUPTIME] || [textField.placeholder isEqualToString:COOLDOWNTIME]) ? YES : NO ;
        
        if([textField.placeholder isEqualToString:@"Enter Tag Name"] || [textField.placeholder isEqualToString:@"Exercise Type"]  )
        {
            [textField resignFirstResponder];
            [listPicker reloadComponent:0];
            [self setPickerVisibleAt:YES:arrExerciseType];
            
            return NO;
            
        }
        
        if([textField.placeholder isEqualToString:@"Description"]||[textField.placeholder isEqualToString:@"Unit"] || [textField.placeholder isEqualToString:@"# of Intervals"])
        {
            
            if([textField.placeholder isEqualToString:@"Description"]   )
            {
                
                
            }else  if([textField.placeholder isEqualToString:@"# of Intervals"]  )
            {
                textField.keyboardType=UIKeyboardTypeNumberPad;
                
            }
            
        }
        
        if([textField.placeholder isEqualToString:@"Workout Date"]  )
        {
            [textField resignFirstResponder];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [self setDatePickerVisibleAt:YES];
            if(currentText.text.length==0)
                [self dateChange];
            
            return NO;
            
        }else if ([textField.placeholder isEqualToString:WARMUPTIME]|| [textField.placeholder isEqualToString:COOLDOWNTIME] || [textField.placeholder isEqualToString:@"Total Time"] )
        {
            [textField resignFirstResponder];
            
            
            if ([textField.placeholder isEqualToString:@"Total Time"]) {
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
        if([textField.placeholder isEqualToString:@"Workout Type"] ||  [textField.placeholder isEqualToString:@"Unit."])
        {
            [textField resignFirstResponder];
            
            if([textField.placeholder isEqualToString:@"Workout Type"])
            {
                // [listPicker reloadComponent:0];
                if (arrWorkOutList.count==0) {
                    
                }else
                {
                    [listPicker reloadAllComponents];
                    [listPicker selectRow:0 inComponent:0 animated:YES];
                    [self setPickerVisibleAt:YES:arrWorkOutList];
                }
            }else if ([textField.placeholder isEqualToString:@"Unit."])
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
        
        if (([textField.placeholder isEqualToString:@"Name"] ||[textField.placeholder isEqualToString:@"Sets"]||[textField.placeholder isEqualToString:@"Reps"]||[textField.placeholder isEqualToString:@"Weight"]) && arrLiftPlaceholder.count > 0) {
            
            isKeyBoard=TRUE;
            if ([textField.placeholder isEqualToString:@"Name"]) {
                
                /////
                [listPicker reloadAllComponents];
                [listPicker selectRow:0 inComponent:0 animated:YES];
                arrLiftExercise.count > 0 ? [self setPickerVisibleAt:YES:arrLiftExercise] : EMPTYSTRING;
                return NO;
                ////
                
            }else{
                
                textField.keyboardType=UIKeyboardTypeNumberPad;
            }
        }else if([textField.placeholder isEqualToString:@"Unit"]   )
        {
            [textField resignFirstResponder];
            
            [self selectUnits];
            
            return NO;
            
        }else if([textField.placeholder isEqualToString:@"Custom Tags"]   )
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
        
        return YES;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:@"Email Notification"]|| [[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:@"Athletes"] || [[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:@"Exercise"]) {
        
        
        if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:@"Exercise"])
        {
            return isIPAD ? 160 : 120;
        }else{
            return isIPAD ? 100 : 70.0;
        }
    }else{
        
        if ([[arrFieldsPlaceholder objectAtIndex:indexPath.section] isEqualToString:@"Description"])
        {
            return isIPAD ? 110 : 80;
        }else
        {
            return isIPAD ? 80 : 50.0;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark Web service Calling Method
-(void)getWorkOutList{
    
    @try {
        
        if ([SingletonClass  CheckConnectivity]) {
            
            UserInformation *userInfo=[UserInformation shareInstance];
            [SingletonClass addActivityIndicator:self.view];
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
                                   // ...
                                   
                                   //NSLog(@"announcement response:%@",response);
                                   
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
    if ((currentText && (![currentText.placeholder isEqualToString:@"Unit"] && ![currentText.placeholder isEqualToString:@"Custom Tags"] )) && (arrLiftPlaceholder.count ==0 || [currentText.placeholder isEqualToString:@"Total Time"]|| [currentText.placeholder isEqualToString:@"Workout Name"]|| [currentText.placeholder isEqualToString:@"Workout Date"] || [currentText.placeholder isEqualToString:@"Description"]|| [currentText.placeholder isEqualToString:WARMUPTIME]|| [currentText.placeholder isEqualToString:COOLDOWNTIME] ))
    {
        [workOutDic setObject:currentText.text forKey:currentText.placeholder];
        
    }else if([currentText.placeholder isEqualToString:@"Name"] || [currentText.placeholder isEqualToString:@"Sets"] || [currentText.placeholder isEqualToString:@"Reps"]||[currentText.placeholder isEqualToString:@"Unit."]||[currentText.placeholder isEqualToString:@"Weight"]) {
        
        if ([currentText.placeholder isEqualToString:@"Unit."]) {
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:@"Unit"];
        }else{
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:currentText.placeholder];
        }
        [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
    }
    
    
    if(([currentText.placeholder isEqualToString:@"Workout Type"]  ) )
    {
        
        if (currentText.text.length > 0) {
            
            NSString *code= [self KeyForValue:@"Workout Type" :currentText.text];
            
            [self getWorkOutUnit:code :EMPTYSTRING];
            
            [self ShowFieldsRegardingWorkOutType:currentText.text];
            
            
            
        }
        
    }else if([strPlaceHolder isEqualToString:@"Athletes"] || [strPlaceHolder isEqualToString:@"Groups"] )
    {
        // If nothing is selected from picker
        
        if ([[workOutDic objectForKey:@"Athletes"] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:@"Athletes"] ) {
            
            [workOutDic setObject:@"1" forKey:@"Whole Team"];
        }
        
        if ([[workOutDic objectForKey:@"Groups"] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:@"Groups"] ) {
            
            [workOutDic setObject:@"1" forKey:@"Whole Team"];
        }
        
        
        
    }
    
    if ((currentText) && !([currentText.placeholder isEqualToString:@"Name"]||[currentText.placeholder isEqualToString:@"Sets"] || [currentText.placeholder isEqualToString:@"Reps"]||[currentText.placeholder isEqualToString:@"Weight"])) {
        
        [currentText resignFirstResponder];
        
    }
    currentText=nil;
    
}

-(void)doneClicked
{
    
    if ((currentText && (![currentText.placeholder isEqualToString:@"Unit"] && ![currentText.placeholder isEqualToString:@"Custom Tags"] )) && (arrLiftPlaceholder.count ==0 || [currentText.placeholder isEqualToString:@"Total Time"]|| [currentText.placeholder isEqualToString:@"Workout Name"]|| [currentText.placeholder isEqualToString:@"Workout Date"] || [currentText.placeholder isEqualToString:@"Description"]|| [currentText.placeholder isEqualToString:WARMUPTIME]|| [currentText.placeholder isEqualToString:COOLDOWNTIME] ))
    {
        [workOutDic setObject:currentText.text forKey:currentText.placeholder];
        
    }else if([currentText.placeholder isEqualToString:@"Name"] || [currentText.placeholder isEqualToString:@"Sets"] || [currentText.placeholder isEqualToString:@"Reps"]||[currentText.placeholder isEqualToString:@"Unit."]||[currentText.placeholder isEqualToString:@"Weight"]) {
        
        //NSLog(@"tag %d",currentText.tag);
        
        if ([currentText.placeholder isEqualToString:@"Unit."]) {
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:@"Unit"];
        }else{
            
            [[arrLiftPlaceholder objectAtIndex:currentText.tag] setValue:currentText.text forKey:currentText.placeholder];
        }
        
        
        
        [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
    }
    
    if(([currentText.placeholder isEqualToString:@"Exercise Type"]  ) )
    {
        NSString *workoutType= [workOutDic valueForKey:@"Workout Type"];
        NSString *code= [self KeyForValue:@"Workout Type" :workoutType];
        
        NSString *ExerciseCode= [self KeyForValue:@"Exercise" :currentText.text];
        
        [self getWorkOutUnit:code :ExerciseCode];
        
    }
    if(([currentText.placeholder isEqualToString:@"Workout Type"]  ) )
    {
        if (currentText.text.length > 0) {
            if (isChangeWorkoutType==TRUE)
            {
                [workOutDic setValue:EMPTYSTRING forKey:@"Exercise Type"];
                NSString *code= [self KeyForValue:@"Workout Type" :currentText.text];
                [self getWorkOutUnit:code :EMPTYSTRING];
                [self ShowFieldsRegardingWorkOutType:currentText.text];
                isChangeWorkoutType=FALSE;
            }
        }
        
    }else if([strPlaceHolder isEqualToString:@"Athletes"] || [strPlaceHolder isEqualToString:@"Groups"] )
    {
        // If nothing is selected from picker
        if ([[workOutDic objectForKey:@"Athletes"] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:@"Athletes"] ) {
            [workOutDic setObject:@"1" forKey:@"Whole Team"];
        }
        
        if ([[workOutDic objectForKey:@"Groups"] isEqual:EMPTYSTRING] && [strPlaceHolder isEqualToString:@"Groups"] ) {
            
            [workOutDic setObject:@"1" forKey:@"Whole Team"];
        }
    }
    
    if ((currentText) && !([currentText.placeholder isEqualToString:@"Name"]||[currentText.placeholder isEqualToString:@"Sets"] || [currentText.placeholder isEqualToString:@"Reps"]||[currentText.placeholder isEqualToString:@"Weight"])) {
        [self setContentOffsetDown:currentText table:tableview];
    }else
    {
        
    }
    currentText=nil;
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
        [arrFieldsPlaceholder removeObject:@"Exercise Type"];
        [arrFieldsPlaceholder removeObject:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
        
    }else if ( [workOutType isEqualToString:WORKOUTTYPE_CORE])
    {
        [arrFieldsPlaceholder removeObject:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
    }else  if ( [workOutType isEqualToString:WORKOUTTYPE_STRETCHING] )
    {
        [arrFieldsPlaceholder removeObject:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_OHTER]) {
        
        [arrFieldsPlaceholder removeObject:@"Exercise Type"];
        [arrFieldsPlaceholder removeObject:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_OHTER]) {
        
        [arrFieldsPlaceholder removeObject:@"Exercise Type"];
        [arrFieldsPlaceholder removeObject:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_INTERVAL] ) {
        
        [arrFieldsPlaceholder removeObject:@"Exercise Type"];
        [arrFieldsPlaceholder removeObject:@"# of Intervals"];
        [arrFieldsPlaceholder removeObject:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Unit"];
        [workOutDic setObject:EMPTYSTRING forKey:@"# of Intervals"];
        
    }else if ([workOutType isEqualToString:WORKOUTTYPE_LIFT]) {
        LiftExerciseCount=0;
        [arrFieldsPlaceholder removeObject:@"Exercise"];
        [arrFieldsPlaceholder removeObject:@"Total Time"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Exercise"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Total Time"];
        [arrLiftPlaceholder removeAllObjects];
        
    }
    
    [tableview reloadData];
}

-(void)ShowFieldsRegardingWorkOutType : (NSString *)workOutType
{
    @try {
        
        if (![arrFieldsPlaceholder containsObject:@"Exercise Type"] && [workOutType isEqualToString:WORKOUTTYPE_CARDIO] )
        {
            
            [arrFieldsPlaceholder insertObject:@"Exercise Type" atIndex:4];
            [arrFieldsPlaceholder insertObject:@"Unit" atIndex:arrFieldsPlaceholder.count];
            
        }else  if ( [workOutType isEqualToString:WORKOUTTYPE_CORE] )
        {
            [arrFieldsPlaceholder insertObject:@"Unit" atIndex:arrFieldsPlaceholder.count];
        }else  if ( [workOutType isEqualToString:WORKOUTTYPE_STRETCHING] )
        {
            [arrFieldsPlaceholder insertObject:@"Unit" atIndex:arrFieldsPlaceholder.count];
            
        }else if ([workOutType isEqualToString:WORKOUTTYPE_OHTER]) {
            
            [arrFieldsPlaceholder insertObject:@"Exercise Type" atIndex:4];
            [arrFieldsPlaceholder insertObject:@"Unit" atIndex:arrFieldsPlaceholder.count];
            
        }else if ([workOutType isEqualToString:WORKOUTTYPE_INTERVAL]) {
            
            [arrFieldsPlaceholder insertObject:@"Exercise Type" atIndex:4];
            [arrFieldsPlaceholder insertObject:@"Unit" atIndex:arrFieldsPlaceholder.count];
            [arrFieldsPlaceholder insertObject:@"# of Intervals" atIndex:arrFieldsPlaceholder.count-1];
            
        }else if ([workOutType isEqualToString:WORKOUTTYPE_LIFT]) {
            
            
            if (!isEditData) {
                
                [arrFieldsPlaceholder insertObject:@"Exercise" atIndex:arrFieldsPlaceholder.count];
                
                if (arrLiftPlaceholder.count==0) {
                    [arrFieldsPlaceholder insertObject:@"Total Time" atIndex:arrFieldsPlaceholder.count-1];
                }
                
                [workOutDic setValue:EMPTYSTRING forKeyPath:@"Total Time"];
                
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:EMPTYSTRING,@"Name",EMPTYSTRING,@"Sets",EMPTYSTRING,@"Reps",EMPTYSTRING,@"Weight",EMPTYSTRING,@"Unit.", nil];
                
                [arrLiftPlaceholder addObject:dic];
                
                dic=nil;
            }else{
                
                if (arrLiftPlaceholder.count==0) {
                    
                    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:EMPTYSTRING,@"Name",EMPTYSTRING,@"Sets",EMPTYSTRING,@"Reps",EMPTYSTRING,@"Weight",EMPTYSTRING,@"Unit.", nil];
                    
                    [arrLiftPlaceholder addObject:dic];
                    [workOutDic setValue:EMPTYSTRING forKeyPath:@"Total Time"];
                    
                    dic=nil;
                    [arrFieldsPlaceholder insertObject:@"Total Time" atIndex:arrFieldsPlaceholder.count];
                }
                for (int i=0; i< arrLiftPlaceholder.count; i++) {
                    
                    [arrFieldsPlaceholder insertObject:@"Exercise" atIndex:arrFieldsPlaceholder.count];
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
        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        point.y=self.view.frame.size.height+(pickerView.frame.size.height/2);
    }
    
    //    int tag=0;
    //
    //    if ((orientation==UIDeviceOrientationLandscapeRight || (orientation==UIDeviceOrientationLandscapeLeft)))
    //    {
    //        tag=-(MultipleSelectionPickerTag);
    //    }else{
    //
    //        MultipleSelectionPickerTag
    //    }
    
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
    
    
    if([currentText.placeholder isEqualToString:@"Workout Date"]  )
    {
        df.dateFormat = @"MMM-dd-YYYY";
        currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
        
    }else if ([currentText.placeholder isEqualToString:@"Total Time"] )
    {
        if ( [currentText.placeholder isEqualToString:@"Total Time"]) {
            
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
            strPlaceHolder=@"Whole Team";
            break;
        }
        case 2001:
        {
            strPlaceHolder=@"Athletes";
            break;
        }
        case 2002:
        {
            strPlaceHolder=@"Groups";
            break;
        }
        default:
            break;
    }
    
    isWholeTeam=[strPlaceHolder isEqualToString:@"Whole Team"] ? YES : NO ;
    isAthletes=[strPlaceHolder isEqualToString:@"Athletes"] ? YES : NO ;
    isGroups=[strPlaceHolder isEqualToString:@"Groups"] ? YES : NO ;
    isUnits=[strPlaceHolder isEqualToString:@"Unit"] ? YES : NO ;
    isCustomTag=[strPlaceHolder isEqualToString:@"Custom Tags"] ? YES : NO ;
    [self SetValuesforShowInMultiPicker];
    if (!isWholeTeam)
    {
        if ((UnitsArray.count > 0)) {
            [pickerView reloadAllComponents];
            [self setMultipleSlectionPicker:YES];
        }else
        {
            btn.selected=NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
            [SingletonClass initWithTitle:EMPTYSTRING message:[NSString stringWithFormat:@"NO %@",strPlaceHolder] delegate:nil btn1:@"OK"];
        }
    }
}
-(void)selectUnits
{
    strPlaceHolder=@"Unit";
    
    isWholeTeam=[strPlaceHolder isEqualToString:@"Whole Team"] ? YES : NO ;
    isAthletes=[strPlaceHolder isEqualToString:@"Athletes"] ? YES : NO ;
    isGroups=[strPlaceHolder isEqualToString:@"Groups"] ? YES : NO ;
    isUnits=[strPlaceHolder isEqualToString:@"Unit"] ? YES : NO ;
    isCustomTag=[strPlaceHolder isEqualToString:@"Custom Tags"] ? YES : NO ;
    [self SetValuesforShowInMultiPicker];
    [pickerView reloadAllComponents];
    [self setMultipleSlectionPicker:YES];
    
}
-(void)selectCustomTags
{
    strPlaceHolder=@"Custom Tags";
    isWholeTeam=[strPlaceHolder isEqualToString:@"Whole Team"] ? YES : NO ;
    isAthletes=[strPlaceHolder isEqualToString:@"Athletes"] ? YES : NO ;
    isGroups=[strPlaceHolder isEqualToString:@"Groups"] ? YES : NO ;
    isUnits=[strPlaceHolder isEqualToString:@"Unit"] ? YES : NO ;
    isCustomTag=[strPlaceHolder isEqualToString:@"Custom Tags"] ? YES : NO ;
    
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
        
        [workOutDic setObject:@"1" forKey:@"assigned"];
        [workOutDic setObject:@"1" forKey:@"Whole Team"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Athletes"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Groups"];
    }else if (isAthletes)
    {
        [workOutDic setObject:@"2" forKey:@"assigned"];
        
        [workOutDic setObject:EMPTYSTRING forKey:@"Whole Team"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Groups"];
        
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        if (tempDic.count > 0) {
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
            
        }else{
            [self getUnitArryValues :@"Athletes"];
        }
    }else if (isGroups)
    {
        [workOutDic setObject:@"3" forKey:@"assigned"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Whole Team"];
        [workOutDic setObject:EMPTYSTRING forKey:@"Athletes"];
        
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        if (tempDic.count > 0) {
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
            
        }else{
            [self getUnitArryValues :@"Groups"];
        }
    }else if (isUnits)
    {
        if (![[workOutDic objectForKey:strPlaceHolder] isEqual:EMPTYSTRING]) {
            
            tempDic=[workOutDic objectForKey:strPlaceHolder];
        }
        
        if (tempDic.count > 0) {
            
            [selectedUnits addEntriesFromDictionary:[workOutDic objectForKey:strPlaceHolder]];
            [UnitsArray addObjectsFromArray:[selectedUnits allKeys]];
            
        }else{
            
            [self getUnitArryValues :@"Unit"];
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
            
            [self getUnitArryValues :@"Custom Tags"];
            
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
                
            }else
            {
                
                [selectedUnits setObject:[NSNumber numberWithBool:NO] forKey:[UnitsArray objectAtIndex:i]];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)addCustomTag:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Add Custom Tag"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=AddcustomAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=@"Custom Tags";
    currentText=textField;
    [alertView show];
    alertView=nil;
}

-(void)addExercise:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Add Exercise Type"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Save", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=AddexerciseAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=@"Exercise Type";
    currentText=textField;
    [alertView show];
    alertView=nil;
}

-(void)deleteExercise:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Remove Exercise Type"
                              message:EMPTYSTRING
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Delete", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    alertView.tag=DeleteexerciseAlertTag;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder=@"Exercise Type";
    isWorkOut=NO;
    isExercise=YES;
    isCustomTag=NO;
    [listPickerRemoveTag reloadComponent:0];
    [textField setInputView:listPickerRemoveTag];
    
    if (iosVersion >=8) {
        [listPickerRemoveTag removeFromSuperview];
    }
    //textField.delegate=self;
    currentText=textField;
    
    [alertView show];
    alertView=nil;
    
    
    
}
-(void)deleteExerciseSection:(id)sender
{
    UIButton *btn=sender;
    //NSLog(@"btn tag %d",btn.tag);
    
    [arrFieldsPlaceholder removeObjectAtIndex:arrFieldsPlaceholder.count-1];
    [arrLiftPlaceholder removeObjectAtIndex:btn.tag];
    [workOutDic setObject:arrLiftPlaceholder forKey:WORKOUTTYPE_LIFT];
    [tableview reloadData];
    
}


-(void)addExerciseSection:(id)sender
{
    //UIButton *btn=sender;
    //NSLog(@"btn tag %d",btn.tag);
    
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
        
        //NSLog(@"code %@ ",[pickerData allValues]);
        
        if ([pickerData allValues]) {
            
            arrValues=[pickerData allValues];
            
            
            for (int i=0; i<arrValues.count; i++) {
                
                if ([[arrValues objectAtIndex:i] intValue]==1)
                {
                    if (i < arrValues.count)
                    {
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
-(NSString *)IdForValues :(NSDictionary *)dic :(NSString *)value
{
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
            
            if ([[arrValues objectAtIndex:i] isEqualToString:SubKey])
            {
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
            
            if ([[arrkeys objectAtIndex:i] isEqualToString:SubKey])
            {
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



-(void)SaveWorkOutData:(id)sender
{
    [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
    
    self.navigationItem.leftBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    
    @try {
        
        int assigned=[[workOutDic objectForKey:@"assigned"] intValue];
        NSString *strAthletesIds=EMPTYSTRING,*strGroupsIds=EMPTYSTRING,*strWholeTeam=EMPTYSTRING;
        switch (assigned)
        {
            case 1:
            {
                
                strWholeTeam=[workOutDic objectForKey:@"Whole Team"];
                
                break;
            }
            case 2:
            {
                strAthletesIds=[self GetCode:[workOutDic objectForKey:@"Athletes"] :@"Athletes"];
                //NSLog(@"unit %@",strAthletesIds);
                
                
                break;
            }
            case 3:
            {
                strGroupsIds=[self GetCode:[workOutDic objectForKey:@"Groups"] :@"Groups"];
                //NSLog(@"unit %@",strGroupsIds);
                
                break;
            }
            default:
                break;
        }
   
        NSString *strCustomTagsIds=[self GetCode:[workOutDic objectForKey:@"Custom Tags"] :@"Custom Tags"];
        NSString *strExerciseIds=[self KeyForValue:@"Exercise" :[workOutDic objectForKey:@"Exercise Type"]];
        NSString *strWorkOutTypeIds=[self KeyForValue:@"Workout Type" :[workOutDic objectForKey:@"Workout Type"]];
        NSString *strWorkOutName=[workOutDic objectForKey:@"Workout Name"];
        NSString *strWorkOutDate=[workOutDic objectForKey:@"Workout Date"];
        NSString *strWorkOutEmail=[[workOutDic valueForKey:@"Email Notification"] isEqualToString: @"Yes"] ?[NSString stringWithFormat:@"%@",@"1"] :[NSString stringWithFormat:@"%@",@"0"];
        NSString *strWorkOutDes=[workOutDic objectForKey:@"Description"];
        NSString *strWormUpTime=[workOutDic objectForKey:WARMUPTIME];
        strWormUpTime=[strWormUpTime stringByReplacingOccurrencesOfString:@"Minutes" withString:EMPTYSTRING];
        NSString *strCoolDownTime=[workOutDic objectForKey:COOLDOWNTIME];
        strCoolDownTime=[strCoolDownTime stringByReplacingOccurrencesOfString:@"Minutes" withString:EMPTYSTRING];
        
        NSString *strInterval=EMPTYSTRING;
        NSString *strUnitsIds=EMPTYSTRING;
        
        if ([[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_INTERVAL]) {
            
            if (![[workOutDic valueForKey:@"# of Intervals"] isKindOfClass:[NSNull class]]) {
                
                if([[workOutDic valueForKey:@"# of Intervals"] intValue ] < 2){
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    [SingletonClass initWithTitle:EMPTYSTRING message:@"Please Enter # of intervals greater than one" delegate:nil btn1:@"Ok"];
                    return;
                }else
                    
                    strInterval=[NSString stringWithFormat:@"%@",[workOutDic valueForKey:@"# of Intervals"] ];
            }
        }
        NSString *strTotalTime=EMPTYSTRING;
         BOOL LiftExerciseStatus;
        
        if ([[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT]) {
            
            if (![[workOutDic valueForKey:@"Total Time"] isKindOfClass:[NSNull class]]) {
                strTotalTime=[NSString stringWithFormat:@"%@",[workOutDic valueForKey:@"Total Time"] ];
            }
            
            NSArray *arr = [workOutDic valueForKey:WORKOUTTYPE_LIFT];
            for (int i=0; i< arr.count ; i++) {
                NSString *strName = [[[workOutDic valueForKey:WORKOUTTYPE_LIFT] objectAtIndex:i] valueForKey:@"Name"];
                if (strName.length ==0) {
                    LiftExerciseStatus = FALSE ;
                }else{
                     LiftExerciseStatus = TRUE ;
                }
            }
            
        }else
        {
            strUnitsIds=[self GetCode:[workOutDic valueForKey:@"Unit"]  :@"Unit"];
        }
        
        if (strWorkOutTypeIds.length > 0) {
            
            switch (1) {
                case 1:
                {
                    //Check for empty Text box
                    NSString *strError = EMPTYSTRING;
                    if(strWorkOutName.length < 1 )
                    {
                        strError = @"Please enter workout name";
                    }
                    else if(strWorkOutDate.length < 1 )
                    {
                        strError = @"Please enter workout date";
                    } else if(strWorkOutTypeIds.length < 1 )
                    {
                        strError = @"Please enter workout type";
                    }else if((strUnitsIds.length < 1 ) && ![[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT])
                    {
                        strError = @"Please select units";
                    }else if(assigned == 0 || ( [strAthletesIds isEqualToString:EMPTYSTRING] && assigned==2)||([strGroupsIds isEqualToString:EMPTYSTRING] && assigned==3) || ( [strWholeTeam isEqualToString:EMPTYSTRING] && assigned==1 ))
                    {
                        strError = @"Please select Athletes/Groups/WholeTeam ";
                    }else if(strWorkOutDes.length <  1)
                    {
                        strError = @"Please enter workout Description";
                    }else if(strInterval.length <  1 && [[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_INTERVAL] )
                    {
                        strError = @"Please enter # of Interval";
                    }else if([[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT] && LiftExerciseStatus == FALSE)
                    {
                        strError = @"Please enter Exercise Name";
                    }

                    if(strError.length > 2 )
                    {
                        self.navigationItem.rightBarButtonItem.enabled=YES;
                        [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                        return;
                    }else{
                        
                        if ([SingletonClass  CheckConnectivity]) {
                            
                            [SingletonClass addActivityIndicator:self.view];
                            
                            NSString *strWorkOutId=EMPTYSTRING;
                            if (objEditModeData) {
                                
                                strWorkOutId=[objEditModeData valueForKey:@"Workout Id"];
                            }
                            
                            if ([[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_INTERVAL]) {
                                
                                
                                strInterval=[workOutDic objectForKey:@"# of Intervals"];
                            }
                            NSString *strURL =EMPTYSTRING;
                            
                            if (![[workOutDic valueForKey:@"Workout Type"] isEqual:WORKOUTTYPE_LIFT]) {
                                
                                strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\",\"user_id\":\"%d\",\"user_type\":\"%d\",\"Workout Id\":\"%@\",\"Workout Name\":\"%@\",\"CoolDown Time\":\"%@\",\"WarmUp Time\":\"%@\",\"Custom Tags\":\"%@\",\"Description\":\"%@\",\"Email Notification\":\"%@\",\"Date\":\"%@\",\"Exercise Type\":\"%@\",\"Unit\":\"%@\",\"Workout Type\":\"%@\",\"assigned\":\"%d\",\"Athletes\":\"%@\",\"Groups\":\"%@\",\"Interval\":\"%@\"}",[UserInformation shareInstance].userSelectedTeamid,[UserInformation shareInstance].userSelectedSportid,[UserInformation shareInstance].userId,[UserInformation shareInstance].userType,strWorkOutId,strWorkOutName,strCoolDownTime,strWormUpTime,strCustomTagsIds,strWorkOutDes,strWorkOutEmail,strWorkOutDate,strExerciseIds,strUnitsIds,strWorkOutTypeIds,assigned,strAthletesIds,strGroupsIds,strInterval];
                                
                                [webservice WebserviceCall:webUrlAddWorkOut :strURL :AddWorkoutTag];
                                
                            }else{
                                
                                NSArray *tempLiftdata=[self LiftDataWithUnitCode:[workOutDic valueForKeyPath:WORKOUTTYPE_LIFT]];
                                
                                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userSelectedTeamid] forKey:@"team_id"];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userSelectedSportid] forKey:@"sport_id"];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userId] forKey:@"user_id"];
                                [dic setObject:[NSString stringWithFormat:@"%d",[UserInformation shareInstance].userType] forKey:@"user_type"];
                                [dic setObject:strWorkOutId forKey:@"Workout Id"];
                                [dic setObject:strWorkOutName forKey:@"Workout Name"];
                                [dic setObject:strCoolDownTime forKey:COOLDOWNTIME];
                                [dic setObject:strWormUpTime forKey:WARMUPTIME];
                                [dic setObject:strCustomTagsIds forKey:@"Custom Tags"];
                                [dic setObject:strWorkOutDes forKey:@"Description"];
                                [dic setObject:strWorkOutEmail forKey:@"Email Notification"];
                                [dic setObject:strWorkOutDate forKey:@"Date"];
                                [dic setObject:strWorkOutTypeIds forKey:@"Workout Type"];
                                [dic setObject:[NSString stringWithFormat:@"%d",assigned] forKey:@"assigned"];
                                [dic setObject:strAthletesIds forKey:@"Athletes"];
                                [dic setObject:strGroupsIds forKey:@"Groups"];
                                [dic setObject:EMPTYSTRING forKey:WORKOUTTYPE_INTERVAL];
                                [dic setObject:EMPTYSTRING forKey:@"Exercise Type"];
                                [dic setObject:strTotalTime forKey:@"Lift Total Time"];
                                
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
        
        //NSLog(@"Edit workout exception");
    }
    @finally {
    }
}

-(NSMutableArray  *)LiftDataWithUnitCode:(NSMutableArray *)data
{
    @try {
        for (int i=0 ; i< data.count ;i++)
        {
            NSDictionary *temp=[data objectAtIndex:i];
            
            NSString *strvalue=[temp valueForKey:@"Unit"];
            
            NSString *code=[self KeyForValue:@"Lift Unit" :strvalue];
            
            [temp setValue:code forKey:@"Unit"];
          
            NSString *strId = [self IdForValues:LiftExerciseDic:[temp valueForKey:@"Name"]];
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
-(NSMutableArray  *)LiftDataWithUnitValue:(NSMutableArray *)data
{
    for (int i=0 ; i< data.count ;i++)
    {
        NSDictionary *temp=[data objectAtIndex:i];
        
        NSString *strvalue=[temp valueForKey:@"Unit"];
        
        NSString *code=[self ValueForKey:@"Lift Unit" :strvalue];
        
        [temp setValue:code forKey:@"Unit"];
        
        [data replaceObjectAtIndex:i withObject:temp];
        
    }
    
    return data;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // if(iosVersion <= 8)
    // [self setToolbarVisibleAt:CGPointMake(160, 600)];
    
    if (alertView.tag == AddcustomAlertTag && buttonIndex==1) {
        
        if (currentText.text.length > 0) {
            
            [SingletonClass addActivityIndicator:self.view];
            
            NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\",\"tag_name\":\"%@\"}",[UserInformation shareInstance].userSelectedTeamid,[UserInformation shareInstance].userSelectedSportid,currentText.text];
            
            [webservice WebserviceCall:webUrlAddCustomTag :strURL :AddCustomTag];
            
        }else{
        }
        
    }else if (alertView.tag ==DeletecustomAlertTag && buttonIndex==1)
    {
        if ([arrCustomList containsObject:currentText.text]) {
            
            // [arrCustomList removeObject:currentText.text];
            if (currentText.text.length > 0) {
                
                [self getWorkOutList];
                [SingletonClass addActivityIndicator:self.view];
                NSString *customId=[self KeyForValue:@"Custom Tags" :currentText.text];
                
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
        if (currentText.text.length > 0)
        {
            if ([arrExerciseType containsObject:currentText.text]) {
                //  [arrExerciseType removeObject:currentText.text];
                [self getWorkOutList];
                [SingletonClass addActivityIndicator:self.view];
                NSString *exerciseId=[self KeyForValue:@"Exercise" :currentText.text];
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
            for (id object in arrController)
            {
                if ([object isKindOfClass:[WorkOutView class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            if (Status==FALSE)
            {
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
    textField.placeholder=@"Custom Tags";
    isWorkOut=NO;
    isExercise=NO;
    isCustomTag=YES;
    [listPickerRemoveTag reloadComponent:0];
    [textField setInputView:listPickerRemoveTag];
    
    if (iosVersion >=8) {
        [listPickerRemoveTag removeFromSuperview];
    }
    
    //textField.delegate=self;
    currentText=textField;
    // Add arrow image in textfield
    UIImage *image;
    
    image=[UIImage imageNamed:@"arrow.png"];
    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
    imageview.frame=CGRectMake(textField.frame.size.width-imageview.frame.size.width, textField.frame.origin.x,imageview.frame.size.width, imageview.frame.size.height);
    [textField addSubview:imageview];
    // textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView show];
    //alertView=nil;
    
}

-(void)EmailCheckBoxEvent:(id)sender
{
    
    UIButton *btn=sender;
    if (btn.tag==1000) {
        [workOutDic setObject:@"Yes" forKey:@"Email Notification"];
    }else{
        
        [workOutDic setObject:@"No" forKey:@"Email Notification"];
    }
    UITableViewCell *tableview1=(UITableViewCell *)[sender superview];
    
    NSArray *subview=[tableview1 subviews];
    
    
    for (int i=0 ;i < subview.count ;i++)
    {
        id temp=[subview objectAtIndex:i];
        
        if ([temp isKindOfClass:[UIButton class]])
        {
            UIButton *bb=temp;
            
            ////NSLog(@"check box tag %d",bb.tag);
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
    
}
//- (void)keyboardWillShow:(NSNotification *)sender
//{
//    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView animateWithDuration:duration animations:^{
//        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
//        [tableview setContentInset:edgeInsets];
//        [tableview setScrollIndicatorInsets:edgeInsets];
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)sender
//{
//    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView animateWithDuration:duration animations:^{
//        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
//        [tableview setContentInset:edgeInsets];
//        [tableview setScrollIndicatorInsets:edgeInsets];
//    }];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
