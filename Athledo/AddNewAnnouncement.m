
//
//  AddNewAnnouncement.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/24/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "AddNewAnnouncement.h"
#import "AnnouncementView.h"
#import "UserInformation.h"
#import "CheckboxButton.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"

#define CornerRadius 5
#define PadingW 12
#define PadingH 20

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

- (void)viewDidLoad
{
    self.title = _ScreenTitle;


    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
    [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];

    [super viewDidLoad];

    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
         [self setDatePickerVisibleAt:NO];
        [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(kbSize.height+22))];
        scrollHeight=kbSize.height;
        
        
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        
    }];
    
    
    scrollHeight=0;



    scrollHeight=0;

    emailNotification=@"1";
    announcementId=@"";
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

    NSLog(@"frame %f%f%f%f",self.view.frame.size.width,self.view.frame.size.height,self.view.bounds.size.height,self.view.bounds.size.width);


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

    UIToolbar *toolBar;
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];



    descTxt.layer.borderWidth = .50f;
    descTxt.layer.borderColor = [[UIColor lightGrayColor] CGColor];


    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    // UIImage *imageEdit=[UIImage imageNamed:@"add.png"];



    [btnSave addTarget:self action:@selector(saveAnnouncement:) forControlEvents:UIControlEventTouchUpInside];
    // [btnSave setBackgroundImage:imageEdit forState:UIControlStateNormal];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];

    self.navigationItem.rightBarButtonItem = ButtonItem;

    //set pickerView

    [self getGroupList];

    pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height+50, self.view.frame.size.width, 216)];
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.tag=60;
    pickerView.delegate=self;
    //    pickerView.dataSource=self;
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
    [emailBtn2 setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    [emailBtn1 setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    emailBtn1.userInteractionEnabled=YES;
    emailNotification=@"0";

    }else{
    emailBtn1.userInteractionEnabled=NO;
    [emailBtn1 setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    [emailBtn2 setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
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


    if ([array count]==3 && [array containsObject:@"2"]) {
    UIButton *btn = (UIButton*)[scrollView viewWithTag:1000];
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
    btn.selected=YES;
    }

    for (int i=0; i<array.count; i++)
    {
    int a = [[array objectAtIndex:i]intValue];
    [settingArray addObject:[array objectAtIndex:i]];

    UIButton *btn = (UIButton*)[scrollView viewWithTag:(a+1000)];
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
    btn.selected=YES;
    }


    }
    
    [scrollView setContentOffset:CGPointMake(0,scrollHeight+100) animated: YES];
}

// this method used to get list of groups, Athletes to send Announcement to them

-(void)getGroupList{
    
    if ([SingaltonClass  CheckConnectivity]) {

    UserInformation *userInfo=[UserInformation shareInstance];



    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = 50;
    [self.view addSubview:indicator];

    NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\"}",userInfo.userSelectedTeamid];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceGetGroups]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableData *data = [NSMutableData data];

    [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
    [request setHTTPBody:data];

    //HttpRequest *http = [[HttpRequest alloc] init];
    //[http request:request delegate:self tagNumber:200];
    [NSURLConnection sendAsynchronousRequest:request
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    // ...

    //NSLog(@"announcement response:%@",response);
    tagNumber=101;
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

    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }


}
// this method used to get web service response from server

-(void)httpResponseReceived:(NSData *)webResponse
{
    @try {
    self.navigationItem.leftBarButtonItem.enabled=YES;

    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
    if(acti)
    [acti removeFromSuperview];
    // Now we Need to decrypt data

    NSError *error=nil;

    if (tagNumber==101) {

    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];

    //NSLog(@"Get groups Response >>%@",myResults);

    if([[myResults objectForKey:@"status"] isEqualToString:@"success"])
    {
    AllGroupData=[[myResults  objectForKey:@"data"]valueForKey:@"Group"]  ;
    //        //NSLog(@"%@",[data allValues]);


    if (AllGroupData.count>0) {


    NSArray *arr = [AllGroupData allValues];

    for (int i=0; i<[arr count]; i++) {
    NSString *value=[arr objectAtIndex:i];

    [groupArray addObject:value];
    }

    for (int i=0;i< groupArray.count;i++){

    //NSLog(@"%@",[groupArray objectAtIndex:i]);

    [selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:[groupArray objectAtIndex:i]];
    }

    // In Edit mode group shows selected here

    if (obj) {

    NSString *settingStr = [obj valueForKey:@"group_ids"];
    NSArray *array;
    if (![settingStr isKindOfClass:[NSNull class]] && settingStr!=nil && settingStr.length > 0)
    array = [settingStr componentsSeparatedByString:@","];


    for (int i=0;i< array.count;i++){

    //NSLog(@"%@",[array objectAtIndex:i]);

    [selectedGroups setObject:[NSNumber numberWithBool:YES] forKey:[AllGroupData objectForKey:[array objectAtIndex:i] ]];
    }

    if (array.count > 0) {
    [selectGroupBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
    }

    }
    }
    }
    else
    {
    self.navigationItem.rightBarButtonItem.enabled=YES;
    //[SingaltonClass initWithTitle:@"" message:@"No Data Found !" delegate:nil btn1:@"Ok"];
    }
    [pickerView  reloadAllComponents];
    }
    if (tagNumber==102) {
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];


    //NSLog(@"Data Saved Response >>%@",myResults);

    // Result is nill but announcement is adding on web , I don't know why it happen

    if([[myResults objectForKey:@"status"] isEqualToString:@"success"] || ( myResults==nil))
    {

    [SingaltonClass initWithTitle:@"" message:@"Announcement saved successfully" delegate:self btn1:@"Ok"];
    }else{

    self.navigationItem.rightBarButtonItem.enabled=YES;

    [SingaltonClass initWithTitle:@"" message:[myResults valueForKey:@"message"] delegate:nil btn1:@"Ok"];
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
    [self setDatePickerVisibleAt:NO];
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50)];
    [self setPickerVisibleAt:NO];
    }


    if (txtViewCurrent) {
    if (!(txtViewCurrent.text.length > 0)) {
    txtViewCurrent.text=@"Enter Description";

    }
    [txtViewCurrent resignFirstResponder];

    }



    [self showBtnGroupStatus];

    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];

}

