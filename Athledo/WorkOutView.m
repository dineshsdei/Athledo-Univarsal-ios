//
//  WorkOutView.m
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WorkOutView.h"
#import "SWRevealViewController.h"
#import "WorkOutListCell.h"
#import "AddWorkOut.h"
#import "WorkOutHistory.h"
#import "WorkOutDetails.h"

// tagNumber->100 for get list data
// tagNumber->200 for get search result

#define GetWorkOutListTag 100
#define SearchWorkOutTag 200
#define DeleteWorkOutTag 400




@interface WorkOutView ()
{
    NSMutableArray *arrWorkOutData;
    UIButton *btnAddNew;
}

@end

@implementation WorkOutView

-(void)ReAsignWorkout :(int)index
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)ReAsignWorkOut:(id)sender
{
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    arrWorkOutData=[[NSMutableArray alloc] init];
    UIButton *btnAddWorkout = [[UIButton alloc] initWithFrame:CGRectMake(220, 5, 44, 44)];
    UIImage *imageAdd=[UIImage imageNamed:@"add.png"];
    [btnAddWorkout addTarget:self action:@selector(AddNewWorkOut) forControlEvents:UIControlEventTouchUpInside];
    [btnAddWorkout setImage:imageAdd forState:UIControlStateNormal];
    
     UIBarButtonItem *BarItemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAddWorkout];
    
    UIButton *btnHistory = [[UIButton alloc] initWithFrame:CGRectMake(150, 5, 44, 44)];
    UIImage *imageHistory=[UIImage imageNamed:@"save_icon.png"];
    [btnHistory addTarget:self action:@selector(WorkoutHistory:) forControlEvents:UIControlEventTouchUpInside];
    [btnHistory setImage:imageHistory forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemHistory = [[UIBarButtonItem alloc] initWithCustomView:btnHistory];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemAdd,BarItemHistory, nil];
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    
}
-(void)doneClicked
{
    [self setToolbarVisibleAt:CGPointMake(160, self.view.bounds.size.height+50)];
    
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
}


-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    [self.view viewWithTag:40].center = point;
    
    [UIView commitAnimations];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title = NSLocalizedString(@"Workouts", nil);
    tblList.userInteractionEnabled=YES;
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];

    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    [super viewWillAppear:NO];
    
    if ([SingletonClass ShareInstance].isWorkOutSectionUpdate == TRUE) {
        [self getList];
    }
}
- (BOOL)revealController:(SWRevealViewController *)revealController
panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)AddNewWorkOut
{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {

    if ([object isKindOfClass:[AddWorkOut class]])
    {
        Status=TRUE;
        [self.navigationController popToViewController:object animated:NO];
    }
    }

    if (Status==FALSE)
    {
    AddWorkOut *annView=[[AddWorkOut alloc] initWithNibName:@"AddWorkOut" bundle:nil];

    [self.navigationController pushViewController:annView animated:NO];
    }
    
}


- (void)getList

{
    if ([SingletonClass  CheckConnectivity]) {

    UserInformation *userInfo=[UserInformation shareInstance];

    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;

    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = ACTIVITYTAG;
    [self.view addSubview:indicator];

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
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:ACTIVITYTAG];
    if(acti)
    [acti removeFromSuperview];
    }
    }];
    }else{
        
    [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}


- (void)WebServiceDeleteWorkOut : (int )Index
{
    if ([SingletonClass  CheckConnectivity])
    {
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;

    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = ACTIVITYTAG;
    [self.view addSubview:indicator];

    NSString *strURL = [NSString stringWithFormat:@"{\"workout_id\":\"%d\"}",[[[arrWorkOutData objectAtIndex:Index] objectForKey:@"Workout Id"] intValue]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceDeleteWorkOut]];
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
    [self httpResponseReceived:data :DeleteWorkOutTag];

    }else{

    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:ACTIVITYTAG];
    if(acti)
    [acti removeFromSuperview];
    }
    }];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}


