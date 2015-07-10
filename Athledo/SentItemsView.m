//
//  SentItemsView.m
//  Athledo
//
//  Created by Smartdata on 9/11/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "SentItemsView.h"
#import "ComposeMessage.h"
#import "ArichiveView.h"
#import "MessangerView.h"
#import "TSActionSheet.h"
#import "MessageInboxCell.h"
#import "UIImageView+WebCache.h"
#import "MessageDetails.h"
#import "SWRevealViewController.h"

@interface SentItemsView ()
@end
@implementation SentItemsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark Webservice call event
-(void)getMessages{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];
        
        [SingletonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetSentMessageslist :strURL :getMessagesTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)deleteMessageEvent :(int)Webmail_id :(int)webmail_sender_id{
    if ([SingletonClass  CheckConnectivity]) {
        // UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"webmail_id\":\"%d\"}",webmail_sender_id,Webmail_id];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceDeleteMessage :strURL :deleteMessagesTag];
        
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)archiveMessageEvent :(int)webmail_parent_id{
    if ([SingletonClass  CheckConnectivity]) {
        NSString *strURL = [NSString stringWithFormat:@"{\"status\":\"%@\",\"webmail_parent_id\":\"%d\"}",@"sent_to_archive",webmail_parent_id];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceMessageStatus:strURL :archiveMessagesTag];
        
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    switch (Tag)
    {
        case getMessagesTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                messageArrDic =[MyResults objectForKey:DATA];
                messageArrDic.count == 0 ? ([table addSubview:[SingletonClass ShowEmptyMessage:@"No messages":table]]): [SingletonClass deleteUnUsedLableFromTable:table];
                [table reloadData];
            }else
            {
                [table addSubview:[SingletonClass ShowEmptyMessage:@"No messages":table]];
            }
            [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
        case deleteMessagesTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                [SingletonClass RemoveActivityIndicator:self.view];
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Message deleted successully" delegate:nil btn1:@"Ok"];
                [self getMessages];
            }else{
                [SingletonClass RemoveActivityIndicator:self.view];
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Message delete fail try again" delegate:nil btn1:@"Ok"];
            }
            [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
        case archiveMessagesTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                [SingletonClass ShareInstance].isMessangerSent = TRUE;
                [SingletonClass ShareInstance].isMessangerArchive = TRUE;
                [SingletonClass RemoveActivityIndicator:self.view];
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Message archived successully" delegate:nil btn1:@"Ok"];
                [self getMessages];
            }else{
                [SingletonClass RemoveActivityIndicator:self.view];
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Message archive fail try again" delegate:nil btn1:@"Ok"];
            }
            [SingletonClass RemoveActivityIndicator:self.view];
            break;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:1];
    [tabBar setSelectedItem:tabBarItem];
    if([SingletonClass ShareInstance].isMessangerSent==TRUE){
        [self getMessages];
        [SingletonClass ShareInstance].isMessangerSent=FALSE;
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)orientationChanged{
    [SingletonClass deleteUnUsedLableFromTable:table];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    messageArrDic=[[NSArray alloc] init];
    self.title = NSLocalizedString(@"Sent Messages", EMPTYSTRING);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    UIButton  *btnCompose = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 25, 25)];
    UIImage *imageEdit=[UIImage imageNamed:@"compose_icon.png"];
    [btnCompose addTarget:self action:@selector(ComposeMessage:) forControlEvents:UIControlEventTouchUpInside];
    [btnCompose setBackgroundImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCompose];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    [self getMessages];
}

