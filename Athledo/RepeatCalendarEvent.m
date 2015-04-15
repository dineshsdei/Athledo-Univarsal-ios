//
//  RepeatCalendarEvent.m
//  Athledo
//
//  Created by Dinesh Kumar on 10/20/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "RepeatCalendarEvent.h"
#import "RepeatEventCell.h"
#import "AddCalendarEvent.h"

@interface RepeatCalendarEvent ()

@end
//int toolBarPosition;
NSArray *arrMonths;
NSArray *arrDays;
UITextField *currentText;
BOOL isMonth,isDay;
UIDeviceOrientation CurrentOrientation;
@implementation RepeatCalendarEvent


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardHide];
}
#pragma mark setcontent offset
#pragma mark setcontent offset
- (void)setContentOffsetDown:(id)textField table:(UITableView*)m_TableView {
    
    [m_TableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)setContentOffset:(id)textField table:(UITableView*)m_TableView {
    
    UITableViewCell *theTextFieldCell = (UITableViewCell *)[textField superview];
    NSIndexPath *indexPath = [m_TableView indexPathForCell:theTextFieldCell];
    if (scrollHeight==0) {
        scrollHeight=216;
    }
    CGSize keyboardSize = CGSizeMake(320,scrollHeight+70);
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
// This method used to prepare array or splite sting into array after finaly to create string fron this array from repeat event string
-(void)SpliteEventString:(NSString *)strEventString
{
    NSArray *arrStrTemp=[strEventString componentsSeparatedByString:@"#"];
    //NSString *strBeforeHash=[arrStrTemp objectAtIndex:0];
    NSString *strAfterHash=[arrStrTemp objectAtIndex:1];;
    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"_#"];
    NSArray *components = [strEventString componentsSeparatedByCharactersInSet:delimiters];
    
    if ([[components objectAtIndex:0] isEqualToString:@"day"]) {
        strRepeatEvent=@"Daily";
        
        [arrEventSting insertObject:@"day_" atIndex:0];
    }else if([[components objectAtIndex:0] isEqualToString:@"week"])
    {
        strRepeatEvent=@"Weekly";
        [arrEventSting insertObject:@"week_" atIndex:0];
    }else if([[components objectAtIndex:0] isEqualToString:@"month"])
    {
        strRepeatEvent=@"Monthly";
        [arrEventSting insertObject:@"month_" atIndex:0];
    }else if([[components objectAtIndex:0] isEqualToString:@"year"])
    {
        strRepeatEvent=@"Yearly";
        [arrEventSting insertObject:@"year_" atIndex:0];
    }else{
        
        return;
    }
    
    // occurrences
    if ([[arrEventSting objectAtIndex:0] isEqualToString:@"day_"]) {
        if (components.count > 1) {
            [arrEventSting insertObject:[components objectAtIndex:1] atIndex:1];
        }
        
        [arrEventSting insertObject:@"_" atIndex:2];
        [arrEventSting insertObject:@"_" atIndex:3];
        [arrEventSting insertObject:@"_" atIndex:4];
        [arrEventSting insertObject:@"#" atIndex:5];
        [arrEventSting insertObject:strAfterHash atIndex:6];
        
    }else  if ([[arrEventSting objectAtIndex:0] isEqualToString:@"week_"])
    {
        if (components.count > 1) {
            [arrEventSting insertObject:[components objectAtIndex:1] atIndex:1];
        }
        [arrEventSting insertObject:@"_" atIndex:2];
        [arrEventSting insertObject:@"_" atIndex:3];
        [arrEventSting insertObject:@"_" atIndex:4];
        [arrEventSting insertObject:[components objectAtIndex:components.count-2] atIndex:5];
        [arrEventSting insertObject:@"#" atIndex:6];
        [arrEventSting insertObject:strAfterHash atIndex:7];
    }else  if ([[arrEventSting objectAtIndex:0] isEqualToString:@"month_"])
    {
        if (components.count > 1) {
            [arrEventSting insertObject:[components objectAtIndex:1] atIndex:1];
        }
        if ([[components objectAtIndex:3] isEqualToString:@""]) {
            [arrEventSting insertObject:@"_" atIndex:2];
            [arrEventSting insertObject:@"_" atIndex:3];
            [arrEventSting insertObject:@"_" atIndex:4];
            [arrEventSting insertObject:@"#" atIndex:5];
            [arrEventSting insertObject:strAfterHash atIndex:6];
        }else{
            
            [arrEventSting insertObject:@"_" atIndex:2];
            [arrEventSting insertObject:[components objectAtIndex:2] atIndex:3];
            [arrEventSting insertObject:@"_" atIndex:4];
            [arrEventSting insertObject:[components objectAtIndex:3] atIndex:5];
            [arrEventSting insertObject:@"_" atIndex:6];
            [arrEventSting insertObject:@"#" atIndex:7];
            [arrEventSting insertObject:strAfterHash atIndex:8];
        }
        
    }else  if ([[arrEventSting objectAtIndex:0] isEqualToString:@"year_"])
    {
        // fix 1 value in year case
        [arrEventSting insertObject:@"1" atIndex:1];
        
        if ([[components objectAtIndex:3] isEqualToString:@""]) {
            [arrEventSting insertObject:@"_" atIndex:2];
            [arrEventSting insertObject:@"_" atIndex:3];
            [arrEventSting insertObject:@"_" atIndex:4];
            [arrEventSting insertObject:@"#" atIndex:5];
            [arrEventSting insertObject:strAfterHash atIndex:6];
        }else{
            
            [arrEventSting insertObject:@"_" atIndex:2];
            [arrEventSting insertObject:[components objectAtIndex:2] atIndex:3];
            [arrEventSting insertObject:@"_" atIndex:4];
            [arrEventSting insertObject:[components objectAtIndex:3] atIndex:5];
            [arrEventSting insertObject:@"_" atIndex:6];
            [arrEventSting insertObject:@"#" atIndex:7];
            [arrEventSting insertObject:strAfterHash atIndex:8];
        }
        
    }
    
}

- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+350):toolBar];
        [self.tableview reloadData];
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // message received
        
        NSDictionary* info = [note userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
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
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}
- (void)viewDidLoad
{
    
    self.title=NSLocalizedString(@"Repeat Event", @"");
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    scrollHeight=0;
    segment.selected=NO;
    
    if (_obj) {
        
        // Edit event
        
        // NSString *str=[@"day_1___1,2,3,4,5#no" stringByReplacingOccurrencesOfString:@"1,2,3,4,5" withString:@""];
        NSString *str=@"";
        if ([CalendarEvent ShareInstance].strRepeatSting.length > 0)
        {
            str=[CalendarEvent ShareInstance].strRepeatSting;
            
        }else{
            str =[_obj valueForKey:@"rec_type"];
        }
        
        if (str.length==0) {
            str=@"day_1___#no";
        }
        
        arrEventSting=[[NSMutableArray alloc] init];
        [self SpliteEventString:str];
        const char *c = str.length > 0 ? [str UTF8String] : [@""  UTF8String];
        if (c[0]=='d') {
            strRepeatEvent=@"Daily";
            [CalendarEvent ShareInstance].strDailyEventSubType=@"nonworkingday";
            segment.selectedSegmentIndex=0;
        }else  if (c[0]=='w') {
            strRepeatEvent=@"Weekly";
            segment.selectedSegmentIndex=1;
        }else  if (c[0]=='m') {
            strRepeatEvent=@"Monthly";
            segment.selectedSegmentIndex=2;
        }else  if (c[0]=='y') {
            strRepeatEvent=@"Yearly";
            segment.selectedSegmentIndex=3;
        }
        
        
    }else{
        
        // Default setting for Daily event
        NSString *str=@"day_1___#no";
        [CalendarEvent ShareInstance].strDailyEventSubType=@"nonworkingday";
        
        if ([CalendarEvent ShareInstance].strRepeatSting.length > 0) {
            str=[CalendarEvent ShareInstance].strRepeatSting;
            
            const char *c = str.length > 0 ? [str UTF8String] : [@""  UTF8String];
            if (c[0]=='d') {
                strRepeatEvent=@"Daily";
                segment.selectedSegmentIndex=0;
            }else  if (c[0]=='w') {
                strRepeatEvent=@"Weekly";
                segment.selectedSegmentIndex=1;
            }else  if (c[0]=='m') {
                strRepeatEvent=@"Monthly";
                segment.selectedSegmentIndex=2;
            }else  if (c[0]=='y') {
                strRepeatEvent=@"Yearly";
                segment.selectedSegmentIndex=3;
                
            }
            arrEventSting=[[NSMutableArray alloc] init];
            [self SpliteEventString:str];
            
            [_tableview reloadData];
            
        }
        
        arrEventSting=[[NSMutableArray alloc] init];
        [self SpliteEventString:str];
        
    }
    
    arrDays=[[NSArray alloc] initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    arrMonths=[[NSArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+50, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, PickerHeight);
    listPicker.tag=listPickerTag;
    listPicker.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    //Set the Date picker view
    
    _datePicker=[[UIDatePicker alloc] init];
    _datePicker.frame=CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, PickerHeight);
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    _datePicker.date = [NSDate date];
    _datePicker.tag=70;
    _datePicker.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_datePicker];
    
    [_datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tableview addGestureRecognizer:tap];
    [super viewDidLoad];
    
    UIButton *btnSave = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 50, 30)];
    
    [btnSave addTarget:self action:@selector(SaveEvent) forControlEvents:UIControlEventTouchUpInside];
    // [btnSave setBackgroundImage:imageEdit forState:UIControlStateNormal];
    [btnSave setTitle:@"Done" forState:UIControlStateNormal];
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
}
-(void)dateChange
{
    dformate = [[NSDateFormatter alloc] init];
    dformate.dateFormat =DATE_FORMAT_Y_M_D_H_M_S;
    currentText.text=[NSString stringWithFormat:@"%@", [ dformate stringFromDate:[_datePicker date] ]];
    strSelectedEndDate=currentText.text;
    
    dformate=nil;
    
}
// Create repeat string from array and creat event end date
-(NSString *)PrepareEndDateAndRepeatString
{
    // NO limit case
    // if ([[arrEventSting objectAtIndex:0] isEqualToString:@"day_"]) {
    [CalendarEvent ShareInstance].NoOfDay=0;
    [CalendarEvent ShareInstance].NoOfOccurrence=0;
    
    NSArray *arr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    if ([[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@"no"])
    {
        [CalendarEvent ShareInstance].strEndDate=@"9999-02-01 00:00:00";
        
    }else if ([arr containsObject:[arrEventSting objectAtIndex:arrEventSting.count-1]])
    {
        // if user select no of occurrence
        
        if ([strRepeatEvent isEqualToString:@"Monthly"] || [strRepeatEvent isEqualToString:@"Yearly"])
        {
            // if user select no of occurrence and repeat type monthly
            
            int noOfday=[[arrEventSting objectAtIndex:1] intValue];
            int noOfOccurrence=[[arrEventSting objectAtIndex:arrEventSting.count-1] intValue];
            
            [CalendarEvent ShareInstance].NoOfDay=noOfday;
            [CalendarEvent ShareInstance].NoOfOccurrence=noOfOccurrence;
            
            // end date for case repeat nth day of every nth month
            [self CalculateEndDate];
            
        }else{
            
            // if user select no of occurrence and repeat type Daily and weekly
            int noOfday=[[arrEventSting objectAtIndex:1] intValue];
            int noOfOccurrence=[[arrEventSting objectAtIndex:arrEventSting.count-1] intValue];
            [CalendarEvent ShareInstance].strNoOfDaysWeekCase =[arrEventSting objectAtIndex:5];
            [CalendarEvent ShareInstance].NoOfDay=noOfday;
            [CalendarEvent ShareInstance].NoOfOccurrence=noOfOccurrence;
            
        }
    }else if(strSelectedEndDate.length > 0 && [[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@""])
    {
        // if repeat end on perticular date
        
        [CalendarEvent ShareInstance].strEndDate=strSelectedEndDate ;
    }
    
    NSString *strRepeat=@"";
    
    for (int i=0; i< arrEventSting.count ; i++) {
        
        strRepeat=[strRepeat stringByAppendingString:[arrEventSting objectAtIndex:i]];
    }
    
    return strRepeat;
    
}
-(void)SaveEvent
{
    [CalendarEvent ShareInstance].strEventType=strRepeatEvent;
    [CalendarEvent ShareInstance].CalendarRepeatStatus=TRUE;
    [CalendarEvent ShareInstance].strRepeatSting=[self PrepareEndDateAndRepeatString];
    
    NSArray *arrController=[self.navigationController viewControllers];
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        
        if ([object isKindOfClass:[AddCalendarEvent class]])
        {
            Status=TRUE;
            AddCalendarEvent *temp=(AddCalendarEvent *)object;
            temp.eventDetailsDic=_obj;
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
    if (Status==FALSE)
    {
        AddCalendarEvent *annView=[[AddCalendarEvent alloc] init];
        annView.eventDetailsDic=_obj;
        [self.navigationController pushViewController:annView animated:NO];
        
    }
}

-(void)didTapOnTableView:(UIGestureRecognizer*) recognizer {
    
    // CGPoint tapLocation = [recognizer locationInView:self.tableview];
    // NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:tapLocation];
}
-(void)doneClicked
{
    if ([currentText.placeholder isEqualToString:@"Date"] && currentText.tag==2004) {
        
        [CalendarEvent ShareInstance].strEndDate=currentText.text;
        [self CreateRepeatString:strRepeatEvent :2003 :currentText];
        
    }
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+350):toolBar];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
    [self setContentOffsetDown:currentText table:self.tableview];
}

-(void)ShowPickerSelection : (NSArray *)data
{
    if (currentText.text.length > 0) {
        for (int i=0; i< data.count; i++) {
            
            if ([[data objectAtIndex:i] isEqual:currentText.text]) {
                
                [listPicker selectRow:i inComponent:0 animated:YES];
                
                break;
            }
        }
    }
}
#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isMonth) {
        
        return [arrMonths count];
        
    }else{
        
        return [arrDays count];
    }
    
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    if (isMonth) {
        str = [arrMonths objectAtIndex:row];
    }else
    {
        str = [arrDays objectAtIndex:row];
    }
    
    
    NSArray *arr = [str componentsSeparatedByString:@"****"];
    
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isMonth)
    {
        currentText.text=[arrMonths objectAtIndex:row];
        [self CreateRepeatString:strRepeatEvent :0:currentText];
        
    }else if (isDay)
    { currentText.text=[arrDays objectAtIndex:row];
        [self CreateRepeatString:strRepeatEvent :0:currentText];
    }else
    {
        currentText.text=[arrDays objectAtIndex:row];
    }
}