#pragma mark-  Http call back

-(void)httpResponseReceived:(NSData *)webResponse :(int )tagNumber
{
    // tagNumber->100 for get list data
    // tagNumber->200 for get search result
   
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationItem.leftBarButtonItem.enabled=YES;
    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:ACTIVITYTAG];
    if(acti)
    [acti removeFromSuperview];
    // Now we Need to decrypt data
    NSError *error=nil;

    if (tagNumber == GetWorkOutListTag)
    {
    [SingletonClass ShareInstance].isWorkOutSectionUpdate =FALSE;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];

    if ([[myResults objectForKey:@"status"] isEqualToString:@"success"])
    {

    [arrWorkOutData removeAllObjects];

    NSArray *data=[myResults objectForKey:@"data"] ;

    for (int i=0; i< data.count; i++)
    {

    if ([[data objectAtIndex:i]objectForKey:@"Workout"]) {

    [arrWorkOutData addObject:[[data objectAtIndex:i]objectForKey:@"Workout"]];
    }

    }

    [tblList reloadData];

    }else
    {
    [SingletonClass initWithTitle:@"" message:@"No Data Found!" delegate:nil btn1:@"Ok"];
    }

    }else if (tagNumber == SearchWorkOutTag)
    {

    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];

    NSArray *data=[myResults objectForKey:@"data"] ;
    if ([[myResults objectForKey:@"status"] isEqualToString:@"success"])
    {
    [arrWorkOutData removeAllObjects];

    for (int i=0; i< data.count; i++)
    {
    if ([[data objectAtIndex:i]objectForKey:@"Workout"]) {

    [arrWorkOutData addObject:[[data objectAtIndex:i]objectForKey:@"Workout"]];
    }

    }

    [tblList reloadData];

    }else
    {
    [self getList];

    [SingletonClass initWithTitle:@"" message:@"No Data Found!" delegate:nil btn1:@"Ok"];
    }
    }else if (tagNumber == DeleteWorkOutTag)
    {

    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];

    if ([[myResults objectForKey:@"status"] isEqualToString:@"success"])
    {
    [SingletonClass initWithTitle:@"" message:@"Workout has been deleted successfully." delegate:nil btn1:@"Ok"];
    [self getList];
    }else
    {
    // [self getList];

    [SingletonClass initWithTitle:@"" message:@"Try Again!" delegate:nil btn1:@"Ok"];
    }

    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    if (searchBar.text.length==0) {
        [self getList];
    }
    
    [searchBar resignFirstResponder];
}



-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    if(theSearchBar.text.length>0)
    {
    if ([SingletonClass  CheckConnectivity]) {

    UserInformation *userInfo=[UserInformation shareInstance];
    //Check for empty Text box
    NSString *strError = @"";
    if(theSearchBar.text.length < 1 )
    {
    strError = @"Please enter searching text";
    }

    if(strError.length > 1)
    {
    [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
    return;

    }else{

    [arrWorkOutData removeAllObjects];

    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = ACTIVITYTAG;
    [self.view addSubview:indicator];

    NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"search\":\{\"name\":\"%@\"}""}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid,[theSearchBar.text lowercaseString]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceWorkoutInfo]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableData *data = [NSMutableData data];
    //[data appendData:[[NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"] dataUsingEncoding: NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
    [request setHTTPBody:data];

    [NSURLConnection sendAsynchronousRequest:request
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
    if (data!=nil)
    {
    [self httpResponseReceived:data :SearchWorkOutTag];
    }else{
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:ACTIVITYTAG];
    if(acti)
    [acti removeFromSuperview];
    }

    }];

    }

    }else{

    [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }

    }
    [theSearchBar resignFirstResponder];
}


