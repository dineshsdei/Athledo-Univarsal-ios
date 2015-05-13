
//
//  AddNewAnnouncement.m
//  Athledo
//
//  Created by Smartdata on 7/24/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddNewAnnouncement.h"
#import "AnnouncementView.h"
#import "UserInformation.h"
#import "CheckboxButton.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
@interface AddNewAnnouncement ()

@end

BOOL checkBoxSelected;
BOOL isKeyBoard;
UITextField *currentText;
UITextView *txtViewCurrent;
int tagNumber;
NSMutableArray *arridIndex;
NSMutableArray *groupArray;
NSMutableArray *groupKeyArr;
NSMutableDictionary *selectedGroups;
NSMutableDictionary *AllGroupData;
NSString *emailNotification;
NSMutableString *privacySetting;
NSMutableArray *settingArray;
UIButton *selectedBtn;
NSString* announcementId;
NSMutableArray *groupIds;
UIDeviceOrientation CurrentOrientation;

#define scrollViewHeight

@implementation AddNewAnnouncement
@synthesize obj;

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

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [super viewDidDisappear:animated];
}

// this method, set textfield font, color,size etc.

-(void)setFieldsProperty
{
    nameTxt.layer.cornerRadius=CornerRadius;
    nameTxt.layer.borderWidth=.5;
    nameTxt.font=Textfont;
    nameTxt.layer.borderColor=[UIColor lightGrayColor].CGColor;
    nameTxt.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    nameTxt.leftViewMode = UITextFieldViewModeAlways;
    
    descTxt.layer.cornerRadius=CornerRadius;
    descTxt.layer.borderWidth=.5;
    descTxt.font=Textfont;
    descTxt.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    dateTxt.layer.cornerRadius=CornerRadius;
    dateTxt.layer.borderWidth=.5;
    dateTxt.font=Textfont;
    dateTxt.layer.borderColor=[UIColor lightGrayColor].CGColor;
    dateTxt.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    dateTxt.leftViewMode = UITextFieldViewModeAlways;
    
    timeTxt.layer.cornerRadius=CornerRadius;
    timeTxt.layer.borderWidth=.5;
    timeTxt.font=Textfont;
    timeTxt.layer.borderColor=[UIColor lightGrayColor].CGColor;
    timeTxt.leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    timeTxt.leftViewMode = UITextFieldViewModeAlways;
    
}

// this method call, when user rotate your device
- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    
    if (isIPAD) {
        [pickerView removeFromSuperview];
        pickerView=nil;
        pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height+350, self.view.frame.size.width, 216)];
        pickerView.backgroundColor=[UIColor whiteColor];
        pickerView.tag=60;
        pickerView.delegate=self;
        [self.view addSubview:pickerView];
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50):toolBar];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        UIToolbar *toolbar=(UIToolbar *)[self.view viewWithTag:40];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolbar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolbar];
        
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            if (iosVersion < 8) {
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolbar];
                scrollHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolbar];
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

    if (isIPAD)
    {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}