// this method used to hide listpicker , Datepicker when click on checkbox

-(void)ClickCheckBoxHideControll
{
    [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50)];
    [[[UIApplication sharedApplication]keyWindow] endEditing:YES];
    [self setPickerVisibleAt:NO];
    [self setDatePickerVisibleAt:NO];
    
}
// this method used to manage toolbar up/down on screen

-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    [self.view viewWithTag:40].center = point;
    
    [UIView commitAnimations];
}

// this method used to Datepicker up/down and initial date on picker also

-(void)setDatePickerVisibleAt :(BOOL)ShowHide
{
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (currentText.text.length > 0 && currentText.tag == 10) {
        
        [df setDateFormat:@"MMM dd,yyyy"];
        NSDate *Date;
        Date= [df dateFromString:currentText.text];
        UIDatePicker *tempdatePicker= (UIDatePicker *)[self.view viewWithTag:70];
        if (Date) {
            
            [tempdatePicker setDate:Date];
        }
        
    }else{
        
        
        [df setTimeStyle:NSDateFormatterShortStyle];
        [df setDateFormat:@"hh:mm a"];
        
        NSDate *Date;
        
        Date= [df dateFromString:currentText.text];
        
        UIDatePicker *tempdatePicker= (UIDatePicker *)[self.view viewWithTag:70];
        if (Date) {
            
            [tempdatePicker setDate:Date];
        }
    }
    
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint Point;
    Point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {
        
        Point.y=self.view.frame.size.height-(datePicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(Point.x,Point.y-(datePicker.frame.size.height/2)-22)];
        
    }else{
        Point.y=self.view.frame.size.height+(datePicker.frame.size.height/2);
    }
    [self.view viewWithTag:70].center = Point;
    [UIView commitAnimations];
}

// this method used to manage listpicker

