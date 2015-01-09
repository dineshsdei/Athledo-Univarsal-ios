//
//  WorkOutHistory.m
//  Athledo
//
//  Created by Dinesh Kumar on 8/25/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WorkOutHistory.h"
#import "WorkOutView.h"
#import "DashBoardCell.h"
#import "WorkoutHistoryDetails.h"

#define listPickerTag 60
#define toolBarTag 40
#define getDataTag 100
#define getSearchDataTag 110
#define PadingW 12
#define PadingH 20
@interface WorkOutHistory ()
{
    BOOL isSeasons;
    BOOL isWorkOutType;
    BOOL isAthletes;
    
    UITextField *currentText;
    
    NSArray *arrWorkOut;
    NSArray *arrSeasons;
    NSMutableArray *arrAthletes;
    
    int toolBarPosition;
    BOOL isKeyBoard;
    
    WebServiceClass *webservice;
    
    NSDictionary *DicData;
    
    NSString *seasonId;
    NSString *workoutId;
    NSString *AthleteId;
    
    NSMutableArray *arrSearchData;
    
    BOOL isPicker;
    
    NSDateFormatter *formater;
    
}

@end

@implementation WorkOutHistory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isSeasons) {
        if (currentText.text.length==0) {
            currentText.text=[arrSeasons objectAtIndex:0];
             seasonId=[self KeyForValue:@"Season":currentText.text];
        }
        
        return [arrSeasons count];
        
    }else if (isWorkOutType)
    {
        if (currentText.text.length==0) {
            currentText.text=[arrWorkOut objectAtIndex:0];
            workoutId=[self KeyForValue:@"Workout Type":currentText.text];
        }
        
        return [arrWorkOut count];
    }else if (isAthletes)
    {
        if (currentText.text.length==0) {
            currentText.text=[arrAthletes objectAtIndex:0];
            AthleteId=[self KeyForValue:@"Athletes":currentText.text];
        }
        return [arrAthletes count];
    }else
        return 0;
    
    
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    if (isWorkOutType) {
        
        str= [arrWorkOut objectAtIndex:row];
        
    }else  if (isAthletes)
    {
        str = [arrAthletes objectAtIndex:row];
    }else if (isSeasons)
    {
        str = [arrSeasons objectAtIndex:row];
    }
    
    
    NSArray *arr = [str componentsSeparatedByString:@"****"]; //For State, But will not effect to other
    
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (isWorkOutType) {
        
        currentText.text=arrWorkOut.count > row ? [arrWorkOut objectAtIndex:row] : [arrWorkOut objectAtIndex:row-1] ;
        
        workoutId=[self KeyForValue:@"Workout Type":currentText.text];
        
    }else  if (isAthletes)
    {
        currentText.text=arrAthletes.count > row ? [arrAthletes objectAtIndex:row] : [arrAthletes objectAtIndex:row-1] ;
        AthleteId=[self KeyForValue:@"Athletes":currentText.text];
    }else if (isSeasons)
    {
        currentText.text=arrSeasons.count > row ? [arrSeasons objectAtIndex:row] : [arrSeasons objectAtIndex:row-1] ;
        seasonId=[self KeyForValue:@"Season":currentText.text];
    }
    
    
    
    
}

