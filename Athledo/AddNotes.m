//
//  AddNotes.m
//  Athledo
//
//  Created by Smartdata on 2/23/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import "AddNotes.h"
@interface AddNotes ()
{
    UITextView *txtViewCurrent;
    NSMutableArray *arrNotesData;
    NSInteger EditIndex;
    BOOL isEdit;
    int KeyboardHeight;
    NSDateFormatter *formatter;
}
@end
@implementation AddNotes

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [UIView animateKeyframesWithDuration:.27f delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            if (iosVersion < 8) {
                KeyboardHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
            }else{
                KeyboardHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
            }
        }completion:^(BOOL finished){
            
        }];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_TIME_FORMAT_MESSAGE];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add Notes";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(150, 5, 44, 44)];
    UIImage *imageHistory=[UIImage imageNamed:@"add.png"];
    [btnShare addTarget:self action:@selector(AddNote) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setImage:imageHistory forState:UIControlStateNormal];
    UIBarButtonItem *BarItemHistory = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemHistory, nil];
    self.navigationItem.rightBarButtonItem.tintColor=NAVIGATION_COMPONENT_COLOR;
    
   
    [self RefreshNotes];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    
}
-(void)EditNote:(NSInteger)index
{
    if(txtViewCurrent)
    {
        [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            txtViewCurrent.frame = CGRectMake(150, 100, 0, 0);
            [txtViewCurrent resignFirstResponder];
        } completion:^(BOOL finished){
            if(txtViewCurrent)
            {
                [txtViewCurrent removeFromSuperview];
                txtViewCurrent=nil;
            }
        } ];
    }
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(150, 100, 0, 0)];
    txtView.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [SingletonClass ShareInstance].delegate = self;
    txtView.delegate = self;
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.cornerRadius = 4.0f;
    txtView.font = Textfont;
    txtView.textColor=[UIColor lightGrayColor];
    [txtView becomeFirstResponder];
    [self.view addSubview:txtView];
    if (index < arrNotesData.count) {
        txtView.text = [[arrNotesData objectAtIndex:index] valueForKey:@"notes"];
        txtViewCurrent = txtView;
    }
    txtViewCurrent = txtView;
    isEdit = TRUE;
    EditIndex = index;
    [UIView animateWithDuration:0.48f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{txtView.frame = CGRectMake(5, 3, self.view.frame.size.width-10 ,self.view.frame.size.height - (KeyboardHeight+10));} completion:^(BOOL finished){}];
}
//show Animated textview
-(void)AddNote
{
    if(txtViewCurrent)
    {
        [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            txtViewCurrent.frame = CGRectMake(150, 100, 0, 0);
            [txtViewCurrent resignFirstResponder];
        } completion:^(BOOL finished){
            
            if(txtViewCurrent)
            {
                [txtViewCurrent removeFromSuperview];
                txtViewCurrent=nil;
            }
        } ];
    }
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(150, 100, 0, 0)];
    txtView.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [SingletonClass ShareInstance].delegate = self;
    txtView.delegate =self;
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.cornerRadius = 4.0f;
    txtView.font = Textfont;
    txtView.textColor=[UIColor lightGrayColor];
    [txtView becomeFirstResponder];
    [self.view addSubview:txtView];
    txtViewCurrent = txtView;
    isEdit = FALSE;
    EditIndex = -1;
    [UIView animateWithDuration:0.48f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{txtView.frame = CGRectMake(5, 3, self.view.frame.size.width-10 ,self.view.frame.size.height - (KeyboardHeight+10));} completion:^(BOOL finished){}];
}
// edit / Add text in arry and remove textview
-(void)Done
{
    if (( isEdit == TRUE && EditIndex != -1 ) && txtViewCurrent.text.length > 0) {
        [self EditNotesWebservice:EditIndex];
    }else  if (txtViewCurrent.text.length > 0)
    {
        [self AddNotesWebservice];
    }else{
        EditIndex = -1;
        isEdit = FALSE;
    }
    [txtViewCurrent endEditing:YES];
    [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        txtViewCurrent.frame = CGRectMake(150, 100, 0, 0);
        [txtViewCurrent resignFirstResponder];
    } completion:^(BOOL finished){
        
        if(txtViewCurrent)
        {
            [txtViewCurrent removeFromSuperview];
            txtViewCurrent=nil;
        }
    } ];
}
#pragma Textview delegate
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

#pragma mark- TableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNotesData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddNoteCell";
    static NSString *CellNib = @"AddNoteCell";
    AddNoteCell *cell = (AddNoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (AddNoteCell *)[nib objectAtIndex:0];
    }
    @try {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellTextView.text = [[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"notes"];
        cell.cellTextView.font = Textfont;
        cell.cellTextView.textColor=[UIColor lightGrayColor];
        [formatter setDateFormat:DATE_TIME_FORMAT_MESSAGE];
        NSDate *date = [formatter dateFromString:[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"date"]];
        [formatter setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
        cell.lblDate.text = [formatter stringFromDate:date];
        cell.lblDate.font = Textfont;
        cell.rightUtilityButtons = [self rightButtons : indexPath.row];
        cell.delegate=self;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self EditNote:indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

#pragma SWTableviewCell delegate

- (NSArray *)rightButtons :(NSInteger)btnTag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"edit.png"] :(int)btnTag];
    return rightUtilityButtons;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:0];
    [self EditNote:btn.tag];
}
#pragma webservice calling/Response
-(void)AddNotesWebservice
{
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",EMPTYSTRING] forKey:@"id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",userInfo.userId] forKey:@"user_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%d",[[_objNotes valueForKey:@"user_id"] intValue]] forKey:@"athlete_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",txtViewCurrent.text] forKey:@"notes"];
        [SingletonClass addActivityIndicator:self.view];
        [webservice  WebserviceCallwithDic:dicttemp :webserviceAddNotes :AddNotesTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)EditNotesWebservice:(NSInteger)index
{
    if ([SingletonClass  CheckConnectivity]) {
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSMutableDictionary* dicttemp = [[NSMutableDictionary alloc] init];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",[[arrNotesData objectAtIndex:index] valueForKey:@"id"]] forKey:@"id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",[[arrNotesData objectAtIndex:index] valueForKey:@"user_id"]] forKey:@"user_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",[[arrNotesData objectAtIndex:index] valueForKey:@"athlete_id"]] forKey:@"athlete_id"];
        [dicttemp setObject:[NSString stringWithFormat:@"%@",txtViewCurrent.text] forKey:@"notes"];
        [SingletonClass addActivityIndicator:self.view];
        [webservice  WebserviceCallwithDic:dicttemp :webserviceAddNotes :EditNotesTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)RefreshNotes
{
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"athlete_id\":\"%@\",\"searchType\":\"%@\",\"keyword\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,[_objNotes valueForKey:@"user_id"],EMPTYSTRING,EMPTYSTRING];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webserviceNotesList :strURL :RefreshNotesTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case AddNotesTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                [self RefreshNotes];
            }
            break;
        }
        case EditNotesTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                 [self RefreshNotes];
            }
            break;
        }case RefreshNotesTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {   arrNotesData =[[MyResults objectForKey:DATA] valueForKey:@"AthleteNote"];
                arrNotesData.count == 0 ? [objTableView addSubview:[SingletonClass ShowEmptyMessage:@"No Notes"]] :[SingletonClass deleteUnUsedLableFromTable:objTableView];
                 [objTableView reloadData];
            }
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
