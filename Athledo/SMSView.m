//
//  SMSView.m
//  Athledo
//
//  Created by Dinesh Kumar on 3/26/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "SMSView.h"
#import "SWRevealViewController.h"
#import "MessageInboxCell.h"
#import "SMSCustomCell.h"

@interface SMSView ()
{
    NSArray *arrGroupsListData;
    NSArray *arrMemberListData;
    NSArray *arrHistoryListData;
    
    UIToolbar *toolBar;
    NSMutableDictionary *DicCellCheckBoxState;
    int keyboardHeight;
    UIButton *btnAllcheck;
    BOOL ShowOnceSuccessAlert;
    id currentTextview;
    NSInteger PreviousIndex;
}

@end

@implementation SMSView
@synthesize arrFilterdData;
@synthesize arrGroupFilterdData;
#pragma mark UIViewController life cyle
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
    [super viewDidDisappear:animated];
}
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
        if (currentTextview) {
            if (iosVersion < 8) {
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolBar];
            }else{
                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolBar];
            }
        }
    }];
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
    }];
    
    // _ObjSegment.selectedSegmentIndex = PreviousIndex;
    
    //    if (arrFilterdData.count > 0) {
    //        [btnAllcheck setSelected:NO];
    //        [arrFilterdData removeAllObjects];
    //        [self FilterData:arrMemberListData];
    //        [_tableview reloadData];
    //    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSMSListData];
    _ObjSegment.selectedSegmentIndex = 0;
    _textview.font = Textfont;
    DicCellCheckBoxState = [[NSMutableDictionary alloc] init];
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    self.title = @"Send SMS";
    
    arrFilterdData = [[NSMutableArray alloc] init];
    arrGroupFilterdData = [[NSMutableArray alloc] init];
    // [arrFilterdData addObjectsFromArray:arrMemberListData];
    _textview.layer.borderWidth = .5;
    _textview.layer.cornerRadius = 9;
    _textview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textview.textColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SendSMS:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    [SingletonClass ShareInstance].delegate = self;
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [self.view addSubview:toolBar];
    
    btnAllcheck = (UIButton *)[self.view viewWithTag:AllSelectedTag];
    
    [btnAllcheck setImage:UncheckImage forState:UIControlStateNormal];
    [btnAllcheck setImage:CheckImage forState:UIControlStateSelected];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CellDelegate
