//
//  EditGenralInfo.m
//  Athledo
//
//  Created by Dinesh Kumar on 9/23/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "EditGenralInfo.h"
#import "AddAthleteHistoryCell.h"
#import "ProfileView.h"

#define CellHeight  isIPAD ? 60 : 60
#define toolBarTag 40
#define EditData 110
#define CONTRYLISTNUMBER 300
#define STATELISTNUMBER 400

@interface EditGenralInfo ()
{
    NSArray *arrPlaceHolder;
    NSMutableArray *arrTextFieldText;
    
    UITextField *currentText;
    
    NSArray *arrStateList;
    NSArray *arrCountryList;
    NSArray *arrCountryCode;
    NSArray *arrStateCode;
    
    BOOL isState;
    BOOL isCountry;
    
    long int stateCodeIndex;
    long int CountryCodeIndex;
    UIDeviceOrientation CurrentOrientation;
}

@end

@implementation EditGenralInfo

#pragma mark UIViewController method
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
    [self getCountryList];
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
    
    scrollHeight=0;
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    arrCountryList=[[NSMutableArray alloc] init];
    arrCountryCode=[[NSMutableArray alloc] init];;
    
    arrStateList=[[NSMutableArray alloc] init];;
    arrStateCode=[[NSMutableArray alloc] init];;
    
    
    self.title=@"Genral Info";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    arrPlaceHolder=[[NSArray alloc] initWithObjects:@"First Name",@"Last Name",@"Address",@"Country ",@"State",@"City",@"Unit No.",@"Zip",@"Phone No", nil];
    
    if (_objData) {
        arrTextFieldText =[[NSMutableArray alloc] initWithObjects:[_objData valueForKey:@"firstname"],[_objData valueForKey:@"lastname"],[_objData valueForKey:@"address"],[_objData valueForKey:@"country_name"],[_objData valueForKey:@"state_name"],[_objData valueForKey:@"city"],[_objData valueForKey:@"apt_no"],[_objData valueForKey:@"zip"],[_objData valueForKey:@"cellphone"], nil];
    }else{
        
        arrTextFieldText =[[NSMutableArray alloc]init];
    }
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 50)];
    // UIImage *imageEdit=[UIImage imageNamed:@"edit.png"];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(SendGenralInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = toolBarTag;
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    listPicker=[[UIPickerView alloc] init];
    listPicker.delegate=self;
    listPicker.dataSource=self;
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216);
    listPicker.tag=60;
    listPicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview: listPicker];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
}
#pragma mark Webservice Delegate method
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
        case EditData:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {// Now we Need to decrypt data
                [SingletonClass ShareInstance].isProfileSectionUpdate=TRUE;
                [SingletonClass initWithTitle:nil message:@"Data saved successfully" delegate:self btn1:@"Ok"];
                
            }else{
                
                [SingletonClass initWithTitle:nil message:@"Invalid Data" delegate:nil btn1:@"Ok"];
            }
            
            break;
            
        } case CONTRYLISTNUMBER:
        {
            arrCountryList=[MyResults allValues];
            arrCountryCode=[MyResults allKeys];
            break;
        }
        case STATELISTNUMBER:
        {
            arrStateList=[MyResults allValues];
            arrStateCode=[MyResults allKeys];
            break;
        }
    }
}
-(void)httpResponseReceived:(NSData *)webResponse :(int)tagNumber
{
    // tagNumber -> 300 country list Profile
    
    NSError *error=nil;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    // Now we Need to decrypt data
    switch (tagNumber) {
            
        case CONTRYLISTNUMBER:
        {
            arrCountryList=[myResults allValues];
            arrCountryCode=[myResults allKeys];
            
            
            
            break;
        }
        case STATELISTNUMBER:
        {
            arrStateList=[myResults allValues];
            arrStateCode=[myResults allKeys];
            break;
        }
        default:
            break;
    }
    
}
#pragma mark EditGenralInfo Utility method
- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+350):toolBar];
        [table reloadData];
    }
}

- (void)getCountryList{
    if ([SingletonClass  CheckConnectivity]) {
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceGetCountryList]];
        [request setHTTPMethod:@"POST"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (data!=nil)
                                   {
                                       [self httpResponseReceived : data : CONTRYLISTNUMBER];
                                   }else{
                                       
                                   }
                               }];
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}

- (void)getStateList : (int )CountryCode{
    
    self.navigationItem.leftBarButtonItem.enabled=NO;
    if ([SingletonClass  CheckConnectivity]) {
        NSString *strURL = [NSString stringWithFormat:@"{\"country_id\":\"%d\"}",CountryCode];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceGetStateList]];
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
                                       [self httpResponseReceived : data : STATELISTNUMBER];
                                   }else{
                                   }
                               }];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}
