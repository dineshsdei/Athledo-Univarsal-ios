//
//  ArichiveView.m
//  Athledo
//
//  Created by Dinesh Kumar on 9/11/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "ArichiveView.h"
#import "SentItemsView.h"
#import "ComposeMessage.h"
#import "MessangerView.h"
#import "TSActionSheet.h"
#import "UIImageView+WebCache.h"
#import "MessageDetails.h"
#import "SWRevealViewController.h"

@interface ArichiveView ()

@end

@implementation ArichiveView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
   
    
    UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:2];
    
    [tabBar setSelectedItem:tabBarItem];
     if([SingletonClass ShareInstance].isMessangerArchive==TRUE)
     {
         [self getMessages];
         [SingletonClass ShareInstance].isMessangerArchive=FALSE;
     }
}

#pragma mark Webservice call event
-(void)getMessages{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];
        
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceArchiveMessage :strURL :getMessagesTag];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
  
}
-(void)deleteMessageEvent:(NSInteger)index{
    
    if ([SingletonClass  CheckConnectivity]) {
    
        NSString *strURL=@"";
        
        if([[[messageArrDic objectAtIndex:index] valueForKey:@"mail_from"] isEqualToString:@"inbox"])
        {
             strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"webmail_id\":\"%d\"}",[[[messageArrDic objectAtIndex:index] valueForKey:@"webmail_receiver_id"] intValue],[[[messageArrDic objectAtIndex:index] valueForKey:@"webmail_id"] intValue]];
            
        }else if([[[messageArrDic objectAtIndex:index] valueForKey:@"mail_from"] isEqualToString:@"sent"])
        {
            strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"webmail_id\":\"%d\"}",[[[messageArrDic objectAtIndex:index] valueForKey:@"webmail_sender_id"] intValue],[[[messageArrDic objectAtIndex:index] valueForKey:@"webmail_id"] intValue]];

        }
        //[SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceDeleteMessage :strURL :deleteMessagesTag];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}
-(void)archiveMessageMoveToInboxEvent:(int)index{
    
    if ([SingletonClass  CheckConnectivity]) {
        
        NSString *strURL=@"";
        
        if([[[messageArrDic objectAtIndex:index] valueForKey:@"mail_from"] isEqualToString:@"inbox"])
        {
            strURL = [NSString stringWithFormat:@"{\"status\":\"%@\",\"webmail_parent_id\":\"%d\"}",@"move_to_inbox",[[[messageArrDic objectAtIndex:index] valueForKey:@"webmail_parent_id"] intValue]];
            
        }else if([[[messageArrDic objectAtIndex:index] valueForKey:@"mail_from"] isEqualToString:@"sent"])
        {
            strURL = [NSString stringWithFormat:@"{\"status\":\"%@\",\"webmail_parent_id\":\"%d\"}",@"move_to_sent",[[[messageArrDic objectAtIndex:index] valueForKey:@"webmail_parentsender_id"] intValue]];
            
        }

       // [SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceMessageStatus:strURL :archiveMessagesTag];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case getMessagesTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                messageArrDic =[MyResults objectForKey:@"data"];
                [SingletonClass deleteUnUsedLableFromTable:table];
                messageArrDic.count == 0 ? ([table addSubview:[SingletonClass ShowEmptyMessage:@"NO MESSAGE"]]):@"";
                [table reloadData];
            }else
            {
                [table addSubview:[SingletonClass ShowEmptyMessage:@"NO MESSAGE"]];
            }
            
            break;
        }
        case deleteMessagesTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                [SingletonClass initWithTitle:@"" message:@"Message deleted successully" delegate:nil btn1:@"Ok"];
                [self getMessages];
            }else{
                
                [SingletonClass initWithTitle:@"" message:@"Message delete fail try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case archiveMessagesTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                [SingletonClass ShareInstance].isMessangerInbox = TRUE;
                 [SingletonClass ShareInstance].isMessangerSent = TRUE;
                 [SingletonClass ShareInstance].isMessangerArchive = TRUE;
                [SingletonClass initWithTitle:@"" message:@"Message restored successully" delegate:nil btn1:@"Ok"];
                [self getMessages];
            }else{
                [SingletonClass initWithTitle:@"" message:@"Message restored fail try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)orientationChanged
{
    [SingletonClass deleteUnUsedLableFromTable:table];
    messageArrDic.count == 0 ? ([table addSubview:[SingletonClass ShowEmptyMessage:@"NO MESSAGE"]]):@"";
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   // if (isIPAD)
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    messageArrDic=[[NSArray alloc] init];
    
   self.title = NSLocalizedString(@"Archive", @"");
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    
    
    
    
    //    UIBarButtonItem *popMenuItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(popMenuAction:)];
    //    self.navigationItem.rightBarButtonItem = popMenuItem;
    //    [popMenuItem release];
    
    UIButton  *btnCompose = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 25, 25)];
    UIImage *imageEdit=[UIImage imageNamed:@"compose_icon.png"];
    
    
    
    [btnCompose addTarget:self action:@selector(ComposeMessage:) forControlEvents:UIControlEventTouchUpInside];
    [btnCompose setBackgroundImage:imageEdit forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCompose];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
     [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    [self getMessages];
       
    
}

-(void)ComposeMessage:(id)sender
{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[ComposeMessage class]])
        {
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }
    
    if (Status==FALSE)
    {
         ComposeMessage *compose=[[ComposeMessage alloc] initWithNibName:@"ComposeMessage" bundle:nil];
        [self.navigationController pushViewController:compose animated:NO];
    }
    
}