-(void)ComposeMessage:(id)sender{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController){
        if ([object isKindOfClass:[ComposeMessage class]]){
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }
    if (Status==FALSE){
        ComposeMessage *compose=[[ComposeMessage alloc] initWithNibName:@"ComposeMessage" bundle:nil];
        [self.navigationController pushViewController:compose animated:NO];
    }
}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    messageArrDic=[messageArrDic copy];
    return messageArrDic.count;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MessageInboxCell";
    static NSString *CellNib = @"MessageInboxCell";
    MessageInboxCell *cell = (MessageInboxCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (MessageInboxCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //[cell.contentView setUserInteractionEnabled:NO];
        cell.delegate=self;
        cell.btndelete.tag=indexPath.section;
        cell.btnarchive.tag=indexPath.section;
        cell.btnarchive.hidden=YES;
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.lblSenderName.text=[[messageArrDic objectAtIndex:indexPath.section] objectForKey:@"reciever"];
    cell.lblReceivingDate.text=[[messageArrDic objectAtIndex:indexPath.section] objectForKey:KEY_date];
    cell.lblDescription.text=[[messageArrDic objectAtIndex:indexPath.section] valueForKey:Key_discription];
    cell.lblDescription.text  =[cell.lblDescription.text  stringByReplacingOccurrencesOfString:@"/n" withString:EMPTYSTRING];
    [cell.senderPic setImageWithURL:[NSURL URLWithString:[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
    cell.senderPic.layer.masksToBounds = YES;
    cell.senderPic.layer.cornerRadius=(cell.senderPic.frame.size.width)/2;
    cell.senderPic.layer.borderWidth=2.0f;
    cell.senderPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    if ([[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"reciever_type"] isKindOfClass:[NSString class]]) {
        
        cell.senderTypePic.image=[[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"reciever_type"] intValue] == 1 ? [UIImage imageNamed:@"Coach.png"] : [UIImage imageNamed:@"Athlete.png"];
    }
    cell.lblSenderName.font=Textfont;
    cell.lblDescription.font=SmallTextfont;
    cell.lblReceivingDate.font=SmallTextfont;
    if ([[[messageArrDic objectAtIndex:indexPath.section] objectForKey:@"is_read"] intValue] == 1) {
        // cell.lblSenderName.textColor=[UIColor lightGrayColor];
    }else
    {    cell.lblSenderName.font = [UIFont boldSystemFontOfSize:15];
        //cell.lblSenderName.textColor=[UIColor lightGrayColor];
    }
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIImageView *img1;
    if (isIPAD) {
        img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3, cell.frame.size.width, 1)];
        
    }else{
        img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3, cell.frame.size.width, 1)];
    }
    img1.image=[UIImage imageNamed:@"menu_sep.png"];
    //[cell addSubview:img1];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.rightUtilityButtons = [self rightButtons :(int)indexPath.section];
    cell.delegate=self;
    return cell;
}

