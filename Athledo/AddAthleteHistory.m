//
//  EditProfileGenral.m
//  Athledo
//
//  Created by Smartdata on 7/22/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddAthleteHistory.h"
#import "AddAthleteHistoryCell.h"
#import "AppDelegate.h"
#import "ProfileView.h"
#define CellLocHeight  isIPAD ? 60 : 60

@interface AddAthleteHistory ()
{
    NSArray *arrHistoryInfo;
    BOOL isKeyBoard;
    int toolBarPosition;
    UITextField *currentText;
    NSString *strDate;
    NSArray *arrAthleteHistory;
}

@end

@implementation AddAthleteHistory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(NSString *)dateFormate : (NSString *)strdate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATE_FORMAT_D_M_Y];
    NSDate *date=[df dateFromString:strdate];
    [df setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
    NSString *str=EMPTYSTRING;
    if (![[NSString stringWithFormat:@"%@", [df stringFromDate:date]] isEqualToString:@"(null)"]) {
        str=[NSString stringWithFormat:@"%@", [df stringFromDate:date]];
    }
    if(date==nil)
    {
        return EMPTYSTRING;
    }else{
        return [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
    }
    return str;
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case EditData:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                // Now we Need to decrypt data
                [SingletonClass initWithTitle:nil message:SAVED_DATA_MESSAGE delegate:self btn1:@"Ok"];
                
            }else{
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass initWithTitle:nil message:NOT_SAVE_DATA_MESSAGE delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case Successtag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                [SingletonClass initWithTitle:nil message:SAVED_DATA_MESSAGE delegate:self btn1:@"Ok"];
            }else{
                
                [SingletonClass initWithTitle:nil message:NOT_SAVE_DATA_MESSAGE delegate:nil btn1:@"Ok"];
            }
            break;
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        
    }];
    
}
- (void)viewDidLoad
{
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    self.title=@"Sport Info";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrHistoryInfo=[[NSArray alloc] initWithObjects:@"Enter Team Name",@"Enter Description",@"From Date",@"To Date", nil];
    if (_objData) {
        arrAthleteHistory=[[NSArray alloc] initWithObjects:[_objData valueForKey:@"team"],[_objData valueForKey:@"description"],[self dateFormate:[_objData valueForKey:@"from"] ],[self dateFormate:[_objData valueForKey:@"to"] ],nil];
    }
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] < 8) {
        toolBarPosition = (([[UIScreen mainScreen] bounds].size.height >= 568)?266:180);
    } else {
        toolBarPosition = (([[UIScreen mainScreen] bounds].size.height >= 568)?266:180)-40;
    }
    //Set the Date picker view
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT)+50,SCREEN_WIDTH , 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    datePicker.tag=60;
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT)+50, SCREEN_WIDTH, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    [self.view addSubview:datePicker];
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 50)];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(sendAthleteHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
}
-(void)dateChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat =DATE_FORMAT_dd_MMM_yyyy;
    currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    UITableView *table=(UITableView *)[self.view viewWithTag:100];
    UITextField *textfieldStart=(UITextField *)[table viewWithTag:1002];
    UITextField *textfieldEnd=(UITextField *)[table viewWithTag:1003];
    
    NSDate *dateOne=[df dateFromString:textfieldStart.text];
    NSDate *dateTwo=[df dateFromString:textfieldEnd.text];
    
    if (textfieldStart.text.length !=0 && textfieldEnd.text.length !=0) {
        NSString *strError=EMPTYSTRING;
        switch ([dateOne compare:dateTwo]) {
            case NSOrderedAscending:
            {
                strError = EMPTYSTRING;
                // dateOne is earlier in time than dateTwo
                break;
            }
            case NSOrderedSame:
            {
                strError = @"Start and end date can not same";
                // The dates are the same
                break;
            }
            case NSOrderedDescending:
            {
                strError = @"End date can not earlier to Start date";
                // dateOne is later in time than dateTwo
                break;
            }
        }
        if(strError.length > 1)
        {
            // Uncomment to show last date should be greater
            // currentText.text=EMPTYSTRING;
            //[SingaltonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            // return;
        }
    }
}
#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrHistoryInfo.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAthleteHistoryCell *cell = nil;
    if(cell == nil)
    {
        cell = [[AddAthleteHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strIdentifier" indexPath:indexPath delegate:self textData:arrHistoryInfo:arrAthleteHistory.count > 0 ? [arrAthleteHistory objectAtIndex:indexPath.section]:EMPTYSTRING];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellLocHeight;
}
#pragma mark -TextView Delegate 
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}
#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     textField.autocorrectionType = UITextAutocorrectionTypeNo;
    currentText=textField;
    [self setContentOffset:textField table:tableView];
    if (textField.tag==1003 || textField.tag==1002)
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self setDatePickerVisibleAt:YES];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSArray *arrController=[self.navigationController viewControllers];
        BOOL Status=FALSE;
        for (id object in arrController)
        {
            if ([object isKindOfClass:[ProfileView class]])
            {
                Status=TRUE;
                [self.navigationController popToViewController:object animated:NO];
            }
        }
        
        if (Status==FALSE)
        {
            ProfileView *annView=[[ProfileView alloc] init];
            [self.navigationController pushViewController:annView animated:NO];
        }
        
    }else{
        
    }
}


