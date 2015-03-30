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
    NSArray *arrSmsListData;
    NSArray *arrNUmber;
    NSMutableArray *arrFilterdData;
    UIToolbar *toolBar;
    NSMutableDictionary *DicCellCheckBoxState;
    int keyboardHeight;
  
}

@end

@implementation SMSView

#pragma mark UIViewController life cyle
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        keyboardHeight = kbSize.height;
        if (iosVersion < 8) {
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.width : kbSize.height)+22)):toolBar];
            keyboardHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
        }else{
            
            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-((kbSize.height > 310 ? kbSize.height : kbSize.height)+22)):toolBar];
            keyboardHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
        }
        
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
       
    }];
    _textview.font = Textfont;
    DicCellCheckBoxState = [[NSMutableDictionary alloc] init];
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    self.title = @"Send sms";
    arrSmsListData = [[NSArray alloc] initWithObjects:[NSDictionary dictionaryWithObject:@"Dinesh kumar" forKey:@"name"],[NSDictionary dictionaryWithObject:@"Nishant kumar" forKey:@"name"],[NSDictionary dictionaryWithObject:@"Varsha" forKey:@"name"], nil];
    
    arrFilterdData = [[NSMutableArray alloc] init];
    [arrFilterdData addObjectsFromArray:arrSmsListData];
    _textview.layer.borderWidth = .5;
    _textview.layer.cornerRadius = 9;
    _textview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    [btnSave addTarget:self action:@selector(SendSMS:) forControlEvents:UIControlEventTouchUpInside];
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    [SingletonClass ShareInstance].delegate = self;
    toolBar = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [self.view addSubview:toolBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CellDelegate
-(void)CheckBoxEvent:(id)sender
{
    CheckboxButton *button=(CheckboxButton*)sender;
    NSLog(@"check box index %i",button.tag);
    if (button.selected == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        button.selected = NO;
        [DicCellCheckBoxState setValue:[NSNumber numberWithBool:NO]forKeyPath:[NSString stringWithFormat:@"%i",button.tag]];
    }else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
        button.selected = YES;
        [DicCellCheckBoxState setValue:[NSNumber numberWithBool:YES]forKeyPath:[NSString stringWithFormat:@"%i",button.tag]];
    }
}

#pragma mark- UITableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrFilterdData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SMScustomCell";
    static NSString *CellNib = @"SMSCustomCell";
    SMSCustomCell *cell = (SMSCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (SMSCustomCell *)[nib objectAtIndex:0];
    }
    @try {
        
        cell.lblName.text=[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.lblName.textColor = [UIColor darkGrayColor];
        cell.lblName.font = Textfont;
        cell.lblPhoneNumber.text=@"9718937613";
        cell.lblPhoneNumber.textColor = [UIColor lightGrayColor];
        cell.lblPhoneNumber.font = Textfont;
        cell.btnSelectContact.tag = indexPath.row;
        cell.cellDelegate=self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CheckboxButton *cellCheckBox = (CheckboxButton *)cell.btnSelectContact;
        BOOL checkBoxState = [[DicCellCheckBoxState valueForKey:[NSString stringWithFormat:@"%i",indexPath.row]] boolValue];
        if (checkBoxState == YES) {
             [cellCheckBox setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
            cellCheckBox.selected = YES;
        }else
        {
           [cellCheckBox setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
             cellCheckBox.selected = NO;
        }
        
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD) {
        return 70;
    }else
    {
      return 50;
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        
    }
}
#pragma mark SearchBar Delegate
#pragma SearchBar Delegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [arrFilterdData removeAllObjects];
    [_tableview reloadData];
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        if (arrFilterdData.count == 0) {
            [SingletonClass initWithTitle:@"" message:@"No Notes" delegate:nil btn1:@"Ok"];
        }
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                //Check for empty Text box
                NSString *strError = @"";
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    [arrFilterdData removeAllObjects];
                    NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                             [@"SELF['name'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBar.text lowercaseString]]];
                    NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                                [@"SELF['phone'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBar.text substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBar.text substringFromIndex:1] ]]];
                    NSArray *res = [arrSmsListData  valueForKey:@"UserProfile"];
                    [arrFilterdData addObjectsFromArray:[res filteredArrayUsingPredicate:lowerCase]] ;
                    [arrFilterdData addObjectsFromArray:[res filteredArrayUsingPredicate:orginaltext]] ;
                    [_tableview reloadData];
                    [theSearchBar endEditing:YES];
                }
            }else{
                [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
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
    [UIView animateWithDuration:0.39f
                     animations:^{
                         [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(keyboardHeight+22)) :toolBar];
                     }
                     completion:^(BOOL finished){
                     }];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([_textview.text isEqualToString:@"Compose New Sms"]) {
        _textview.text = @"";
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
       [SingletonClass initWithTitle:@"" message:@"The message body exceeds the 160 character limit" delegate:nil btn1:@"Ok"];
        return NO;
    }else{
        return YES;
    }
    
}
#pragma mark UIToolBar Delegate 
-(void)Done
{
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+(keyboardHeight+22)) :toolBar];
    [self.view endEditing:YES];
}