- (NSArray *)rightButtons :(int)btnTag{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"deleteBtn.png"] :btnTag];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:41/255.0 green:58/255.0 blue:71/255.0 alpha:1.0] icon:[UIImage imageNamed:@"update_icon.png"] :btnTag];
    return rightUtilityButtons;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetails *details=[[MessageDetails alloc] init];
    details.webmail_id=[[messageArrDic  objectAtIndex:indexPath.section] valueForKey:@"webmail_id"];
    details.webmail_parent_id=[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"webmail_parent_id"];
    [self.navigationController pushViewController:details animated:NO];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:0];
    switch (index) {
        case 0:
        {
            [self deleteMessage:btn];
            break;
        }
        case 1:
        {
            [self archiveMessage:btn];
            break;
        }
        default:
            break;
    }
}
-(void)deleteMessage:(id)sender
{
    UIButton *btn=sender;
    [SingletonClass initWithTitle:EMPTYSTRING message: @"Do you want to delete message?" delegate:self btn1:@"No" btn2:@"Yes" tagNumber:(int)btn.tag];
}
-(void)archiveMessage:(id)sender;
{
    UIButton *btn=sender;
    [self archiveMessageEvent:[[[messageArrDic objectAtIndex:btn.tag] valueForKey:
                                @"webmail_parent_id"] intValue] ];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deleteMessageEvent:[[[messageArrDic objectAtIndex:alertView.tag] valueForKey:
                                   @"webmail_id"] intValue]:[[[messageArrDic objectAtIndex:alertView.tag] valueForKey:
                                                              
                                                              @"webmail_sender_id"] intValue] ];
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray *arrController=[self.navigationController viewControllers];
    switch (item.tag) {
        case 0:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                if ([object isKindOfClass:[MessangerView class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            if (Status==FALSE)
            {
                MessangerView *sentItems=[[MessangerView alloc] initWithNibName:@"MessangerView" bundle:nil];
                [self.navigationController pushViewController:sentItems animated:NO];
            }
            
            break;
        } case 2:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                if ([object isKindOfClass:[ArichiveView class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            if (Status==FALSE)
            {
                ArichiveView *arichive=[[ArichiveView alloc] initWithNibName:@"ArichiveView" bundle:nil];
                [self.navigationController pushViewController:arichive animated:NO];
            }
            break;
        }
        default:
            break;
    }
}
-(void)CalculateBMI
{
    /*
     float feet, inches, stones, pounds, m, cm, kg, kilo, meter, cmeter;
     NSString* ft =self.ftInput.text;
     feet = [ft floatValue];
     NSString* ins = self.insInput.text;
     inches = [ins floatValue];
     
     NSString *st = self.stInput.text;
     stones = [st floatValue];
     NSString *lbs = self.lbsInput.text;
     pounds = [lbs floatValue];
     
     m = feet;
     cm = inches;
     kg = stones;
     cm=feet;
     
     if ([labelFt.text isEqualToString:@"ft"] && [labelSt.text isEqualToString:@"st"]) {
     
     float height = (feet*12)+inches;
     float heightValue =height*height;
     
     float weightValue = (stones*14)+pounds;
     float result = ((weightValue / heightValue)*703);
     finalBmi = result;
     NSString *resultBmi = [NSString stringWithFormat:@"%f", result];
     NSRange range = [resultBmi rangeOfString:@"." options: 0];
     NSString *newString = [resultBmi substringToIndex:(range.location+2)];
     
     bmiResult.text = newString;
     
     }else if([labelFt.text isEqualToString:@"m"] && [labelSt.text isEqualToString:@"kg"]){
     
     float height = m+(cm/100);
     float heightValue =height*height;
     
     float weightValue = kg;
     
     float result = (weightValue / heightValue);
     finalBmi = result;
     
     NSString *resultBmi = [NSString stringWithFormat:@"%f", result];
     NSRange range = [resultBmi rangeOfString:@"." options: 0];
     NSString *newString = [resultBmi substringToIndex:(range.location+2)];
     
     bmiResult.text = newString;
     }else if([labelFt.text isEqualToString:@"ft"] && [labelSt.text isEqualToString:@"kg"]){
     meter = m*0.3048;
     cmeter = inches*2.54;
     float height = meter+(cmeter/100);
     float heightValue =height*height;
     
     float weightValue = kg;
     
     float result = (weightValue / heightValue);
     finalBmi = result;
     
     NSString *resultBmi = [NSString stringWithFormat:@"%f", result];
     NSRange range = [resultBmi rangeOfString:@"." options: 0];
     NSString *newString = [resultBmi substringToIndex:(range.location+2)];
     
     bmiResult.text = newString;
     }else if([labelFt.text isEqualToString:@"m"] && [labelSt.text isEqualToString:@"st"]){
     kilo = kg*6.35;
     float height = m+(cm/100);
     float heightValue =height*height;
     
     float weightValue = kilo;
     float result = ((weightValue / heightValue)*703);
     finalBmi = result;
     
     
     
     NSString *resultBmi = [NSString stringWithFormat:@"%f", result];
     NSRange range = [resultBmi rangeOfString:@"." options:0 ];
     NSString *newString = [resultBmi substringToIndex:(range.location+2)];
     
     bmiResult.text = newString;        }
     
     
     // Only to calculate in CM
     else if([labelFt.text isEqualToString:@"cm"]&& [labelSt.text isEqualToString:@"st"]){
     kilo = kg*6.35;
     
     kilo= kilo+(pounds*0.454);
     
     // float height = m+(cm/100);
     float height= cm/100;
     float heightValue =height*height;
     
     //        float weightValue = kilo;
     //        float result = ((weightValue / heightValue)*703);
     //        finalBmi = result;
     
     float weightValue = kilo;
     
     float result = (weightValue / heightValue);
     finalBmi = result;
     
     
     
     NSString *resultBmi = [NSString stringWithFormat:@"%f", result];
     NSRange range = [resultBmi rangeOfString:@"." options:0 ];
     NSString *newString = [resultBmi substringToIndex:(range.location+2)];
     
     bmiResult.text = newString;        }
     
     
     else if([labelFt.text isEqualToString:@"cm"]&& [labelSt.text isEqualToString:@"kg"]){
     float height = cm/100;
     float heightValue =height*height;
     
     float weightValue = kg;
     
     float result = (weightValue / heightValue);
     finalBmi = result;
     
     NSString *resultBmi = [NSString stringWithFormat:@"%f", result];
     NSRange range = [resultBmi rangeOfString:@"." options: 0];
     NSString *newString = [resultBmi substringToIndex:(range.location+2)];
     
     bmiResult.text = newString;
     }
     
     
     NSMutableArray *userInfo = [[NSMutableArray alloc]init];
     CommonClass *singleton=[CommonClass sharedInstance];
     userInfo = singleton.loginUser;
     
     if (finalBmi > 25)
     {
     
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cambridge Weight Plan" message:@"Your BMI suggests that you are overweight. Please contact your nearest Cambridge Weight Plan Consultant to see how you can\nstart losing weight and looking\n great today" delegate:self cancelButtonTitle:@"Find a Consultant" otherButtonTitles:@" Maybe later  ", nil];
     [alert show];
     }
     
     
     //        if (finalBmi > 25 && [[CommonClass sharedInstance].logged isEqual:@"Yes"] && ([[userInfo valueForKey:@"roles"] isEqualToString:@"Paid"] || [[userInfo valueForKey:@"roles"] isEqualToString:@"Consultant"]))
     //        {
     //
     //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cambridge Weight Plan" message:@"Your BMI suggests that you are overweight. Please contact your nearest Cambridge Weight Plan Consultant to see how you can start losing weight and looking great today" delegate:self cancelButtonTitle:@"     Maybe later    " otherButtonTitles:@"Find a Consultant", nil];
     //            [alert show];
     //            }
     
     */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