- (void)viewDidLoad
{
    [scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height)];
    self.title = _ScreenTitle;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    [super viewDidLoad];
    UIDeviceOrientation orientation=[[SingletonClass ShareInstance] CurrentOrientation:self];
    scrollHeight=0;
    emailNotification=@"1";
    announcementId=EMPTYSTRING;
    groupKeyArr=[[NSMutableArray alloc]init];
    arridIndex=[[NSMutableArray alloc]init];
    settingArray=[[NSMutableArray alloc]init];
    groupIds = [[NSMutableArray alloc]init];
    
    selectedGroups = [[NSMutableDictionary alloc] init];
    AllGroupData= [[NSMutableDictionary alloc] init];
    groupArray=[[NSMutableArray alloc]init];
    
    privacySetting=[[NSMutableString alloc]init];
    emailBtn1.userInteractionEnabled=NO;
    emailBtn2.userInteractionEnabled=YES;
    
    [self setFieldsProperty];
    
    //Set the Date picker view
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216)];
    datePicker.date = [NSDate date];
    datePicker.tag=70;
    //[datePicker setHidden:YES];
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    descTxt.layer.borderWidth = .50f;
    descTxt.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(saveAnnouncement:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    //set pickerView
    
    [self getGroupList];
    if (((orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight)))
    {
        if (iosVersion < 8) {
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.width+350, [[UIScreen mainScreen] bounds].size.width, 216)];
        }else{
            
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,[[UIScreen mainScreen] bounds].size.height+350, [[UIScreen mainScreen] bounds].size.width+50, 216)];
        }
        
    }else{
        pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height+350, self.view.frame.size.width, 216)];
    }
    
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.tag=60;
    pickerView.delegate=self;
    [self.view addSubview:pickerView];
    
    if(obj)
    {
        nameTxt.text = [obj valueForKey:@"name"];
        descTxt.text = [obj valueForKey:@"description"];
        dateTxt.text = [obj valueForKey:@"schedule_date"];
        timeTxt.text = [obj valueForKey:@"schedule_time"];
        announcementId = [obj valueForKey:@"id"];
        if ([[obj valueForKey:@"email_notification"] intValue]==0) {
            emailBtn2.userInteractionEnabled=NO;
            [emailBtn2 setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
            [emailBtn1 setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
            emailBtn1.userInteractionEnabled=YES;
            emailNotification=@"0";
            
        }else{
            emailBtn1.userInteractionEnabled=NO;
            [emailBtn1 setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
            [emailBtn2 setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
            emailBtn2.userInteractionEnabled=YES;
            emailNotification=@"1";
        }
        
        NSString *settingStr = [obj valueForKey:@"privacy_setting"];
        NSArray *array = [settingStr componentsSeparatedByString:@","];
        for (int i=0; i<array.count; i++) {
            [privacySetting appendFormat:@"%@",array[i]];
            if (i<array.count-1) {
                [privacySetting appendString:@","];
            }
        }
        if ([array count]==4 && [array containsObject:@"2"]) {
            UIButton *btn = (UIButton*)[scrollView viewWithTag:1000];
            [btn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            btn.selected=YES;
        }
        
        for (int i=0; i<array.count; i++)
        {
            int a = [[array objectAtIndex:i]intValue];
            [settingArray addObject:[array objectAtIndex:i]];
            if ([settingArray[i] intValue] == 5) {
                [settingArray replaceObjectAtIndex:i withObject:@"5"];
                a=4;
            }
            UIButton *btn = (UIButton*)[scrollView viewWithTag:(a+1000)];
            [btn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            btn.selected=YES;
        }
    }
    [scrollView setContentOffset:CGPointMake(0,scrollHeight+100) animated: YES];
}

// this method used to get list of groups, Athletes to send Announcement to them

-(void)getGroupList{
    
    if ([SingletonClass  CheckConnectivity]) {
        
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\"}",userInfo.userSelectedTeamid];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceGetGroups]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSMutableData *data = [NSMutableData data];
        [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
        [request setHTTPBody:data];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   tagNumber=GetGroupsTag;
                                   if (data!=nil)
                                   {
                                       [self httpResponseReceived : data];
                                   }else{
                                       
//                                       ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
//                                       if(acti)
//                                           [acti removeFromSuperview];
                                   }
                               }];
        
    }else{
        
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
// this method used to get web service response from server

-(void)httpResponseReceived:(NSData *)webResponse
{
    @try {
        self.navigationItem.leftBarButtonItem.enabled=YES;
        self.navigationItem.rightBarButtonItem.enabled=YES;
        // Now remove the Active indicator
       [SingletonClass RemoveActivityIndicator:self.view];
        // Now we Need to decrypt data
        NSError *error=nil;
        if (tagNumber == GetGroupsTag) {
            NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                AllGroupData=[[myResults  objectForKey:DATA]valueForKey:@"Group"]  ;
                if (AllGroupData.count>0) {
                    NSArray *arr = [AllGroupData allValues];
                    
                    for (int i=0; i<[arr count]; i++) {
                        NSString *value=[arr objectAtIndex:i];
                        
                        [groupArray addObject:value];
                    }
                    
                    for (int i=0;i< groupArray.count;i++){
                        [selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:[groupArray objectAtIndex:i]];
                    }
                    // In Edit mode group shows selected here
                    if (obj) {
                        NSString *settingStr = [obj valueForKey:@"group_ids"];
                        NSArray *array;
                        if (![settingStr isKindOfClass:[NSNull class]] && settingStr!=nil && settingStr.length > 0)
                            array = [settingStr componentsSeparatedByString:@","];
                        for (int i=0;i< array.count;i++){
                            [selectedGroups setObject:[NSNumber numberWithBool:YES] forKey:[AllGroupData objectForKey:[array objectAtIndex:i] ]];
                        }
                        if (array.count > 0) {
                            [selectGroupBtn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
            else
            {
                self.navigationItem.rightBarButtonItem.enabled=YES;
                //[SingaltonClass initWithTitle:EMPTYSTRING message:@"No Data Found !" delegate:nil btn1:@"Ok"];
            }
            [pickerView  reloadAllComponents];
        }
        if (tagNumber==AddAnnouncementTag)
        {
            NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            
            // Result is nill but announcement is adding on web , I don't know why it happen
            
            if([[myResults objectForKey:STATUS] isEqualToString:SUCCESS] || (myResults == nil))
            {
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Announcement has been saved successfully" delegate:self btn1:@"Ok"];
            }else{
                self.navigationItem.rightBarButtonItem.enabled=YES;
                [SingletonClass initWithTitle:@"Server Fail" message:@"Please try again" delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        AnnouncementView *annView=[[AnnouncementView alloc] init];
        [self.navigationController pushViewController:annView animated:NO];
    }else{
        
    }
}
// this method used to keep position down of picker, Datepicker,multiselection picker
-(void)doneClicked
{
    UIScrollView *scrllView = (UIScrollView *)[self.view viewWithTag:90];
    [scrllView setContentOffset:CGPointMake(0,0) animated: YES];
    CheckboxButton *btn=(CheckboxButton *)selectGroupBtn;
    
    if(currentText.tag==10||currentText.tag==11 || btn ||selectDateBtn || selectTimeBtn) {
        
        [UIView beginAnimations:@"tblViewMove" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.27f];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [UIView commitAnimations];
    }
    if (txtViewCurrent) {
        if (!(txtViewCurrent.text.length > 0)) {
            txtViewCurrent.text=@"Enter Description";
            
        }
        [txtViewCurrent resignFirstResponder];
        
    }
    [self showBtnGroupStatus];
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolBar];
    [UIView commitAnimations];
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
    
}
// this method used to hide listpicker , Datepicker when click on checkbox
-(void)ClickCheckBoxHideControll
{
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolBar];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolBar];
}

-(void)dateChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (currentText.tag==10||selectedBtn.tag==501) {
        [df setDateFormat:DATE_FORMAT_MMM_DD_YYYY];
        [df setDateStyle:NSDateFormatterMediumStyle];
        [df setTimeStyle:NSDateFormatterNoStyle];
    }else if (currentText.tag==11||selectedBtn.tag==502)
    {
        [df setDateFormat:TIME_FORMAT_h_m_A];
    }
    currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set date in date picker in edit mode of Announcement

-(void)setDateInDatePicker
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (currentText.text.length > 0 && currentText.tag == 10) {
        [df setDateFormat:DATE_FORMAT_MMM_DD_YYYY];
        NSDate *Date;
        Date= [df dateFromString:currentText.text];
        UIDatePicker *tempdatePicker= (UIDatePicker *)[self.view viewWithTag:70];
        if (Date) {
            [tempdatePicker setDate:Date];
        }
        
    }else{
        [df setTimeStyle:NSDateFormatterShortStyle];
        [df setDateFormat:TIME_FORMAT_h_m_A];
        NSDate *Date;
        Date= [df dateFromString:currentText.text];
        UIDatePicker *tempdatePicker= (UIDatePicker *)[self.view viewWithTag:70];
        if (Date) {
            [tempdatePicker setDate:Date];
        }
    }
}
#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    if (![textField.placeholder isEqualToString:@"Enter Name"]) {
        scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y-(100));
    }
    currentText=nil;
    currentText=textField;
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (currentText.tag==10||selectedBtn.tag==501) {
        [self setDateInDatePicker];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
         datePicker.datePickerMode = UIDatePickerModeDate;
        if (currentText.text.length ==0) {
            [df setDateFormat:DATE_FORMAT_MMM_DD_YYYY];
            [df setDateStyle:NSDateFormatterMediumStyle];
            [df setTimeStyle:NSDateFormatterNoStyle];
            currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
        }
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :datePicker :toolBar];
        return NO;
    }else if (currentText.tag==11||selectedBtn.tag==502)
    {
        [self setDateInDatePicker];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
         datePicker.datePickerMode = UIDatePickerModeTime;
        [df setDateFormat:TIME_FORMAT_h_m_A];
        currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :datePicker :toolBar];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
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

#pragma mark- UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    txtViewCurrent=textView;
     scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y-(20));
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    txtViewCurrent=textView;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"Enter Description"]) {
        textView.text=EMPTYSTRING;
    }
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}

