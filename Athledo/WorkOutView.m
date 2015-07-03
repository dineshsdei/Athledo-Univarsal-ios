//
//  WorkOutView.m
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//


#import "WorkOutView.h"
#import "SWRevealViewController.h"
#import "WorkOutListCell.h"
#import "AddWorkOut.h"
#import "WorkOutHistory.h"
#import "WorkOutDetails.h"

// tagNumber->100 for get list data
// tagNumber->200 for get search result

@interface WorkOutView (){
    NSMutableArray *arrWorkOutData;
    UIButton *btnAddNew;
    UIButton *btnHistory;
}

@end

@implementation WorkOutView

-(void)ReAsignWorkout :(int)index{
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)ReAsignWorkOut:(id)sender{
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrWorkOutData=[[NSMutableArray alloc] init];
    btnAddNew = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageAdd=[UIImage imageNamed:@"Navadd.png"];
    btnAddNew.bounds = CGRectMake( 0, 0, imageAdd.size.width, imageAdd.size.height );
    [btnAddNew addTarget:self action:@selector(AddNewWorkOut) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNew setImage:imageAdd forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAddNew];
    
    btnHistory = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageHistory=[UIImage imageNamed:@"save_icon.png"];
     btnHistory.bounds = CGRectMake( 0, 0, imageHistory.size.width, imageHistory.size.height );
    [btnHistory addTarget:self action:@selector(WorkoutHistory:) forControlEvents:UIControlEventTouchUpInside];
    [btnHistory setImage:imageHistory forState:UIControlStateNormal];
   // btnHistory.backgroundColor = NAVIGATION_COMPONENT_COLOR;
    UIBarButtonItem *BarItemHistory = [[UIBarButtonItem alloc] initWithCustomView:btnHistory];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemAdd,BarItemHistory, nil];
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
}
-(void)doneClicked{
    [self setToolbarVisibleAt:CGPointMake(160, self.view.bounds.size.height+50)];
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
}
-(void)setToolbarVisibleAt:(CGPoint)point{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [self.view viewWithTag:40].center = point;
    [UIView commitAnimations];
}
#pragma mark Class Utility method 
- (void)orientationChanged{
    [SingletonClass deleteUnUsedLableFromTable:tblList];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    if (isIPAD){
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    self.title = NSLocalizedString(@"Workouts", nil);
    tblList.userInteractionEnabled=YES;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = NAVIGATION_COMPONENT_COLOR;
    [super viewWillAppear:NO];
    if ([SingletonClass ShareInstance].isWorkOutSectionUpdate == TRUE) {
        [self getList];
    }
}
- (BOOL)revealController:(SWRevealViewController *)revealController
panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)AddNewWorkOut{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController){
        if ([object isKindOfClass:[AddWorkOut class]]){
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }
    if (Status==FALSE){
        AddWorkOut *annView=[[AddWorkOut alloc] initWithNibName:@"AddWorkOut" bundle:nil];
        [self.navigationController pushViewController:annView animated:NO];
    }
}
- (void)getList{
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.navigationItem.leftBarButtonItem.enabled=NO;
        btnHistory.userInteractionEnabled=NO;
        [SingletonClass addActivityIndicator:self.view];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"type\":\"%d\",\"sport_id\":\"%d\",\"search\":\{}""}",userInfo.userSelectedTeamid,userInfo.userType,userInfo.userSelectedSportid];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceWorkoutInfo]];
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
                                       [self httpResponseReceived:data :GetWorkOutListTag];
                                   }else{
                                       
                                       self.navigationItem.rightBarButtonItem.enabled=YES;
                                       self.navigationItem.leftBarButtonItem.enabled=YES;
                                       [SingletonClass RemoveActivityIndicator:self.view];
                                   }
                               }];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
- (void)WebServiceDeleteWorkOut : (int )Index{
    if ([SingletonClass  CheckConnectivity]){
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.navigationItem.leftBarButtonItem.enabled=NO;
        [SingletonClass addActivityIndicator:self.view];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"workout_id\":\"%d\"}",[[[arrWorkOutData objectAtIndex:Index] objectForKey:KEY_WORKOUT_ID] intValue]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceDeleteWorkOut]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSMutableData *data = [NSMutableData data];
        [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
        [request setHTTPBody:data];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (data!=nil){
                                       [self httpResponseReceived:data :DeleteWorkOutTag];
                                   }else{
                                       self.navigationItem.rightBarButtonItem.enabled=YES;
                                       self.navigationItem.leftBarButtonItem.enabled=YES;
                                       [SingletonClass RemoveActivityIndicator:self.view];
                                   }
                               }];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
