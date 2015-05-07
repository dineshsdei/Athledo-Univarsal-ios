//
//  AddManagerSportInfo.m
//  Athledo
//
//  Created by Dinesh Kumar on 3/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "AddManagerSportInfo.h"

@interface AddManagerSportInfo ()
{
    UITextField *currentText;
    int keyboardHeight;
    BOOL isHeightInFeet;
    BOOL isHeightInInches;
    BOOL isClassYear;
    BOOL isLeagueLable;
    NSArray *arrFeets;
    NSArray *arrInches;
    NSMutableArray *arrYear;
    NSArray *arrLeagues;
    UIPickerView *picker;
    UIToolbar *toolbar;
    NSDictionary *leagueDataDic;
}

@end

@implementation AddManagerSportInfo
#pragma mark UIViewController Method

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        keyboardHeight = kbSize.height;
        if (iosVersion < 8) {
            keyboardHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
        }else{
            keyboardHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
        }
        [UIView animateWithDuration:0.27f
                         animations:^{
                             UIView* txt = currentText;
                             int position=self.view.frame.size.height-(txt.frame.origin.y+txt.frame.size.height);
                             keyboardHeight= keyboardHeight ==0 ? [@"216" intValue]:keyboardHeight;
                             int p = keyboardHeight -(self.view.frame.size.height - (txt.frame.origin.y+txt.frame.size.height));
                             if ((position < keyboardHeight )) {
                                 [_ScrollView setContentOffset:CGPointMake(0,(p)) animated: YES];
                             }
                         }
                         completion:^(BOOL finished){
                         }];
    }];
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [UIView animateWithDuration:0.27f
                         animations:^{
                             [_ScrollView setContentOffset:CGPointMake(0,(0)) animated: YES];
                         }
                         completion:^(BOOL finished){
                         }];
    }];

}
- (void)viewDidLoad {
    
    [self getSeasonData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_ScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
    _ScrollView.scrollEnabled =YES;
    arrFeets = @[@"4",@"5",@"6",@"7",@"8"];
    arrInches = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
    arrYear=[[NSMutableArray alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"YYYY";
    NSString *currentYesr= [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    int currentyear=[currentYesr intValue];
    for (int i=0; i< 150; i++) {
        [arrYear addObject:[NSString stringWithFormat:@"%d",currentyear-i]];
    }
    
    picker = [[SingletonClass ShareInstance] AddPickerView:self.view];
    [self.view addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    
    toolbar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [self.view addSubview:toolbar];
    self.title = NSLocalizedString(@"Add Sport Info", @"Title");
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;

    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(saveSportInfo:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
    [super viewDidLoad];
    [self FieldsSetProperty];
    if (_objData) {
        [self FillDatainFields];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Class Utility Method
-(void)ShowPickerSelection : (NSArray *)data
{
    if (isHeightInFeet) {
        data = arrFeets;
    }else if(isHeightInInches)
    {
        data = arrInches;
    }else if(isClassYear)
    {
        data = arrYear;
    }else if(isLeagueLable)
    {
        data = arrLeagues;
    }
    if (currentText.text.length > 0) {
        for (int i=0; i< data.count; i++) {
            if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                [picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}
-(void)MoveScrollView
{
    [UIView animateWithDuration:0.27f
                     animations:^{
                         UIView* txt = currentText;
                         int position=self.view.frame.size.height-(txt.frame.origin.y+txt.frame.size.height);
                         keyboardHeight= keyboardHeight ==0 ? [@"216" intValue]:keyboardHeight;
                         int p = keyboardHeight -(self.view.frame.size.height - (txt.frame.origin.y+txt.frame.size.height));
                         if ((position < keyboardHeight )) {
                             [_ScrollView setContentOffset:CGPointMake(0,(p)) animated: YES];
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)saveSportInfo:(id)sender
{
    [self AddManagerSport];
}
-(void)FillDatainFields
{
    @try {
        _txtSportName.text = [_objData valueForKey:@"sport_name"];
        _txtHeight.text = [[[_objData valueForKey:@"height"] componentsSeparatedByString:@"'"] objectAtIndex:0];
        _txtHeightInches.text = [[[_objData valueForKey:@"height"] componentsSeparatedByString:@"'"] objectAtIndex:1];
        _txtLeague.text = [_objData valueForKey:@"league_level"];
        _txtClassYear.text = [_objData valueForKey:@"class_year"];
        _txtweight.text = [_objData valueForKey:@"weight"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)FieldsSetProperty
{
    _txtSportName.layer.borderWidth = .5;
    _txtweight.layer.borderWidth = .5;
    _txtLeague.layer.borderWidth = .5;
    _txtClassYear.layer.borderWidth = .5;
    _txtweight.layer.borderWidth = .5;
    _txtHeightInches.layer.borderWidth = .5;
    _txtHeight.layer.borderWidth = .5;
    _txtSportName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtweight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtLeague.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtClassYear.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtweight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtHeightInches.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtHeight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _txtSportName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtSportName.leftViewMode = UITextFieldViewModeAlways;
    _txtweight.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtweight.leftViewMode = UITextFieldViewModeAlways;
    _txtLeague.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtLeague.leftViewMode = UITextFieldViewModeAlways;
    _txtClassYear.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtClassYear.leftViewMode = UITextFieldViewModeAlways;
    _txtHeight.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtHeight.leftViewMode = UITextFieldViewModeAlways;
    _txtHeightInches.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtHeightInches.leftViewMode = UITextFieldViewModeAlways;
    
}
#pragma mark TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    isHeightInFeet = [textField.placeholder isEqualToString:@"Enter height in feets"] ? YES : NO;
    isHeightInInches = [textField.placeholder isEqualToString:@"Enter height in inches"] ? YES : NO;
    isClassYear = [textField.placeholder isEqualToString:@"Enter class year"] ? YES : NO;
    isLeagueLable = [textField.placeholder isEqualToString:@"Enter league level"] ? YES : NO;
    currentText = textField;
    
    [SingletonClass ShareInstance].delegate = self;

    if (isHeightInInches == YES || isHeightInFeet == YES || isClassYear == YES || isLeagueLable == YES) {
        [self.view endEditing:YES];
        if (textField.text.length > 0) {
            [self ShowPickerSelection:arrFeets];
        }
        [self MoveScrollView];
        textField.inputView = picker;
        [picker reloadAllComponents];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :picker :toolbar];
        return NO;
    }else
    {
        if ([textField.placeholder isEqualToString:@"Enter weight in lbs"]) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :picker :toolbar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolbar];
        textField.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.placeholder isEqualToString:@"Enter weight in lbs"]) {
        
        NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:textField.text];
        BOOL stringIsValid = [numbersOnly isSupersetOfSet:characterSetFromTextField];
        return stringIsValid;
    }else
    {
        return YES;
    }
}
#pragma mark singalton class delegate
-(void)Done
{
    [self.view endEditing:YES];
    [_ScrollView setContentOffset:CGPointMake(0,0) animated: YES];
    if (isHeightInInches == YES || isHeightInFeet == YES || isClassYear == YES || isLeagueLable == YES) {
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :picker :toolbar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolbar];
    }
}
#pragma mark- UIPickerView Delegate method
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isHeightInFeet) {
        if (currentText.text.length == 0 && arrFeets.count > 0) {
            currentText.text = [arrFeets objectAtIndex:0];
        }
        return arrFeets.count;
    }else if (isHeightInInches )
    {
        if (currentText.text.length==0 && arrInches.count > 0) {
            currentText.text = [arrInches objectAtIndex:0];
        }
        return arrInches.count;
    }else if (isClassYear)
    {
        if (currentText.text.length==0 && arrYear.count > 0) {
            currentText.text = [arrYear objectAtIndex:0];
        }
        return arrYear.count;
    }else if (isLeagueLable)
    {
        if (currentText.text.length==0 && arrLeagues.count > 0) {
            currentText.text = [arrLeagues objectAtIndex:0];
        }
        return arrLeagues.count;
    }else
    {
        return 0;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //NSString *str;
    if (isHeightInFeet) {
        //str= [arrFeets objectAtIndex:row];
        return [arrFeets objectAtIndex:row];
    }else if (isHeightInInches)
    {
        //str= [arrInches objectAtIndex:row];
        return [arrInches objectAtIndex:row];
    }else if (isClassYear)
    {
        // str= [arrYear objectAtIndex:row];
        return [arrYear objectAtIndex:row];
    }else if (isLeagueLable)
    {
        return [arrLeagues objectAtIndex:row];
    }else
    {
        return EMPTYSTRING;
    }
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isHeightInFeet) {
        currentText.text=arrFeets.count > row ? [arrFeets objectAtIndex:row] : [arrFeets objectAtIndex:row-1] ;
    }else if (isHeightInInches)
    {
        currentText.text=arrInches.count > row ? [arrInches objectAtIndex:row] : [arrInches objectAtIndex:row-1] ;
    }else if (isClassYear)
    {
        currentText.text=arrYear.count > row ? [arrYear objectAtIndex:row] : [arrYear objectAtIndex:row-1] ;
    }else if (isLeagueLable)
    {
        currentText.text=arrLeagues.count > row ? [arrLeagues objectAtIndex:row] : [arrLeagues objectAtIndex:row-1] ;
    }else
    {
        currentText.text=EMPTYSTRING;
    }
}
#pragma mark Webservice call event
-(void)getSeasonData{
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = EMPTYSTRING;
        [webservice WebserviceCall:webServiceGetLeagueLevel :strURL :GetLeaguelavelTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)AddManagerSport{
    
    if ([SingletonClass  CheckConnectivity]) {
        
        NSString *strError = EMPTYSTRING;
        if(_txtSportName.text.length < 1 )
        {
            strError = @"Please enter sport name";
        }
        else if(_txtHeight.text.length < 1 )
        {
            strError = @"Please enter height";
        } else if(_txtweight.text.length < 1 )
        {
            strError = @"Please enter weight";
        } else if(_txtClassYear.text.length < 1 )
        {
            strError = @"Please enter class year";
        } else if(_txtLeague.text.length < 1 )
        {
            strError = @"Please enter league";
        }
        if(strError.length > 1)
        {
            self.navigationItem.rightBarButtonItem.enabled=YES;
            [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            return;
        }
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        [SingletonClass addActivityIndicator:self.view];
        NSString *leagueId = [leagueDataDic valueForKey:_txtLeague.text];
        NSString *strURL;
        
        if (_objData) {
            strURL= [NSString stringWithFormat:@"{\"id\":\"%@\",\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\",\"sport_name\":\"%@\",\"league_level_id\":\"%@\",\"height\":\"%@\",\"weight\":\"%@\",\"class_year\":\"%@\"}",[_objData valueForKey:@"id"],userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid,_txtSportName.text,leagueId,[_txtHeight.text stringByAppendingFormat:@"'%@",_txtHeightInches.text],_txtweight.text,_txtClassYear.text];
        }else
        {
            strURL= [NSString stringWithFormat:@"{\"id\":\"%@\",\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\",\"sport_name\":\"%@\",\"league_level_id\":\"%@\",\"height\":\"%@\",\"weight\":\"%@\",\"class_year\":\"%@\"}",EMPTYSTRING,userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid,_txtSportName.text,leagueId,[_txtHeight.text stringByAppendingFormat:@"'%@",_txtHeightInches.text],_txtweight.text,_txtClassYear.text];
        }
        self.navigationController.navigationItem.rightBarButtonItem.enabled = NO;
        [webservice WebserviceCall:webServiceAddManagerSport :strURL :AddManagerSportTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
    switch (Tag)
    {
        case GetLeaguelavelTag :
        {
            @try {
                leagueDataDic = MyResults ;
                arrLeagues=[MyResults allKeys];
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
            break;
        }
        case AddManagerSportTag :
        {
            [SingletonClass ShareInstance].isProfileSectionUpdate = TRUE;
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Sport Information has been saved successfully" delegate:self btn1:@"Ok"];
            }
            break;
        }
    }
}
#pragma mark UIAlertView Delegate 
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


@end