#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return arrWorkOutData.count;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    cell.lblWorkoutName.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Name"];
    cell.lblWorkoutName.font=SmallTextfont;

    cell.lblWorkoutSeason.text=[[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"season"] isEqual:@""] ? @"Off Season" :[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"season"]  ;
    cell.lblWorkoutSeason.font=SmallTextfont;
    
    cell.lblWorkoutType.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Type"] ?[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Type"] :@"" ;
    cell.lblWorkoutType.font=SmallTextfont;

    cell.lblWorkoutDate.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Date"] ?[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Date"] :@"" ;
    cell.lblWorkoutDate.font=SmallTextfont;
    cell.lblWorkoutCratedBy.text=[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"createdby"] ;
    cell.lblWorkoutCratedBy.font=Textfont;
   
    cell.rightUtilityButtons = [self rightButtons :(int)(indexPath.section)];
    cell.delegate=self;
    
    if (_notificationData) {

    NSArray *arrTemp=(NSArray *)_notificationData ;
    if ([arrTemp containsObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Id"]]) {

    cell.lblWorkoutCratedBy.font=[UIFont boldSystemFontOfSize: cell.lblWorkoutCratedBy.font.pointSize];
    cell.lblWorkoutName.font=[UIFont boldSystemFontOfSize: cell.lblWorkoutName.font.pointSize];
  
    }

    }
    return cell;
}

- (NSArray *)rightButtons :(int)tag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"deleteBtn.png"] :tag];
    return rightUtilityButtons;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD) {
        return 110.0f;
    }else{
        return 104.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        if ([object isKindOfClass:[WorkOutDetails class]])
        {
        Status=TRUE;
        WorkOutDetails *workoutDetails=(WorkOutDetails *)object;
        workoutDetails.obj=[[arrWorkOutData objectAtIndex:indexPath.section] copy];
        if (_notificationData)
        {
        NSArray *arrTemp=(NSArray *)_notificationData;
        if ([arrTemp containsObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Id"]])
        {
        [_notificationData removeObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Id"]];
        workoutDetails.NotificationStataus=TRUE;

        }else{
        workoutDetails.NotificationStataus=FALSE;
        }
        }
        [self.navigationController popToViewController:workoutDetails animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
        WorkOutDetails *workoutDetails=[[WorkOutDetails alloc] initWithNibName:@"WorkOutDetails" bundle:nil];
        workoutDetails.obj=[[arrWorkOutData objectAtIndex:indexPath.section] copy];
        if (_notificationData) {
        NSArray *arrTemp=(NSArray *)_notificationData;
        if ([arrTemp containsObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Id"]]) {
        [_notificationData removeObject:[[arrWorkOutData objectAtIndex:indexPath.section] objectForKey:@"Workout Id"]];
        workoutDetails.NotificationStataus=TRUE;

        }else{
        workoutDetails.NotificationStataus=FALSE;
            }
        }
        [self.navigationController pushViewController:workoutDetails animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:0];
    switch (index) {
    case 0:
    {
    [self DeleteWorkOut:btn];

    break;
    }

    default:
    break;
    }
}
-(void)EditWorkOut:(id)sender
{
    UIButton *btn=sender;
    AddWorkOut *edit=[[AddWorkOut alloc] init];
    edit.objEditModeData=[arrWorkOutData objectAtIndex:btn.tag];
    [self.navigationController pushViewController:edit animated:YES];
}

-(IBAction)WorkoutHistory:(id)sender
{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController) {

    if ([object isKindOfClass:[WorkOutHistory class]])
    {
    Status=TRUE;
    [self.navigationController popToViewController:object animated:NO];
    }
    }
    if (Status==FALSE)
    {
    WorkOutHistory *addNew=[[WorkOutHistory alloc] init];
    [self.navigationController pushViewController:addNew animated:NO];
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    buttonIndex==1 ? [self WebServiceDeleteWorkOut :(int)(alertView.tag)] : @"";

}
-(void)DeleteWorkOut:(id)sender
{
    UIButton *btn=sender;
    [SingletonClass initWithTitle:@"" message: @"Do you want to delete workout ?" delegate:self btn1:@"NO" btn2:@"YES" tagNumber:(int)(btn.tag)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
