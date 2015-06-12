//
//  AnnouncementView.m
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AnnouncementView.h"
#import "SWRevealViewController.h"
#import "UserInformation.h"
#import "AnnouncementCell.h"
#import "UIImageView+WebCache.h"
#import "AddNewAnnouncement.h"
#import "UpdateDetails.h"
#import "AppDelegate.h"

# define tblViewY (([UIScreen mainScreen].bounds.size.height >= 568)?266:180)

#define USE_GESTURE_RECOGNIZERS YES
#define BOUNCE_PIXELS 5.0
#define BUTTON_LEFT_MARGIN 10.0
@interface AnnouncementView ()
{
    UserInformation *userInfo;
    NSMutableArray *arrAnnouncements;
    NSInteger deleteBtnTag;
    
    BOOL isKeyBoard;
    CGRect btnEditFram;
    int tagNumber;
    int deleteIndex;
    UIButton *btnAddNew;
    NSString *nameStr, *descStr, *dateStr, *timeStr, *emailNotification,*privacySettings, *groupId;
    NSArray* buttonData;
    int toolBarPosition;
    int textFieldTag;
    UITextField *currentText;
    UITextView *txtViewCurrent;
    NSArray *notificationData;
    UIDeviceOrientation oraintation;
    
}

@end

@implementation AnnouncementView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)awakeFromNib
{
}

- (void)orientationChanged:(NSNotification *)notification
{
    [SingletonClass deleteUnUsedLableFromTable:tblAnnouncementRecods];
    [SingletonClass deleteUnUsedLableFromTable:tblUpdatesRecods];
}

-(void)AddNewAnnouncement
{
    AddNewAnnouncement *addNew=[[AddNewAnnouncement alloc] initWithNibName:@"AddNewAnnouncement" bundle:nil];
    addNew.obj=nil;
    addNew.ScreenTitle=@"Add Announcement";
    
    [self.navigationController pushViewController:addNew animated:YES];
    
}
-(void)delete:(id)sender
{
}

