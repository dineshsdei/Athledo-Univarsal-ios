//
//  AddPracticeLog.m
//  Athledo
//
//  Created by Smartdata on 5/12/15.
//  Copyright (c) 2015 Athledo inc. All rights reserved.
//

#import "AddPracticeLog.h"
#define DESCRIPTIONTAG 1000
#define DRILLTAG 1001
#define NOTESTAG 1002
#define STARTTIMETAG 1003
#define ENDTAG 1004



@interface AddPracticeLog ()
{
    UIToolbar *toolBar;
    UIDatePicker *practice_TimePicker;
    UITextField *currentTextField;
}

@end

@implementation AddPracticeLog

#pragma mark UIViewController LifeCycle method
-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
     self.title=NSLocalizedString(@"Add Practice", EMPTYSTRING);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SavePracticeData) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    [_scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height+100)];
    _scrollView.scrollEnabled = YES;
    [super viewDidLoad];
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [self setFieldsProperty];
    practice_TimePicker = [[SingletonClass ShareInstance] AddDatePickerView:self.view];
    [practice_TimePicker addTarget:self action:@selector(GetPickerTime:) forControlEvents:UIControlEventValueChanged];
    
}
- (void)viewDidLayoutSubviews {
    [_scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height+100)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark Class Utility method
-(void)SetTimeInDatePicker:(UITextField *)textField
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterNoStyle];
    practice_TimePicker.datePickerMode = UIDatePickerModeTime;
    [df setDateFormat:TIME_FORMAT_h_m_A];
    if (textField.text.length==0) {
        textField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:practice_TimePicker.date]];
    }else{
        NSDate *Date;
        Date= [df dateFromString:textField.text];
        if (Date) {
            [practice_TimePicker setDate:Date];
        }
    }
}
- (IBAction)GetPickerTime:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterNoStyle];
    practice_TimePicker.datePickerMode = UIDatePickerModeTime;
    [df setDateFormat:TIME_FORMAT_h_m_A];
    currentTextField.text = [NSString stringWithFormat:@"%@", [df stringFromDate:practice_TimePicker.date]];
    
    UITextField *textfieldStart=(UITextField *)[self.view viewWithTag:1003];
    UITextField *textfieldEnd=(UITextField *)[self.view viewWithTag:1004];
    
    NSDate *dateOne=[df dateFromString:textfieldStart.text];
    NSDate *dateTwo=[df dateFromString:textfieldEnd.text];
    
    if (textfieldStart.text.length !=0 && textfieldEnd.text.length !=0) {
        NSString *strError=EMPTYSTRING;
        switch ([dateOne compare:dateTwo]) {
            case NSOrderedSame:
            {
                strError = @"Start time and end time cann't same";
                currentTextField.text=EMPTYSTRING;
                [SingletonClass initWithTitle:nil message:strError delegate:nil btn1:@"Ok"];
                // The dates are the same
                break;
            }
            case NSOrderedDescending:
            {
                strError = @"End time cann't earlier to Start time";
                currentTextField.text=EMPTYSTRING;
                [SingletonClass initWithTitle:nil message:strError delegate:nil btn1:@"Ok"];
                // dateOne is later in time than dateTwo
                break;
            }
        }
        // To check end is greater or not uncomment
    }
}
-(void)setFieldsProperty
{    _txtViewDescription.layer.borderWidth = BORDERWIDTH;
    _txtViewDescription.layer.borderColor =  BORDERCOLOR;
    _txtViewDescription.layer.cornerRadius = CornerRadius;
    _txtViewDescription.textColor = LightGrayColor;
    _txtViewDrill.layer.borderWidth = BORDERWIDTH;
    _txtViewDrill.layer.borderColor = BORDERCOLOR;
    _txtViewDrill.layer.cornerRadius = CornerRadius;
    _txtViewDrill.textColor =LightGrayColor;
    _txtViewNotes.layer.borderWidth = BORDERWIDTH;
    _txtViewNotes.layer.borderColor = BORDERCOLOR;
    _txtViewNotes.layer.cornerRadius = CornerRadius;
    _txtViewNotes.textColor = LightGrayColor;
    
    _txtFieldEndTime.textColor = LightGrayColor;
    _txtFieldStartTime.textColor = LightGrayColor;
}
#pragma mark UITextView Delegate Method
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y-(10));
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"Enter Description"]) {
        textView.text = EMPTYSTRING;
    }
    if ([textView.text  isEqualToString:@"Enter Drill"]) {
        textView.text = EMPTYSTRING;
    }
   if ([textView.text  isEqualToString:@"Enter Notes"]) {
        textView.text = EMPTYSTRING;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [SingletonClass ShareInstance].delegate = self;
    textView.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.tag == DESCRIPTIONTAG) {
        textView.text = @"Enter Description";
    }
    if (textView.tag == DRILLTAG) {
        textView.text = @"Enter Drill";
    }
    if (textView.tag == NOTESTAG) {
        textView.text = @"Enter Notes";
    }
    return YES;
}
#pragma mark UITextFeild Delegate method 
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [SingletonClass ShareInstance].delegate = self;
    textField.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
   
    textField.inputView = practice_TimePicker;
    _scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y-(100));
    [self SetTimeInDatePicker:textField];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}
#pragma mark Singalton Class Delegate
-(void)Done
{
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}
#pragma mark WebService Comunication Method
-(void)SavePracticeData{
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetPracticeData :strURL :getPracticeTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
    switch (Tag){
        case getPracticeTag :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                
            }else{
               
            }
            break;
        }
    }
}

@end