-(void)setPickerVisibleAt :(BOOL)ShowHide
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {
        
        point.y=self.view.frame.size.height-(pickerView.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(pickerView.frame.size.height/2)-22)];
        
    }else{
        point.y=self.view.frame.size.height+(pickerView.frame.size.height/2);
    }
    
    
    [self.view viewWithTag:60].center = point;
    
    [UIView commitAnimations];
}


-(void)dateChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    if (currentText.tag==10||selectedBtn.tag==501) {

    [df setDateFormat:@"MMM dd,yyyy"];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    }else if (currentText.tag==11||selectedBtn.tag==502)
    {
    [df setDateFormat:@"hh:mm a"];
    }
    currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setcontent offset
- (void)setContentOffset:(id)textField table:(UIScrollView*)m_ScrollView {
    
    UIView* txt = textField;

    // Scroll to cell

    int position=self.view.frame.size.height-(txt.frame.origin.y+txt.frame.size.height);

    NSLog(@"%d",position);

    scrollHeight= scrollHeight ==0 ? [@"216" intValue]:scrollHeight;

    if ((position < scrollHeight )) {

    [m_ScrollView setContentOffset:CGPointMake(0,scrollHeight+2*(txt.frame.size.height)) animated: YES];
    }
}

#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self setContentOffset:textField table:scrollView];
    
    currentText=textField;
    if (textField.tag==10 || textField.tag==11) {
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self setPickerVisibleAt:NO];
        
        if (textField.tag==10)
        {
            datePicker.datePickerMode = UIDatePickerModeDate;
        }else if (textField.tag==11){
            
            datePicker.datePickerMode = UIDatePickerModeTime;
        }
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        if ((currentText.tag==10||selectedBtn.tag==501) && currentText.text.length==0) {
            
            [df setDateFormat:@"MMM dd,yyyy"];
            [df setDateStyle:NSDateFormatterMediumStyle];
            [df setTimeStyle:NSDateFormatterNoStyle];
            currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
        }else if ((currentText.tag==11||selectedBtn.tag==502) && currentText.text.length==0)
        {
            [df setDateFormat:@"hh:mm a"];
            currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
        }
        
        df=nil;
        
        [self setDatePickerVisibleAt:YES];
        
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
    
    if ( txtViewCurrent.text.length == 0 && (obj == nil)) {
        
        textView.text=@"";
    }
    
    txtViewCurrent=textView;
    [self setContentOffset:textView table:scrollView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
     txtViewCurrent=textView;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
    {
    if ([textView.text isEqualToString:@"Enter Description"]) {

    textView.text=@"";
    }

    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
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
    [sender setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    [emailBtn2 setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    emailBtn2.userInteractionEnabled=YES;
    emailNotification=@"1";
    }else if (sender==emailBtn2){
    emailBtn2.userInteractionEnabled=NO;
    [sender setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    [emailBtn1 setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
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

    //NSLog(@"tag %d",button.tag);

    if (!button.selected)
    {
    [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
    //Athlete or All
    if (button.tag == 1002 || button.tag==1000) {

    //btn Group
    CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(1004)];
    // If Group is selected then Athlete will not selected .
    if (btn.selected)
    {
    btn.selected=NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
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
    [btn1 setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    for (int i=0; i<4; i++)
    {
    int a = i;

    CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
    btn.enabled=YES;

    // Athlete button unckeck
    if (btn.tag == 1002)
    [btn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

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
    [btn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

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
    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];



    if (button.tag ==1004) {
    for (id key in [selectedGroups allKeys])
    {
    if ([[selectedGroups objectForKey:key] intValue] == 1) {

    button.selected=YES;
    [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

    break;
    }else
    {
    button.selected=NO;
    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
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
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

    if (a!=0) {
    btn.selected=YES;
    NSString *str =[NSString stringWithFormat:@"%i",a];
    if (![settingArray containsObject:str])
    [settingArray addObject:str];

    //btn.enabled=NO;
    }
    }else{
    [btn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    if (a!=0) {
    btn.selected=NO;
    NSString *str =[NSString stringWithFormat:@"%i",a];
    if ([settingArray containsObject:str])
    [settingArray removeObject:str];

    // btn.enabled=YES;
    }
    }

    }
    }else if(button.tag>1000 && button.tag <1004){

    //NSLog(@"tag %d",button.tag);



    NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
    if (![settingArray containsObject:str1]) {
    [settingArray addObject:str1];
    }
    else
    [settingArray removeObject:str1];

    }
    else{
    // For Group selected
    [self setPickerVisibleAt:YES];
    //}



    }

    button.selected=!button.selected;


    }
}


- (IBAction)selectDate:(id)sender{
    selectedBtn=sender;
//    selectDateBtn.tag=501;
   
   currentText=dateTxt;
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    isKeyBoard=YES;
    [UIView commitAnimations];
    [self setDatePickerVisibleAt:YES];
}
- (IBAction)selectTime:(id)sender{
    selectedBtn=sender;
    currentText=timeTxt;
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    isKeyBoard=YES;
    [UIView commitAnimations];

    datePicker.datePickerMode = UIDatePickerModeTime;
    [self setDatePickerVisibleAt:YES];
}

- (IBAction)saveAnnouncement:(id)sender {
    
    [SingaltonClass ShareInstance].isAnnouncementUpdate=TRUE;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    //Check for empty Text box
    NSString *strError = @"";
    if(nameTxt.text.length < 1 )
    {
    strError = @"Please enter announcement name";
    }
    else if(dateTxt.text.length < 1 )
    {
    strError = @"Please enter announcement date";
    } else if(timeTxt.text.length < 1 )
    {
    strError = @"Please enter announcement time";
    }else if(settingArray.count==0 )
    {
    strError = @"Please select privacy setting item";
    }
    if(strError.length>2)
    {
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [SingaltonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
    return;
    }else{

    if ([SingaltonClass  CheckConnectivity]) {

    UserInformation *userInfo=[UserInformation shareInstance];

    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = 50;
    [self.view addSubview:indicator];

    NSMutableString *groupIdString=[[NSMutableString alloc]init];

    NSArray *arrKeys=[selectedGroups allKeys];
    NSArray *arrValues=[selectedGroups allValues];

    NSMutableArray *temp1=[[NSMutableArray alloc] init];

    for (int i=0; i<arrValues.count; i++) {

    if ([[arrValues objectAtIndex:i] intValue]==1)
    {
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

    NSMutableString *tepmSetting=[[NSMutableString alloc]init];

    // add 4 for group data in setting

    if (temp1.count > 0 && settingArray!=nil) {
    NSString *str1=[NSString stringWithFormat:@"%i",4];
    if (![settingArray containsObject:str1]) {
    [settingArray addObject:str1];
    }
    }
    for (int i=0; i<settingArray.count; i++) {

    if (i < settingArray.count-1 )
    [tepmSetting appendFormat:@"%@,",settingArray[i]];
    else
    [tepmSetting appendFormat:@"%@",settingArray[i]];

    }

    temp1=nil;
    NSString *description=descTxt.text;
    NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
    [dicttemp setObject:[NSString stringWithFormat:@"%@",announcementId] forKey:@"id"];
    [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"user_id"];
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
    // ...//NSLog(@"announcement response:%@",response);
    tagNumber=102;
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
    self.navigationItem.rightBarButtonItem.enabled=YES;

    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

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

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    // Check whether all rows are checked or only one
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
    //[selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:key];
    if ([[selectedGroups objectForKey:key] intValue] == 1) {
    status=TRUE;
    }
    }
    if (status) {
    [selectGroupBtn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
    }else
    {
    [selectGroupBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    }
}


- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    // Check whether all rows are unchecked or only one
    if (row == -1)
    for (id key in [selectedGroups allKeys])
    [selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:key];
    else
    [selectedGroups setObject:[NSNumber numberWithBool:NO] forKey:[groupArray objectAtIndex:row]];
    [self showBtnGroupStatus];
}
- (IBAction)AllButtonEvent:(id)sender {
     [self ClickCheckBoxHideControll];
    if ([sender isKindOfClass:[CheckboxButton class]])
    {
    CheckboxButton *button=(CheckboxButton*)sender;

    // All button Seleted No Or Selected yes
    if (button.tag == 1000 && button.selected==NO) {

    for (int i=0; i<4; i++)
    {
    int a = i;

    CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
    [btn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

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
    CheckboxButton *btnGroup = (CheckboxButton*)[scrollView viewWithTag:(1004)];

    NSString *str=[NSString stringWithFormat:@"%d",(int)(btnGroup.tag-1000)];
    if ([settingArray containsObject:str]) {
    [settingArray removeObject:str];
    }

    if (btnGroup.selected==YES) {
    [btnGroup setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    btnGroup.selected=NO;
    [self ChangeAllGroupStatus : NO];
    }


    }else if (button.tag == 1000 && button.selected==YES){

    for (int i=0; i<4; i++)
    {
    int a = i;

    CheckboxButton *btn = (CheckboxButton*)[scrollView viewWithTag:(a+1000)];
    [btn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

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

    [Allbtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    Allbtn.selected=NO;

    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;

    }else{

    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;

    }

    NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
    if ([settingArray containsObject:str1]) {
    [settingArray removeObject:str1];
    }

    }else if (button.tag == 1001 && button.selected==NO)
    {
    [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

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

    if (count==2) {

    CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
    [Allbtn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

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

    [Allbtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    Allbtn.selected=NO;

    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;

    }else{

    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;

    }

    NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
    if ([settingArray containsObject:str1]) {
    [settingArray removeObject:str1];
    }


    }else if (button.tag == 1002 && button.selected==NO)
    {
    [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

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

    if (count==2) {

    CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
    [Allbtn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

    Allbtn.selected=YES;


    }
    //Add values for use
    NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
    if (![settingArray containsObject:str1]) {
    [settingArray addObject:str1];
    }


    // If group already selected
    CheckboxButton *btnGroup = (CheckboxButton*)[scrollView viewWithTag:(1004)];
    NSString *str=[NSString stringWithFormat:@"%d",(int)(btnGroup.tag-1000)];
    if ([settingArray containsObject:str]) {
    [settingArray removeObject:str];
    }

    if (btnGroup.selected==YES) {
    [btnGroup setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    btnGroup.selected=NO;
    [self ChangeAllGroupStatus : NO];
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

    [Allbtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    Allbtn.selected=NO;

    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;

    }else{

    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;

    }

    NSString *str1=[NSString stringWithFormat:@"%d",(int)(button.tag-1000)];
    if ([settingArray containsObject:str1]) {
    [settingArray removeObject:str1];
    }

    }else if (button.tag == 1003 && button.selected==NO)
    {
    [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

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

    if (count==2) {

    CheckboxButton *Allbtn = (CheckboxButton*)[scrollView viewWithTag:(1000)];
    [Allbtn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

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
    [self setDatePickerVisibleAt:NO];
    
    if (groupArray.count==0) {
        
        [SingaltonClass initWithTitle:@"" message:@"Groups are not exist" delegate:nil btn1:@"Ok"];
        return;

    }

    if ([sender isKindOfClass:[CheckboxButton class]])
    {
    CheckboxButton *button=(CheckboxButton*)sender;

    if (button.tag == 1004 && button.selected==YES)
    {
    [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];

    button.selected=NO;


    }else if (button.tag == 1004 && button.selected==NO)
    {
    [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];

    button.selected=YES;


    CheckboxButton *btnAll = (CheckboxButton*)[scrollView viewWithTag:(1000)];

    if (btnAll.selected==YES) {

    [btnAll setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    btnAll.selected=NO;

    }
    CheckboxButton *btnAthlete = (CheckboxButton*)[scrollView viewWithTag:(1002)];

    if (btnAthlete.selected==YES) {

    [btnAthlete setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    btnAthlete.selected=NO;

    NSString *str1=[NSString stringWithFormat:@"%d",(int)(btnAthlete.tag-1000)];
    if ([settingArray containsObject:str1]) {
    [settingArray removeObject:str1];
    }

    }
    }
    }


    [self setPickerVisibleAt:YES];

}
@end
