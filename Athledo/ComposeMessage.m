//
//  ComposeMessage.m
//  Athledo
//
//  Created by Dinesh Kumar on 9/11/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "ComposeMessage.h"
#import "TSActionSheet.h"
#import "MessangerView.h"
#import "SentItemsView.h"
#import "ArichiveView.h"
#define listPickerTag 60
#define toolBarTag 40
#define getUserTypeTag 120
#define MultipleSelectionPickerTag 130
#define sendMessageTag 140

@interface ComposeMessage ()
{
    BOOL isUserType;
    BOOL isTo;
    
    UITextField *currentText;
    UITextField *currentText1;
    NSArray *arrSeasons;
    NSMutableArray *arrAthletes;
    BOOL isKeyBoard;
    
    WebServiceClass *webservice;
    NSArray *arrUserType;
    NSArray *arrUserTypeCode;
    // For Multiple selection
    NSDictionary *userToData;
    NSMutableArray *ToDataArray;
    NSMutableDictionary *ToSelectedData;
    
    int noOfLine;
}

@end

@implementation ComposeMessage

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
    [super viewWillAppear:animated];
    // [self.navigationItem setHidesBackButton:YES animated:NO];
}

#pragma mark Webservice call event
-(NSString *)GetCode :(NSMutableDictionary *)pickerData :(NSString *)Tag
{
    NSArray *arrKeys=[pickerData allKeys];
    NSArray *arrValues=[pickerData allValues];
    
    NSString *values=@"";
    
    for (int i=0; i<arrValues.count; i++) {
        
        if ([[arrValues objectAtIndex:i] intValue]==1)
        {
            if (i < arrValues.count)
            {
                values=[values stringByAppendingString:[self KeyForValue:Tag :[arrKeys objectAtIndex:i]] ];
            }
            values=[values stringByAppendingString:@","];
        }
        
    }
    
    if (values.length > 0) {
        
        values=[values stringByReplacingCharactersInRange:NSMakeRange(values.length-1, 1) withString:@""];
    }
    
    
    return values;
}

-(NSString *)KeyForValue :(NSString *)superKey :(NSString *)SubKey

{
    NSArray *arrValues=[[userToData objectForKey:superKey] allValues];
    
    NSArray *arrkeys=[[userToData objectForKey:superKey] allKeys];
    
    NSString *strValue=@"";
    
    for (int i=0; i<arrValues.count; i++) {
        
        if ([[arrValues objectAtIndex:i] isEqualToString:SubKey])
        {
            strValue=[arrkeys objectAtIndex:i];
            
            break;
            
        }
        
    }
    return strValue;
    
}