-(void)SendGenralInfo:(id)sender
{
    if ([SingletonClass  CheckConnectivity]) {
        
        for (int i=0; i < arrTextFieldText.count; i++) {
            
            //Check for empty Text box
            
            int tag=i+1000;
            
            UITextField *textfield=(UITextField *)[table viewWithTag:tag];
            
            NSString *strError = @"";
            if(textfield.text.length < 1 && tag==1000)
            {
                strError = @"Please enter first name";
            }
            else if(textfield.text.length < 1 && tag==1001)
            {
                strError =@"Please enter last name";
                
                
            } else if(textfield.text.length < 1 && tag==1002)
            {
                strError = @"Please enter Address";
                
            }else if(textfield.text.length < 1 && tag==1003)
            {
                strError = @"Please enter Country";
                
            }else if(textfield.text.length < 1 && tag==1004)
            {
                strError = @"Please enter State";
                
            }else if(textfield.text.length < 1 && tag==1005)
            {
                strError = @"Please enter City";
                
            }else if(textfield.text.length < 1 && tag==1003)
            {
                strError = @"Please enter Unit No.";
                
            }else if(textfield.text.length < 1 && tag==1003)
            {
                strError = @"Please enter Zip code";
                
            }else if(textfield.text.length < 1 && tag==1003)
            {
                strError = @"Please enter Phone No";
                
            }
            if(strError.length > 1)
            {
                [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
                return;
            }
        }
        
        UserInformation *userInfo=[UserInformation shareInstance];
        
        // ObjData in case edit
        if (_objData) {
            
            NSMutableDictionary *temp=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[_objData valueForKey:@"id"],@"id",[arrTextFieldText objectAtIndex:0],@"firstname",[arrTextFieldText objectAtIndex:1],@"lastname",[arrTextFieldText objectAtIndex:2],@"address",[arrTextFieldText objectAtIndex:3],@"country_name",[arrTextFieldText objectAtIndex:4],@"state_name",[arrTextFieldText objectAtIndex:5],@"city",[arrTextFieldText objectAtIndex:6],@"apt_no",[arrTextFieldText objectAtIndex:7],@"zip",[arrTextFieldText objectAtIndex:8],@"cellphone", nil];
            
            if (arrStateCode.count > 0) {
                
                [temp setObject:[arrStateCode objectAtIndex:stateCodeIndex] forKey:@"state_id"];
                [temp setObject:[arrCountryCode objectAtIndex:CountryCodeIndex] forKey:@"country_id"];
                
            }else
            {
                [temp setObject: [_objData valueForKey:@"state_id"] forKey:@"state_id"];
                [temp setObject: [_objData valueForKey:@"country_id"] forKey:@"country_id"];
            }
            [temp setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:@"user_id"];
            //Use less but mandatory field on web
            
            [temp setObject: [_objData valueForKey:@"age"] forKey:@"age"];
            [temp setObject: [_objData valueForKey:@"class_year"] forKey:@"class_year"];
            [temp setObject: [_objData valueForKey:@"created"] forKey:@"created"];
            [temp setObject: [_objData valueForKey:@"height"] forKey:@"height"];
            [temp setObject: [_objData valueForKey:@"league_level_id"] forKey:@"league_level_id"];
            [temp setObject: [_objData valueForKey:@"modified"] forKey:@"modified"];
            [temp setObject: [_objData valueForKey:@"profile_img"] forKey:@"profile_img"];
            [temp setObject: [_objData valueForKey:@"profile_pic"] forKey:@"profile_pic"];
            [temp setObject: [_objData valueForKey:@"school_level"] forKey:@"school_level"];
            [temp setObject: [_objData valueForKey:@"weight"] forKey:@"weight"];
            [temp setObject: [_objData valueForKey:@"school_id"] forKey:@"school_id"];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userType] forKey:@"type"];
            [dict setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:@"user_id"];
            
            
            [dict setObject:temp forKey:@"UserProfile"];
            [dict setObject:@"" forKey:@"cochng_hstry"];
            [dict setObject:@"" forKey:@"awards"];
            [SingletonClass addActivityIndicator:self.view];
            
            [webservice WebserviceCallwithDic:dict :webServiceEditProfileInfo :EditData];
            
            
        }else{
            
            
        }
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}

-(void)doneClicked
{
    @try {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height)+350) : toolBar];
            //[SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
            listPicker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height+500);
            
            
        }completion:^(BOOL finished){
            
        }];
        [self setContentOffsetDown:currentText table:table];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

