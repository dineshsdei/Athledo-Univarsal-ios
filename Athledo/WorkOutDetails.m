//
//  WorkOutDetails.m
//  Athledo
//
//  Created by Dinesh Kumar on 9/24/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WorkOutDetails.h"
#import "AddWorkOut.h"
#import "UIImageView+WebCache.h"
#import "WorkOutView.h"
#import "WorkOutDetailCell.h"

#define getDetailDataTag 510
#define deleteWorkoutTag 520
#define deleteNotificationTag 580
#define ReassignWorkoutTag 530
#define EditableDataTag 540
#define SaveDataTag 570

#define listPickerTag 550
#define toolBarTag 560


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
    
    BOOL isRate,isDistance,isTime,isSplit,isSelectAthlete;
    
    
    int ViewY;
    int isDate;
}

@end

@implementation WorkOutDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingaltonClass RemoveActivityIndicator:self.view];
    
    
    switch (Tag)
    {
        case deleteWorkoutTag:
        {
            [SingaltonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                
                
                [SingaltonClass initWithTitle:@"" message:@"Workout deleted successfully" delegate:self btn1:@"Ok" btn2:nil tagNumber:10];
            }else{
                
                [SingaltonClass initWithTitle:@"" message:@"Workout delete fail try again" delegate:nil btn1:@"Ok"];
            }
            
            
            break;
        }
        case ReassignWorkoutTag:
        {
            [SingaltonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                
                [SingaltonClass initWithTitle:@"" message:@"Workout has been reassigned successfully." delegate:nil btn1:@"Ok"];
                
            }else{
                
                [SingaltonClass initWithTitle:@"" message:@"Workout reassign fail try again" delegate:nil btn1:@"Ok"];
            }
            
            break;
        }
        case getDetailDataTag:
        {
            if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
                
                arrWorkOuts=[[MyResults valueForKey:@"data"] valueForKey:@"WorkoutAthlete"];
                
                for (int i=0; i< arrWorkOuts.count; i++) {
                    
                    NSArray *tempExercise=[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteExercise"];
                    
                    if ([UserInformation shareInstance].userType==1 && [[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
                        
                        
                        [arrAllAthlete addObject:[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteName"]];
                        
                    }
                    
                    
                    for (int j=0; j < tempExercise.count; j++) {
                        
                        [arrAthleteName addObject:[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteName"]];
                        [arrAthleteExerciseName addObject:[[tempExercise objectAtIndex:j] valueForKey:@"exerciseName"]];
                    }
                    
                    
                }
                
                
                
                if ([UserInformation shareInstance].userType==1 && [[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
                    
                    
                    //Reload table after select athlete name
                    
                    //arrAllAthlete=[[NSMutableArray alloc] init];
                    arrAllAthleteData=[[NSMutableArray alloc] init];
                    
                    // arrAllAthlete=[arrAthleteName copy];
                    arrAllAthleteData=[arrWorkOuts copy];
                    
                }else{
                    
                    [table reloadData];
                    
                }
                
                
                
                
            }else if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"] )
            {
                arrWorkOuts=[[MyResults valueForKey:@"data"] valueForKey:@"WorkoutAthlete"];
                
                for (int i=0; i< arrWorkOuts.count; i++) {
                    [self CalculateAVG :i];
                }
                
                [table reloadData];
                
            }else
            {
                
                arrWorkOuts=[[MyResults valueForKey:@"data"] valueForKey:@"WorkoutAthlete"];
                
                [table reloadData];
                
            }
            
            break;
        }
        case SaveDataTag:
        {
            // arrAssignedNames=[[NSArray alloc] initWithObjects:@"John Anderson",@"John smith", nil];
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                
                [SingaltonClass initWithTitle:@"" message:@"Workout details saved successfully" delegate:nil btn1:@"Ok"];
                
            }else{
                
                [SingaltonClass initWithTitle:@"" message:@"Fail try again!" delegate:nil btn1:@"Ok"];
            }
            
            
            break;
            
        }
            
        case deleteNotificationTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                // nothing doing here when notification response comes
            }
            
            break;
        }
            
            
    }
}

-(void)GetWorkoutData
{
    if ([SingaltonClass  CheckConnectivity]) {
        
        if (_obj) {
            
            NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"workout_id\":\"%d\",\"team_id\":\"%d\"}",[UserInformation shareInstance].userId,[UserInformation shareInstance].userType,[[_obj objectForKey:@"Workout Id"] intValue],[UserInformation shareInstance].userSelectedTeamid];
            //  NSString *strURL = [NSString stringWithFormat:@"{\"workout_id\":\"%d\",\"team_id\":\"%d\"}",[@"8" intValue],[@"13" intValue]];
            
            [SingaltonClass addActivityIndicator:self.view];
            
            [webservice WebserviceCall:WebServiceWorkoutDetails :strURL :getDetailDataTag];
        }
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}

- (void)viewDidLayoutSubviews {
    
}
-(void)viewWillAppear:(BOOL)animated
{
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnSave.titleLabel.textColor=[UIColor whiteColor];
    isDate=FALSE;
    isSelectAthlete=FALSE;
    
    self.title =@"Detail";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    _lblCreatedBy.font=Textfont;
    _lblMeOrALl.font=Textfont;
    _lblSeasion.font=Textfont;
    _lblWorkoutDate.font=Textfont;
    _lblWorkOutName.font=Textfont;
    _lblWorkoutType.font=Textfont;
    _txtViewDescription.font=Textfont;
    ViewY=self.view.frame.origin.y;
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
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
    
    _txtViewDescription.layer.borderWidth=.001;
    
    UIButton *btnDelete = [[UIButton alloc] initWithFrame: CGRectMake(50, 5, 44, 44)];
    UIImage *imageDelete=[UIImage imageNamed:@"deleteBtn.png"];
    [btnDelete addTarget:self action:@selector(DeleteWorkout:) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setImage:imageDelete forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemDelete = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
    
    
    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 44, 44)];
    UIImage *imageEdit=[UIImage imageNamed:@"edit.png"];
    [btnEdit addTarget:self action:@selector(EditWorkout:) forControlEvents:UIControlEventTouchUpInside];
    [btnEdit setImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemEdit = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    
    UIButton *btnReassign = [[UIButton alloc] initWithFrame:CGRectMake(130, 5, 44, 44)];
    UIImage *imageReassign=[UIImage imageNamed:@"reassign.png"];
    [btnReassign addTarget:self action:@selector(ReassignWorkout:) forControlEvents:UIControlEventTouchUpInside];
    [btnReassign setImage:imageReassign forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemReassign = [[UIBarButtonItem alloc] initWithCustomView:btnReassign];
    
    // [newView addSubview:btnReassign];
    //   [newView addSubview:btnDelete];
    //  [newView addSubview:btnEdit];
    
    
    if ([UserInformation shareInstance].userId == [[_obj  objectForKey:@"user_id"] intValue]) {
        
        //self.navigationItem.titleView=newView;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemEdit,BarItemReassign,BarItemDelete,nil];
    }
    if (_obj) {
        
        // _imgCreatedBy
        
        [_imgCreatedBy setImageWithURL:[NSURL URLWithString:[_obj valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        _imgCreatedBy.contentMode=UIViewContentModeScaleAspectFit;
        
        _lblCreatedBy.text=[_obj valueForKey:@"createdby"];
        _lblWorkOutName.text=[_obj valueForKey:@"Workout Name"];
        _lblSeasion.text=[[_obj valueForKey:@"season"] isEqualToString:@""] ? @"Off Season" :[_obj valueForKey:@"season"] ;
        _lblWorkoutType.text=[_obj valueForKey:@"Workout Type"];
        _lblWorkoutDate.text=[_obj valueForKey:@"Date"];
        _txtViewDescription.text=[_obj valueForKey:@"Description"];
        
        if ([UserInformation shareInstance].userType==1) {
            
            _lblMeOrALl.text=@"to all";
        }else{
            
            _lblMeOrALl.text=@"to me";
        }
        
    }
    
    if ([UserInformation shareInstance].userType==1 && [[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
        
        _tfSelectUserType.hidden=NO;
        _dropdownImageview.hidden=NO;
        arrAllAthlete=[[NSMutableArray alloc] init];
        
    }else{
        
        _tfSelectUserType.hidden=YES;
        _dropdownImageview.hidden=YES;
        
    }
    
    [self GetWorkoutData];
    
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(kbSize.height+22))];
        scrollHeight=kbSize.height;
        
        
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [self setPickerVisibleAt:NO:arrTime];
        [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        
    }];
    
    
    scrollHeight=0;
    
    [self setContentOffsetOfTableDown:currentText table:table];
    
    if (_NotificationStataus) {
        
        [self DeleteNotificationFromWeb];
    }
    
}

-(void)FilterDataAccourdingAthlete:(NSString *)athleteName
{
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
            
            if ([[[arrAllAthleteData objectAtIndex:i] valueForKey:@"athleteName"] isEqualToString:athleteName]) {
                
                NSArray *tempExercise=[[arrAllAthleteData objectAtIndex:i] valueForKey:@"athleteExercise"];
                
                for (int j=0; j < tempExercise.count; j++) {
                    
                    [arrAthleteName containsObject:athleteName] ? :[arrAthleteName addObject:athleteName];
                    
                    [arrAthleteExerciseName containsObject:[[tempExercise objectAtIndex:j] valueForKey:@"exerciseName"]] ? :[arrAthleteExerciseName addObject:[[tempExercise objectAtIndex:j] valueForKey:@"exerciseName"]];
                    
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

-(void)DeleteWorkout:(id)sender
{
    [SingaltonClass initWithTitle:@"" message: @"Do you want to delete workout ?" delegate:self btn1:@"NO" btn2:@"YES" tagNumber:1];
    
}
-(void)DeleteFromWeb
{
    if ([SingaltonClass  CheckConnectivity]) {
        
        if (_obj) {
            
            NSString *strURL = [NSString stringWithFormat:@"{\"workout_id\":\"%d\"}",[[_obj objectForKey:@"Workout Id"] intValue]];
            
            [SingaltonClass addActivityIndicator:self.view];
            
            [webservice WebserviceCall:webServiceDeleteWorkOut :strURL :deleteWorkoutTag];
        }
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}
-(void)DeleteNotificationFromWeb
{
    //NOTE ---  type=(1=>announcement, 2=>event, 3=>workout)
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        if (_obj) {
            
            UserInformation *userInfo= [UserInformation shareInstance];
            
            NSString *strURL = [NSString stringWithFormat:@"{\"type\":\"%d\",\"parent_id\":\"%d\",\"team_id\":\"%d\",\"user_id\":\"%d\"}",3,[[_obj objectForKey:@"Workout Id"] intValue],userInfo.userSelectedTeamid,userInfo.userId];
            
            [webservice WebserviceCall:webServiceDeleteNotification :strURL :deleteNotificationTag];
        }
        
    }else{
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && alertView.tag==1) {
        
        [SingaltonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
        
        [self DeleteFromWeb];
        
    }else  if (buttonIndex == 0 && alertView.tag==10){
        
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


-(void)EditWorkout:(id)sender
{
    if (_obj) {
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController)
        {
            
            if ([object isKindOfClass:[CalendarEvent class]])
            {
                Status=TRUE;
                AddWorkOut *edit=(AddWorkOut *)object;
                edit.objEditModeData=_obj;
                [self.navigationController popToViewController:edit animated:NO];
            }
        }
        
        if (Status==FALSE)
        {
            AddWorkOut *edit=[[AddWorkOut alloc] initWithNibName:@"AddWorkOut" bundle:nil];
            edit.objEditModeData=_obj;
            [self.navigationController pushViewController:edit animated:NO];
            
        }
        
    }
    
}
-(void)ReassignWorkout:(id)sender
{
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        if (_obj) {
            
            UserInformation *userInfo= [UserInformation shareInstance];
            
            NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"workout_id\":\"%d\",\"sport_id\":\"%d\",\"user_id\":\"%d\"}",userInfo.userSelectedTeamid,[[_obj objectForKey:@"Workout Id"] intValue],userInfo.userSelectedSportid,[[_obj objectForKey:@"user_id"] intValue]];
            
            
            [SingaltonClass addActivityIndicator:self.view];
            
            [webservice WebserviceCall:webServiceReAssignWorkOut :strURL :ReassignWorkoutTag];
        }
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}
#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    int noOfSection=0;
    if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
        
        // NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
        
        for (int i=0; i< arrWorkOuts.count; i++) {
            
            NSArray *AthleteExercise=  [[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteExercise"] ;
            
            for (int j=0; j < AthleteExercise.count; j++) {
                
                NSArray *AthleteExerciseDetails=  [[AthleteExercise objectAtIndex:j]  valueForKey:@"exerciseDetail"];
                [arrNoOfRowInSection addObject:[NSString stringWithFormat:@"%lu",(unsigned long)AthleteExerciseDetails.count]];
            }
            
            
            noOfSection=(int)(noOfSection+AthleteExercise.count);
            
        }
        
        return noOfSection;
        
    }else if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"]) {
        
        return arrWorkOuts.count;
        
    }else
    {
        return arrWorkOuts.count;
        
    }
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
        
        return [[arrNoOfRowInSection objectAtIndex:section] intValue];
        
    }else if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"])
    {
        //NSArray *units=[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"];
        //return units.count+2;
        
        isDistance=FALSE;
        isTime=FALSE;
        isRate=FALSE;
        isSplit=FALSE;
        
        NSArray *units=[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"];
        return units.count+4;
        
    }else
    {
        NSArray *units=[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"];
        return units.count+2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        
        cell=[[WorkOutDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier indexPath:indexPath delegate:self WorkOutType:[_obj valueForKey:@"Workout Type"]:0];
        
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
    }
    
    if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
        
        
        CustomTextField *txtFieldRepitition=(CustomTextField *)[cell viewWithTag:1001];
        CustomTextField *txtFieldWeight=(CustomTextField *)[cell viewWithTag:1002];
        UILabel *lblExerciseName=(UILabel *)[cell viewWithTag:1003];
        UILabel *lblSets=(UILabel *)[cell viewWithTag:1004];
        txtFieldRepitition.textColor=[UIColor darkGrayColor];
        
        int AthleteIndex=0;
        int AthleteExerciseIndex=0;
        
        // Code for set Athlete index
        
        NSString *athleteName=@"";
        NSString *athleteExerciseName=@"";
        //NSLog(@"%d%d",indexPath.section,indexPath.row);
        athleteName=[arrAthleteName objectAtIndex:indexPath.section];
        athleteExerciseName=[arrAthleteExerciseName objectAtIndex:indexPath.section];
        
        for (int i=0; i< arrWorkOuts.count; i++) {
            
            if ([[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteName"] isEqualToString:athleteName]) {
                
                AthleteIndex=i;
                break;
            }
        }
        // Code for set Athlete exercise index which is matches with Athlete name
        
        for (int i=0; i< arrWorkOuts.count; i++) {
            
            NSArray *tempExercise=[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteExercise"];
            
            for (int j=0; j < tempExercise.count; j++)
            {
                
                [arrAthleteName addObject:[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteName"]];
                
                if ([[[tempExercise objectAtIndex:j] valueForKey:@"exerciseName"] isEqualToString:athleteExerciseName] && [[[arrWorkOuts objectAtIndex:i] valueForKey:@"athleteName"] isEqualToString:athleteName] )
                {
                    
                    AthleteExerciseIndex=j;
                    
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
        
        txtFieldRepitition.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Repetitions" attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor] ,NSFontAttributeName : (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:10]}];
        txtFieldRepitition.textAlignment=NSTextAlignmentCenter;
        txtFieldWeight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Weight" attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor] ,NSFontAttributeName : (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:10]}];
        txtFieldWeight.text=  [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:@"athleteExercise"] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"weight_value"]?[[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:@"athleteExercise"] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"weight_value"] :@"";
        
        txtFieldWeight.textAlignment=NSTextAlignmentCenter;
        txtFieldRepitition.text=  [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:@"athleteExercise"] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"rep_value"] ? [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:@"athleteExercise"] objectAtIndex:AthleteExerciseIndex] valueForKey:@"exerciseDetail"] objectAtIndex:indexPath.row]valueForKey:@"rep_value"] : @"";
        
        
        if (indexPath.row==0) {
            
            lblExerciseName.text=@"Sets";
            
        }else{
            
            lblExerciseName.text=@"";
        }
        lblSets.text=[NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        
    }
    else  if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"])
    {
        
        CustomTextField *txtFieldLeftHeader=(CustomTextField *)[cell viewWithTag:1001];
        CustomTextField *txtField=(CustomTextField *)[cell viewWithTag:1002];
        txtField.borderStyle=UITextBorderStyleRoundedRect;
        txtField.userInteractionEnabled=YES;
        txtField.textAlignment=NSTextAlignmentCenter;
        
        txtField.SectionIndex=(int)indexPath.section;
        txtField.RowIndex=(int)indexPath.row;
        
        NSArray *arrTemp=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"Units"];
        
        if (arrTemp.count > indexPath.row)
        {
            NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:indexPath.row] allKeys];
            
            NSString *unitKey=@"";
            
            if(arrUnitKeys.count > 2)
            {
                unitKey=[arrUnitKeys objectAtIndex:2];
                
                NSString *str=[NSString stringWithFormat:@"%@", [[[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"Units"] objectAtIndex:indexPath.row] valueForKey:@"intervalCount"] ];
                str=[str stringByAppendingString:[NSString stringWithFormat:@" %@",unitKey]];
                
                txtFieldLeftHeader.text=str;
                txtFieldLeftHeader.textColor=[UIColor darkGrayColor];
                txtField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:unitKey attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName : (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:10] }];
                
                txtField.text=[[[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"Units"] objectAtIndex:indexPath.row] valueForKey:unitKey];
                
                
                txtField=nil;
                txtFieldLeftHeader=nil;
            }
            
        }else{
            
            NSArray *units=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"Units"];
            
            if (indexPath.row==units.count+0) {
                
                txtFieldLeftHeader.text=@"Average Distance(Meters)";
                
                txtFieldLeftHeader.font =(isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12];
                txtField.borderStyle=UITextBorderStyleNone;
                txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
                txtField.textAlignment=NSTextAlignmentCenter;
                txtField.userInteractionEnabled=NO;
                // isDistance=FALSE;
                
                
            }else   if ((indexPath.row==units.count+1) ) {
                
                txtFieldLeftHeader.text=@"Average Time(hh:mm:ss:SSS))";
                
                txtFieldLeftHeader.font =(isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12];
                txtField.borderStyle=UITextBorderStyleNone;
                txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_TIME"];
                txtField.textAlignment=NSTextAlignmentCenter;
                txtField.userInteractionEnabled=NO;
                //isTime=FALSE;
                
            }else if ( indexPath.row==units.count+2 ) {
                
                txtFieldLeftHeader.text=@"Average Rate";
                
                txtFieldLeftHeader.font =(isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12];
                txtField.borderStyle=UITextBorderStyleNone;
                txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_RATE"];
                txtField.textAlignment=NSTextAlignmentCenter;
                txtField.userInteractionEnabled=NO;
                //isRate=FALSE;
                
            }else if ( indexPath.row==units.count+3 ) {
                
                txtFieldLeftHeader.text=@"Average Split(mm:ss.S)";
                
                txtFieldLeftHeader.font =(isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12];
                txtField.borderStyle=UITextBorderStyleNone;
                txtField.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_SPLIT"];
                txtField.textAlignment=NSTextAlignmentCenter;
                txtField.userInteractionEnabled=NO;
            }
        }
    }else
    {
        
        
        CustomTextField *txtFieldLeftHeader=(CustomTextField *)[cell viewWithTag:1001];
        CustomTextField *txtField=(CustomTextField *)[cell viewWithTag:1002];
        txtFieldLeftHeader.textColor=[UIColor darkGrayColor];
        txtField.textAlignment=NSTextAlignmentCenter;
        
        txtField.SectionIndex=(int)indexPath.section;
        txtField.RowIndex=(int)indexPath.row;
        
        if (indexPath.row == 0) {
            
            
            txtField.text=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"WarmUp Time"];
            txtFieldLeftHeader.text=@"WarmUp Time";
            txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"WarmUp Time" attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor] ,NSFontAttributeName : (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12]}];
            
            
            
        }else if (indexPath.row==1)
        {
            txtField.text=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"CoolDown Time"];
            txtFieldLeftHeader.text=@"CoolDown Time";
            txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CoolDown Time" attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName : (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12] }];
            
        }else{
            
            //NSLog(@" index Section  %d",(int)indexPath.section);
            ////NSLog(@" index row %d",(int)indexPath.row);
            
            NSArray *arrTemp=[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"Units"];
            NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:indexPath.row-2] allKeys];
            
            NSString *unitKey=@"";
            
            NSString *strTemp=[arrUnitKeys objectAtIndex:0];
            
            if ([strTemp isEqualToString:@"id"]) {
                
                unitKey=[arrUnitKeys objectAtIndex:1];
                
            }else
            {
                unitKey=[arrUnitKeys objectAtIndex:0];
                
            }
            
            
            txtFieldLeftHeader.text=unitKey;
            txtField.attributedPlaceholder= [[NSAttributedString alloc] initWithString:unitKey attributes:@{ NSForegroundColorAttributeName :[UIColor lightGrayColor],NSFontAttributeName : (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:12]}];
            
            txtField.text=[[[[arrWorkOuts objectAtIndex:indexPath.section] valueForKey:@"Units"] objectAtIndex:indexPath.row-2] valueForKey:unitKey];
            
            
        }
        txtField=nil;
        txtFieldLeftHeader=nil;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return isIPAD ? 30 : 20.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]) {
        return [NSString stringWithFormat:@"%@ (%@)",[arrAthleteName objectAtIndex:section],[arrAthleteExerciseName objectAtIndex:section] ];
        
    }else if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"]){
        
        return [[arrWorkOuts objectAtIndex:section] valueForKey:@"athleteName"];
    }else
    {
        
        return [[arrWorkOuts objectAtIndex:section] valueForKey:@"Name"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return isIPAD ? 45 : 35.0;
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
    
    CGSize keyboardSize = CGSizeMake(320,scrollHeight+70);
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

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
    
}
-(void)doneClicked
{
    
    [self setContentOffsetOfTableDown];
    
    [[[UIApplication sharedApplication] keyWindow ] endEditing:YES];
    
    [scrollView setContentOffset:CGPointMake(0, 0) animated: YES];
    
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
    [self setPickerVisibleAt:NO:arrTime];
}

#pragma mark- UITextfield Delegate


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isDate=FALSE;
    isSelectAthlete=[textField.placeholder isEqualToString:@"Select athlete"] ? YES:NO ;
    
    currentText=(CustomTextField *)textField;
    
    textField.keyboardType=UIKeyboardTypeNumberPad;
    [WorkOutDetails setContentOffsetOfScrollView:textField table:scrollView];
    [self setContentOffsetOfTableDown:textField table:table];
    
    if([textField.placeholder isEqualToString:@"WarmUp Time"] || [textField.placeholder isEqualToString:@"CoolDown Time"] || [textField.placeholder isEqualToString:@"Select athlete"] )
    {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        if (arrAllAthlete.count==0) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated: YES];
            [SingaltonClass initWithTitle:@"" message:@"Athlete is not exist" delegate:nil btn1:@"OK"];
            
        }else
        {
            if (arrTime.count==0) {
                
            }else
            {
                [listPicker reloadAllComponents];
                [listPicker selectRow:0 inComponent:0 animated:YES];
                
                [self setPickerVisibleAt:YES:arrTime];
                
            }
        }
        
        return NO;
        
    }else{
        
    }
    isDate=TRUE;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(NSString *)EntervalueInCorrectFormate:(NSString *)Key :(NSString *)value : (int)rowindex : (int)sectionindex
{
    NSString *correctValue=@"";
    
    NSString *PlaceholderValue=@"";
    
    NSString *myString = Key;
    NSRange startRange = [myString rangeOfString:@"("];
    NSRange endRange = [myString rangeOfString:@")"];
    if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
        PlaceholderValue = [myString substringWithRange:NSMakeRange(startRange.location+1,(endRange.location - startRange.location)-1)];
    }
    
    if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
        NSString *CheeckType = [myString substringWithRange:NSMakeRange(0,(startRange.location)-1)];
        
        if ([CheeckType isEqualToString:@"Distance"] || [myString isEqualToString:@"Rate"] || [myString isEqualToString:@"Repetitions"]) {
            
            return value;
        }
    }else{
        
        
        if ([myString isEqualToString:@"Rate"] || [myString isEqualToString:@"Repetitions"] || [myString isEqualToString:@"Weight"] ) {
            
            return value;
        }
    }
    
    value=[value stringByReplacingOccurrencesOfString:@":" withString:@""];
    value=[value stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    const char *c = [PlaceholderValue UTF8String];
    const char *arrValue = [value UTF8String];
    
    
    for (int i=0; i< PlaceholderValue.length; i++) {
        
        if (c[i]==':') {
            
            correctValue=[correctValue stringByAppendingString:@":"];
            //correctValue=[correctValue stringByAppendingString:@"0"];
            
        }else if (c[i]=='.')
        {
            correctValue=[correctValue stringByAppendingString:@"."];
        }else{
            
            correctValue=[correctValue stringByAppendingString:@"0"];
        }
        
        
    }
    
    int actualStingLenght=(int)value.length-1;
    NSString *strTemp=correctValue;
    const char *b= [correctValue UTF8String];
    
    for (int j=(int)(correctValue.length-1); j >= 0  ; j--) {
        
        if (b[j]==':') {
            
            j--;
            
            
        }else if (b[j]=='.')
        {
            j--;
            
        }
        
        if (actualStingLenght >= 0) {
            
            strTemp= [strTemp stringByReplacingCharactersInRange:NSMakeRange(j,1) withString:[NSString stringWithFormat:@"%c",arrValue[actualStingLenght]]];
            
            actualStingLenght=actualStingLenght-1;
        }else
        {
            return strTemp;
        }
    }
    return strTemp;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    @try {
        CustomTextField *Mytext=(CustomTextField *)textField;
        
        Mytext.text = [self EntervalueInCorrectFormate:Mytext.placeholder :Mytext.text :Mytext.RowIndex :Mytext.SectionIndex];
        
        
        if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"])
        {
            [self updateLiftValue:Mytext.liftAthleteIndex :Mytext.text :Mytext.RowIndex :Mytext.liftExerciseIndex:textField];
            
        }else  if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"])
        {
            
            [self updateValue:Mytext.placeholder :Mytext.text :Mytext.RowIndex :Mytext.SectionIndex];
            [self CalculateAVG :Mytext.SectionIndex];
            
            mytextfiled=Mytext;
            
            // Update cell textfield data for show avarage
            
            [self performSelector:@selector(UpdateCelldata) withObject:nil afterDelay:0];
            
        }else
        {
            [self updateValue:Mytext.placeholder :Mytext.text :Mytext.RowIndex :Mytext.SectionIndex];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
-(void)UpdateCelldata
{
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:currentText.SectionIndex] valueForKey:@"Units"];
    
    NSString*strPlaceholder=@"";
    
    NSString *myString = currentText.placeholder;
    NSRange startRange = [myString rangeOfString:@"("];
    NSRange endRange = [myString rangeOfString:@")"];
    if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
        strPlaceholder = [myString substringWithRange:NSMakeRange(0,(startRange.location)-1)];
    }
    
    
    if ([strPlaceholder isEqualToString:@"Distance"]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:arrTemp.count inSection:currentText.SectionIndex];
        // NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        //[table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        WorkOutDetailCell *cell=(WorkOutDetailCell *)[table cellForRowAtIndexPath:indexPath];
        
        CustomTextField *textfield=(CustomTextField *)[cell viewWithTag:1002];
        
        textfield.text=[[arrAvarageTimeDistance objectAtIndex:indexPath.section] valueForKey:@"AVG_DISTANCE"];
        
        
        
    }else  if ([strPlaceholder isEqualToString:@"Time"]) {
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:arrTemp.count+1 inSection:currentText.SectionIndex];
        // NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath1, nil];
        // [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        WorkOutDetailCell *cell=(WorkOutDetailCell *)[table cellForRowAtIndexPath:indexPath1];
        
        CustomTextField *textfield=(CustomTextField *)[cell viewWithTag:1002];
        
        textfield.text=[[arrAvarageTimeDistance objectAtIndex:indexPath1.section] valueForKey:@"AVG_TIME"];
        
        
    }else  if ([myString isEqualToString:@"Rate"]) {
        
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:arrTemp.count+2 inSection:currentText.SectionIndex];
        //NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath2, nil];
        // [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        WorkOutDetailCell *cell=(WorkOutDetailCell *)[table cellForRowAtIndexPath:indexPath2];
        
        CustomTextField *textfield=(CustomTextField *)[cell viewWithTag:1002];
        
        textfield.text=[[arrAvarageTimeDistance objectAtIndex:indexPath2.section] valueForKey:@"AVG_RATE"];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self setToolbarVisibleAt:CGPointMake(160, 600)];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    CustomTextField *LocalTxtFeild=(CustomTextField *)textField;
    
    if ([string isEqualToString:@""]) {
        
    }else if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"])
    {
        int textfieldcount=(int)textField.text.length;
        
        if (textfieldcount==3 && [textField.placeholder isEqualToString:@"Weight"]) {
            return NO;
        }else    if (textfieldcount==2 && [textField.placeholder isEqualToString:@"Repetitions"]){
            
            return NO;
        }
        
        
        
        // [self updateLiftValue:currentText.liftAthleteIndex :textField.text :currentText.RowIndex :currentText.liftExerciseIndex];
        
    }else{
        
        // This code not work for lift and interval ( in both case method work updateLiftValue)
        
        NSString *value=@"";
        
        NSString *myString = textField.placeholder;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(startRange.location+1,(endRange.location - startRange.location)-1)];
        }
        
        
        const char *c = [value UTF8String];
        
        int strTraverselength=(int)textField.text.length;
        
        if ([value isEqualToString:@"Miles"]) {
            
            strTraverselength=2;
            
        }else if ([value isEqualToString:@"Meters"])
        {
            strTraverselength=9;
            
        }else if ([value isEqualToString:@"Kilometers"])
        {
            strTraverselength=2;
        }else if ([value isEqualToString:@"Miles"])
        {
            strTraverselength=2;
            
            
        }else if ([value isEqualToString:@""]){
            
            strTraverselength=2;
            
        }else{
            
            strTraverselength=(int)value.length;
        }
        int textfieldcount=(int)textField.text.length;
        if (strTraverselength==textField.text.length) {
            return NO;
        }
        
        if (c[textfieldcount]==':') {
            // strTraverselength= strTraverselength-1;
            textField.text= [textField.text stringByAppendingString:@":"];
        }else if (c[textfieldcount]=='.')
        {
            //strTraverselength= strTraverselength-1;
            textField.text= [textField.text stringByAppendingString:@"."];
            
        }
        //}
        [self updateValue:LocalTxtFeild.placeholder :LocalTxtFeild.text :LocalTxtFeild.RowIndex :LocalTxtFeild.SectionIndex];
    }
    return YES;
}
+ (void)setContentOffsetOfScrollView:(id)textField table:(UIScrollView*)m_TableView {
    
    int moveUp= (([[UIScreen mainScreen] bounds].size.height >= 568)?50:130);
    
    if (moveUp) {
        
        [m_TableView setContentOffset:CGPointMake(0, moveUp) animated: YES];
    }
    
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
            _tfSelectUserType.text=[arrAllAthlete objectAtIndex:0];
            [self FilterDataAccourdingAthlete:currentText.text];
            
        }
        
        return [arrAllAthlete count];
    }else
    {
        if (currentText.text.length==0) {
            currentText.text=[arrTime objectAtIndex:0];
            
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
        if (currentText.text.length==0) {
            
            currentText.text=[arrTime objectAtIndex:row] ;
            
            [self updateValue:currentText.placeholder :currentText.text :currentText.RowIndex :currentText.SectionIndex];
        }
    }
    
    NSArray *arr = [str componentsSeparatedByString:@"****"];
    
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // currentText.text=[[arrTime objectAtIndex:row] stringByAppendingString:@" Minutes"];
    isDate=TRUE;
    if (isSelectAthlete) {
        
        currentText.text=[arrAllAthlete objectAtIndex:row] ;
        [self FilterDataAccourdingAthlete:currentText.text];
        
    }else
    {
        currentText.text=[arrTime objectAtIndex:row] ;
        
        [self updateValue:currentText.placeholder :currentText.text :currentText.RowIndex :currentText.SectionIndex];
    }
    
}

