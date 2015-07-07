//
//  AddCoachingHistory.m
//  Athledo
//
//  Created by Smartdata on 7/31/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddCoachingHistory.h"
#import "LoginVeiw.h"
#import "AddCoachongHistoryCell.h"
#import "AppDelegate.h"
#import "ProfileView.h"
#define CellLocHeight  isIPAD ? 60 : 60
@interface AddCoachingHistory ()

@end
BOOL isKeyBoard;
UITextField *currentText;
NSArray *arrCoachongInfo;
NSArray *arrAwardsInfo;

NSArray *arrTextFieldText;

NSMutableArray *arrAwardsYear;
UIDeviceOrientation CurrentOrientation;

@implementation AddCoachingHistory

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
    [SingletonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
        case EditData:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                [SingletonClass initWithTitle:nil message:SAVED_DATA_MESSAGE delegate:self btn1:@"Ok"];
            }else{
                
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


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
}
- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+350):toolBar];
        [tableView reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            if (iosVersion < 8) {
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolBar];
                scrollHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolBar];
                scrollHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
            }
        }completion:^(BOOL finished){
            
        }];
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height > 310 ? kbSize.width : kbSize.height+22)) :toolBar];
            
        }completion:^(BOOL finished){
            
        }];
        
    }];
    
}
- (void)viewDidLoad
{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    self.title=_strTitle;
    
    scrollHeight=0;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrCoachongInfo=[[NSArray alloc] initWithObjects:@"Enter School Name",@"Enter Sport Name",@"Enter Description",@"From Date",@"To Date", nil];
    arrAwardsInfo=[[NSArray alloc] initWithObjects:@"Enter Award Title",@"Enter year when awarded",@"Enter Description", nil];
    
    arrAwardsYear=MUTABLEARRAY;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"YYYY";
    NSString *currentYesr= [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    int currentyear=[currentYesr intValue];
    for (int i=0; i< 120; i++) {
        [arrAwardsYear addObject:[NSString stringWithFormat:@"%d",currentyear-i]];
    }
    //Set the Date picker view
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, datePicker.frame.size.height)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    datePicker.tag=60;
    //[datePicker setHidden:YES];
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    listPicker=[[UIPickerView alloc] init];
    listPicker.dataSource=self;
    listPicker.delegate=self;
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, listPicker.frame.size.height);
    listPicker.tag=listPickerTag;
    listPicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:listPicker];
    
    if (_SectionTag ==1) {
        
        if (_objData) {
            arrTextFieldText =[[NSArray alloc] initWithObjects:[_objData valueForKey:@"school_name"],[_objData valueForKey:@"sport_name"],[_objData valueForKey:@"description"],[self dateFormate:[_objData valueForKey:@"from"]],[self dateFormate:[_objData valueForKey:@"to"]], nil];
        }else{
            
            arrTextFieldText =[[NSArray alloc]init];
        }
    }else{
        
        if (_objData) {
            arrTextFieldText =[[NSArray alloc] initWithObjects:[_objData valueForKey:@"title"],[_objData valueForKey:@"year_of_award"],[_objData valueForKey:@"description"], nil];
            
        }else{
            
            arrTextFieldText =[[NSArray alloc]init];
        }
    }
    
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 50)];
    // UIImage *imageEdit=[UIImage imageNamed:@"edit.png"];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(sendCoachingOrAwardsData:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
}

-(void)doneClicked
{
    currentText=nil;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+350) : toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolBar];
        
    }completion:^(BOOL finished){
        
    }];
    [self setContentOffsetDown:currentText table:tableView];
    
}

//-(void)setToolbarVisibleAt:(CGPoint)point
//{
//    [UIView beginAnimations:@"tblViewMove" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:0.27f];
//    
//    [self.view viewWithTag:40].center = point;
//    
//    [UIView commitAnimations];
//}