-(void)setToolbarVisibleAt:(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [self.view viewWithTag:toolBarTag].center = point;
    
    [UIView commitAnimations];
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
        
        if (point.y > 250) {
            
            CGSize keyboardSize = CGSizeMake(320,scrollHeight+44);
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
#pragma mark- UITextfield Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentText=textField;
    if (textField.tag > 1005 ) {
        textField.keyboardType=UIKeyboardTypeNumberPad;
        
    }
    if (textField.tag > 1003 && IS_IPHONE_5) {
        
        [self setContentOffset:textField table:table];
    }else if (textField.tag > 1001 )
    {
        [self setContentOffset:textField table:table];
    }
    
    if (textField.tag==1003 || textField.tag==1004) {
        
        if (textField.tag==1003) {
            
            isState=FALSE;
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            [listPicker reloadComponent:0];
            [self ShowPickerValueSelected:arrCountryList];
            arrCountryList.count > 0 ?  [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar] : @"";
            
            return NO;
            
        }else{
            
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            
            if (arrStateList.count == 0) {
                [SingletonClass initWithTitle:@"" message:@"Please select country name" delegate:nil btn1:@"Ok"];
                
                return NO;
            }
            
            isState=TRUE;
            [listPicker reloadComponent:0];
            [self ShowPickerValueSelected:arrStateList];
            arrStateList.count > 0 ?  [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar] : @"";
            return NO;
        }
    }else
    {
        [self setPickerVisibleAt:NO :arrStateList];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [arrTextFieldText replaceObjectAtIndex:(textField.tag-1000) withObject:textField.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneClicked];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"Enter Description"]) {
        
        textView.text=@"";
    }
    
    return YES;
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

#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrPlaceHolder.count;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 15 && textField.tag == 10008) {
        return NO;
    }else{
        
        return YES;
    }
    
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
     
        cell = [[AddAthleteHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strIdentifier" indexPath:indexPath delegate:self textData:arrPlaceHolder:arrTextFieldText.count > 0 ? [arrTextFieldText objectAtIndex:indexPath.section]:@""];
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isState) {
        if (arrStateList.count > 0 && currentText.text.length == 0) {
            //currentText.text=@"";
            currentText.text=[arrStateList objectAtIndex:0];
        }
        
        return [arrStateList count];
    }else
    {
        if (arrCountryList.count > 0 && currentText.text.length == 0) {
            //currentText.text=@"";
            currentText.text=[arrCountryList objectAtIndex:0];
        }
        
        if (arrStateList.count ==0 && arrCountryCode.count > 0 ) {
            [self getStateList :[[arrCountryCode objectAtIndex:CountryCodeIndex] intValue] ];
        }
        
        return [arrCountryList count];
    }
    
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    @try {
        
        NSString *str=@"";
        if (isState) {
            str= row > arrStateList.count ? [arrStateList objectAtIndex:arrStateList.count-1]:  [arrStateList objectAtIndex:row];
        }else
        {
            str= row > arrCountryList.count ? [arrCountryList objectAtIndex:arrCountryList.count-1]:  [arrCountryList objectAtIndex:row];
        }
        
        NSArray *arr =[str componentsSeparatedByString:@"****"]; //For State, But will not effect to other
        
        return [arr objectAtIndex:0];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
- (void)pickerView :(UIPickerView *)pickerView didSelectRow :(NSInteger)row inComponent :(NSInteger)component
{
    
    if (isState) {
        
        currentText.text=row > arrStateList.count ? [arrStateList objectAtIndex:arrStateList.count-1]:  [arrStateList objectAtIndex:row];;
        stateCodeIndex=row > arrStateList.count ? arrStateList.count-1: row;;
    }else
    {
        currentText.text=row > arrCountryList.count ? [arrCountryList objectAtIndex:arrCountryList.count-1]:  [arrCountryList objectAtIndex:row];
        CountryCodeIndex=row > arrCountryList.count ? arrCountryList.count-1: row;;
        [self getStateList :[[arrCountryCode objectAtIndex:CountryCodeIndex] intValue] ];
        
    }
}
-(void)ShowPickerValueSelected : (NSArray *)data
{
    if (data.count > 0) {
        
        if (currentText.text.length > 0) {
            for (int i=0; i< data.count; i++) {
                
                if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                    
                    if (currentText.tag==1003 && arrStateList.count==0) {
                        CountryCodeIndex=i;
                        [self getStateList :[[arrCountryCode objectAtIndex:CountryCodeIndex] intValue] ];
                        [listPicker reloadAllComponents];
                    }
                    
                    [listPicker selectRow:i inComponent:0 animated:YES];
                    
                    break;
                }
            }
        }
    }
    
}
-(void)setPickerVisibleAt :(BOOL)ShowHide :(NSArray*)data
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {
        if (currentText.text.length > 0) {
            for (int i=0; i< data.count; i++) {
                
                if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                    
                    if (currentText.tag==1003 && arrStateList.count==0) {
                        CountryCodeIndex=i;
                        [self getStateList :[[arrCountryCode objectAtIndex:CountryCodeIndex] intValue] ];
                        [listPicker reloadAllComponents];
                    }
                    [listPicker selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }
        point.y=self.view.frame.size.height-(listPicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(listPicker.frame.size.height/2)-22)];
        
    }else{
        point.y=self.view.frame.size.height+(listPicker.frame.size.height/2);
    }
    listPicker.center = point;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
