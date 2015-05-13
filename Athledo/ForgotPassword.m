//
//  ForgotPassword.m
//  Athledo
//
//  Created by Smartdata on 7/21/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "ForgotPassword.h"
#import "LoginVeiw.h"
@interface ForgotPassword ()
{
    NSArray *arrTableCelldata;
}
@end
BOOL isKeyBoard;
@implementation ForgotPassword
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
    self.title=NSLocalizedString(@"Reset Password", EMPTYSTRING);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem=nil;
    arrTableCelldata=[[NSArray alloc] initWithObjects:@"Enter mail id", nil];
    UIImage *background = [UIImage imageNamed:@"back.png"];
    UIImage *backgroundSelected = [UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(checkButtonTapped) forControlEvents:UIControlEventTouchUpInside]; //adding action
    [button setBackgroundImage:background forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundSelected forState:UIControlStateSelected];
    button.tintColor=[UIColor whiteColor];
    button.frame = CGRectMake(-20,0,50,20);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    int FieldPaiding=0;
    if (isIPAD) {
        FieldPaiding=20;
    }else{
        FieldPaiding=10;
    }
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FieldPaiding, 20)];
    txtFieldUserId.leftView = paddingView;
    txtFieldUserId.leftViewMode = UITextFieldViewModeAlways;
    txtFieldUserId.layer.borderColor =[UIColor lightGrayColor].CGColor;
    txtFieldUserId.font=Textfont;
    txtFieldUserId.layer.cornerRadius=5;
}

-(void)checkButtonTapped
{
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL is_Existing=NO;;
    for (id object in arrController) {
        if ([object isKindOfClass:[LoginVeiw class]])
        {
            is_Existing=YES;
            [self.navigationController popToViewController:object animated:NO];
            break;
        }
    }
    if (is_Existing == NO)
    {
        LoginVeiw *login=[[LoginVeiw alloc] initWithNibName:@"LoginVeiw" bundle:nil];
        [self.navigationController pushViewController:login animated:NO];
    }
}
#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTableCelldata.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell== nil)
    {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.tag=(200)+indexPath.row;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark- UITextfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    UITableView *tblView = (UITableView *)[self.view viewWithTag:100];
    if(textField.frame.origin.y >= tblViewY )
    {
        isKeyBoard=YES;
        [UIView beginAnimations:@"tblMove" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.29f];
        
        tblView.frame = CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y-57, tblView.frame.size.width, tblView.frame.size.height);
        [UIView commitAnimations];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableView *tblView = (UITableView *)[self.view viewWithTag:100];
    UIButton *btnLogin = (UIButton *)[self.view viewWithTag:101];
    if(isKeyBoard)
    {
        isKeyBoard=NO;
        [UIView beginAnimations:@"tblMove" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.29f];
        tblView.frame = CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y+57, tblView.frame.size.width, tblView.frame.size.height);
        btnLogin.frame = CGRectMake(btnLogin.frame.origin.x, btnLogin.frame.origin.y+57, btnLogin.frame.size.width, btnLogin.frame.size.height);
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:(isIPAD) ? [UIImage imageNamed: @"NavBg_ipad.png"]:[UIImage imageNamed: @"profileBg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)submitdata:(id)sender {
    
    if ([SingletonClass  CheckConnectivity]) {
        NSString *strError = EMPTYSTRING;
        if(txtFieldUserId.text.length < 1 )
        {
            strError = @"Please enter your mail address";
        }
        if(strError.length > 1)
        {
            [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            return;
        }else{
            
            BOOL emailValid=[SingletonClass emailValidate:txtFieldUserId.text];
            if (emailValid) {
                ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
                indicator.tag = 50;
                [self.view addSubview:indicator];
                NSString *strURL = [NSString stringWithFormat:@"{\"email\":\"%@\"}",[txtFieldUserId.text lowercaseString]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceForgotPassword]];
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
                                               [self httpResponseReceived : data];
                                           }else{
                                               ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
                                               if(acti)
                                                   [acti removeFromSuperview];
                                           }
                                       }];
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Please enter valid mail address" delegate:nil btn1:@"Ok"];
            }
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self checkButtonTapped];
}
#pragma mark-  Webservice reponse
-(void)httpResponseReceived:(NSData *)webResponse
{
    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
    if(acti)
        [acti removeFromSuperview];
    NSError *error=nil;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    if ([[myResults objectForKey:STATUS] isEqualToString:SUCCESS]) {
        [SingletonClass initWithTitle:EMPTYSTRING message:[@"An email has been sent on email id " stringByAppendingFormat:@"%@ containing new password.",txtFieldUserId.text] delegate:self btn1:@"Ok"];
    }else
    {
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Fail try again" delegate:nil btn1:@"Ok"];
    }
}
@end