- (IBAction)sendAthleteHistory : (id)sender {
    
    [SingletonClass ShareInstance].isProfileSectionUpdate=TRUE;
    self.navigationController.navigationItem.leftBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    NSMutableArray *arrdata = MUTABLEARRAY;
    UserInformation *userInfo=[UserInformation shareInstance];
    
    if ([SingletonClass  CheckConnectivity])
    {
        for (int i=0; i < arrHistoryInfo.count; i++) {
            
            //Check for empty Text box
            
            int tag=i+1000;
            
            UITableView *table=(UITableView *)[self.view viewWithTag:100];
            
            UITextField *textfield=(UITextField *)[table viewWithTag:tag];
            NSString *strError = EMPTYSTRING;
            if(textfield.text.length < 1 && tag==1000)
            {
                strError = @"Please enter team name";
            }
            else if(textfield.text.length < 1 && tag==1001)
            {
                strError = EMPTYSTRING;
            } else if(textfield.text.length < 1 && tag==1002)
            {
                strError = @"Please enter start date";
            }else if(textfield.text.length < 1 && tag==1003)
            {
                strError = @"Please enter end date";
            }
             if(strError.length > 1)
            {
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                return;
            }
        }
        for (int i=0; i < arrHistoryInfo.count; i++) {
            int tag=i+1000;
            UITableView *table=(UITableView *)[self.view viewWithTag:100];
            UITextField *textfield=(UITextField *)[table viewWithTag:tag];
            [arrdata addObject:textfield.text];
        }
        // ObjData in case edit
        if (_objData) {
            NSDictionary *temp=[[NSDictionary alloc] initWithObjectsAndKeys:[_objData valueForKey:@"id"],@"id",[arrdata objectAtIndex:0],@"team",[arrdata objectAtIndex:1],@"description",[arrdata objectAtIndex:2],@"to",[arrdata objectAtIndex:3],@"from", nil];
            NSArray *arrtemp=[[NSArray alloc] initWithObjects:temp, nil];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"type"];
            [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:KEY_USER_ID];
            
            
            [dict setObject:EMPTYSTRING forKey:@"UserProfile"];
            [dict setObject:arrtemp forKey:@"athletic_hstry"];
            [webservice WebserviceCallwithDic:dict :webServiceEditProfileInfo :EditData];
        }else{
            NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\", \"team\":\"%@\", \"desc\":\"%@\",\"from\":\"%@\",\"to\":\"%@\"}", userInfo.userId ,[arrdata objectAtIndex:0],[arrdata objectAtIndex:1],[arrdata objectAtIndex:2],[arrdata objectAtIndex:3]];
            [webservice WebserviceCall:webServiceAddAthleteHistoryInfo:strURL :Successtag];
        }
    }else{
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)doneClicked
{
    [currentText resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self setDatePickerVisibleAt:NO];
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+50)];
    [self setContentOffsetDown:currentText table:tableView];
}
-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.33f];
    [self.view viewWithTag:40].center = point;
    [UIView commitAnimations];
}
-(void)setDatePickerVisibleAt :(BOOL)ShowHide
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    if (ShowHide) {
        point.y=self.view.frame.size.height-(datePicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(datePicker.frame.size.height/2)-22)];
    }else{
        point.y=self.view.frame.size.height+(datePicker.frame.size.height/2);
    }
    [self.view viewWithTag:60].center = point;
    [UIView commitAnimations];
}

-(void)checkTextField
{
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag ==1002 ) {
        strDate=textField.text;
    }
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self doneClicked];
    UITableView *tblView = (UITableView *)[self.view viewWithTag:100];
    if(isKeyBoard)
    {
        isKeyBoard=NO;
        [UIView beginAnimations:@"tblMove" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.29f];
        tblView.frame = CGRectMake(tblView.frame.origin.x, tblView.frame.origin.y+57, tblView.frame.size.width, tblView.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}

#pragma mark setcontent offset
- (void)setContentOffsetDown:(id)textField table:(UITableView*)m_TableView {
    
    [m_TableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)setContentOffset:(id)textField table:(UITableView*)m_TableView {
    
    if (iosVersion < 8) {
        
        int  moveUp = (([[UIScreen mainScreen] bounds].size.height >= 568)?170:100);
        UIView* txt = textField;
        UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
        // Get the text fields location
        CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:m_TableView];
        // Scroll to cell
        [m_TableView setContentOffset:CGPointMake(0, point.y + (txt.frame.origin.y+txt.frame.size.height)-(moveUp)) animated: YES];
    }else{
        UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
        NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
        // Get the text fields location
        CGPoint point = [theTextFieldCell convertPoint:theTextFieldCell.frame.origin toView:m_TableView];
        
        if (point.y > 216 && point.y < 320) {
            int toolbarHeight_KeyAcc=44+37+60;
            CGSize keyboardSize = CGSizeMake(320,point.y+(toolbarHeight_KeyAcc));
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
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