//-(void)setDatePickerVisibleAt :(BOOL)ShowHide
//{
//    [UIView beginAnimations:@"tblViewMove" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:0.27f];
//    
//    CGPoint point;
//    point.x=self.view.frame.size.width/2;
//    if (ShowHide) {
//        point.y=self.view.frame.size.height-(datePicker.frame.size.height/2);
//        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(datePicker.frame.size.height/2)-22)];
//    }else{
//        point.y=self.view.frame.size.height+(datePicker.frame.size.height/2);
//    }
//    
//    [self.view viewWithTag:60].center = point;
//    [UIView commitAnimations];
//}


- (IBAction)sendCoachingOrAwardsData : (id)sender {
    
    [SingletonClass ShareInstance].isProfileSectionUpdate=TRUE;
     [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.leftBarButtonItem.enabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    // _sectionTag -> 1 for coaching data send on server
    // _sectionTag -> 2 for awards data send on server

    if ( _SectionTag==1)
    {
         NSMutableArray *arrdata=MUTABLEARRAY;
        UserInformation *userInfo=[UserInformation shareInstance];
        [arrdata addObject:[NSString stringWithFormat:@"%d",userInfo.userId ]];
        
        if ([SingletonClass  CheckConnectivity]) {
            
            for (int i=0; i < 5; i++) {
                //Check for empty Text box
                int tag=i+1000;
                UITextField *textfield=(UITextField *)[tableView viewWithTag:tag];
                NSString *strError = EMPTYSTRING;
                if(textfield.text.length < 1 && tag==1000)
                {
                    strError = @"Please enter school name";
                }
                else if(textfield.text.length < 1 && tag==1001)
                {
                    strError = @"Please enter sport name";
                } else if(textfield.text.length < 1 && tag==1002)
                {
                    strError = EMPTYSTRING;
                    
                } else if(textfield.text.length < 1 && tag==1003)
                {
                    strError = @"Please enter start date";
                    
                } else if(textfield.text.length < 1 && tag==1004)
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
            for (int i=0; i < 5; i++)
            {
                int tag=i+1000;
                UITextField *textfield=(UITextField *)[tableView viewWithTag:tag];
                [arrdata addObject:textfield.text];
            }
            
            // ObjData in case edit
            if (_objData) {
                
                NSDictionary *temp=[[NSDictionary alloc] initWithObjectsAndKeys:[_objData valueForKey:@"id"],@"id",[arrdata objectAtIndex:1],@"school_name",[arrdata objectAtIndex:2],@"sport_name",[arrdata objectAtIndex:3],@"description",[arrdata objectAtIndex:4],@"from",[arrdata objectAtIndex:5],@"to", nil];
                
                NSArray *arrtemp=[[NSArray alloc] initWithObjects:temp, nil];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"type"];
                [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:KEY_USER_ID];
                [dict setObject:EMPTYSTRING forKey:@"UserProfile"];
                [dict setObject:arrtemp forKey:@"cochng_hstry"];
                [dict setObject:EMPTYSTRING forKey:@"awards"];
                [webservice WebserviceCallwithDic:dict :webServiceEditProfileInfo :EditData];
            }else{
                NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\", \"school\":\"%@\", \"sport\":\"%@\",\"desc\":\"%@\",\"from\":\"%@\",\"to\":\"%@\"}", [[arrdata objectAtIndex:0] intValue] ,[arrdata objectAtIndex:1],[arrdata objectAtIndex:2],[arrdata objectAtIndex:3],[arrdata objectAtIndex:4],[arrdata objectAtIndex:5]];
                [webservice WebserviceCall:webServiceAddCoachingInfo:strURL :Successtag];
            }
        }else{
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
            }
    }
    else
    {
        NSMutableArray *arrdata=MUTABLEARRAY;
        UserInformation *userInfo=[UserInformation shareInstance];
        [arrdata addObject:[NSString stringWithFormat:@"%d",userInfo.userId ]];
        
        if ([SingletonClass  CheckConnectivity]) {
            
            for (int i=0; i < 5; i++) {
                
                //Check for empty Text box
                
                int tag=i+1000;
               UITextField *textfield=(UITextField *)[tableView viewWithTag:tag];
                NSString *strError = EMPTYSTRING;
                if(textfield.text.length < 1 && tag==1000)
                {
                  strError = @"Please enter award title";
                }
                else if(textfield.text.length < 1 && tag==1004)
                {
                    strError = @"Please enter year when awarded";
                } else if(textfield.text.length < 1 && tag==1002)
                {
                    strError = EMPTYSTRING;
                }
                if(strError.length > 1)
                {
                    self.navigationItem.rightBarButtonItem.enabled=YES;
                    [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                    return;
                }
                
            }
            
            UITextField *textfield1=(UITextField *)[tableView viewWithTag:1000];
            [arrdata addObject:textfield1.text];
            
            UITextField *textfield2=(UITextField *)[tableView viewWithTag:1004];
            [arrdata addObject:textfield2.text];
            
            UITextField *textfield3=(UITextField *)[tableView viewWithTag:1002];
            [arrdata addObject:textfield3.text];
            
            // ObjData in case edit
            if (_objData) {
                
                NSDictionary *temp=[[NSDictionary alloc] initWithObjectsAndKeys:[_objData valueForKey:@"id"],@"id",[arrdata objectAtIndex:1],@"title",[arrdata objectAtIndex:2],@"year_of_award",[arrdata objectAtIndex:3],@"description", nil];
                
                NSArray *arrtemp=[[NSArray alloc] initWithObjects:temp, nil];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                
                [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"type"];
                [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:KEY_USER_ID];
                [dict setObject:EMPTYSTRING forKey:@"UserProfile"];
                [dict setObject:EMPTYSTRING forKey:@"cochng_hstry"];
                [dict setObject:arrtemp forKey:@"awards"];
                [webservice WebserviceCallwithDic:dict :webServiceEditProfileInfo :EditData];
                
            }else{
                NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\", \"title\":\"%@\", \"year\":\"%@\",\"desc\":\"%@\"}", [[arrdata objectAtIndex:0] intValue] ,[arrdata objectAtIndex:1],[arrdata objectAtIndex:2],[arrdata objectAtIndex:3]];
                [webservice WebserviceCall:webServiceAddCoachingAwardInfo:strURL :Successtag];
            }
        }else{
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
        }
    }
    self.navigationItem.rightBarButtonItem.enabled=YES;
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

-(void)dateChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (_SectionTag == 1) {
        df.dateFormat =DATE_FORMAT_dd_MMM_yyyy;
        currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
        UITextField *textfieldStart=(UITextField *)[tableView viewWithTag:1003];
        UITextField *textfieldEnd=(UITextField *)[tableView viewWithTag:1004];
        
        NSDate *dateOne=[df dateFromString:textfieldStart.text];
        NSDate *dateTwo=[df dateFromString:textfieldEnd.text];
        
        if (textfieldStart.text.length !=0 && textfieldEnd.text.length !=0) {
            
            NSString *strError=EMPTYSTRING;
            switch ([dateOne compare:dateTwo]) {
                    
                case NSOrderedSame:
                    
                {
                    strError = @"Start and end date can not same";
                    currentText.text=EMPTYSTRING;
                    [SingletonClass initWithTitle:nil message:strError delegate:nil btn1:@"Ok"];
                    // The dates are the same
                    break;
                }
                case NSOrderedDescending:
                {
                    strError = @"End date can not earlier to Start date";
                    currentText.text=EMPTYSTRING;
                    [SingletonClass initWithTitle:nil message:strError delegate:nil btn1:@"Ok"];
                    // dateOne is later in time than dateTwo
                    break;
                }
            }
            // To check end is greater or not uncomment
        }
    }else{
        df.dateFormat = @"YYYY";
        currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    }
}