#pragma mark-  Http call back
-(void)httpResponseReceived:(NSData *)webResponse :(int )tagNumber{
    // tagNumber->100 for get list data
    // tagNumber->200 for get search result
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    btnHistory.userInteractionEnabled=YES;
    // Now remove the Active indicator
    [SingletonClass RemoveActivityIndicator:self.view];
    [SingletonClass deleteUnUsedLableFromTable:tblList];
    // Now we Need to decrypt data
    NSError *error=nil;
    if (tagNumber == GetWorkOutListTag){
        [SingletonClass ShareInstance].isWorkOutSectionUpdate =FALSE;
        NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        
        if ([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            [arrWorkOutData removeAllObjects];
            NSArray *data=[myResults objectForKey:DATA] ;
            for (int i=0; i< data.count; i++){
                if ([[data objectAtIndex:i]objectForKey:KEY_WORKOUT]) {
                    [arrWorkOutData addObject:[[data objectAtIndex:i]objectForKey:KEY_WORKOUT]];
                }
            }
             arrWorkOutData.count == 0 ? [tblList addSubview:[SingletonClass ShowEmptyMessage:@"No workouts":tblList]] :[SingletonClass deleteUnUsedLableFromTable:tblList];
            [tblList reloadData];
        }else{
            [tblList addSubview:[SingletonClass ShowEmptyMessage:@"No workouts":tblList]];
        }
    }else if (tagNumber == SearchWorkOutTag){
        NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        NSArray *data=[myResults objectForKey:DATA] ;
        
        if ([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            [arrWorkOutData removeAllObjects];
            for (int i=0; i< data.count; i++){
                if ([[data objectAtIndex:i]objectForKey:KEY_WORKOUT]) {
                    [arrWorkOutData addObject:[[data objectAtIndex:i]objectForKey:KEY_WORKOUT]];
                }
            }
            [tblList reloadData];
            arrWorkOutData.count == 0 ? [tblList addSubview:[SingletonClass ShowEmptyMessage:@"No workouts":tblList]] :[SingletonClass deleteUnUsedLableFromTable:tblList];
        }else{
            [tblList reloadData];
            arrWorkOutData.count == 0 ? [tblList addSubview:[SingletonClass ShowEmptyMessage:@"No workouts":tblList]] :[SingletonClass deleteUnUsedLableFromTable:tblList];
        }
    }else if (tagNumber == DeleteWorkOutTag){
        NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
        if ([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Workout has been deleted successfully." delegate:nil btn1:@"Ok"];
            [self getList];
        }else{
            [SingletonClass initWithTitle:EMPTYSTRING message:@"Try Again" delegate:nil btn1:@"Ok"];
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    if (searchBar.text.length==0) {
        [self getList];
    }
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar{
    if(theSearchBar.text.length>0){
        if ([SingletonClass  CheckConnectivity]) {
            UserInformation *userInfo=[UserInformation shareInstance];
            //Check for empty Text box
            NSString *strError = EMPTYSTRING;
            if(theSearchBar.text.length < 1 ){
                strError = @"Please enter searching text";
            }
            if(strError.length > 1){
                [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                return;
            }else{
                [arrWorkOutData removeAllObjects];
                [SingletonClass addActivityIndicator:self.view];
                NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"search\":\{\"name\":\"%@\"}""}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid,[theSearchBar.text lowercaseString]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceWorkoutInfo]];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                NSMutableData *data = [NSMutableData data];
                [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
                [request setHTTPBody:data];
                [NSURLConnection sendAsynchronousRequest:request
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                           if (data!=nil){
                                               [self httpResponseReceived:data :SearchWorkOutTag];
                                           }else{
                                               [SingletonClass RemoveActivityIndicator:self.view];
                                           }
                                    }];
            }
        }else{
            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
        }
    }
    [theSearchBar resignFirstResponder];
}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return arrWorkOutData.count;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"WorkOutCell";
    static NSString *CellNib = @"WorkOutListCell";
    WorkOutListCell *cell = (WorkOutListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (WorkOutListCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.del=self;
        // [cell.contentView setUserInteractionEnabled:NO];
    }
    cell.lblWorkoutName.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_NAME];
    cell.lblWorkoutName.font=SmallTextfont;
    cell.lblWorkoutSeason.text=[[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_SEASON] isEqual:EMPTYSTRING] ? KEY_OFF_SEASON :[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_SEASON]  ;
    cell.lblWorkoutSeason.font=SmallTextfont;
    cell.lblWorkoutType.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_TYPE] ?[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_TYPE] :EMPTYSTRING;
    cell.lblWorkoutType.font=SmallTextfont;
    
    cell.lblWorkoutDate.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_DATE] ?[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_DATE] :EMPTYSTRING ;
    cell.lblWorkoutDate.font=SmallTextfont;
    cell.lblWorkoutCratedBy.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_CREATED_BY] ;
    cell.lblWorkoutCratedBy.font=Textfont;
    
    if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
        cell.rightUtilityButtons = [self rightButtons :(int)(indexPath.section)];
        cell.delegate=self;
    }else if ([UserInformation shareInstance].userType == isAthlete && [UserInformation shareInstance].userId == [[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_USER_ID] intValue]){
        cell.rightUtilityButtons = [self rightButtons :(int)(indexPath.section)];
        cell.delegate=self;
    }
    if (_notificationData) {
        NSArray *arrTemp=(NSArray *)_notificationData ;
        if ([arrTemp containsObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_ID]]) {
            cell.lblWorkoutCratedBy.font = [UIFont boldSystemFontOfSize: cell.lblWorkoutCratedBy.font.pointSize];
            cell.lblWorkoutName.font = [UIFont boldSystemFontOfSize: cell.lblWorkoutName.font.pointSize];
        }
    }
    return cell;
}
- (NSArray *)rightButtons :(int)tag{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"deleteBtn.png"] :tag];
    return rightUtilityButtons;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController){
        if ([object isKindOfClass:[WorkOutDetails class]]){
            Status=TRUE;
            WorkOutDetails *workoutDetails=(WorkOutDetails *)object;
            workoutDetails.obj=[[arrWorkOutData objectAtIndex:indexPath.section] copy];
            if (_notificationData){
                NSArray *arrTemp=(NSArray *)_notificationData;
                if ([arrTemp containsObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_ID]]){
                    [_notificationData removeObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_ID]];
                    workoutDetails.NotificationStataus=TRUE;
                }else{
                    workoutDetails.NotificationStataus=FALSE;
                }
            }
            [self.navigationController popToViewController:workoutDetails animated:NO];
        }
    }
    if (Status==FALSE){
        WorkOutDetails *workoutDetails=[[WorkOutDetails alloc] initWithNibName:@"WorkOutDetails" bundle:nil];
        workoutDetails.obj=[[arrWorkOutData objectAtIndex:indexPath.section] copy];
        if (_notificationData) {
            NSArray *arrTemp=(NSArray *)_notificationData;
            if ([arrTemp containsObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_ID]]) {
                [_notificationData removeObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:KEY_WORKOUT_ID]];
                workoutDetails.NotificationStataus = TRUE;
            }else{
                workoutDetails.NotificationStataus = FALSE;
            }
        }
        [self.navigationController pushViewController:workoutDetails animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:0];
    switch (index) {
        case 0:{
            [self DeleteWorkOut:btn];
            break;
        }
        default:
            break;
    }
}
-(void)EditWorkOut:(id)sender{
    UIButton *btn=sender;
    AddWorkOut *edit=[[AddWorkOut alloc] init];
    edit.objEditModeData=[arrWorkOutData objectAtIndex:btn.tag];
    [self.navigationController pushViewController:edit animated:YES];
}
-(IBAction)WorkoutHistory:(id)sender{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController) {
        if ([object isKindOfClass:[WorkOutHistory class]]){
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }
    if (Status==FALSE){
        WorkOutHistory *addNew=[[WorkOutHistory alloc] init];
        [self.navigationController pushViewController:addNew animated:NO];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    buttonIndex == 1 ? [self WebServiceDeleteWorkOut :(int)(alertView.tag)] : EMPTYSTRING;
    }
-(void)DeleteWorkOut:(id)sender{
    UIButton *btn=sender;
    [SingletonClass initWithTitle:EMPTYSTRING message: @"Do you want to delete workout?" delegate:self btn1:@"No" btn2:@"Yes" tagNumber:(int)(btn.tag)];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