-(RepeatEventCell *)UpdateCellValues:(RepeatEventCell*)tableCell
{
    // Fill cell text fields  values and checkbox state regarding to repeat string array
    
    if (arrEventSting.count ==0) {
        return tableCell;
    }
    
    NSArray *arrtemp;
    if (iosVersion >= 8) {
        arrtemp=[[[tableCell subviews] objectAtIndex:0] subviews];
    }else{
        arrtemp=[[[[[tableCell subviews] objectAtIndex:0] subviews] objectAtIndex:1] subviews];
    }
    
    NSInteger btnCkeckedIndex=0;
    
    if (tableCell.tag==0 && [strRepeatEvent isEqualToString:@"Daily"]) {
        
        for (id obj in arrtemp) {
            
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btntemp=obj;
                
                if (btntemp.tag==1000 && [[arrEventSting objectAtIndex:0] isEqualToString:@"day_"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==1002 && [[arrEventSting objectAtIndex:0] isEqualToString:@"week_"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else{
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                    btntemp.selected=NO;
                }
            }
            
            if ([obj isKindOfClass:[UITextField class]])
            {
                UITextField *tftemp=obj;
                
                if (![[arrEventSting objectAtIndex:1] isEqualToString:@""])
                {
                    tftemp.text=[arrEventSting objectAtIndex:1];
                }
            }
        }
        
    }else if (tableCell.tag==0 && [strRepeatEvent isEqualToString:@"Weekly"])
    {
        
        for (id obj in arrtemp) {
            
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btntemp=obj;
                
                NSString *strDays= [arrEventSting objectAtIndex:5];
                NSArray *arrdays=[strDays componentsSeparatedByString:@","];
                
                if (btntemp.tag==3001 && [arrdays containsObject:@"1"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==3002 && [arrdays containsObject:@"2"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==3003 && [arrdays containsObject:@"3"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==3004 && [arrdays containsObject:@"4"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==3005 && [arrdays containsObject:@"5"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==3006 && [arrdays containsObject:@"6"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else if (btntemp.tag==3007 && [arrdays containsObject:@"7"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                }else{
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
                    btntemp.selected=NO;
                }
            }
            
            if ([obj isKindOfClass:[UITextField class]])
            {
                UITextField *tftemp=obj;
                
                if (![[arrEventSting objectAtIndex:1] isEqualToString:@""])
                {
                    tftemp.text=[arrEventSting objectAtIndex:1];
                }
            }
        }
        
    }else if(tableCell.tag==2 && [strRepeatEvent isEqualToString:@"Monthly"])
    {
        UIButton *btnCheckBoxOne=(UIButton *)[tableCell viewWithTag:4000];
        UIButton *btnCheckBoxOneTwo=(UIButton *)[tableCell viewWithTag:4003];
        UITextField *textfieldOne=(UITextField *)[tableCell viewWithTag:4001];
        UITextField *textfieldTwo=(UITextField *)[tableCell viewWithTag:4002];
        UITextField *textfieldThree=(UITextField *)[tableCell viewWithTag:4004];
        UITextField *textfieldFour=(UITextField *)[tableCell viewWithTag:4005];
        UITextField *textfieldFive=(UITextField *)[tableCell viewWithTag:4006];
        // Case 1 when repeat on like (repeat 4 day every 1 month)
        
        if([[arrEventSting objectAtIndex:3] isEqualToString:@"_"])
        {
            [btnCheckBoxOne setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
            btnCheckBoxOne.selected=YES;
            if ([[CalendarEvent ShareInstance].strEventAddOrEdit isEqualToString:@"Add"]) {
                
                textfieldOne.text=@"1";
                textfieldTwo.text=@"1";
                
            }else{
                
                textfieldOne.text=[self CalculateRepeatDayValue];
                textfieldTwo.text=[arrEventSting objectAtIndex:1];
            }
            [self CalculateStartDate_On_Given_MonthDay:[textfieldOne.text intValue]];
            // Case 2 when repeat on like (on 1 monday every 1 month)
            
        }else{
            
            [btnCheckBoxOneTwo setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
            btnCheckBoxOneTwo.selected=YES;
            if ([[CalendarEvent ShareInstance].strEventAddOrEdit isEqualToString:@"Add"]) {
                
                textfieldThree.text=@"1";
                textfieldFour.text=@"Monday";
                textfieldFive.text=@"1";
                
            }else{
                
                textfieldThree.text=[arrEventSting objectAtIndex:5];
                textfieldFour.text=[self DayOnIndex:[[arrEventSting objectAtIndex:3] intValue]];
                textfieldFive.text=[arrEventSting objectAtIndex:1];
            }
            [self CalculateStartDate_On_Given_WeekDay:textfieldFour.text :[CalendarEvent ShareInstance].strActualStartDate];
        }
        
        
        
    }else if(tableCell.tag==2 && [strRepeatEvent isEqualToString:@"Yearly"])
    {
        UIButton *btnCheckBoxOne=(UIButton *)[tableCell viewWithTag:5000];
        UIButton *btnCheckBoxOneTwo=(UIButton *)[tableCell viewWithTag:5003];
        UITextField *textfieldOne=(UITextField *)[tableCell viewWithTag:5001];
        UITextField *textfieldTwo=(UITextField *)[tableCell viewWithTag:5002];
        UITextField *textfieldThree=(UITextField *)[tableCell viewWithTag:5004];
        UITextField *textfieldFour=(UITextField *)[tableCell viewWithTag:5005];
        UITextField *textfieldFive=(UITextField *)[tableCell viewWithTag:5006];
        
        
        // Case 1 when repeat on like (repeat 4 day every 1 month)
        
        if([[arrEventSting objectAtIndex:3] isEqualToString:@"_"])
        {
            [btnCheckBoxOne setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
            btnCheckBoxOne.selected=YES;
            if ([[CalendarEvent ShareInstance].strEventAddOrEdit isEqualToString:@"Add"]) {
                
                textfieldOne.text=@"1";
                textfieldTwo.text=@"January";
                
            }else{
                
                textfieldOne.text=[self CalculateRepeatDayValue];
                textfieldTwo.text=[self CalculateRepeatMonthValue_YearCase];;
            }
            [self CalculateStartDate_On_Given_MonthDay_YearlyCase:[textfieldOne.text intValue]:[self IndexOfMonth:textfieldTwo.text]];
            // Case 2 when repeat on like (on 1 monday every 1 month)
            
        }else{
            
            [btnCheckBoxOneTwo setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
            btnCheckBoxOneTwo.selected=YES;
            if ([[CalendarEvent ShareInstance].strEventAddOrEdit isEqualToString:@"Add"]) {
                
                textfieldThree.text=@"1";
                textfieldFour.text=@"Monday";
                textfieldFive.text=@"January";
                
            }else{
                
                textfieldThree.text=[arrEventSting objectAtIndex:5];
                textfieldFour.text=[self DayOnIndex:[[arrEventSting objectAtIndex:3] intValue]];
                textfieldFive.text=[self CalculateMonthFronStartDate_YearlyCase];
            }
            
            [self CalculateStartDate_On_Given_WeekDay_YearlyCase:[self IndexOfMonth:textfieldFive.text] :[CalendarEvent ShareInstance].strActualStartDate];
        }
        
        
    }else  if (tableCell.tag==1 )
    {
        for (id obj in arrtemp) {
            
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btntemp=obj;
                
                if (btntemp.tag==2000 && [[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@"no"]) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                    btnCkeckedIndex=btntemp.tag;
                }else if (btntemp.tag==2001 && (![[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@"no"] && ![[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@""])) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                    btnCkeckedIndex=btntemp.tag;
                }else if (btntemp.tag==2003 && (![[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@"no"] && [[arrEventSting objectAtIndex:arrEventSting.count-1] isEqualToString:@""])) {
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                    btntemp.selected=YES;
                    btnCkeckedIndex=btntemp.tag;
                    
                }else{
                    
                    [btntemp setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                    btntemp.selected=NO;
                    btnCkeckedIndex=0;
                }
            }
            
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField *tftemp=obj;
                
                if ( tftemp.tag==2004) {
                    
                    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
                    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
                    
                    if ([CalendarEvent ShareInstance].strEndDate.length > 0) {
                        
                        NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strEndDate];
                        tftemp.text=[formatter stringFromDate:date];
                        
                    }else{
                        
                        tftemp.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date] ]];
                    }
                    
                }else if ( tftemp.tag==2002){
                    
                    NSArray *arr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
                    
                    if ([arr containsObject:[arrEventSting objectAtIndex:arrEventSting.count-1]]) {
                        tftemp.text=[arrEventSting objectAtIndex:arrEventSting.count-1];
                    }else
                    {
                        tftemp.text=@"4";
                        
                    }
                }
            }
        }
    }
    return tableCell;
}

-(NSString *)DayOnIndex :(int)Index
{
    return [arrDays objectAtIndex:Index];
}

-(NSString *)MonthsOnIndex :(int)Index
{
    return [arrMonths objectAtIndex:Index];
}

-(NSString *)IndexOfDay :(NSString *)day
{
    NSString *strday;
    for (int i=0; i < arrDays.count; i++) {
        
        if ([day isEqualToString:[arrDays objectAtIndex:i]]) {
            strday=[NSString stringWithFormat:@"%d",i];
            break;
        }
    }
    return strday;
}

-(NSString *)IndexOfMonth :(NSString *)month
{
    NSString *strday;
    for (int i=0; i < arrMonths.count; i++) {
        
        if ([month isEqualToString:[arrMonths objectAtIndex:i]]) {
            //int jj=i+1;
            strday=[NSString stringWithFormat:@"%d",i];
            break;
        }
    }
    return strday;
}
//IN case year we will selected
-(NSString *)CalculateRepeatMonthValue_YearCase
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSString *strday=[self MonthsOnIndex:(int)(components.month-1)];
    
    return strday;
}

// when edit event and startdate is given , to show no of day in textfield

-(NSString *)CalculateRepeatDayValue
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    // NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    
    NSString *strday=[NSString stringWithFormat:@"%d",(int)(components.day)];
    
    return strday;
}

// when edit event and startdate is given , to show no of month in textfield

-(NSString *)CalculateRepeatMonthValue
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    // NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    
    NSString *strday=[NSString stringWithFormat:@"%d",(int)(components.month)];
    
    return strday;
}

#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSString *CellIdentifier =[NSString stringWithFormat:@"Cell%i %i",indexPath.section, indexPath.row];
    //AddWorkOutCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    static NSString *CellIdentifier = @"RepeatEventCell";
    static NSString *CellNib = @"RepeatEventCell";
    
    cell = (RepeatEventCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ;
    
    if (nib == nil) {
        
        nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        // [cell.contentView setUserInteractionEnabled:NO];
    }
    
    if (indexPath.section==0) {
        if ([strRepeatEvent isEqualToString:@"Daily"]) {
            
            CellIndex=0;
            
        }else if ([strRepeatEvent isEqualToString:@"Weekly"]) {
            
            CellIndex=2;
            
        }else if ([strRepeatEvent isEqualToString:@"Monthly"]) {
            CellIndex=1;
            
        }else if ([strRepeatEvent isEqualToString:@"Yearly"]) {
            
            CellIndex=3;
        }
        
    }else{
        
        CellIndex=4;
    }
    
    cell=[self UpdateCellValues:(RepeatEventCell *)[nib objectAtIndex:CellIndex]];
    cell.sectionIndex=indexPath.section;
    
    // cell = (RepeatEventCell *)[nib objectAtIndex:CellIndex];
    //strRepeatEvent=@"";
    
    nib=nil;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    
    cell.tag=indexPath.section;
    UIDeviceOrientation orientation=[[SingletonClass ShareInstance] CurrentOrientation:self];
    UIImageView *img1;
    if (isIPAD) {
        
        if ((orientation==UIDeviceOrientationLandscapeLeft) || orientation == UIDeviceOrientationLandscapeRight) {
            
            img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,137, self.view.frame.size.width, 1)];
        }else{
            img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,137, self.view.frame.size.width, 1)];
        }
    }else{
        img1 =[[UIImageView alloc] initWithFrame:CGRectMake(0,137, self.view.frame.size.width, 1)];
    }
    
    img1.image=[UIImage imageNamed:@"menu_sep.png"];
    if(indexPath.section==0)
        [cell addSubview:img1];
    cell.delegate=self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (isIPAD) {
            return 135;
        }else
        {
            return 135;
        }
    }else if (indexPath.section == 1)
    {
        if (isIPAD) {
            return 140;
        }else{
            return 120;
        }
    }
    return 120;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //    NSArray *arrController=[self.navigationController viewControllers];
    //
    //    for (id object in arrController) {
    //        if ([object isKindOfClass:[SWRevealViewController class]])
    //
    //            [self.navigationController popToViewController:object animated:NO];
    //    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ValueChange:(id)sender {
    
    UISegmentedControl *objSegment=(UISegmentedControl *)sender;
    [self doneClicked ];
    
    if (objSegment.selectedSegmentIndex==0) {
        strRepeatEvent=@"Daily";
        NSString *str=@"day_1___#no";
        [CalendarEvent ShareInstance].strDailyEventSubType=@"nonworkingday";
        
        [arrEventSting removeAllObjects];
        [self SpliteEventString:str];
        
    }else if (objSegment.selectedSegmentIndex==1) {
        strRepeatEvent=@"Weekly";
        NSString *str=@"week_1___1,2,3,4,5,#no";
        [arrEventSting removeAllObjects];
        [self SpliteEventString:str];
        [arrEventSting replaceObjectAtIndex:5 withObject:@""];
        
        
    }else if (objSegment.selectedSegmentIndex==2) {
        strRepeatEvent=@"Monthly";
        NSString *str=@"month_1___#no";
        [arrEventSting removeAllObjects];
        [self SpliteEventString:str];
        
    }else if (objSegment.selectedSegmentIndex==3) {
        strRepeatEvent=@"Yearly";
        NSString *str=@"year_1___#no";
        [arrEventSting removeAllObjects];
        [self SpliteEventString:str];
        
    }
    
    [_tableview reloadData];
}

-(void)CreateRepeatString :(NSString *)eventType :(NSInteger)checkBoxIndex :(id)objControl
{
    UITextField *textfield=objControl;
    RepeatEventCell *tempcell;
    
    if(iosVersion < 8)
    {
        // Find cell object , when ios version is less than ios8
        
        UIView* contentView =[textfield superview];
        CGPoint center = [self.tableview convertPoint:textfield.center fromView:contentView];
        NSIndexPath *indexpath =[self.tableview indexPathForRowAtPoint:center];
        tempcell=(RepeatEventCell *)[self.tableview cellForRowAtIndexPath:indexpath];
        
    }else{
        tempcell=(RepeatEventCell *)[[textfield superview] superview]  ;
    }
    
    if (tempcell.tag==0)
    {
        // if cell tag is 0 for cell section 0
        
        if ([eventType isEqualToString:@"Daily"])
        {
            UIButton *btnOne=(UIButton *)[tempcell viewWithTag:1000];
            UITextField *textfield=(UITextField *)[tempcell viewWithTag:1001];
            UIButton *btnTwo=(UIButton *)[tempcell viewWithTag:1002];
            
            if (btnOne.selected==YES && textfield.text.length > 0)
            {
                [arrEventSting replaceObjectAtIndex:0 withObject:@"day_"];
                [CalendarEvent ShareInstance].strDailyEventSubType=@"nonworkingday";
                [arrEventSting replaceObjectAtIndex:1 withObject:textfield.text];
                
                if (arrEventSting.count > 5 && [[arrEventSting objectAtIndex:5] isEqualToString:@"1,2,3,4,5"])
                {
                    
                    [arrEventSting removeObjectAtIndex:5];
                    
                }
                
            }else if( btnTwo.selected==YES)
            {
                [CalendarEvent ShareInstance].strDailyEventSubType=@"workingday";
                [arrEventSting replaceObjectAtIndex:0 withObject:@"week_"];
                [arrEventSting replaceObjectAtIndex:1 withObject:@"1"];
                [arrEventSting insertObject:@"1,2,3,4,5" atIndex:5];
                
            }
        }else if ([eventType isEqualToString:@"Weekly"]) {
            
            UITextField *textfield=(UITextField *)[tempcell viewWithTag:3000];
            UIButton *btnCheckBoxOne=(UIButton *)[tempcell viewWithTag:3001];
            UIButton *btnCheckBoxOneTwo=(UIButton *)[tempcell viewWithTag:3002];
            UIButton *btnCheckBoxThree=(UIButton *)[tempcell viewWithTag:3003];
            UIButton *btnCheckBoxOneFour=(UIButton *)[tempcell viewWithTag:3004];
            UIButton *btnCheckBoxFive=(UIButton *)[tempcell viewWithTag:3005];
            UIButton *btnCheckBoxOneSix=(UIButton *)[tempcell viewWithTag:3006];
            UIButton *btnCheckBoxSeaven=(UIButton *)[tempcell viewWithTag:3007];
            
            [arrEventSting replaceObjectAtIndex:0 withObject:@"week_"];
            [arrEventSting replaceObjectAtIndex:1 withObject:textfield.text];
            
            NSString *strTemp=@"";
            
            if (btnCheckBoxOne.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"1,"];
            }
            if (btnCheckBoxOneTwo.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"2,"];
            }
            if (btnCheckBoxThree.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"3,"];
            }
            if (btnCheckBoxOneFour.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"4,"];
            }
            if (btnCheckBoxFive.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"5,"];
            }
            if (btnCheckBoxOneSix.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"6,"];
            }
            if (btnCheckBoxSeaven.selected==YES) {
                strTemp=[strTemp stringByAppendingString:@"7,"];
            }
            
            if (strTemp.length==0) {
                
            }else
            {
                long location=strTemp.length;
                strTemp=[strTemp substringWithRange: NSMakeRange(0, location-1) ];
                [arrEventSting replaceObjectAtIndex:5 withObject:strTemp];
                
            }
        }else if ([eventType isEqualToString:@"Monthly"]) {
            
            [arrEventSting removeAllObjects];
            UIButton *btnCheckBoxOne=(UIButton *)[tempcell viewWithTag:4000];
            //UIButton *btnCheckBoxOneTwo=(UIButton *)[tempcell viewWithTag:4003];
            UITextField *textfieldOne=(UITextField *)[tempcell viewWithTag:4001];
            UITextField *textfieldTwo=(UITextField *)[tempcell viewWithTag:4002];
            UITextField *textfieldThree=(UITextField *)[tempcell viewWithTag:4004];
            UITextField *textfieldFour=(UITextField *)[tempcell viewWithTag:4005];
            UITextField *textfieldFive=(UITextField *)[tempcell viewWithTag:4006];
            // UITextField *textfieldSix=(UITextField *)[tempcell viewWithTag:4007];
            if (btnCheckBoxOne.selected==YES) {
                NSString *str=@"month_1___#no";
                if ([CalendarEvent ShareInstance].strRepeatSting.length==0) {
                    str=@"month_1_1_1_#no";
                }else{
                    str=[CalendarEvent ShareInstance].strRepeatSting;
                }
                [self SpliteEventString:str];
                [arrEventSting replaceObjectAtIndex:0 withObject:@"month_"];
                [arrEventSting replaceObjectAtIndex:1 withObject:textfieldTwo.text];
                [self CalculateStartDate_On_Given_MonthDay:[textfieldOne.text intValue]];
            }else{
                
                NSString *str=@"month_1_1_1_#no";
                if ([CalendarEvent ShareInstance].strRepeatSting.length==0) {
                    str=@"month_1_1_1_#no";
                }else{
                    str=[CalendarEvent ShareInstance].strRepeatSting;
                }
                [self SpliteEventString:str];
                [arrEventSting replaceObjectAtIndex:0 withObject:@"month_"];
                [arrEventSting replaceObjectAtIndex:1 withObject:textfieldFive.text];
                [arrEventSting replaceObjectAtIndex:3 withObject:[self IndexOfDay:textfieldFour.text]];
                [arrEventSting replaceObjectAtIndex:5 withObject:textfieldThree.text];
                
                [self CalculateStartDate_On_Given_WeekDay:textfieldFour.text :[CalendarEvent ShareInstance].strActualStartDate];
            }
        }else if ([eventType isEqualToString:@"Yearly"])
        {
            [arrEventSting removeAllObjects];
            UIButton *btnCheckBoxOne=(UIButton *)[tempcell viewWithTag:5000];
            //UIButton *btnCheckBoxOneTwo=(UIButton *)[tempcell viewWithTag:4003];
            UITextField *textfieldOne=(UITextField *)[tempcell viewWithTag:5001];
            UITextField *textfieldTwo=(UITextField *)[tempcell viewWithTag:5002];
            UITextField *textfieldThree=(UITextField *)[tempcell viewWithTag:5004];
            UITextField *textfieldFour=(UITextField *)[tempcell viewWithTag:5005];
            UITextField *textfieldFive=(UITextField *)[tempcell viewWithTag:5006];
            // UITextField *textfieldSix=(UITextField *)[tempcell viewWithTag:4007];
            if (btnCheckBoxOne.selected==YES) {
                
                NSString *str=@"";
                if ([CalendarEvent ShareInstance].strRepeatSting.length==0) {
                    str=@"year_1___#no";
                    [self CellUpdate];
                }else{
                    str=[CalendarEvent ShareInstance].strRepeatSting;
                }
                
                [self SpliteEventString:str];
                [arrEventSting replaceObjectAtIndex:0 withObject:@"year_"];
                [self CalculateStartDate_On_Given_MonthDay_YearlyCase:[textfieldOne.text intValue]:[self IndexOfMonth:textfieldTwo.text ]];
                
            }else{
                
                NSString *str=@"year_1_1_1_#no";
                if ([CalendarEvent ShareInstance].strRepeatSting.length==0) {
                    str=@"year_1_1_1_#no";
                    [self CellUpdate];
                }else{
                    str=[CalendarEvent ShareInstance].strRepeatSting;
                }
                [self SpliteEventString:str];
                [arrEventSting replaceObjectAtIndex:0 withObject:@"year_"];
                [arrEventSting replaceObjectAtIndex:3 withObject:[self IndexOfDay:textfieldFour.text]];
                [arrEventSting replaceObjectAtIndex:5 withObject:textfieldThree.text];
                
                [self CalculateStartDate_On_Given_WeekDay_YearlyCase:[self IndexOfMonth:textfieldFive.text] :[CalendarEvent ShareInstance].strActualStartDate];
            }
        }
        
    }else if (tempcell.tag==1)
    {
        // Cell section index 1
        
        UIButton *btnOne=(UIButton *)[tempcell viewWithTag:2000];
        UIButton *btnTwo=(UIButton *)[tempcell viewWithTag:2001];
        UIButton *btnThree=(UIButton *)[tempcell viewWithTag:2003];
        
        UITextField *textfieldOne=(UITextField *)[tempcell viewWithTag:2002];
        UITextField *textfieldTwo=(UITextField *)[tempcell viewWithTag:2004];
        if (btnOne.selected==YES) {
            [arrEventSting replaceObjectAtIndex:arrEventSting.count-1 withObject:@"no"];
        }else if (btnTwo.selected==YES && textfieldOne.text.length > 0)
        {
            [arrEventSting replaceObjectAtIndex:arrEventSting.count-1 withObject:textfieldOne.text];
        }else if (btnThree.selected==YES && textfieldTwo.text.length > 0)
        {
            [arrEventSting replaceObjectAtIndex:arrEventSting.count-1 withObject:@""];
            strSelectedEndDate=textfieldTwo.text;
        }
    }
}