#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    messageArrDic=[messageArrDic copy];
    
    return messageArrDic.count;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MessageInboxCell";
    static NSString *CellNib = @"MessageInboxCell";
    
    MessageInboxCell *cell = (MessageInboxCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (MessageInboxCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.contentView setUserInteractionEnabled:YES];
        
        cell.delegate=self;
        
        cell.btndelete.tag=indexPath.section;
        cell.btnarchive.tag=indexPath.section;
    }
    
    
    cell.backgroundColor=[UIColor clearColor];
    cell.lblSenderName.text=[[messageArrDic objectAtIndex:indexPath.section] objectForKey:@"sender"];
    cell.lblReceivingDate.text=[[messageArrDic objectAtIndex:indexPath.section] objectForKey:@"date"];
    cell.lblDescription.text=[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"desc"];
    cell.lblDescription.text  =[cell.lblDescription.text  stringByReplacingOccurrencesOfString:@"/n" withString:@""];
    
    cell.lblSenderName.font=Textfont;
    cell.lblDescription.font=SmallTextfont;
    cell.lblReceivingDate.font=SmallTextfont;
    
     [cell.senderPic setImageWithURL:[NSURL URLWithString:[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
    cell.senderPic.layer.masksToBounds = YES;
    cell.senderPic.layer.cornerRadius=(cell.senderPic.frame.size.width)/2;
    cell.senderPic.layer.borderWidth=1.0f;
    cell.senderPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    if ([[[messageArrDic objectAtIndex:indexPath.section] valueForKey:@"sender_type"] intValue] == 1) {
        cell.senderTypePic.image=[UIImage imageNamed:@"Coach.png"];
    }else
    {
        cell.senderTypePic.image=[UIImage imageNamed:@"Athlete.png"];
        
    }
    
    if ([[[messageArrDic objectAtIndex:indexPath.section] objectForKey:@"is_read"] intValue] == 1) {
        
       // cell.lblSenderName.textColor=[UIColor lightGrayColor];
        
        
    }else
    {    cell.lblSenderName.font = [UIFont boldSystemFontOfSize:15];
       // cell.lblSenderName.textColor=[UIColor lightGrayColor];
    }
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIImageView *img1;
    if (isIPAD) {
        img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3, cell.frame.size.width, 1)];
        
    }else{
        img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-3, cell.frame.size.width, 1)];
    }
    img1.image=[UIImage imageNamed:@"menu_sep.png"];
    
   // [cell addSubview:img1];
    
    cell.rightUtilityButtons = [self rightButtons :(int)indexPath.section];
    cell.delegate=self;

    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

- (NSArray *)rightButtons :(int)btnTag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"deleteBtn.png"] : btnTag];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:41/255.0 green:58/255.0 blue:71/255.0 alpha:1.0] icon:[UIImage imageNamed:@"update_icon.png"] :btnTag];
    
    return rightUtilityButtons;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isIPAD)
    {
        return 111;
        
    }else{
        
        return 80;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // MessageDetails *details=[[MessageDetails alloc] init];
    //[self.navigationController pushViewController:details animated:NO];
    
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
    @try {
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
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
  }
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        [self deleteMessageEvent:alertView.tag];
    }
    
}

-(void)deleteMessage:(id)sender
{
    UIButton *btn=sender;

    [SingletonClass initWithTitle:@"" message: @"Do you want to delete message ?" delegate:self btn1:@"NO" btn2:@"YES" tagNumber:(int)btn.tag];

    
}
-(void)archiveMessage:(id)sender;
{
   UIButton *btn=sender;
  [self archiveMessageMoveToInboxEvent:(int)btn.tag];
    
    
    
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
        } case 1:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                
                if ([object isKindOfClass:[SentItemsView class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            
            if (Status==FALSE)
            {
                SentItemsView *compose=[[SentItemsView alloc] initWithNibName:@"SentItemsView" bundle:nil];
                
                [self.navigationController pushViewController:compose animated:NO];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