-(IBAction)Workoutlist:(id)sender
{
    
    NSArray *arrController=[self.navigationController viewControllers];
    
    BOOL Status=FALSE;
    
    for (id object in arrController) {
        
        if ([object isKindOfClass:[WorkOutView class]])
        {
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        WorkOutView *addNew=[[WorkOutView alloc] init];
        [self.navigationController pushViewController:addNew animated:NO];
        
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLayoutSubviews {
    
    if (  isPicker==TRUE) {
        //[self setPickerVisibleAt:CGPointMake(160, self.view.frame.size.height-listPicker.frame.size.height/2)];
        //isPicker=FALSE;
        listPicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-listPicker.frame.size.height/2);
    
   }
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"Workout History", nil);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    AthleteId=@"";
    workoutId=@"";
    seasonId=@"";
    
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
    //self.navigationItem.backBarButtonItem=nil; ;
    // [self.navigationItem setHidesBackButton:YES animated:NO];
    
    arrWorkOut =[[NSArray alloc] init];
    arrSeasons =[[NSArray alloc] init];
    arrSearchData=[[NSMutableArray alloc] init];
    //arrAthletes =[[NSArray alloc] init];
    
    
    toolBarPosition = (([[UIScreen mainScreen] bounds].size.height >= 568)?300:250);
    
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216);
    listPicker.tag=listPickerTag;
    listPicker.delegate=self;
    listPicker.dataSource=self;
    listPicker.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
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
       
        workoutDetails.obj=[[[arrSearchData objectAtIndex:indexPath.section] valueForKey:@"Workout"]copy];
        [self.navigationController pushViewController:workoutDetails animated:YES];
    }
  
 }

-(void)getSeasonOrWorkoutOrAthletesData{
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        UserInformation *userInfo=[UserInformation shareInstance];
        
        [SingaltonClass addActivityIndicator:self.view];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        
        [webservice WebserviceCall:webServiceGetWorkOutdropdownList :strURL :getDataTag];
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
    
}

-(NSString *)KeyForValue :(NSString *)superKey :(NSString *)SubKey

