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

@interface AddPracticeLog (){
    UIToolbar *toolBar;
    UIDatePicker *practice_TimePicker;
    UITextField *currentTextField;
}
@end
@implementation AddPracticeLog

#pragma mark UIViewController LifeCycle method
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @try {
        if (_objEditPracticeData) {
            
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
            NSDate *start_time = [df dateFromString:[[_objEditPracticeData  valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[_objEditPracticeData valueForKey:@"start_time"]]];
            NSDate *end_time = [df dateFromString:[[_objEditPracticeData  valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[_objEditPracticeData valueForKey:@"end_time"]]];
            [df setDateFormat:TIME_FORMAT_h_m_A];
            
            NSString *strstarttime = [df stringFromDate:start_time];
            NSString *strendtime = [df stringFromDate:end_time];
            
            start_time !=nil ?  [_objEditPracticeData setObject:strstarttime forKey:@"start_time"] :@"";
            end_time !=nil ?  [_objEditPracticeData setObject:strendtime forKey:@"end_time"] : @"";
            if(([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger))
            {
                NSString *str =[[_objEditPracticeData objectForKey:@"description"] isKindOfClass:[NSString class]] ?[_objEditPracticeData objectForKey:@"description"] : @"";
                _txtViewDescription.text = str;
                _txtViewDrill.text = [[_objEditPracticeData objectForKey:@"drills"] isKindOfClass:[NSString class]]  ? [_objEditPracticeData objectForKey:@"drills"] :@"";
                _txtViewNotes.text = [[_objEditPracticeData objectForKey:@"notes"] isKindOfClass:[NSString class]] ? [_objEditPracticeData objectForKey:@"notes"]  :  @"";
                _txtFieldStartTime.text = [[_objEditPracticeData objectForKey:@"start_time"] isKindOfClass:[NSString class]] ? [_objEditPracticeData objectForKey:@"start_time"]: @"" ;
                _txtFieldEndTime.text = [[_objEditPracticeData objectForKey:@"end_time"] isKindOfClass:[NSString class]] ? [_objEditPracticeData objectForKey:@"end_time"] : @"" ;
            }else
            {
                _txtViewNotes.text = [[_objEditPracticeData objectForKey:@"notes"] isKindOfClass:[NSString class]] ? [_objEditPracticeData objectForKey:@"notes"]  :  @"";
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    if (isIPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
}
- (void)viewDidLoad {
    self.title=NSLocalizedString(_strScreenTitle, EMPTYSTRING);
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
    if(([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger))
    {
        [self setFieldsProperty];
        practice_TimePicker = [[SingletonClass ShareInstance] AddDatePickerView:self.view];
        [practice_TimePicker addTarget:self action:@selector(GetPickerTime:) forControlEvents:UIControlEventValueChanged];
    }else
    {
        _txtViewNotes.layer.borderWidth = BORDERWIDTH;
        _txtViewNotes.layer.borderColor = BORDERCOLOR;
        _txtViewNotes.layer.cornerRadius = CornerRadius;
        _txtViewNotes.textColor = LightGrayColor;
    }
}
- (void)viewDidLayoutSubviews {
    [_scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height+100)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark Class Utility method
-(void)setContaintOffset:(id)control
{
    UITextField *textfield;
    UITextView *textView;
    if ([control isKindOfClass:[UITextField class]]) {
        textfield = (UITextField *)control;
        
        [UIView animateWithDuration:.29f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _scrollView.contentOffset = CGPointMake(0, textfield.frame.origin.y-(100));
        } completion:^(BOOL finish){}];
    }else if ([control isKindOfClass:[UITextView class]]) {
        textView = (UITextView *)control;
        [UIView animateWithDuration:.29f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y-(10));
        } completion:^(BOOL finish){}];
    }
}
- (void)orientationChanged
{
    [_scrollView setContentSize:CGSizeMake(0, self.view.frame.size.height+100)];
}
-(NSString *)weekStartDate
{
    if (_objEditPracticeData) {
        NSString *str = [_objEditPracticeData valueForKey:@"week_start_date"];
        return str;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *today = [NSDate date];
    [dateFormat setDateFormat:DATE_FORMAT_Y_M_D];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:0];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    long dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    [components setDay:([components day] - (dayofweek-1))];// for beginning of the week.
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSString *strBeginningOfWeek = [dateFormat stringFromDate:beginningOfWeek];
    return strBeginningOfWeek;
}
-(NSString *)weekEndDate
{
    if (_objEditPracticeData) {
        NSString *str = [_objEditPracticeData valueForKey:@"week_end_date"];
        return str;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *today = [NSDate date];
    [dateFormat setDateFormat:DATE_FORMAT_Y_M_D];
    NSCalendar *gregorian = [[NSCalendar alloc]        initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:0];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int Enddayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    [components setDay:([components day]+(7-Enddayofweek))];// for end day of the week
    NSDate *endOfWeek = [gregorian dateFromComponents:components];
    NSString *strEndOfWeek = [dateFormat stringFromDate:endOfWeek];
    return strEndOfWeek;}

-(NSString *)weekCurrentPracticeDate
{
    if (_objEditPracticeData) {
        
        NSString *str =[_objEditPracticeData valueForKey:@"week_current_date"];
        return str;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D];
    NSString *strPracticeCurrentDate = [formatter stringFromDate:_addPracticeOnDate];
    return strPracticeCurrentDate;
}
-(void)SetTimeInDatePicker:(UITextField *)textField{
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
            case NSOrderedSame:{
                strError = @"Start time and end time cann't same";
                currentTextField.text=EMPTYSTRING;
                [SingletonClass initWithTitle:nil message:strError delegate:nil btn1:@"Ok"];
                // The dates are the same
                break;
            }
            case NSOrderedDescending:{
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
-(void)setFieldsProperty{
    _txtViewDescription.layer.borderWidth = BORDERWIDTH;
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
    
    if (isIPAD) {
        
        [self.txtViewDescription sizeToFit];
        [_txtViewDescription layoutIfNeeded];
    }
}
#pragma mark UITextView Delegate Method
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self setContaintOffset:textView];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [SingletonClass ShareInstance].delegate = self;
    textView.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.tag == DESCRIPTIONTAG && textView.text.length == 0) {
        textView.text = @"Enter Description";
    }
    if (textView.tag == DRILLTAG  && textView.text.length == 0) {
        textView.text = @"Enter Drill";
    }
    if (textView.tag == NOTESTAG  && textView.text.length == 0) {
        textView.text = @"Enter Notes";
    }
    return YES;
}
#pragma mark UITextFeild Delegate method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setContaintOffset:textField];
    [SingletonClass ShareInstance].delegate = self;
    textField.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    textField.inputView = practice_TimePicker;
    [self SetTimeInDatePicker:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
}
#pragma mark Singalton Class Delegate
-(void)Done{
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self.view endEditing:YES];
}
#pragma mark WebService Comunication Method
-(void)SavePracticeData{
    if ([SingletonClass  CheckConnectivity]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        NSString *strError = EMPTYSTRING;
        
        if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
            
            if((_txtViewDescription.text.length > 0) && ([_txtViewDescription.text isEqualToString:@"Enter Description"]) )
            {
                strError = @"Please enter practice description";
            }
            else if((_txtViewNotes.text.length > 0)  && ([_txtViewNotes.text isEqualToString:@"Enter Notes"])){
                strError = @"Please enter practice notes";
            } else if(_txtFieldStartTime.text.length == 0 ){
                strError = @"Please enter practice start time";
            }else if(_txtFieldEndTime.text.length == 0  ){
                strError = @"Please enter practice end time";
            }
        }else{
            if((_txtViewNotes.text.length > 0)  && ([_txtViewNotes.text isEqualToString:@"Enter Notes"])){
                strError = @"Please enter practice notes";
            }
        }
        if(strError.length>0){
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            return;
        }
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        [SingletonClass addActivityIndicator:self.view];
        // practice_user_id ,case 1(add practice)->>(login user id) >> case 2(Edit practice)->>(Existing user id)
        NSMutableDictionary *DicPracticeData;
        if (_objEditPracticeData) {
            if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
                DicPracticeData=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:userInfo.userType ],@"type",[NSNumber numberWithInt:userInfo.userId ],@"loguser_id",[_objEditPracticeData valueForKey:@"user_id"],@"practice_user_id",[_objEditPracticeData valueForKey:@"id" ],@"id",[_objEditPracticeData valueForKey:@"parent_id"] ,@"parent_id",[NSNumber numberWithInt:userInfo.userSelectedTeamid ],@"team_id",_txtViewDescription.text,@"description",_txtViewDrill.text,@"drills",_txtViewNotes.text,@"notes",[self weekCurrentPracticeDate],@"week_current_date",[self weekStartDate],@"week_start_date",[self weekEndDate],@"week_end_date",_txtFieldStartTime.text,@"start_time",_txtFieldEndTime.text,@"end_time", nil];
            }else{
                
                DicPracticeData=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:userInfo.userType ],@"type",[NSNumber numberWithInt:userInfo.userId ],@"loguser_id",[_objEditPracticeData valueForKey:@"user_id"],@"practice_user_id",[_objEditPracticeData valueForKey:@"id" ],@"id",[_objEditPracticeData valueForKey:@"parent_id"] ,@"parent_id",[NSNumber numberWithInt:userInfo.userSelectedTeamid ],@"team_id",@"",@"description",@"",@"drills",_txtViewNotes.text,@"notes",[self weekCurrentPracticeDate],@"week_current_date",[self weekStartDate],@"week_start_date",[self weekEndDate],@"week_end_date",[_objEditPracticeData valueForKey:@"start_time"],@"start_time",[_objEditPracticeData valueForKey:@"end_time"],@"end_time", nil];
            }
        }else{
            DicPracticeData=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:userInfo.userType ],@"type",[NSNumber numberWithInt:userInfo.userId ],@"loguser_id",[NSNumber numberWithInt:userInfo.userId ],@"practice_user_id",@"",@"id",@"",@"parent_id",[NSNumber numberWithInt:userInfo.userSelectedTeamid ],@"team_id",_txtViewDescription.text,@"description",_txtViewDrill.text,@"drills",_txtViewNotes.text,@"notes",[self weekCurrentPracticeDate],@"week_current_date",[self weekStartDate],@"week_start_date",[self weekEndDate],@"week_end_date",_txtFieldStartTime.text,@"start_time",_txtFieldEndTime.text,@"end_time", nil];
        }
        [SingletonClass ShareInstance].isPracticeLogUpdate = TRUE;
        [webservice WebserviceCallwithDic:DicPracticeData :webServiceSavePractice :SaveAddPracticeTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    switch (Tag){
        case SaveAddPracticeTag :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                if ([UserInformation shareInstance].userType == isAthlete) {
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Practice note has been saved successfully" delegate:self btn1:@"Ok"];
                }else
                {
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Practice has been saved successfully" delegate:self btn1:@"Ok"];
                }
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Please try again" delegate:self btn1:@"Ok"];
            }
            break;
        }
    }
}
#pragma mark UIAlertView Delegate menthod
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [SingletonClass ShareInstance].isPracticeLogUpdate = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