-(void)updateLiftValue :(int)AthleteIndex :(NSString *)value : (int)rowindex : (int)sectionindex :(id)textField
{
    UITextField *txtfield=(UITextField *)textField;
    
    if ([txtfield.placeholder isEqualToString:@"Weight"]) {
        
        [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:@"athleteExercise"] objectAtIndex:sectionindex] valueForKey:@"exerciseDetail"] objectAtIndex:rowindex]setValue:value forKey:@"weight_value"];
    }else if ([txtfield.placeholder isEqualToString:@"Repetitions"]){
        
        [[[[[[arrWorkOuts objectAtIndex:AthleteIndex] valueForKey:@"athleteExercise"] objectAtIndex:sectionindex] valueForKey:@"exerciseDetail"] objectAtIndex:rowindex]setValue:value forKey:@"rep_value"];
        
        
    }
    
}

-(BOOL)CheckStatus :(NSString *)StrValues :(long)section
{
    BOOL status=false;
    
    
    
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"];
    
    for (int i=0; i < arrTemp.count ; i++) {
        
        NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:i] allKeys];
        
        NSString *unitKey=@"";
        
        NSString *strTemp=[arrUnitKeys objectAtIndex:0];
        
        if ([strTemp isEqualToString:@"id"]) {
            
            unitKey=[arrUnitKeys objectAtIndex:1];
            
        }else
        {
            unitKey=[arrUnitKeys objectAtIndex:0];
            
        }
        
        
        // NSString *values=[[[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"] objectAtIndex:i] valueForKey:unitKey];
        
        
        NSString *value;
        NSString *myString = unitKey;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(0,startRange.location)];
            value=[value stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        if ([StrValues isEqualToString:@"Rate"] &&[myString isEqualToString:StrValues ] )
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
    
    
    
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"];
    count=(int)arrTemp.count;
    for (int i=0; i < arrTemp.count ; i++) {
        
        NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:i] allKeys];
        
        NSString *unitKey=@"";
        
        NSString *strTemp=[arrUnitKeys objectAtIndex:0];
        
        if ([strTemp isEqualToString:@"id"]) {
            
            unitKey=[arrUnitKeys objectAtIndex:1];
            
        }else
        {
            unitKey=[arrUnitKeys objectAtIndex:0];
            
        }
        
        
        // NSString *values=[[[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"] objectAtIndex:i] valueForKey:unitKey];
        
        
        NSString *value;
        NSString *myString = unitKey;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(0,startRange.location)];
            value=[value stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        if (([value isEqualToString:@"Time"] ) && isTime==FALSE) {
            count=count+1;
            isTime=TRUE;
        }else  if ([value isEqualToString:@"Distance"] && isDistance==FALSE) {
            
            count=count+1;
            
            isDistance=TRUE;
        }else  if ([myString isEqualToString:@"Rate"] && isRate==FALSE) {
            
            count=count+1;
            isRate=TRUE;
        }else  if ([value isEqualToString:@"Split"] && isSplit==FALSE) {
            
            count=count+1;
            isSplit=TRUE;
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
    
    
    NSArray *arrTemp=[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"];
    for (int i=0; i < arrTemp.count ; i++) {
        
        NSArray *arrUnitKeys=[[ arrTemp objectAtIndex:i] allKeys];
        
        NSString *unitKey=@"";
        
        NSString *strTemp= arrUnitKeys.count > 2 ? [arrUnitKeys objectAtIndex:2] : @"";
        
        unitKey=strTemp;
        NSString *values=[[[[arrWorkOuts objectAtIndex:section] valueForKey:@"Units"] objectAtIndex:i] valueForKey:unitKey];
        
        
        NSString *value;
        NSString *myString = unitKey;
        NSRange startRange = [myString rangeOfString:@"("];
        NSRange endRange = [myString rangeOfString:@")"];
        if (startRange.location != NSNotFound && endRange.location != NSNotFound && endRange.location > startRange.location) {
            value = [myString substringWithRange:NSMakeRange(startRange.location+1,(endRange.location - startRange.location)-1)];
        }
        
        if ([value isEqualToString:@"Meters"]) {
            
            TotalDistance=TotalDistance+[values intValue];
            DistanceCount++;
            
        }else if ([myString isEqualToString:@"Rate"])
        {
            TotalRate=TotalRate+([values intValue]);
            RateCount++;
            
            RateAVG=TotalRate/RateCount;
            
        }else if ([value isEqualToString:@"Kilometers"])
        {
            TotalDistance=TotalDistance+([values intValue]*1000);
            DistanceCount++;
            
        }else if ([value isEqualToString:@"Miles"])
        {
            TotalDistance=TotalDistance+([values intValue]*1609.34);
            DistanceCount++;
            
        }else if ([value isEqualToString:@"HH:mm:ss.SSS"])
        {
            TimeCount=TimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            
            for (int i=0; i< TimeComponents.count; i++) {
                
                [arrTotalTimeComponenet replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", ([[arrTotalTimeComponenet objectAtIndex:i] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
            
        }else if ([value isEqualToString:@"mm:ss.SSS"])
        {
            TimeCount=TimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            
            for (int i=0; i< TimeComponents.count; i++) {
                
                int j=i+1;
                
                [arrTotalTimeComponenet replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d", ([[arrTotalTimeComponenet objectAtIndex:j] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
            
        }else if ([value isEqualToString:@"ss.SSS"])
        {
            TimeCount=TimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            
            for (int i=0; i< TimeComponents.count; i++) {
                
                int j=i+2;
                
                [arrTotalTimeComponenet replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d", ([[arrTotalTimeComponenet objectAtIndex:j] intValue] + [[TimeComponents objectAtIndex:i] intValue]) ]];
            }
            
        }else if ([value isEqualToString:@"mm:ss.S"])
        {
            splitTimeCount=splitTimeCount+1;
            values=[values stringByReplacingOccurrencesOfString:@"." withString:@":"];
            NSArray *TimeComponents=[values componentsSeparatedByString:@":"];
            
            for (int i=0; i< TimeComponents.count; i++) {
                
                //int j=i+1;
                
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
                
                sss=sss-1;
                ss=ss+1;
            }
            
            ss=[[arrTotalTimeComponenet objectAtIndex:2] intValue]/TimeCount;
            
            if (ss > 60) {
                
                ss=ss-1;
                mm=mm+1;
            }
            
            mm=[[arrTotalTimeComponenet objectAtIndex:1] intValue]/TimeCount;
            
            if (mm > 60) {
                
                mm=mm-1;
                hh=hh+1;
            }
            
            
            // NSString *sss=[NSString stringWithFormat:@"%@",]
            
            TimeAVG=[NSString stringWithFormat:@"%d:%d:%d:%d", hh,mm,ss,sss ];
        }
        
        if (splitTimeCount > 0) {
            
            int ss=0,mm=0,S=0;
            
            S=[[arrTotalSplitTimeComponenet objectAtIndex:2] intValue];
            
            if (S > 1000) {
                
                int  STemp=S%1000;
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",STemp]];
                
                ss=ss+S/1000;
                
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",ss+([[arrTotalSplitTimeComponenet objectAtIndex:1] intValue])]];
            }
            
            ss=[[arrTotalSplitTimeComponenet objectAtIndex:1] intValue];
            
            if (ss > 60) {
                
                int ssTemp=ss%60;
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",ssTemp]];
                mm=mm+(ss/60);
                
                int mValue=[[arrTotalSplitTimeComponenet objectAtIndex:0] intValue];
                
                [arrTotalSplitTimeComponenet replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",mm+(mValue)]];
            }
            
            mm=[[arrTotalSplitTimeComponenet objectAtIndex:0] intValue];
            
            int avgMM=([[arrTotalSplitTimeComponenet objectAtIndex:0] intValue]/splitTimeCount);
            int temp=([[arrTotalSplitTimeComponenet objectAtIndex:0] intValue]%splitTimeCount);
            int avSS=((temp*60)+[[arrTotalSplitTimeComponenet objectAtIndex:1] intValue])/splitTimeCount;
            int temp1=([[arrTotalSplitTimeComponenet objectAtIndex:1] intValue]%splitTimeCount);
            int avS=((temp1*1000)+[[arrTotalSplitTimeComponenet objectAtIndex:2] intValue])/splitTimeCount;
            
            SplitTimeAVG=[NSString stringWithFormat:@"%d:%d.%@", avgMM,avSS,[[NSString stringWithFormat:@"%d" ,avS ] substringWithRange:NSMakeRange(0,1)] ];
        }
    }
    NSDictionary *dicTemp=[[NSDictionary alloc] initWithObjectsAndKeys:TimeAVG,@"AVG_TIME",[NSString stringWithFormat:@"%f", DistanceAVG ],@"AVG_DISTANCE",[NSString stringWithFormat:@"%f", RateAVG ],@"AVG_RATE",[NSString stringWithFormat:@"%@", SplitTimeAVG ],@"AVG_SPLIT", nil];
    
    if (arrAvarageTimeDistance.count > section) {
        
        [arrAvarageTimeDistance replaceObjectAtIndex:section withObject: dicTemp ];
    }else
    {
        [arrAvarageTimeDistance addObject:dicTemp ];
    }
    
    dicTemp=nil;
    arrTotalTimeComponenet=nil;
    
    
    ////NSLog(@"Avg time %@",TimeAVG);
    // //NSLog(@"Avg Distance %ld",DistanceAVG);
    
}

-(void)updateValue :(NSString *)Key :(NSString *)value : (int)rowindex : (int)sectionindex
{
    if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"]){
        
        [[[[arrWorkOuts objectAtIndex:sectionindex] valueForKey:@"Units"] objectAtIndex:rowindex] setValue:value forKey:Key];
        
    }else  if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Interval"])
    {
        [[[[arrWorkOuts objectAtIndex:sectionindex] valueForKey:@"Units"] objectAtIndex:rowindex] setValue:value forKey:Key];
        
    }else
    {
        
        if (rowindex == 0 || rowindex==1) {
            
            [[arrWorkOuts objectAtIndex:sectionindex] setValue:value forKey:Key];
            
        }else
        {
            
            [[[[arrWorkOuts objectAtIndex:sectionindex] valueForKey:@"Units"] objectAtIndex:rowindex-2] setValue:value forKey:Key];
            
        }
    }
    
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
        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        point.y=self.view.frame.size.height+(listPicker.frame.size.height/2);
    }
    
    
    [self.view viewWithTag:listPickerTag].center = point;
    
    [UIView commitAnimations];
}

-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    [self.view viewWithTag:toolBarTag].center = point;
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveEvent:(id)sender {
    
    // if there are no values available or comes from web, then no data to save
    if (arrWorkOuts.count==0) {
        
        return;
    }
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        if (_obj) {
            
            
            if ([[_obj valueForKey:@"Workout Type"] isEqualToString:@"Lift"])
            {
                [SingaltonClass addActivityIndicator:self.view];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                
                [dict setObject:arrWorkOuts forKey:@"WorkoutAthleteLift"];
                
                
                [webservice WebserviceCallwithDic:dict :webServiceSaveWorkOutDetails :SaveDataTag];
                
            }else{
                
                [SingaltonClass addActivityIndicator:self.view];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                
                [dict setObject:arrWorkOuts forKey:@"WorkoutAthlete"];
                [webservice WebserviceCallwithDic:dict :webServiceSaveWorkOutDetails :SaveDataTag];
                
            }
            
            //[webservice WebserviceCall:webServiceSaveWorkOutDetails :strURL :SaveDataTag];
        }
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}
@end