-(void)deleteCell:(id)sender
{
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                
                //Check for empty Text box
                NSString *strError = EMPTYSTRING;
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    
                    [arrAnnouncements removeAllObjects];
                    [SearchBar resignFirstResponder];
                    [self SearchAnnouncement : theSearchBar.text];
                 }
                
            }else{
                
                [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)getNotificationData{
    
    if ([SingletonClass  CheckConnectivity])
    {
        userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];
        
        //[SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetNotification :strURL :getNotificationTag];
        
    }else{
        
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
        
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    switch (Tag){
        case getNotificationTag:{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                notificationData=[MyResults objectForKey:DATA];
                if (userInfo.userType==1 || userInfo.userType==4) {
                    [tblAnnouncementRecods reloadData];
                }else{
                    [tblUpdatesRecods reloadData];
                }
            }
           break;
        }
        case getAnnouncementTag:{
            [SingletonClass deleteUnUsedLableFromTable:tblAnnouncementRecods];
            [SingletonClass deleteUnUsedLableFromTable:tblUpdatesRecods];
            NSArray *data=[MyResults objectForKey:DATA] ;
            if ([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                [arrAnnouncements removeAllObjects];
                self.navigationItem.rightBarButtonItem.enabled=YES;
                self.navigationItem.leftBarButtonItem.enabled=YES;
                for (int i=0; i< data.count; i++){
                    [arrAnnouncements addObject:[[data objectAtIndex:i]objectForKey:@"Announcement"]];
                }
                switch (userInfo.userType) {
                    case 1:{
                        tblAnnouncementRecods.delegate=self;
                        tblAnnouncementRecods.dataSource=self;
                        arrAnnouncements.count == 0 ?  [tblAnnouncementRecods addSubview:[SingletonClass ShowEmptyMessage:@"No announcements":tblAnnouncementRecods] ] : @"";
                        
                        [tblAnnouncementRecods reloadData];
                        
                        break;
                    }
                    case 2:{
                        tblUpdatesRecods.delegate=self;
                        tblUpdatesRecods.dataSource=self;
                        arrAnnouncements.count == 0 ?  [tblAnnouncementRecods addSubview:[SingletonClass ShowEmptyMessage:@"No announcements":tblAnnouncementRecods] ] : @"";
                        [tblUpdatesRecods reloadData];
                        break;
                    }
                    case 4:{
                        tblAnnouncementRecods.delegate=self;
                        tblAnnouncementRecods.dataSource=self;
                        [tblAnnouncementRecods reloadData];
                        break;
                    }
                }
            }else{
                [tblAnnouncementRecods reloadData];
                self.navigationItem.rightBarButtonItem.enabled=YES;
                self.navigationItem.leftBarButtonItem.enabled=YES;
                [arrAnnouncements removeObject:[[data objectAtIndex:0]objectForKey:@"Announcement"]];
                
                [tblAnnouncementRecods addSubview:[SingletonClass ShowEmptyMessage:@"No announcements":tblAnnouncementRecods] ];
                 [tblUpdatesRecods addSubview:[SingletonClass ShowEmptyMessage:@"No announcements":tblUpdatesRecods] ];
            }
            [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
         case searchAnnouncementTag:{
             [SingletonClass deleteUnUsedLableFromTable:tblAnnouncementRecods];
             [SingletonClass deleteUnUsedLableFromTable:tblUpdatesRecods];
           
            if ([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                [arrAnnouncements removeAllObjects];
                NSArray *data=[MyResults objectForKey:DATA] ;
                for (int i=0; i< data.count; i++){
                    //if (![arrAnnouncements containsObject:[[data objectAtIndex:i]objectForKey:@"Announcement"]]) {
                        [arrAnnouncements addObject:[[data objectAtIndex:i]objectForKey:@"Announcement"]];
                    //}
                }
                switch (userInfo.userType) {
                  case 1:{
                        [tblAnnouncementRecods reloadData];
                        break;
                    }
                 case 2:{
                        [tblUpdatesRecods reloadData];
                        break;
                    }
                    case 4:{
                        [tblAnnouncementRecods reloadData];
                        break;
                    }
                }
            }else{
                [SingletonClass RemoveActivityIndicator:self.view];
                [SingletonClass deleteUnUsedLableFromTable:tblAnnouncementRecods];
                 arrAnnouncements.count == 0 ?
                [tblAnnouncementRecods addSubview:[SingletonClass ShowEmptyMessage:@"No announcements":tblAnnouncementRecods]] :@"";
                [tblAnnouncementRecods reloadData];
            }
            [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
    }
}
- (void)getList
{
    if ([SingletonClass  CheckConnectivity])
    {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.navigationItem.leftBarButtonItem.enabled=NO;
        
        userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"search\":\{}""}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceSearchAnnouncement :strURL :getAnnouncementTag];
   
    }else{
        
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}

- (void)SearchAnnouncement :(NSString *)searchText
{
    if ([SingletonClass  CheckConnectivity])
    {
        userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        
       NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"type\":\"%d\",\"team_id\":\"%d\",\"search\":\{\"name\":\"%@\",\"date\":\"%@\"}""}",userInfo.userId,userInfo.userType,userInfo.userSelectedTeamid,[searchText lowercaseString],EMPTYSTRING];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceSearchAnnouncement :strURL :searchAnnouncementTag];
        
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(NSMutableArray*)sortingArrayOfDict:(NSMutableArray *)arrayTosort sortByObject:(NSString*)sortKey{
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    [arrayTosort sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
    return arrayTosort;
}
-(IBAction)searchData:(NSString *)searchText{
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    if (searchBar.text.length==0) {
        [self getList];
    }
    [searchBar resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:arrAnnouncements forKey:@"announcementdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (isIPAD)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    self.title = @"Announcements";
    if (isIPAD){
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    userInfo=[UserInformation shareInstance];
    [self getNotificationData];
    [self CerateLayOut];
    [super viewWillAppear:NO];
    if ([SingletonClass ShareInstance].isAnnouncementUpdate == TRUE) {
        [self getList];
        [SingletonClass ShareInstance].isAnnouncementUpdate=FALSE;
    }else{
        switch (userInfo.userType) {
            case isCoach:{
                tblAnnouncementRecods.delegate=self;
                tblAnnouncementRecods.dataSource=self;
                [tblAnnouncementRecods reloadData];
                break;
            }
            case isAthlete:{
                tblUpdatesRecods.delegate=self;
                tblUpdatesRecods.dataSource=self;
                [tblUpdatesRecods reloadData];
                break;
            }
            case isManeger:{
                tblAnnouncementRecods.delegate=self;
                tblAnnouncementRecods.dataSource=self;
                [tblAnnouncementRecods reloadData];
                break;
            }
        }
    }
}
-(void)CerateLayOut{
    switch (userInfo.userType){
        case isCoach:{
            tblUpdatesRecods.hidden=YES;
            tblAnnouncementRecods.hidden=NO;
            btnAddNew.hidden=NO;
            SearchBar.hidden=NO;
             break;
        }
        case isAthlete:{
            tblAnnouncementRecods.hidden=YES;
            btnAddNew.hidden=YES;
            btnSearch.hidden=YES;
            tfSearch.hidden=YES;
            SearchBar.hidden=YES;
            break;
        }
        case isManeger:{
            tblUpdatesRecods.hidden=YES;
            tblAnnouncementRecods.hidden=NO;
            btnAddNew.hidden=NO;
            SearchBar.hidden=NO;
            break;
        }
        default:
            break;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad{
    if (isIPAD) {
        [AppDelegate restrictRotation :NO];
    }else{
        [AppDelegate restrictRotation :YES];
    }
    userInfo=[UserInformation shareInstance];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblAnnouncementRecods.backgroundColor=[UIColor clearColor];
    tblUpdatesRecods.backgroundColor=[UIColor clearColor];
    arrAnnouncements=[[NSMutableArray alloc] init];
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    SWRevealViewController *revealController = [self revealViewController];
    // revealController.delegate=self;
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
     btnAddNew = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageEdit=[UIImage imageNamed:@"Navadd.png"];
     btnAddNew.bounds = CGRectMake( 0, 0, imageEdit.size.width, imageEdit.size.height );
    [btnAddNew addTarget:self action:@selector(AddNewAnnouncement) forControlEvents:UIControlEventTouchUpInside];
    [btnAddNew setImage:imageEdit forState:UIControlStateNormal];
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnAddNew];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = NAVIGATION_ICON_BG_COLOR;
    [self CerateLayOut];
    [[SingletonClass ShareInstance] CurrentOrientation:self];
    [self getList];
    [SingletonClass ShareInstance].isAnnouncementUpdate=FALSE;
}

- (BOOL)revealController:(SWRevealViewController *)revealController
panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)doneClicked{
    [currentText resignFirstResponder];
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
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return arrAnnouncements.count;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"DashBoardCell";
    static NSString *CellNib = @"AnnouncementCell";
    AnnouncementCell *cell = (AnnouncementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (AnnouncementCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;

    }
    cell.btnDelete.tag=indexPath.section;
    cell.btnEdit.tag=indexPath.section;
    
    // Show desending order data of array
    int DesendingIndex=(int)(indexPath.section);
    cell.lblSenderName.text=[[arrAnnouncements objectAtIndex:DesendingIndex] objectForKey:@"sender"];
    cell.lblSenderName.font=Textfont;
    cell.lblAnnoName.text=[[arrAnnouncements objectAtIndex:DesendingIndex] objectForKey:@"name"];
    cell.lblAnnoName.tag=10;
    cell.lblAnnoName.font=SmallTextfont;
    
    cell.lblAnnoDesc.text=[[arrAnnouncements objectAtIndex:DesendingIndex] objectForKey:@"description"] ?[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"description"] :EMPTYSTRING ;
    cell.lblAnnoDesc.tag=11;
    cell.lblAnnoDesc.font=SmallTextfont;
    
    cell.lblAnnoDate.text=[[arrAnnouncements objectAtIndex:DesendingIndex] objectForKey:@"schedule_date"] ?[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"schedule_date"] :EMPTYSTRING ;
    cell.lblAnnoDate.font=SmallTextfont;
    cell.lblAnnoDate.tag=12;
    
    NSArray *arrtemp=[notificationData valueForKey:@"announcements"];
    if (notificationData) {
        if ([arrtemp containsObject:[[arrAnnouncements objectAtIndex:DesendingIndex] objectForKey:@"id"]]) {
            cell.lblSenderName.font=[UIFont boldSystemFontOfSize:cell.lblSenderName.font.pointSize];
            cell.lblAnnoName.font=[UIFont boldSystemFontOfSize:cell.lblAnnoName.font.pointSize];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpdateDetails *updateDetails=[[UpdateDetails alloc] init];
    updateDetails.obj=[arrAnnouncements objectAtIndex:indexPath.section];
    updateDetails.strName=[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"name"];
    updateDetails.strDate=[[[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"schedule_date"] stringByAppendingString:@" " ] stringByAppendingString:[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"schedule_time"]];
    updateDetails.strDes=[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"description"];
    NSArray *arrtemp=[notificationData valueForKey:@"announcements"];
    if ([arrtemp containsObject:[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"id"]]) {
        updateDetails.NotificationStataus=TRUE;
        [[notificationData valueForKey:@"announcements"] removeObject:[[arrAnnouncements objectAtIndex:indexPath.section] objectForKey:@"id"]];
    }else{
        updateDetails.NotificationStataus=FALSE;
    }
    [self.navigationController pushViewController:updateDetails animated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}

-(void)editCell:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    AddNewAnnouncement *addNew=[[AddNewAnnouncement alloc] init];
    addNew.obj = [arrAnnouncements objectAtIndex:btn.tag];
    [self.navigationController pushViewController:addNew animated:YES];
}
-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