-(void)CheckBoxEvent:(id)sender
{
    CheckboxButton *button=(CheckboxButton*)sender;
    
    if ([[button imageForState:UIControlStateNormal] isEqual:CheckImage]) {
        [button setImage:UncheckImage forState:UIControlStateNormal];
        if ( _ObjSegment.selectedSegmentIndex ==0) {
            [[arrFilterdData objectAtIndex:button.tag] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }else{
            [[arrGroupFilterdData objectAtIndex:button.tag] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }
    }else
    {
        [button setImage:CheckImage forState:UIControlStateNormal];
        if ( _ObjSegment.selectedSegmentIndex ==0) {
            [[arrFilterdData objectAtIndex:button.tag] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
        }else{
            [[arrGroupFilterdData objectAtIndex:button.tag] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
        }
        
    }
    
    [self AllButtonUpdateStatus];
}

#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( _ObjSegment.selectedSegmentIndex ==0) {
        return arrFilterdData.count;
    }else{
        return arrGroupFilterdData.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SMScustomCell";
    static NSString *CellNib = @"SMSCustomCell";
    SMSCustomCell *cell = (SMSCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (SMSCustomCell *)[nib objectAtIndex:0];
        cell.contentView.userInteractionEnabled = YES;
    }
    @try {
        
        if ( _ObjSegment.selectedSegmentIndex ==0) {
            cell.lblName.hidden = NO;
            cell.lblPhoneNumber.hidden = NO;
            cell.btnSelectContact.hidden = NO;
            btnAllcheck.hidden = NO;
            _lblSelectAll.hidden = NO;
            
            cell.lblName.text=[[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"firstname"] stringByAppendingFormat:@" %@", [[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
            cell.lblName.textColor = [UIColor darkGrayColor];
            cell.lblName.font = Textfont;
            cell.lblPhoneNumber.text = [[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"cellphone"];
            cell.lblPhoneNumber.textColor = [UIColor lightGrayColor];
            cell.lblPhoneNumber.font = Textfont;
            CheckboxButton *cellCheckBox = (CheckboxButton *)cell.btnSelectContact;
            
            BOOL checkBoxState = [[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue];
            if (checkBoxState == YES) {
                [cellCheckBox setImage:CheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = YES;
            }else
            {
                [cellCheckBox setImage:UncheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = NO;
            }
        }else if (_ObjSegment.selectedSegmentIndex ==1)
        {
            cell.lblName.text=[[arrGroupFilterdData objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.lblName.textColor = [UIColor darkGrayColor];
            cell.lblName.font = Textfont;
            cell.lblName.hidden = NO;
            cell.lblPhoneNumber.hidden = YES;
            cell.btnSelectContact.hidden = NO;
            btnAllcheck.hidden = NO;
            _lblSelectAll.hidden = NO;
            CheckboxButton *cellCheckBox = (CheckboxButton *)cell.btnSelectContact;
            BOOL checkBoxState = [[[arrGroupFilterdData objectAtIndex:indexPath.row] valueForKey:@"isCheck"] boolValue];
            if (checkBoxState == YES) {
                [cellCheckBox setImage:CheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = YES;
            }else
            {
                [cellCheckBox setImage:UncheckImage forState:UIControlStateNormal];
                cellCheckBox.selected = NO;
            }
        }else if (_ObjSegment.selectedSegmentIndex ==2)
        {
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    cell.cellDelegate=self;
    cell.btnSelectContact.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isIPAD)
    {
        return 70;
    }else{
        return 60;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ObjSegment.selectedSegmentIndex == 0) {
        
        AthleteDetail *athleteDetails = [[AthleteDetail alloc] initWithNibName:@"AthleteDetail" bundle:nil];
        athleteDetails.objAthleteDetails = [arrFilterdData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:athleteDetails animated:YES];
    }
}

#pragma mark SearchBar Delegate

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    currentTextview = searchBar;
    [btnAllcheck setSelected:NO];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    currentTextview= nil;
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(keyboardHeight+22)) :toolBar];
    searchBar.showsCancelButton=YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [arrGroupFilterdData removeAllObjects];
    [arrFilterdData removeAllObjects];
    _ObjSegment.selectedSegmentIndex == 0 ? [self FilterData:arrMemberListData] : [self FilterData:arrGroupsListData];
    [SingletonClass deleteUnUsedLableFromTable:self.view];
    [_tableview reloadData];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                //Check for empty Text box
                NSString *strError = EMPTYSTRING;
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    [self PrepareSearchPredicate:theSearchBar.text];
                    [_tableview reloadData];
                    [theSearchBar endEditing:YES];
                }
            }else{
                [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
#pragma mark UITextview Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        if (iosVersion < 8) {
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(keyboardHeight+22)):toolBar];
        }else{
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(keyboardHeight+22)):toolBar];
        }
        
    }completion:^(BOOL finished){
        
    }];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    currentTextview = textView;
    if ([_textview.text isEqualToString:@"Compose New Sms"]) {
        _textview.text = EMPTYSTRING;
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textview.text.length == 0) {
        _textview.text = @"Compose New Sms";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 140) {
        [SingletonClass initWithTitle:EMPTYSTRING message:@"The message body exceeds the 160 character limit" delegate:nil btn1:@"Ok"];
        return NO;
    }else{
        return YES;
    }
}
#pragma mark UISegmentControl Delegate
- (IBAction)ValueChange:(id)sender {
    
    UISegmentedControl *objSegment=(UISegmentedControl *)sender;
    if (objSegment.selectedSegmentIndex==0) {
        PreviousIndex = objSegment.selectedSegmentIndex;
        arrFilterdData.count == 0 ? [self FilterData:arrMemberListData] : EMPTYSTRING;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [btnAllcheck setSelected:NO];
        [_tableview reloadData];
    }else if (objSegment.selectedSegmentIndex==1) {
        PreviousIndex = objSegment.selectedSegmentIndex;
        arrGroupFilterdData.count==0 ? [self FilterData:arrGroupsListData] :EMPTYSTRING;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [btnAllcheck setSelected:NO];
        [_tableview reloadData];
    }else if (objSegment.selectedSegmentIndex==2) {
        objSegment.selectedSegmentIndex = PreviousIndex ;
        History *history = [[History alloc] initWithNibName:@"History" bundle:nil];
        [self.navigationController pushViewController:history animated:YES];
    }
    [self AllButtonUpdateStatus];
}
#pragma mark UIToolBar Delegate
-(void)Done
{
    [self.view endEditing:YES];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(keyboardHeight+22)) :toolBar];
}
#pragma mark WebService Comunication Method
-(void)getSaveSMSDataOnWeb{
    
    @try {if ([SingletonClass  CheckConnectivity]) {
        
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedTeamid] forKey:@"team_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userSelectedSportid] forKey:@"sport_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:@"sender_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",_textview.text] forKey:@"message"];
        
        NSMutableArray *arrReceiverData = [[NSMutableArray alloc] init];
        for (int i=0; i<arrFilterdData.count ; i++ ) {
            if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                
                NSDictionary *tosDic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%@",[[arrFilterdData objectAtIndex:i] valueForKey:@"id"]],[NSString stringWithFormat:@"%@",[[arrFilterdData objectAtIndex:i] valueForKey:@"cellphone"]],EMPTYSTRING] forKeys:@[@"user_id",@"phone",@"group_id",]];
                [arrReceiverData addObject:tosDic];
            }
        }
        for (int i=0; i<arrGroupFilterdData.count ; i++ ) {
            
            if ([[[arrGroupFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                
                NSDictionary *phoneDic = [[arrGroupFilterdData objectAtIndex:i]valueForKey:@"memberPhone"];
                if (phoneDic.count > 0) {
                    NSArray *arrKeyTemp = [phoneDic allKeys];
                    NSArray *arrPhoneTemp = [phoneDic allValues];
                    
                    for (int i=0; i < phoneDic.count; i++) {
                        NSDictionary *tosDic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%@",[arrKeyTemp objectAtIndex:i]],[NSString stringWithFormat:@"%@",[arrPhoneTemp objectAtIndex:i]],[NSString stringWithFormat:@"%@",[[arrFilterdData objectAtIndex:i] valueForKey:@"id"]]] forKeys:@[@"user_id",@"phone",@"group_id",]];
                        [arrReceiverData addObject:tosDic];
                    }
                }
            }
        }
        [dicttemp setObject:arrReceiverData forKey:@"Reciever"];
        [webservice WebserviceCallwithDic:dicttemp :webServiceAddSmsOnWeb :GetSaveSmsData];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
-(void)getSMSListData{
    
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceSendSms :strURL :GetSmsData];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
    switch (Tag){
        case GetSmsData :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                arrMemberListData = [MyResults valueForKey:@"userData"];
                arrGroupsListData = [MyResults valueForKey:@"groupData"];
                [self FilterData:arrMemberListData];
                [_tableview reloadData];
            }else{
                [self.view addSubview:[SingletonClass ShowEmptyMessage:@"No records"]] ;
            }
            break;
        }case GetSaveSmsData :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                // Save sms on server reponse, No required to show alert.
            }
            break;
        }
    }
}
#pragma mark Class Utility
-(void)AllButtonUpdateStatus{
    int AllStatusCount = 0;
    if ( _ObjSegment.selectedSegmentIndex ==0) {
        for (int i=0; i<arrFilterdData.count; i++) {
            if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue]) {
                AllStatusCount = AllStatusCount + 1;
            }
        }
        if (AllStatusCount == arrFilterdData.count) {
            [btnAllcheck setSelected:YES];
        }else{
            [btnAllcheck setSelected:NO];
        }
    }else  if (_ObjSegment.selectedSegmentIndex ==1) {
        for (int i=0; i<arrGroupFilterdData.count; i++) {
            if ([[[arrGroupFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue]){
                AllStatusCount = AllStatusCount + 1;
            }
        }
        if (AllStatusCount == arrGroupFilterdData.count) {
            [btnAllcheck setSelected:YES];
        }else{
            [btnAllcheck setSelected:NO];
        }
    }
}
-(void)PrepareSearchPredicate:(NSString *)theSearchBarText{
    if (_ObjSegment.selectedSegmentIndex == 0) {
        [arrFilterdData removeAllObjects];
        NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                 [@"SELF['firstname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                    [@"SELF['firstname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
        NSPredicate *lastNameLowerCase= [NSPredicate predicateWithFormat:
                                         [@"SELF['lastname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        NSPredicate *lastNameOrginaltext = [NSPredicate predicateWithFormat:
                                            [@"SELF['lastname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
        NSPredicate *phone= [NSPredicate predicateWithFormat:
                             [@"SELF['cellphone'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:lowerCase]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:orginaltext]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:lastNameLowerCase]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:lastNameOrginaltext]] ;
        [arrFilterdData addObjectsFromArray:[arrMemberListData filteredArrayUsingPredicate:phone]] ;
        for (int i=0; i< arrFilterdData.count; i++) {
            [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }
        
        arrFilterdData.count == 0 ? [self.view addSubview:[SingletonClass ShowEmptyMessage:@"No records"]] :[SingletonClass deleteUnUsedLableFromTable:self.view];
        
    }else if (_ObjSegment.selectedSegmentIndex == 1) {
        [arrGroupFilterdData removeAllObjects];
        NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                 [@"SELF['name'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBarText lowercaseString]]];
        NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                    [@"SELF['name'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBarText substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBarText substringFromIndex:1] ]]];
        [arrGroupFilterdData addObjectsFromArray:[arrGroupsListData filteredArrayUsingPredicate:lowerCase]] ;
        [arrGroupFilterdData addObjectsFromArray:[arrGroupsListData filteredArrayUsingPredicate:orginaltext]] ;
        for (int i=0; i< arrGroupFilterdData.count; i++) {
            [[arrGroupFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
        }
         arrGroupFilterdData.count == 0 ? [self.view addSubview:[SingletonClass ShowEmptyMessage:@"No records"]] :[SingletonClass deleteUnUsedLableFromTable:self.view];
    }
}
-(void)FilterData:(id)data
{
    @try {
        NSArray *arr = (NSArray *)data;
         arr.count == 0 ? [self.view addSubview:[SingletonClass ShowEmptyMessage:@"No records"]] :[SingletonClass deleteUnUsedLableFromTable:self.view];
        if (_ObjSegment.selectedSegmentIndex == 0) {
            for (int i=0; i< arr.count; i++) {
                NSMutableDictionary *dicTemp = [NSMutableDictionary dictionaryWithObjects:@[[[arr objectAtIndex:i] valueForKey:@"id"],[[arr objectAtIndex:i] valueForKey:@"firstname"],[[arr objectAtIndex:i] valueForKey:@"lastname"],[[arr objectAtIndex:i] valueForKey:@"cellphone"],[[arr objectAtIndex:i] valueForKey:@"age"],[[arr objectAtIndex:i] valueForKey:@"city"],[[arr objectAtIndex:i] valueForKey:@"class_year"],[[arr objectAtIndex:i] valueForKey:@"email"],[[arr objectAtIndex:i] valueForKey:@"school"],[[arr objectAtIndex:i] valueForKey:@"zip"],[[arr objectAtIndex:i] valueForKey:@"country"],[[arr objectAtIndex:i] valueForKey:@"address"],[[arr objectAtIndex:i] valueForKey:@"image"],[[arr objectAtIndex:i] valueForKey:@"class_year"],[[arr objectAtIndex:i] valueForKey:@"state"],[NSNumber numberWithBool:NO]] forKeys:@[@"id",@"firstname",@"lastname",@"cellphone",@"age",@"city",@"class_year",@"email",@"school",@"zip",@"country",@"address",@"image",@"class_year",@"state",@"isCheck"]];
                [arrFilterdData addObject:dicTemp];
                dicTemp = nil;
            }
        }else if (_ObjSegment.selectedSegmentIndex == 1) {
            [arrGroupFilterdData addObjectsFromArray:arr];
            for (int i=0; i< arrGroupFilterdData.count; i++) {
                [[arrGroupFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
- (IBAction)selectAllCheckBox:(id)sender {
    CheckboxButton *button=(CheckboxButton*)sender;
    
    if (button.isSelected) {
        [button setSelected:NO];
        if ( _ObjSegment.selectedSegmentIndex ==0) {
            for (int i=0; i<arrFilterdData.count; i++) {
                [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
            }
        }else
        {
            for (int i=0; i<arrGroupFilterdData.count; i++) {
                [[arrGroupFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
            }
        }
    }else
    {
        [button setSelected:YES];
        if ( _ObjSegment.selectedSegmentIndex ==0) {
            for (int i=0; i<arrFilterdData.count; i++) {
                [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
            }
        }else
        {
            for (int i=0; i<arrGroupFilterdData.count; i++) {
                [[arrGroupFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:YES] forKey:@"isCheck"];
            }
        }
    }
    [_tableview reloadData];
}
-(void)RefreshSMSView
{
    [btnAllcheck setSelected:NO];
    _textview.text = @"Compose New Sms";
    for (int i=0; i<arrFilterdData.count; i++) {
        [[arrFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
    }
    for (int i=0; i<arrGroupFilterdData.count; i++) {
        [[arrGroupFilterdData objectAtIndex:i] setValue:[NSNumber numberWithBool:NO] forKey:@"isCheck"];
    }
    [_tableview reloadData];
}
-(void)SendSMS:(id)sender
{
    @try {
        ShowOnceSuccessAlert = TRUE;
        BOOL selectedNumber = NO;
        NSString *strError = EMPTYSTRING;
        if(_textview.text.length < 1 || [_textview.text isEqualToString:@"Compose New Sms"] )
        {
            strError = @"Please enter sms text";
        }else if(selectedNumber == NO )
        {
            for (int i=0; i<arrFilterdData.count ; i++) {
                if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                    selectedNumber = YES;
                    break;
                }
            }
            for (int i=0; i<arrGroupFilterdData.count ; i++) {
                if ([[[arrGroupFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                    selectedNumber = YES;
                    break;
                }
            }
            if (selectedNumber == NO) {
                strError = @"Please select receiver";
            }
        }
        if(strError.length>2)
        {
            [SingletonClass initWithTitle:EMPTYSTRING message:strError delegate:nil btn1:@"Ok"];
            return;
        }
        NSMutableArray *arrIndividualPhones = [[NSMutableArray alloc] init];
        for (int i=0; i<arrFilterdData.count ; i++ ) {
            if ([[[arrFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                NSString *phoneNumber = [[arrFilterdData objectAtIndex:i]valueForKey:@"cellphone"] ? [[arrFilterdData objectAtIndex:i]valueForKey:@"cellphone"] :EMPTYSTRING ;
                if([phoneNumber isEqualToString:EMPTYSTRING])
                    continue;
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json", accountSID]]];
                [request setUsername:accountSID];
                [request setPassword:authToken];
                [request addPostValue:FromPhoneNumber forKey:@"From"];
                [request addPostValue:phoneNumber forKey:@"To"];
                [arrIndividualPhones addObject:phoneNumber];
                [request addPostValue:_textview.text forKey:@"Body"];
                [request setDelegate:self];
                [request setDidStartSelector:@selector(requestStarted:)];
                [request setDidFinishSelector:@selector(requestFinished:)];
                [request setDidFailSelector:@selector(requestFailed:)];
                [request setUploadProgressDelegate:self];
                [request setTimeOutSeconds:50000];
                [request startAsynchronous];
            }
        }
        
        for (int i=0; i<arrGroupFilterdData.count ; i++ ) {
            
            if ([[[arrGroupFilterdData objectAtIndex:i] valueForKey:@"isCheck"] boolValue] == YES) {
                NSDictionary *phoneDic = [[arrGroupFilterdData objectAtIndex:i]valueForKey:@"memberPhone"];
                if (phoneDic.count > 0) {
                    NSArray *arrTemp = [phoneDic allValues];
                    for (int i=0 ; i < arrTemp.count; i++) {
                        if (![arrIndividualPhones containsObject:[arrTemp objectAtIndex:i]]) {
                            NSString *phoneNumber = [arrTemp objectAtIndex:i] ? [arrTemp objectAtIndex:i] :EMPTYSTRING ;
                            if([phoneNumber isEqualToString:EMPTYSTRING])
                                continue;
                            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json", accountSID]]];
                            [request setUsername:accountSID];
                            [request setPassword:authToken];
                            [request addPostValue:FromPhoneNumber forKey:@"From"];
                            [request addPostValue:phoneNumber forKey:@"To"];
                            [request addPostValue:_textview.text forKey:@"Body"];
                            [request setDelegate:self];
                            [request setDidStartSelector:@selector(requestStarted:)];
                            [request setDidFinishSelector:@selector(requestFinished:)];
                            [request setDidFailSelector:@selector(requestFailed:)];
                            [request setUploadProgressDelegate:self];
                            [request setTimeOutSeconds:50000];
                            [request startAsynchronous];
                        }
                    }
                }
            }
        }
    }@catch (NSException *exception) {
    }
    @finally {
    }
}
#pragma mark- ASIHTTPRequest class delegate
- (void)requestStarted:(ASIHTTPRequest *)theRequest {
}
- (void)requestFinished:(ASIHTTPRequest *)theRequest {
    @try {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *responseDict = [parser objectWithString:[theRequest responseString ]];
        
        if ( ShowOnceSuccessAlert==TRUE ) {
            ShowOnceSuccessAlert=FALSE;
            [responseDict valueForKey:@"message"] ? [SingletonClass initWithTitle:EMPTYSTRING message:[responseDict valueForKey:@"message"]  delegate:nil btn1:@"Ok"] :EMPTYSTRING;
            if([[responseDict valueForKey:STATUS] isEqualToString:@"queued"])
            {
                [[responseDict valueForKey:STATUS] isEqualToString:@"queued"] ? [SingletonClass initWithTitle:EMPTYSTRING message:@"SMS has been send successfully"  delegate:nil btn1:@"Ok"] :EMPTYSTRING;
                [self getSaveSMSDataOnWeb];
                [self RefreshSMSView];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
- (void)requestFailed:(ASIHTTPRequest *)theRequest {
    
}
@end