-(void)WebServiceComposeMessage
{
    
    if (receiver_ids.length > 0) {
        
        receiver_ids=[receiver_ids stringByReplacingCharactersInRange:NSMakeRange(receiver_ids.length-1, 1) withString:@""];
    }
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        //Check for empty Text box
        NSString *strError = @"";
        if(_txtType.text.length < 1 )
        {
            strError = @"Please select user type";
        }
        else if(_txtTo.text.length < 1 )
        {
            strError = @"Please enter receiver";
        }else if(_textviewDesc.text.length < 1 )
        {
            strError = @"Please enter message text";
        }
        if(strError.length > 2)
        {
            [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
            return;
        }
        
        
        NSString *strURL = [NSString stringWithFormat:@"{\"option_id\":\"%d\",\"user_id\":\"%d\",\"team_id\":\"%d\",\"receiver_id\":\"%@\",\"description\":\"%@\"}",option_id,userInfo.userId,userInfo.userSelectedTeamid,receiver_ids,[self.textviewDesc.text stringByReplacingOccurrencesOfString:@"\n" withString:@"" ]];
        
        [SingletonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceComposeMessage :strURL :sendMessageTag];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}


-(void)getUser:(int)optionId{
    
    if ([SingletonClass  CheckConnectivity])
    {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"option_id\":\"%d\",\"user_id\":\"%d\",\"team_id\":\"%d\"}",optionId,userInfo.userId,userInfo.userSelectedTeamid];
        
        //[SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetUserType :strURL :getUserTypeTag];
        
    }else
    {
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}


-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
        case getUserTypeTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                // Now we Need to decrypt data
                
                userToData=[MyResults objectForKey:@"data"];
                [ToDataArray removeAllObjects];
                [ToSelectedData removeAllObjects];
                
                
                if (userToData.count > 0) {
                    
                    [ToDataArray addObjectsFromArray:[userToData allValues] ];
                    
                    for (int i=0; i< ToDataArray.count; i++) {
                        
                        [ToSelectedData setObject:[NSNumber numberWithBool:NO] forKey:[ToDataArray objectAtIndex:i]];
                    }
                }else{
                    
                    //  [SingaltonClass initWithTitle:@"" message:@"Data Not Found!" delegate:nil btn1:@"Ok"];
                }
            }
            
            break;
            
        } case sendMessageTag:
        {
            
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                _txtType.text=@"";
                _textviewDesc.text=@"";
                _txtTo.text=@"";
                 [m_ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                [SingletonClass initWithTitle:@"" message:@"Message send successfully" delegate:nil btn1:@"Ok"];
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
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
}
-(void)viewWillLayoutSubviews
{
    if (isUserType) {
        
    [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
    }
}
//- (void)orientationChanged :(NSNotification *)notification
//{
//    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
//    
//    NSLog(@"height %f, width%f",self.view.frame.size.width,self.view.frame.size.height);
//   
//    if ((isIPAD) && ((deviceOrientation==UIDeviceOrientationLandscapeLeft) || (deviceOrientation==UIDeviceOrientationLandscapeRight))) {
//        
//         listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, SCREEN_HEIGHT,216);
//         pickerView.frame=CGRectMake(0, self.view.frame.size.height+50, SCREEN_HEIGHT,216);
//          toolBar.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_HEIGHT,44);
//    }else{
//        
//        listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width,216);
//        pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width,216)];
//        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,44)];
//    }
//
//}
// this method call, when user rotate your device
- (void)orientationChanged
{
    NSLog(@"view fram %@",NSStringFromCGRect(self.view.frame));
    if (isIPAD) {
        
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+350):toolBar];
        [pickerView removeFromSuperview];
        pickerView=nil;
        UIDeviceOrientation orientation=[SingletonClass getOrientation];
        if(orientation == UIDeviceOrientationLandscapeRight ||orientation == UIDeviceOrientationLandscapeLeft)
        {
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+350, 1024,216)];
        }else{
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+350, 768,216)];
        }
        
        pickerView.backgroundColor=[UIColor whiteColor];
        pickerView.tag=60;
        pickerView.delegate=self;
        [self.view addSubview:pickerView];
        
    }
}
- (void)viewDidLoad
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
      
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
        
      //  [self setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height+22))];
        
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
           [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(kbSize.height > 310 ? kbSize.width : kbSize.height+22)) :toolBar];
            
        }completion:^(BOOL finished){
            
        }];

        
    }];
    
    
    
    strUser=@"";
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 55)];
    _txtTo.leftView = paddingView;
    _txtTo.leftViewMode = UITextFieldViewModeAlways;
    
    paddingView=nil;
    
    UIView *paddingViewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 55)];
    _txtType.leftView = paddingViewOne;
    _txtType.leftViewMode = UITextFieldViewModeAlways;
    paddingViewOne=nil;
    // To move left decrease y and move up decrease x
    
    //_texviewDescription.textContainerInset = UIEdgeInsetsMake(15, 18, 0, 0);
    
    _textviewDesc.text=@"Enter Text";
    _textviewDesc.textColor=[UIColor lightGrayColor];
    _textviewDesc.layer.cornerRadius = 5;
    _textviewDesc.layer.borderWidth=.50;
    _textviewDesc.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _textviewDesc.clipsToBounds = YES;
    
    _textviewDesc.textContainerInset = UIEdgeInsetsMake(15, 15, 0, 20);
    
    ToSelectedData = [[NSMutableDictionary alloc] init];
    ToDataArray=[[NSMutableArray alloc]init];
    
    arrUserType=[[NSArray alloc] initWithObjects:@"Coach",@"Manager",@"Athlete",@"Alumni",@"Team",@"Groups", nil];
    arrUserTypeCode=[[NSArray alloc] initWithObjects:@"1",@"6",@"2",@"3",@"4",@"5", nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"New Message", @"");
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    // UIImage *imageEdit=[UIImage imageNamed:@"add.png"];

    [btnSave addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchUpInside];
    // [btnSave setBackgroundImage:imageEdit forState:UIControlStateNormal];
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    _textviewDesc.layer.borderColor=(__bridge CGColorRef)([UIColor lightTextColor]);
    _textviewDesc.layer.borderWidth=2;
    
    
    
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+350, self.view.frame.size.width,216);
    listPicker.tag=listPickerTag;
    listPicker.delegate=self;
    listPicker.dataSource=self;
    listPicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UIDeviceOrientation orientation=[SingletonClass getOrientation];
    if (isIPAD) {
        if(orientation == UIDeviceOrientationLandscapeRight ||orientation == UIDeviceOrientationLandscapeLeft)
        {
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+350, 1024,216)];
        }else{
            pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+350, 768,216)];
        }
    }else{
         pickerView=[[ALPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+350, self.view.frame.size.width,216)];
    }
    
    pickerView.backgroundColor=[UIColor whiteColor];
    pickerView.tag=MultipleSelectionPickerTag;
    pickerView.delegate=self;
    //pickerView.dataSource=self;
    [self.view addSubview:pickerView];
    
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,44)];
    toolBar.tag = toolBarTag;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    // Static data 1 passed, because
    [self getUser:[@"1" intValue]];
    
}