- (IBAction)emailBtnClick:(id)sender {
    [self buttonSelected:sender];
}
-(void) buttonSelected:(UIButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender==emailBtn1) {
        emailBtn1.userInteractionEnabled=NO;
        [sender setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
        [emailBtn2 setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        emailBtn2.userInteractionEnabled=YES;
        emailNotification=@"1";
    }else if (sender==emailBtn2){
        emailBtn2.userInteractionEnabled=NO;
        [sender setImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
        [emailBtn1 setImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
        emailBtn1.userInteractionEnabled=YES;
        emailNotification=@"0";
    }
    
}

-(void)ChangeAllGroupStatus : (BOOL)Status
{
    for (id key in [selectedGroups allKeys])
        [selectedGroups setObject:[NSNumber numberWithBool:Status] forKey:key];
    
    [pickerView  reloadAllComponents];
}


- (IBAction)settingBtnClick:(id)sender {
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        
        if (!button.selected)
        {
            [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            //Athlete or All
            if (button.tag == 1002 || button.tag==1000) {
                
                //btn Group
                CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(1004)];
                // If Group is selected then Athlete will not selected .
                if (btn.selected)
                {
                    btn.selected=NO;
                    [btn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    [self ChangeAllGroupStatus : NO];
                }
                
            }
            if (button.tag == 1004){
                //btn All
                CheckboxButton *btn1 = (CheckboxButton*)[scrollView viewWithTag:(1000)];
                // If Athlete is selected then Group will not selected .
                if (btn1.selected)
                {
                    btn1.selected=NO;
                    [btn1 setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    
                    for (int i=0; i<4; i++)
                    {
                        int a = i;
                        
                        CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
                        btn.enabled=YES;
                        
                        // Athlete button unckeck
                        if (btn.tag == 1002)
                            [btn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    }
                    NSString *str1=[NSString stringWithFormat:@"%d",(int)(btn1.tag-1000)];
                    if ([settingArray containsObject:str1])
                    {
                        [settingArray removeObject:str1];
                    }
                }
                //btn Athlete
                CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(1002)];
                // If Athlete is selected then Group will not selected .
                if (btn.selected)
                {
                    btn.selected=NO;
                    [btn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    NSString *str1=[NSString stringWithFormat:@"%d",(int)(btn.tag-1000)];
                    if ([settingArray containsObject:str1])
                    {
                        [settingArray removeObject:str1];
                    }
                }
                
            }
        }
        else
        {
            [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            
            if (button.tag ==1004) {
                for (id key in [selectedGroups allKeys])
                {
                    if ([[selectedGroups objectForKey:key] intValue] == 1) {
                        button.selected=YES;
                        [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                        break;
                    }else
                    {
                        button.selected=NO;
                        [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    }
                    
                }
                
            }else
            {
                
            }
        }
        // All button selected
        
        if (button.tag==1000)
        {
            for (int i=0; i<4; i++) {
                int a = i;
                
                CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
                if (!button.selected) {
                    [btn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    
                    if (a!=0) {
                        btn.selected=YES;
                        NSString *str =[NSString stringWithFormat:@"%i",a];
                        if (![settingArray containsObject:str])
                            [settingArray addObject:str];
                    }
                }else{
                    [btn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    
                    if (a!=0) {
                        btn.selected=NO;
                        NSString *str =[NSString stringWithFormat:@"%i",a];
                        if ([settingArray containsObject:str])
                            [settingArray removeObject:str];
                    }
                }
                
            }
        }else if(button.tag>1000 && button.tag <1004){
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if (![settingArray containsObject:str1]) {
                [settingArray addObject:str1];
            }
            else
                [settingArray removeObject:str1];
        }
        else{
            // For Group selected
            UIToolbar *toolbar=(UIToolbar *)[self.view viewWithTag:40];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :pickerView :toolbar];
        }
        button.selected=!button.selected;
    }
}


- (IBAction)selectDate:(id)sender{
    selectedBtn=sender;
    currentText=dateTxt;
    datePicker.datePickerMode = UIDatePickerModeDate;
    isKeyBoard=YES;
    [SingletonClass setListPickerDatePickerMultipickerVisible:YES :datePicker :toolBar];
    
}
- (IBAction)selectTime:(id)sender{
    selectedBtn=sender;
    currentText=timeTxt;
    isKeyBoard=YES;
    datePicker.datePickerMode = UIDatePickerModeTime;
    [SingletonClass setListPickerDatePickerMultipickerVisible:YES :datePicker :toolBar];
}

- (IBAction)saveAnnouncement:(id)sender {
    [SingletonClass ShareInstance].isAnnouncementUpdate=TRUE;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    NSString *strError = EMPTYSTRING;
    if(nameTxt.text.length < 1 ){
        strError = @"Please enter announcement name";
    }
    else if(dateTxt.text.length < 1 ){
        strError = @"Please enter announcement date";
    } else if(timeTxt.text.length < 1 ){
        strError = @"Please enter announcement time";
    }else if(settingArray.count==0 ){
        strError = @"Please select privacy setting item";
    }
    if(strError.length>2){
        self.navigationItem.rightBarButtonItem.enabled=YES;
        [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
        return;
    }else{
        if ([SingletonClass  CheckConnectivity]) {
            UserInformation *userInfo=[UserInformation shareInstance];
            [SingletonClass addActivityIndicator:self.view];
            NSMutableString *groupIdString=[[NSMutableString alloc]init];
            NSArray *arrKeys=[selectedGroups allKeys];
            NSArray *arrValues=[selectedGroups allValues];
            NSMutableArray *temp1=[[NSMutableArray alloc] init];
            for (int i=0; i<arrValues.count; i++) {
                if ([[arrValues objectAtIndex:i] intValue]==1){
                    NSArray *temp = [AllGroupData allKeysForObject:[arrKeys objectAtIndex:i]];
                    NSString *key = [temp lastObject];
                    [temp1 addObject: key];
                }
            }
            for (int i=0; i<temp1.count; i++) {
                if (i < temp1.count-1 )
                    [groupIdString appendFormat:@"%@,",temp1[i]];
                else
                    [groupIdString appendFormat:@"%@",temp1[i]];
            }
            NSString *tepmSetting=EMPTYSTRING;
            for (int i=0; i<settingArray.count; i++) {
                
                if (i < settingArray.count-1 )
                    tepmSetting =[tepmSetting stringByAppendingString:[NSString stringWithFormat:@"%@,",settingArray[i]]];
                else
                    tepmSetting = [tepmSetting stringByAppendingString:[NSString stringWithFormat:@"%@",settingArray[i]]];
            }
            tepmSetting=[tepmSetting stringByReplacingOccurrencesOfString:@"4" withString:@"5"];
            // add 4 for group data in setting
            if (temp1.count > 0) {
                tepmSetting=[tepmSetting stringByAppendingString:@",4"];
            }
            temp1=nil;
            NSString *description=descTxt.text;
            NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",announcementId] forKey:@"id"];
            [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:@"user_id"];
            [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedTeamid] forKey:@"team_id"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",groupIdString] forKey:@"group_ids"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",nameTxt.text] forKey:@"name"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",description] forKey:@"desc"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",dateTxt.text] forKey:@"date"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",timeTxt.text] forKey:@"time"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",emailNotification] forKey:@"email"];
            [dicttemp setObject:[NSString stringWithFormat:@"%@",tepmSetting] forKey:@"privacy_setting"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicttemp options:0 error:NULL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceAddAnnouncement]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSMutableData *data = [NSMutableData data];
            [data appendData:jsonData];
            [request setHTTPBody:data];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       tagNumber=AddAnnouncementTag;
                                       if (data!=nil)
                                       {
                                           [self httpResponseReceived : data];
                                       }else{
                                        
                                           [SingletonClass RemoveActivityIndicator:self.view];
                                        
                                       }
                                   }];
        }else{
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
        }
    }
}
#pragma mark -
#pragma mark ALPickerView delegate methods
- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
    return [groupArray count];
}
- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    return [groupArray objectAtIndex:row];
}
- (BOOL)pickerView:(ALPickerView *)pickerView selectionGroupForRow:(NSInteger)row {
      return [[selectedGroups objectForKey:[groupArray objectAtIndex:row]] boolValue];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    return [[selectedGroups objectForKey:[groupArray objectAtIndex:row]] boolValue];
}

// Check whether all rows are checked or only one
- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    
    if (row == -1)
        for (id key in [selectedGroups allKeys])
            [selectedGroups setObject:[NSNumber numberWithBool:YES] forKey:key];
    else
        [selectedGroups setObject:[NSNumber numberWithBool:YES] forKey:[groupArray objectAtIndex:row]];
    [self showBtnGroupStatus];
}

-(void)showBtnGroupStatus
{
    BOOL status=FALSE;
    for (id key in [selectedGroups allKeys])
    {
        if ([[selectedGroups objectForKey:key] intValue] == 1) {
            status=TRUE;
        }
    }
    if (status) {
        [selectGroupBtn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
    }else
    {
        [selectGroupBtn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    }
}

// Check whether all rows are unchecked or only one
- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    
    if (row == -1)
        for (id key in [selectedGroups allKeys])
            [selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:key];
    else
        [selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:[groupArray objectAtIndex:row]];
    [self showBtnGroupStatus];
}

// All button Seleted No Or Selected yes
- (IBAction)AllButtonEvent:(id)sender {
    [self ClickCheckBoxHideControll];
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        if (button.tag == 1000 && button.selected==NO) {
            
            for (int i=0; i<5; i++)
            {
                int a = i;
                
                CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
                [btn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                
                btn.selected=YES;
                if (a!=0) {
                    
                    NSString *str =[NSString stringWithFormat:@"%i",a];
                    if ([settingArray containsObject:str])
                    {
                        
                    }else
                        [settingArray addObject:str];
                }
            }
            // If group already selected
            CheckboxButton *btnGroup = (CheckboxButton*)[scrollView viewWithTag:(1005)];
            
            NSString *str=[NSString stringWithFormat:@"%d",(int)(btnGroup.tag-1000)];
            if ([settingArray containsObject:str]) {
                [settingArray removeObject:str];
            }
            
            if (btnGroup.selected==YES) {
                [btnGroup setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                btnGroup.selected=NO;
                [self ChangeAllGroupStatus : NO];
            }
            
            
        }else if (button.tag == 1000 && button.selected==YES){
            
            for (int i=0; i<5; i++)
            {
                int a = i;
                
                CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
                [btn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                
                btn.selected=NO;
                if (a!=0) {
                    NSString *str =[NSString stringWithFormat:@"%i",a];
                    if ([settingArray containsObject:str])
                        [settingArray removeObject:str];
                }
            }
        }
    }
}

- (IBAction)CoachButtonEvent:(id)sender {
    [self ClickCheckBoxHideControll];
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        
        if (button.tag == 1001 && button.selected==YES)
        {
            CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
            if (Allbtn.selected==YES) {
                [Allbtn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=NO;
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
            }else{
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
            }
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if ([settingArray containsObject:str1]) {
                [settingArray removeObject:str1];
            }
            
        }else if (button.tag == 1001 && button.selected==NO)
        {
            [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            
            button.selected=YES;
            
            int count=0;
            
            CheckboxButton *btnAthlete = (CheckboxButton*)[scrollView viewWithTag:(1002)];
            
            if (btnAthlete.selected==YES) {
                
                count++;
            }
            CheckboxButton *btnAlumini = (CheckboxButton*)[scrollView viewWithTag:(1003)];
            
            if (btnAlumini.selected==YES) {
                
                count++;
            }
            CheckboxButton *btnManager = (CheckboxButton*)[scrollView viewWithTag:(1004)];
            if (btnManager.selected==YES) {
                count++;
            }
            if (count==3) {
                
                CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
                [Allbtn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                
                Allbtn.selected=YES;
            }
            //Add values for use
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if (![settingArray containsObject:str1]) {
                [settingArray addObject:str1];
            }
            
        }
    }
}

- (IBAction)AthleteButtonEvent:(id)sender {
    [self ClickCheckBoxHideControll];
    
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        
        if (button.tag == 1002 && button.selected==YES)
        {
            CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
            
            if (Allbtn.selected==YES) {
                
                [Allbtn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=NO;
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
                
            }else{
                
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
            }
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if ([settingArray containsObject:str1]) {
                [settingArray removeObject:str1];
            }
        }else if (button.tag == 1002 && button.selected==NO)
        {
            [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            button.selected=YES;
            int count=0;
            CheckboxButton *btnAthlete = (CheckboxButton*)[scrollView viewWithTag:(1001)];
            if (btnAthlete.selected==YES) {
                
                count++;
            }
            CheckboxButton *btnAlumini = (CheckboxButton*)[scrollView viewWithTag:(1003)];
            if (btnAlumini.selected==YES) {
                
                count++;
            }
            CheckboxButton *btnManager = (CheckboxButton*)[scrollView viewWithTag:(1004)];
            if (btnManager.selected==YES) {
                count++;
            }
            
            if (count==3) {
                
                CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
                [Allbtn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=YES;
            }
            //Add values for use
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if (![settingArray containsObject:str1]) {
                [settingArray addObject:str1];
            }
            // If group already selected
            CheckboxButton *btnGroup = (CheckboxButton*)[scrollView viewWithTag:(1005)];
            NSString *str=[NSString stringWithFormat:@"%d",(int)(btnGroup.tag-1000)];
            if ([settingArray containsObject:str]) {
                [settingArray removeObject:str];
            }
            if (btnGroup.selected==YES) {
                [btnGroup setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                btnGroup.selected=NO;
                [self ChangeAllGroupStatus : NO];
            }
        }
    }
    
}
- (IBAction)ManagerButtonEvent:(id)sender
{
    [self ClickCheckBoxHideControll];
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        if (button.tag == 1004 && button.selected==YES)
        {
            CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
            if (Allbtn.selected==YES) {
                [Allbtn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=NO;
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
            }else{
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
            }
            
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if ([settingArray containsObject:str1]) {
                [settingArray removeObject:str1];
            }
            
        }else if (button.tag == 1004 && button.selected==NO)
        {
            [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            button.selected=YES;
            int count=0;
            CheckboxButton *btnAthlete = (CheckboxButton*)[scrollView viewWithTag:(1002)];
            if (btnAthlete.selected==YES) {
                count++;
            }
            CheckboxButton *btnAlumini = (CheckboxButton*)[scrollView viewWithTag:(1003)];
            if (btnAlumini.selected==YES) {
                count++;
            }
            CheckboxButton *btnCoach = (CheckboxButton*)[scrollView viewWithTag:(1001)];
            if (btnCoach.selected==YES) {
                count++;
            }
            if (count==3) {
                
                CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
                [Allbtn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=YES;
            }
            //Add values for use
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if (![settingArray containsObject:str1]) {
                [settingArray addObject:str1];
            }
        }
    }
    
}
- (IBAction)AluminiButtonEvent:(id)sender {
    [self ClickCheckBoxHideControll];
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        
        if (button.tag == 1003 && button.selected==YES)
        {
            CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
            if (Allbtn.selected==YES) {
                [Allbtn setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=NO;
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
                
            }else{
                
                [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                button.selected=NO;
            }
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if ([settingArray containsObject:str1]) {
                [settingArray removeObject:str1];
            }
            
        }else if (button.tag == 1003 && button.selected==NO)
        {
            [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            
            button.selected=YES;
            int count=0;
            CheckboxButton *btnAthlete = (CheckboxButton*)[scrollView viewWithTag:(1001)];
            if (btnAthlete.selected==YES) {
                count++;
            }
            CheckboxButton *btnAlumini = (CheckboxButton*)[scrollView viewWithTag:(1002)];
            if (btnAlumini.selected==YES) {
                count++;
            }
            CheckboxButton *btnManager = (CheckboxButton*)[scrollView viewWithTag:(1004)];
            if (btnManager.selected==YES) {
                count++;
            }
            if (count==3) {
                CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
                [Allbtn setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                Allbtn.selected=YES;
            }
            //Add values for use
            NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
            if (![settingArray containsObject:str1]) {
                [settingArray addObject:str1];
            }
        }
    }
}

- (IBAction)GroupsButtonEvent:(id)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :datePicker :toolBar];
    if (groupArray.count==0) {
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Groups are not exist" delegate:nil btn1:@"Ok"];
        return;
    }
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
        CheckboxButton *button=(CheckboxButton*)sender;
        if (button.tag == 1005 && button.selected==YES)
        {
            [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            button.selected=NO;
        }else if (button.tag == 1005 && button.selected==NO)
        {
            [button setImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            
            button.selected=YES;
            CheckboxButton *btnAll = (CheckboxButton*)[scrollView viewWithTag:(1000)];
            
            if (btnAll.selected==YES) {
                [btnAll setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                btnAll.selected=NO;
            }
            CheckboxButton *btnAthlete = (CheckboxButton*)[scrollView viewWithTag:(1002)];
            if (btnAthlete.selected==YES) {
                [btnAthlete setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                btnAthlete.selected=NO;
                NSString *str1=[NSString stringWithFormat:@"%d",(int)(btnAthlete.tag-1000)];
                if ([settingArray containsObject:str1]) {
                    [settingArray removeObject:str1];
                }
            }
        }
    }
    UIToolbar *toolbar=(UIToolbar *)[self.view viewWithTag:40];
    [SingletonClass setListPickerDatePickerMultipickerVisible:YES :pickerView :toolbar];
}
@end
