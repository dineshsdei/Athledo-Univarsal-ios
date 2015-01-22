//
//  LoginVeiw.m
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "LoginVeiw.h"
#import "DashBoard.h"
#import "ForgotPassword.h"
#import "UserInformation.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "CalendarMonthViewController.h"

@interface LoginVeiw ()
{
 
    UITextField *txtFieldUserId;
    UITextField *txtFieldPassword;
    UITextField *currentText;
    NSString *date;
}
@end

@implementation LoginVeiw

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)MoveToDashBoard:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:txtFieldUserId.text forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:txtFieldPassword.text forKey:@"PASSWORD"];


    if ([SingletonClass  CheckConnectivity]) {

    //Check for empty Text box
    NSString *strError = @"";
    if(txtFieldUserId.text.length < 1 )
    {
        strError = @"Please enter User Id";
    }
    else if(txtFieldPassword.text.length < 1 )
    {
        strError = @"Please enter password";
    }
    if(strError.length>2)
    {
        [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
        return;
    }else{
        
        
    BOOL emailValid=[SingletonClass emailValidate:txtFieldUserId.text];

    if (emailValid) {

    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = 50;
    [self.view addSubview:indicator];

    NSString *strURL = [NSString stringWithFormat:@"{\"email\":\"%@\", \"password\":\"%@\", \"device_id\":\"%@\"}", [txtFieldUserId.text lowercaseString],[txtFieldPassword.text lowercaseString],@"321434"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceLogin]];
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
    [self httpResponseReceived : data];
    }else{
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
    if(acti)
       [acti removeFromSuperview];
    }

                           
                       }];


    }else
    {
    [SingletonClass initWithTitle:@"" message:@"Please enter valid user id" delegate:nil btn1:@"Ok"];

    }
        
    }


    }else{

    [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }
    


}

#pragma mark-  Http call back
-(void)httpResponseReceived:(NSData *)webResponse
{
    // Now we Need to decrypt data

    NSError *error=nil;

    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];


    // ***Tag 100 for Log in web service


    if([[myResults objectForKey:@"status"] isEqualToString:@"success"])
    {
    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
    if(acti)
    [acti removeFromSuperview];


    NSMutableDictionary *user=[[myResults objectForKey:@"data"] objectForKey:@"User"];


    UserInformation *userdata=[UserInformation shareInstance];

    userdata.arrUserTeam=[[myResults objectForKey:@"data"] objectForKey:@"UserTeam"];



    userdata.userEmail=[user objectForKey:@"email"];
    userdata.userId=[[user objectForKey:@"id"] intValue];
    userdata.userType=[[user objectForKey:@"type"] intValue];
    userdata.userPicUrl=[user valueForKey:@"image"];
    userdata.userFullName=[user valueForKey:@"sender"];
        
    SingletonClass *obj=[SingletonClass ShareInstance];
    [obj  SaveUserInformation:[user objectForKey:@"email"] :[user objectForKey:@"id"] :[user objectForKey:@"type"] :[user valueForKey:@"image"] :[user valueForKey:@"sender"] :@"" :@""];
        

    NSArray *arrController=[self.navigationController viewControllers];
    if (userdata.arrUserTeam.count==1)
    {


    @try {

    NSDictionary *team = [[UserInformation shareInstance].arrUserTeam objectAtIndex:0] ;
    [UserInformation shareInstance].userSelectedTeamid =[[team objectForKey:@"team_id"] intValue];
    [UserInformation shareInstance].userSelectedSportid =[[team objectForKey:@"sport_id"] intValue];


    for (id object in arrController)
    {
        if ([object isKindOfClass:[SWRevealViewController class]])
            
            [self.navigationController popToViewController:object animated:NO];
    }


    }
    @catch (NSException *exception) {

    }
    @finally
    {

    }

    }else{

    BOOL Status=FALSE;
    for (id object in arrController)
    {

    if ([object isKindOfClass:[DashBoard class]])
    {
        Status=TRUE;
        [self.navigationController popToViewController:object animated:NO];
    }
    }

    if (Status==FALSE)
    {
    DashBoard *Dashboard=[[DashBoard alloc] init];

    [self.navigationController pushViewController:Dashboard animated:NO];

    }
    }

    }else  if([[myResults objectForKey:@"status"] isEqualToString:@"failed"])
    {
    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
    if(acti)
    [acti removeFromSuperview];

    txtFieldPassword.text=@"";
    //txtFieldUserId.text=@"";

    [SingletonClass initWithTitle:@"" message:@"Invalid User" delegate:nil btn1:@"Ok"];


    }

    
    }


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
}
- (void)viewDidLoad
{
    if (isIPAD) {
        [AppDelegate restrictRotation:NO];
    }else{
        
         [AppDelegate restrictRotation:YES];
    }
    
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
      
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        int dif=0;
        
        UITableViewCell *theTextFieldCell = (UITableViewCell *)[currentText superview];
        // Get the text fields location
        CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:self.view];
        if ((point.y - kbSize.height) < (dif=([SingletonClass getOrientation]==UIDeviceOrientationPortrait) ? 70: 180) ) {
          self.view.frame=CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height);
            CGRect frame = self.view.frame;
            frame.origin.y = self.view.frame.origin.y - 2*(currentText.frame.size.height);
            self.view.frame = frame;
        }
    
        [UIView commitAnimations];
        
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        // Frame Update
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
        
        [UIView commitAnimations];
        
    }];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self setNeedsStatusBarAppearanceUpdate];
    self.loginTableView.backgroundColor=[UIColor clearColor];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isStart=TRUE;
    
    
   

}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}