{
    NSArray *arrValues;
    NSArray *arrkeys;
    [[DicData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ? arrValues=[[DicData objectForKey:superKey] allValues] : @"";
    
    [[DicData objectForKey:superKey] isKindOfClass:[NSDictionary class]] ?  arrkeys=[[DicData objectForKey:superKey] allKeys] : @"";
    
    NSString *strValue=@"";
    
    for (int i=0; i<arrValues.count; i++) {
        
        if ([[arrValues objectAtIndex:i] isEqualToString:SubKey])
        {
            strValue=[arrkeys objectAtIndex:i];
            
            break;
            
        }
        
    }
    
    
    
    return strValue;
    
}


-(IBAction)getSearchData{
    
    isPicker=FALSE;
    
    [self doneClicked];
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        
        [SingaltonClass addActivityIndicator:self.view];
        
        
        
        NSString *strURL = [NSString stringWithFormat:@"{\"season_id\":\"%@\",\"workout_type_id\":\"%@\",\"user_id\":\"%@\"}",seasonId,workoutId,AthleteId];
        
        [webservice WebserviceCall:webUrlSearchHistory :strURL :getSearchDataTag];
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
    
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingaltonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
        case getDataTag:
        {
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                //NSLog(@"%@",MyResults);
                
                DicData=[MyResults  objectForKey:@"data"];
                
                // check if nsdictionary object then find allvalues otherwise  this @"" statement execute . it do nothing
                
                [[[MyResults  objectForKey:@"data"] objectForKey:@"Workout Type"] isKindOfClass:[NSDictionary class]] ? arrWorkOut=[[[MyResults  objectForKey:@"data"] objectForKey:@"Workout Type"] allValues] : @"";
                
                [[[MyResults  objectForKey:@"data"] valueForKey:@"Athletes"] isKindOfClass:[NSDictionary class]] ? arrAthletes=[NSMutableArray arrayWithArray:[[[MyResults  objectForKey:@"data"] valueForKey:@"Athletes"] allValues]] : @"";
                
                [[[MyResults  objectForKey:@"data"] objectForKey:@"Season"] isKindOfClass:[NSDictionary class]] ?  arrSeasons=[[[MyResults  objectForKey:@"data"] objectForKey:@"Season"] allValues] :@"";
                
                [arrAthletes addObject:@"Whole Team"];
                
            }else{
                [SingaltonClass initWithTitle:@"" message:@"Try again" delegate:nil btn1:@"Ok"];
            }
            
            break;
        }
        case getSearchDataTag:
        {
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                //NSLog(@"%@",MyResults);
                
                [arrSearchData removeAllObjects];
                
                [arrSearchData addObjectsFromArray:[MyResults  objectForKey:@"data"] ];
                
                if (arrSearchData.count==0) {
                    
                    [SingaltonClass initWithTitle:@"" message:@"Data Not Found!" delegate:nil btn1:@"Ok"];
                    
                }else{
                    
                    [tableview reloadData];
                }
                
            }else{
                [SingaltonClass initWithTitle:@"" message:@"Try again!" delegate:nil btn1:@"Ok"];
            }
            
            break;
        }
            
            
            
        default:
            break;
    }
    
    
}
-(void)doneClicked
{
    
    [UIView beginAnimations:@"tblMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.29f];
    // if condition -> for not Lift workout
    
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
    [self setPickerVisibleAt:NO:arrSeasons];
    
    [UIView commitAnimations];
    
}

#pragma mark- UITextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    currentText=textField;
    
    isSeasons=[textField.placeholder isEqualToString:@"Select Season"] ? YES : NO ;
    isWorkOutType=[textField.placeholder isEqualToString:@"Select Workout Type"] ? YES : NO ;
    isAthletes=[textField.placeholder isEqualToString:@"Select Athlete"] ? YES : NO ;
     isPicker=FALSE;
    
    //NSLog(@"y position %f",[textField superview].frame.origin.y);
    //NSLog(@"The picker Values are %@",[NSValue valueWithCGRect:listPicker.frame]);
    
    if (isAthletes) {
        
         isPicker=TRUE;
        arrAthletes.count > 0 ? [self setPickerVisibleAt:YES:arrAthletes] :[SingaltonClass initWithTitle:@"" message:@"Athletes are not exist" delegate:nil btn1:@"Ok"];
        if (arrAthletes.count==0) {
            [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
            [self setPickerVisibleAt:NO:arrSeasons];
        }
    
    }else if(isWorkOutType){
        
         isPicker=TRUE;
         arrWorkOut.count > 0 ? [self setPickerVisibleAt:YES:arrWorkOut]:[SingaltonClass initWithTitle:@"" message:@"Workouts are not exist" delegate:nil btn1:@"Ok"];
        if (arrWorkOut.count==0) {
            [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
            [self setPickerVisibleAt:NO:arrSeasons];
        }
       
    }else if(isSeasons){
        
        isPicker=TRUE;
       
          arrSeasons.count > 0 ?  [self setPickerVisibleAt:YES:arrSeasons]:[SingaltonClass initWithTitle:@"" message:@"Seasons data are not exist" delegate:nil btn1:@"Ok"];
        if (arrSeasons.count==0) {
            [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
            [self setPickerVisibleAt:NO:arrSeasons];
        }
        
    }

    
    [textField resignFirstResponder];
    [listPicker reloadAllComponents];
    [listPicker selectRow:0 inComponent:0 animated:YES];
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return arrSearchData.count;
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [cell.lblWorkoutName setFont:[UIFont boldSystemFontOfSize:15]];
    if (![[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:@"Workout"] valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
        cell.lblWorkoutName.text=[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:@"Workout"] valueForKey:@"name"];
    }
    
    cell.lblWorkoutDate.textColor=[UIColor lightGrayColor];
    [cell.lblWorkoutDate setFont:[UIFont boldSystemFontOfSize:13]];
    if (![[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:@"Workout"] valueForKey:@"date"] isKindOfClass:[NSNull class]]) {
        
        NSDate *date=[formater dateFromString:[[[arrSearchData objectAtIndex:indexPath.section ]valueForKey:@"Workout"] valueForKey:@"date"]];
        [formater setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
        cell.lblWorkoutDate.text=[formater stringFromDate:date];
        [formater setDateFormat:DATE_FORMAT_Y_M_D];
    }
    
    // cell.lblWorkoutDate.backgroundColor=[UIColor clearColor];
    // cell.lblWorkoutName.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68.0f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