-(NSString *)CalculateDateFronStartDate_YearlyCase :(int)nth_Day
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    components.week=nth_Day;
    
    
    return [self DayOnIndex:(int)components.day];
}


-(NSString *)CalculateMonthFronStartDate_YearlyCase
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    return [self MonthsOnIndex:(int)components.month-1];
}


-(void)CalculateStartDate_On_Given_MonthDay_YearlyCase :(int)monthDay :(NSString *)month
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    [CalendarEvent ShareInstance].strStartDate=[CalendarEvent ShareInstance].strActualStartDate;
    
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    components.day=monthDay;
    components.month=[month intValue]+1;
    
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    
    [CalendarEvent ShareInstance].strStartDate=[formatter stringFromDate:dayOneInCurrentMonth];
}
-(void)CalculateStartDate_On_Given_MonthDay :(int)monthDay
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    [CalendarEvent ShareInstance].strStartDate=[CalendarEvent ShareInstance].strActualStartDate;
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    components.day=monthDay;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    [CalendarEvent ShareInstance].strStartDate=[formatter stringFromDate:dayOneInCurrentMonth];
}

-(void)CalculateStartDate_On_Given_WeekDay_YearlyCase :(NSString *)Month :(NSString*)Startdate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:Startdate];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D];
    NSString *date_Y_M_D=[formatter stringFromDate:date];
    NSArray *dateComponents=[date_Y_M_D componentsSeparatedByString:@"-"];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day=1;
    // on day , set 1 for web required
    //[components setWeekdayOrdinal:[nth_Day intValue]];                  // The nth day in the month
    [components setMonth:[Month intValue]+1];  // Month
    [components setYear:[[dateComponents objectAtIndex:0] intValue]];   // Year
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *EventStartDate = [gregorian dateFromComponents:components];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    [CalendarEvent ShareInstance].strStartDate=[formatter stringFromDate:EventStartDate];
    formatter=nil;
}
-(void)CalculateStartDate_On_Given_WeekDay :(NSString *)DayName :(NSString*)Startdate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    NSDate *date=[formatter dateFromString:Startdate];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D];
    NSString *date_Y_M_D=[formatter stringFromDate:date];
    NSArray *dateComponents=[date_Y_M_D componentsSeparatedByString:@"-"];
    
    //NSString *DayNumber=[self IndexOfDay:DayName];
    // NSString *nth_Day=[arrEventSting objectAtIndex:5];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day=1;
    //[components setWeekday:1];                       // on day
    //[components setWeekdayOrdinal:[nth_Day intValue]];                  // The nth day in the month
    [components setMonth:[[dateComponents objectAtIndex:1] intValue]];  // Month
    [components setYear:[[dateComponents objectAtIndex:0] intValue]];   // Year
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *EventStartDate = [gregorian dateFromComponents:components];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    
    [CalendarEvent ShareInstance].strStartDate=[formatter stringFromDate:EventStartDate];
    
    formatter=nil;
}
-(NSString *)DateAfter_Nth_Year_Interval :(int)Interval
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    components.year=components.year+Interval;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    NSString *strDate=[formatter stringFromDate:dayOneInCurrentMonth];
    return strDate;
}