#pragma mark setcontent offset
 // Scroll to cell
- (void)setContentOffset:(id)textField :(UIScrollView*)ScrollView {
    
    UIView* txt = textField;
   
    int position=self.view.frame.size.height-(txt.frame.origin.y+txt.frame.size.height);
    scrollHeight= scrollHeight ==0 ? [@"216" intValue]:scrollHeight;
    
    if ((position < scrollHeight )) {
        
        [m_ScrollView setContentOffset:CGPointMake(0,100) animated: YES];
    }
}

-(void)doneClicked
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+350) :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
         [m_ScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }completion:^(BOOL finished){
        
    }];
    currentText=nil;
}

#pragma mark- UITextfield Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    isU_Type=FALSE;
    
    if (currentText) {
        
       // [self doneClicked];
    }
    currentText=textField;
    [self setContentOffset:textField :m_ScrollView];
    
    isUserType=[textField.placeholder isEqualToString:@"Select User Type"] ? YES : NO ;
    isTo=[textField.placeholder isEqualToString:@"To"] ? YES : NO ;
    
    
    
    if ([textField.placeholder isEqualToString:@"To"]) {
         [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        
        if (ToDataArray.count > 0) {
            
            [pickerView reloadAllComponents];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :pickerView :toolBar];
            
        }else{
            
            [SingletonClass initWithTitle:@"" message:@"Selected user type are not available " delegate:nil btn1:@"Ok"];
        }
        return NO;
        
    }else if ([textField.placeholder isEqualToString:@"Select User Type"]) {
        
        isU_Type=TRUE;
        currentText1=textField;
      
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :pickerView :toolBar];
        [listPicker reloadComponent:0];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        return NO;
    }
    
    return YES;
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Enter Text" ]) {
        
        [textView setText:@""];
        textView.textColor=[UIColor blackColor];
    }
    if (isIPAD) {
        
        
    }else
    {
        [self setContentOffset:textView :m_ScrollView];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length ==0) {
        
        textView.text=@"Enter Text";
        textView.textColor=[UIColor lightGrayColor];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        noOfLine++;
    }
    
    if (noOfLine==15) {
        
    }
    return YES;
}

-(void)setMultipleSlectionPicker :(BOOL)ShowHide
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
        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        point.y=self.view.frame.size.height+(pickerView.frame.size.height/2);
    }
    
    [self.view viewWithTag:MultipleSelectionPickerTag].center = point;
    [UIView commitAnimations];
}

-(void)setPickerVisibleAt :(BOOL)ShowHide
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {
        
        point.y=self.view.frame.size.height-(listPicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(listPicker.frame.size.height/2)-22)];
        
    }else{
        // [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        point.y=self.view.frame.size.height+(listPicker.frame.size.height/2);
    }
    
    listPicker.center = point;
    [UIView commitAnimations];
}
-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    [self.view viewWithTag:toolBarTag].center = point;
    
    [UIView commitAnimations];
}