-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if(cell== nil)
    {
    cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    int FieldHeight=0,FieldWeight=0,FieldPaiding=0;
    if (isIPAD) {
    FieldHeight=60;
    FieldWeight=400;
    FieldPaiding=20;
    }else{

    FieldHeight=40;
    FieldWeight=280;
    FieldPaiding=10;
    }

    if (indexPath.section==0) {



    txtFieldUserId = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, FieldWeight, FieldHeight)];

    txtFieldUserId.borderStyle = UITextBorderStyleNone;

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FieldPaiding, 20)];
    txtFieldUserId.leftView = paddingView;
    txtFieldUserId.leftViewMode = UITextFieldViewModeAlways;
    txtFieldUserId.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);;
    txtFieldUserId.delegate = self;

    UIColor *color = [UIColor lightGrayColor];
    txtFieldUserId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];

    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_txtfld.png"]];

    /// set the Email text if any available

    txtFieldUserId.backgroundColor = [UIColor clearColor];
    //        txtFieldUserId.textColor=[UIColor whiteColor];
    txtFieldUserId.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtFieldUserId.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtFieldUserId.font=Textfont;
    [cell addSubview:txtFieldUserId];

    }
    else
    {
    txtFieldPassword = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, FieldWeight, FieldHeight)];
    txtFieldPassword.backgroundColor = [UIColor clearColor];
    txtFieldPassword.borderStyle = UITextBorderStyleNone;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FieldPaiding, 20)];
    txtFieldPassword.leftView = paddingView;
    txtFieldPassword.leftViewMode = UITextFieldViewModeAlways;
    txtFieldPassword.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);;
    txtFieldPassword.delegate = self;
    txtFieldPassword.placeholder = @"Password";

    UIColor *color = [UIColor lightGrayColor];
    txtFieldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    txtFieldPassword.backgroundColor=[UIColor clearColor];
    txtFieldPassword.secureTextEntry = YES;
    txtFieldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtFieldPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtFieldPassword.font=Textfont;
    //        txtFieldPassword.textColor=[UIColor whiteColor];

    [cell addSubview:txtFieldPassword];
    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_txtfld.png"]];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];


    txtFieldUserId.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"] != nil ?[[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"] :@"";

    txtFieldPassword.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"] != nil ?[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"] :@"";


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD) {
        return 60.0f;
    }else{
        return 45.0f;
    }
    
}

#pragma mark- UITextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentText=textField;
    [textField returnKeyType];
  
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ForgotPasswordClick:(id)sender {

    NSArray *arrController=[self.navigationController viewControllers];
   
    BOOL Status=FALSE;

    for (id object in arrController) {

    if ([object isKindOfClass:[ForgotPassword class]])
    {
        Status=TRUE;
        [self.navigationController popToViewController:object animated:NO];
        break;
    }
    }
    if (Status==FALSE)
    {
    ForgotPassword *forgotPw=[[ForgotPassword alloc] init];

     [self.navigationController pushViewController:forgotPw animated:NO];
    }

}
@end