#pragma show selected value in listpicker

-(void)showSeletedPickerValue
{
    if (currentText.text.length > 0) {
        
        for (int i=0; i< arrAwardsYear.count; i++) {
            
            if ([[arrAwardsYear objectAtIndex:i] isEqual:currentText.text]) {
                
                [listPicker selectRow:i inComponent:0 animated:YES];
                
                break;
            }
            
        }
        
    }
}

//-(void)setPickerVisibleAt :(BOOL)ShowHide
//{
//    if (currentText.text.length > 0) {
//        
//        for (int i=0; i< arrAwardsYear.count; i++) {
//            
//            if ([[arrAwardsYear objectAtIndex:i] isEqual:currentText.text]) {
//                [listPicker selectRow:i inComponent:0 animated:YES];
//                break;
//            }
//        }
//    }
//    [UIView beginAnimations:@"tblViewMove" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:0.27f];
//    
//    CGPoint point;
//    point.x=self.view.frame.size.width/2;
//    
//    if (ShowHide) {
//        point.y=self.view.frame.size.height-(listPicker.frame.size.height/2);
//        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(listPicker.frame.size.height/2)-22)];
//        
//    }else{
//        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
//        point.y=self.view.frame.size.height+(listPicker.frame.size.height/2);
//    }
//    
//    [self.view viewWithTag:110].center = point;
//    [UIView commitAnimations];
//    
//}
#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_SectionTag ==1) {
        
        return 5;
    }else{
        return 3;
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddCoachongHistoryCell *cell = nil;
    if(cell == nil)
    {
        if (_SectionTag ==1) {
            cell = [[AddCoachongHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strIdentifier" indexPath:indexPath delegate:self textData:arrCoachongInfo:arrTextFieldText.count > 0 ? [arrTextFieldText objectAtIndex:indexPath.section]: EMPTYSTRING];
        }else{
            cell = [[AddCoachongHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strIdentifier" indexPath:indexPath delegate:self textData:arrAwardsInfo:arrTextFieldText.count > 0 ? [arrTextFieldText objectAtIndex:indexPath.section]: EMPTYSTRING] ;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellLocHeight;
}
-(NSString *)dateFormate : (NSString *)strdate
{
    if ([strdate isEqualToString:@"Present"]) {
        return @"Present";
    }else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:DATE_FORMAT_D_M_Y];
        NSDate *date=[df dateFromString:strdate];
        [df setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
        if(date==nil)
        {
            return @"Present";
        }else{
            return [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
        }
    }
}
#pragma mark TextView Delegate
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
    if (textField.tag > 1001 ) {
        [self setContentOffset:textField table:tableView];
    }
    if (textField.tag==1003 || textField.tag==1004) {
        
        [textField resignFirstResponder];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        currentText=textField;
        if ([textField.placeholder isEqualToString:@"From Date"] || [textField.placeholder isEqualToString:@"To Date"]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            if (currentText.text.length > 0) {
                df.dateFormat =DATE_FORMAT_dd_MMM_yyyy;
                NSDate *date=[df dateFromString:currentText.text];
                date !=nil ? [datePicker setDate:date] : @"";
                df=nil;
            }
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :datePicker :toolBar];
        }else{
            [self showSeletedPickerValue];
            [listPicker reloadComponent:0];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        }
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //
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
#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (currentText.text.length==0) {
        currentText.text=[arrAwardsYear objectAtIndex:0];
    }
    return [arrAwardsYear count];
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    str = [arrAwardsYear objectAtIndex:row];
    NSArray *arr = [str componentsSeparatedByString:KEY_TRIPLE_STAR];
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentText.text=[arrAwardsYear objectAtIndex:row];
}
#pragma mark setcontent offset
- (void)setContentOffsetDown:(id)textField table:(UITableView*)m_TableView {
    [m_TableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)setContentOffset:(id)textField table:(UITableView*)m_TableView {
    
    UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
    NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
    if (scrollHeight==0) {
        scrollHeight=216;
    }
    CGSize keyboardSize = CGSizeMake(310,scrollHeight+70);
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