#pragma mark- Picker delegate method

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isUserType) {
        currentText.text.length==0 ?  currentText.text=@"Coach":@"";
        
        return [arrUserType count];
    }else{
        return 0;
    }
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    if (isUserType) {
        
        str= [arrUserType objectAtIndex:row];
        
    }
    
    NSArray *arr = [str componentsSeparatedByString:@"****"]; //For State, But will not effect to other
    
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    isU_Type=TRUE;
    
    if ((isUserType)) {
        
          _txtTo.text=@"";
    }
    
    UITextField *text=(UITextField *)[self.view viewWithTag:11];
    text.text=arrUserType.count > row ? [arrUserType objectAtIndex:row] : [arrUserType objectAtIndex:row-1] ;
    
    option_id=[[arrUserTypeCode objectAtIndex:row < [arrUserTypeCode count] ? row : [[arrUserTypeCode objectAtIndex:[arrUserTypeCode count]-1] intValue]] intValue];
    
    [self getUser:[[arrUserTypeCode objectAtIndex:row < [arrUserTypeCode count] ? row : [[arrUserTypeCode objectAtIndex:[arrUserTypeCode count]-1] intValue]] intValue]]   ;
}
#pragma mark -
#pragma mark ALPickerView delegate methods

- (NSInteger)numberOfRowsForPickerView:(ALPickerView *)pickerView {
    return [ToDataArray count];
}

- (NSString *)pickerView:(ALPickerView *)pickerView textForRow:(NSInteger)row {
    return [ToDataArray objectAtIndex:row];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionGroupForRow:(NSInteger)row {
    return [[ToSelectedData objectForKey:[ToDataArray objectAtIndex:row]] boolValue];
}

- (BOOL)pickerView:(ALPickerView *)pickerView selectionStateForRow:(NSInteger)row {
    
    return [[ToSelectedData objectForKey:[ToDataArray objectAtIndex:row]] boolValue];
}

- (void)pickerView:(ALPickerView *)pickerView didCheckRow:(NSInteger)row {
    // Check whether all rows are checked or only one
    if (row == -1)
        for (id key in [ToSelectedData allKeys])
            [ToSelectedData setObject:[NSNumber numberWithBool:YES] forKey:key];
    else
        [ToSelectedData setObject:[NSNumber numberWithBool:YES] forKey:[ToDataArray objectAtIndex:row]];
    
    [self saveMultiPickerValues];
}

- (void)viewDidLayoutSubviews {
    
    if ( isU_Type==TRUE) {
        // [self.view viewWithTag:listPickerTag].center = CGPointMake(160, toolBarPosition+100);;
        // isU_Type=FALSE;
    }
}

- (void)pickerView:(ALPickerView *)pickerView didUncheckRow:(NSInteger)row {
    // Check whether all rows are unchecked or only one
    if (row == -1)
        for (id key in [ToSelectedData allKeys])
            [ToSelectedData setObject:[NSNumber numberWithBool:NO] forKey:key];
    else
        [ToSelectedData setObject:[NSNumber numberWithBool:NO] forKey:[ToDataArray objectAtIndex:row]];
    
    [self saveMultiPickerValues];
}

-(void)saveMultiPickerValues
{
    if ([currentText.placeholder isEqualToString:@"To"] && isTo==YES)
    {
        currentText.text = [self PickerSlectedValues:ToSelectedData];
        //NSLog(@"text %@",currentText.text);
        receiver_ids=[self PickerSlectedIds :ToSelectedData:userToData];
    }
}

-(NSString *)PickerSlectedIds:(NSDictionary *)pickerData :(NSDictionary *)userData
{
    NSArray *arrKeys=[userData allKeys];
    NSArray *arrValues=[pickerData allValues];
    
    NSString *values=@"";
    
    for (int i=0; i<arrKeys.count; i++)
    {
        
        if ([[arrValues objectAtIndex:i] intValue]==1)
        {
            if (i < arrValues.count )
                values =[values stringByAppendingString:[NSString stringWithFormat:@"%@,", arrKeys[i] ] ];
            else
                values =[values stringByAppendingString:[NSString stringWithFormat:@"%@", arrKeys[i] ] ];
            
        }
        
    }
    return values;
}

-(NSString *)PickerSlectedValues:(NSMutableDictionary *)pickerData
{
    NSArray *arrKeys=[pickerData allKeys];
    NSArray *arrValues=[pickerData allValues];
    NSString *values=@"";
    
    for (int i=0; i<arrValues.count; i++) {
        
        if ([[arrValues objectAtIndex:i] intValue]==1)
        {
            if (i < arrValues.count-1 )
                values =[values stringByAppendingString:[NSString stringWithFormat:@"%@,", arrKeys[i] ] ];
            else
                values =[values stringByAppendingString:[NSString stringWithFormat:@"%@", arrKeys[i] ] ];
        }
    }
    return values;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SendMessage:(id)sender {
    
    [SingletonClass ShareInstance].isMessangerSent =TRUE;
    
    [self WebServiceComposeMessage];
    
}
@end