-(NSString *)DateAfter_Nth_Interval :(int)Interval
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
    NSDate *date=[formatter dateFromString:[CalendarEvent ShareInstance].strStartDate];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSDayCalendarUnit) fromDate:date];
    components.month=components.month+Interval;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    NSString *strDate=[formatter stringFromDate:dayOneInCurrentMonth];
    
    return strDate;
}

// Calculate end date of monthly repeat event

-(void)CalculateEndDate
{
    if ([strRepeatEvent isEqualToString:@"Monthly"])
    {
        // end date for case repeat nth day of every nth month
        if ([[arrEventSting objectAtIndex:3] isEqualToString:@"_"]) {
            
            int NoOfMonth=[[arrEventSting objectAtIndex:1] intValue];
            [CalendarEvent ShareInstance].NoOfOccurrence=[[arrEventSting objectAtIndex:arrEventSting.count-1] intValue];
            int endDateAfter=NoOfMonth*[CalendarEvent ShareInstance].NoOfOccurrence;
            [CalendarEvent ShareInstance].strEndDate=[self DateAfter_Nth_Interval:endDateAfter];
            
            // end date for case repeat nth weekday of every nth month interval
        }
        else
        {
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
            NSString *dayName=[arrEventSting objectAtIndex:3];
            NSString *DayNumber=dayName ;
            NSString *nth_Week=[arrEventSting objectAtIndex:5];
            
            int after_nth_month=([CalendarEvent ShareInstance].NoOfOccurrence * [[arrEventSting objectAtIndex:1] intValue]);
            NSString *dateAfterInterval=[self DateAfter_Nth_Interval:after_nth_month];
            
            NSDate *date=[formatter dateFromString:dateAfterInterval];
            [formatter setDateFormat:DATE_FORMAT_Y_M_D];
            NSArray *dateComponents=[[formatter stringFromDate:date] componentsSeparatedByString:@"-"];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day=[DayNumber intValue];
            //[components setWeekday:[DayNumber intValue]];                       // on day
            [components setWeekdayOrdinal:[nth_Week intValue]];                  // The nth day in the month
            [components setMonth:[[dateComponents objectAtIndex:1] intValue]];  // Month
            [components setYear:[[dateComponents objectAtIndex:0] intValue]];   // Year
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *EventEndDate = [gregorian dateFromComponents:components];
            [CalendarEvent ShareInstance].strEndDate=[formatter stringFromDate:EventEndDate];
            formatter=nil;
        }
        
    }else if ([strRepeatEvent isEqualToString:@"Yearly"])
    {
        // When repeat type yearly
        // end date for case repeat nth day of every nth month
        if ([[arrEventSting objectAtIndex:3] isEqualToString:@"_"]) {
            
            int NoOfMonth=[[arrEventSting objectAtIndex:1] intValue];
            [CalendarEvent ShareInstance].NoOfOccurrence=[[arrEventSting objectAtIndex:arrEventSting.count-1] intValue];
            int endDateAfter=NoOfMonth*[CalendarEvent ShareInstance].NoOfOccurrence;
            [CalendarEvent ShareInstance].strEndDate=[self DateAfter_Nth_Year_Interval:endDateAfter];
            
            // end date for case repeat nth weekday of every nth month interval
        }
        else
        {
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
            
            NSString *dayName=[arrEventSting objectAtIndex:3];
            
            NSString *DayNumber=dayName ;
            NSString *nth_Week=[arrEventSting objectAtIndex:5];
            
            int after_nth_month=([CalendarEvent ShareInstance].NoOfOccurrence * [[arrEventSting objectAtIndex:arrEventSting.count-1] intValue]);
            NSString *dateAfterInterval=[self DateAfter_Nth_Year_Interval:after_nth_month];
            
            NSDate *date=[formatter dateFromString:dateAfterInterval];
            [formatter setDateFormat:DATE_FORMAT_Y_M_D];
            NSArray *dateComponents=[[formatter stringFromDate:date] componentsSeparatedByString:@"-"];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day=[DayNumber intValue];
            //[components setWeekday:[DayNumber intValue]];                       // on day
            [components setWeekdayOrdinal:[nth_Week intValue]];                  // The nth day in the month
            [components setMonth:[[dateComponents objectAtIndex:1] intValue]];  // Month
            [components setYear:[[dateComponents objectAtIndex:0] intValue]];   // Year
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *EventEndDate = [gregorian dateFromComponents:components];
            [CalendarEvent ShareInstance].strEndDate=[formatter stringFromDate:EventEndDate];
            formatter=nil;
        }
    }
}