#pragma mark Class Utility
-(void)SendSMS:(id)sender
{
    NSMutableArray *arrMobileNumbers = [[NSMutableArray alloc] init];
    NSArray *arrNumbersIndex = [DicCellCheckBoxState allKeys];
     NSArray *arrSelectedNumber = [DicCellCheckBoxState allValues];
    
    NSString *strError = @"";
    if(_textview.text.length < 1 || [_textview.text isEqualToString:@"Compose New Sms"] )
    {
        strError = @"Please enter sms text";
    }else if(arrSelectedNumber.count == 0 )
    {
        strError = @"Please select receiver";
    }
    if(strError.length>2)
    {
        [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
        return;
    }
    
    //Uncomment when webservice create
    
//    for (int i=0; i < arrSelectedNumber.count; i++) {
//        
//        if ([[arrSelectedNumber objectAtIndex:i] intValue] == 1) {
//            [arrMobileNumbers addObject:[arrFilterdData objectAtIndex:[[arrSelectedNumber objectAtIndex:i] intValue]]];
//        }
//        
//    }
    
    // From test Account
   
    //Twilinator *twilio = [[Twilinator alloc] initWithSID:@"AC0f6fae9e2a5b0ff47d1b1dcbd20a0e83" authToken:@"dde62baf5beb5775896434797e915c8c" fromNumber:@"+19894744473"];
    
    //From Paid Account
    
    
  //  Twilinator *twilio = [[Twilinator alloc] initWithSID:@"ACdf9e62bbfd4132901754d34b445fb110" authToken:@"e2a6374d96e4df75e245f2854850f3dd" fromNumber:@"+14844364239"];
//

    
   ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages.json", accountSID]]];
    [request setUsername:accountSID];
    [request setPassword:authToken];
    
    [request addPostValue:FromPhoneNumber forKey:@"From"];
    [request addPostValue:@"+918427176032" forKey:@"To"];
    [request addPostValue:_textview.text forKey:@"Body"];
   // [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setUploadProgressDelegate:self];
    [request setTimeOutSeconds:50000];
    [request startAsynchronous];

}
#pragma mark- ASIHTTPRequest class delegate

- (void)requestStarted:(ASIHTTPRequest *)theRequest {
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *responseDict = [parser objectWithString:[theRequest responseString ]];
    
    if ([[responseDict valueForKey:@"status"] isEqualToString:@"queued"]) {
        
        [SingletonClass initWithTitle:@"" message:@"SMS has been send successfully" delegate:nil btn1:@"Ok"];
    }
    
   }
- (void)requestFailed:(ASIHTTPRequest *)theRequest {
    
}


@end