-(void)CellUpdate
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    RepeatEventCell *tempcell=(RepeatEventCell *)[_tableview cellForRowAtIndexPath:indexPath];
    
    UIButton *btnOne=(UIButton *)[tempcell viewWithTag:2000];
    [btnOne setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    btnOne.selected=YES;
    
    UIButton *btnTwo=(UIButton *)[tempcell viewWithTag:2001];
    UIButton *btnThree=(UIButton *)[tempcell viewWithTag:2003];
    
    [btnTwo setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    btnTwo.selected=NO;
    [btnThree setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
    btnThree.selected=NO;
}

#pragma mark- cell delegate

-(void)comboBoxBoxClick:(id)sender
{
    [CalendarEvent ShareInstance].strRepeatSting=@"";
    UIButton *btn=sender;
    NSArray *arrtemp=[[sender superview] subviews];
    
    for (id obj in arrtemp)
    {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btntemp=obj;
            
            if (btntemp.selected==YES) {
                [btntemp setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                btntemp.selected=NO;
            }
        }
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
    btn.selected=YES;
    [self CreateRepeatString:strRepeatEvent :btn.tag :sender];
}
-(void)checkBoxClick:(id)sender
{
    UIButton *btn=sender;
    if (btn.isSelected)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        btn.selected=NO;
    }else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"selectedCheck.png"] forState:UIControlStateNormal];
        btn.selected=YES;
    }
    [self CreateRepeatString:strRepeatEvent :btn.tag :sender];
}

#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    currentText=textField;
    textField.keyboardType=UIKeyboardTypeNumberPad;
    //[self setToolbarVisibleAt:CGPointMake(160, toolBarPosition-70)];
    [self setContentOffset:textField table:self.tableview];
    isMonth = [textField.placeholder isEqualToString:@"select month"] ? YES : NO;
    isDay = [textField.placeholder isEqualToString:@"select day"] ? YES : NO;
    if (isMonth) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [listPicker reloadComponent:0];
        [self ShowPickerSelection:arrMonths];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        return NO;
    }else  if (isDay)
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [listPicker reloadComponent:0];
        [self ShowPickerSelection:arrDays];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :_datePicker :toolBar];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
        return NO;
    }else if ([textField.placeholder isEqualToString:@"Date"]) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat =DATE_FORMAT_dd_MMM_yyyy;
        currentText.text = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        //[self setDatePickerVisibleAt:YES];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :_datePicker :toolBar];
        
        return NO;
    }else{
        
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length==0) {
        [SingletonClass initWithTitle:@"" message:@"Please enter value" delegate:nil btn1:@"Ok"];
    }else{
        
        [self CreateRepeatString:strRepeatEvent :0:textField];
        // [_tableview reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
