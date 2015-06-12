//
//  PracticeLogDetail.m
//  Athledo
//
//  Created by Dinesh Kumar on 5/15/15.
//  Copyright (c) 2015 Smartdata. All rights reserved.
//

#import "PracticeLogDetail.h"
#import "PracticeCell.h"
#import "AthletePracticeNotesCell.h"
#define BORDERWEIGHT 2
#define ICON_HEIGHT_WEIGHT 30
#define PRACTICENOTE_CELL_HEIGHT isIPAD ? 70 : 60
#define VIEW_ATHLETE_NOTE_BG [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]

@interface PracticeLogDetail ()
{
    UIView *athleteNotesView;
    NSArray *arrAthletesNotes;
    UITableView *tblAthleteNotes;
    BOOL isOpenNoteView;
    UITextView *txtViewCurrent;
    int KeyboardHeight;
    NSInteger EditIndex;
    BOOL isEdit;
}
@end
@implementation PracticeLogDetail

#pragma mark UIViewController Life cycle method

- (void)viewDidLayoutSubviews {
    [_PracticeDetailScrollView setContentSize:CGSizeMake(_PracticeDetailScrollView.frame.size.width, _PracticeDetailScrollView.frame.size.height+(isIPAD ? 300 :100))];
    _PracticeDetailScrollView.scrollEnabled = YES;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.keyboardAppear];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isIPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
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
    _btnViewNotes.hidden=YES;
    _btnViewNotes.backgroundColor = VIEW_ATHLETE_NOTE_BG;
    self.title = @"Practice Log Detail";
    [super viewDidLoad];
    [_PracticeDetailScrollView setContentSize:CGSizeMake(_PracticeDetailScrollView.frame.size.width, _PracticeDetailScrollView.frame.size.height+(isIPAD ? 300 :100))];
    _PracticeDetailScrollView.scrollEnabled = YES;
    if (_objEditPracticeData) {
        if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
            if([[_objEditPracticeData valueForKey:@"athleteNotes"] isKindOfClass:[NSArray class]])
            {
                 arrAthletesNotes =  [_objEditPracticeData valueForKey:@"athleteNotes"] ;
            }
            if (arrAthletesNotes.count == 0) {
                _btnViewNotes.hidden = YES;
                [_btnViewNotes removeFromSuperview];
            }
        }else{
            _btnViewNotes.hidden = YES;
            [_btnViewNotes removeFromSuperview];
        }
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
        NSDate *start_time = [df dateFromString:[[_objEditPracticeData  valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[_objEditPracticeData valueForKey:@"start_time"]]];
        NSDate *end_time = [df dateFromString:[[_objEditPracticeData  valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[_objEditPracticeData valueForKey:@"end_time"]]];
        [df setDateFormat:DATE_FORMAT_M_D_Y_H_M];
        
        NSString *strstarttime = [df stringFromDate:start_time];
        NSString *strendtime = [df stringFromDate:end_time];
        start_time !=nil ?  [_objEditPracticeData setObject:strstarttime forKey:@"start_time"] :@"";
        end_time !=nil ?  [_objEditPracticeData setObject:strendtime forKey:@"end_time"] : @"";
        _lblStartTime.text = [[_objEditPracticeData valueForKey:@"start_time"] isKindOfClass:[NSString class]] ?[_objEditPracticeData valueForKey:@"start_time"] : @"";
        _lblEndTime.text = [[_objEditPracticeData valueForKey:@"end_time"] isKindOfClass:[NSString class]]? [_objEditPracticeData valueForKey:@"end_time"]: @"";
        _textviewDescription.text = [[_objEditPracticeData valueForKey:@"description"] isKindOfClass:[NSString class]] ?[_objEditPracticeData valueForKey:@"description"] :@"" ;
        _textViewDrill.text = [[_objEditPracticeData valueForKey:@"drills"] isKindOfClass:[NSString class]]? [_objEditPracticeData valueForKey:@"drills"]:@"";
        _txtViewNotes.text = [[_objEditPracticeData valueForKey:@"notes"] isKindOfClass:[NSString class]] ? [_objEditPracticeData valueForKey:@"notes"]:@"";
        
        _btnViewNotes.hidden=NO;
        _btnViewNotes.layer.borderWidth = BORDERWIDTH;
        _btnViewNotes.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnViewNotes.titleLabel.textColor = [UIColor lightTextColor];
        _btnViewNotes.tintColor = [UIColor darkGrayColor];
        _btnViewNotes.layer.cornerRadius = CornerRadius + 10;
    }else{
        _btnViewNotes.hidden=YES;
    }
    [self setFieldsProperty];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark Class Utility Method
-(void)Done{
    [[arrAthletesNotes objectAtIndex:EditIndex] setValue:txtViewCurrent.text forKey:@"notes"];
    [tblAthleteNotes reloadData];
    [self EditAthleteNote:EditIndex];
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
-(void)EditNote:(NSInteger)index{
    if(txtViewCurrent){
        [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            txtViewCurrent.frame = CGRectMake(150, 100, 0, 0);
            [txtViewCurrent resignFirstResponder];
        } completion:^(BOOL finished){
            if(txtViewCurrent){
                [txtViewCurrent removeFromSuperview];
                txtViewCurrent=nil;
            }
        } ];
    }
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(150, 100, 0, 0)];
    txtView.autocorrectionType = UITextAutocorrectionTypeNo;
    txtView.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
    [SingletonClass ShareInstance].delegate = self;
    txtView.delegate = self;
    txtView.layer.borderWidth = 1.0f;
    txtView.layer.cornerRadius = 4.0f;
    txtView.font = Textfont;
    txtView.textColor=[UIColor lightGrayColor];
    [txtView becomeFirstResponder];
    [self.view addSubview:txtView];
    if (index < arrAthletesNotes.count) {
        txtView.text = [[arrAthletesNotes objectAtIndex:index] valueForKey:@"notes"];
        txtViewCurrent = txtView;
    }
    txtViewCurrent = txtView;
    EditIndex = index;
    [UIView animateWithDuration:0.48f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{txtView.frame = CGRectMake(5, 3, self.view.frame.size.width-10 ,self.view.frame.size.height - (KeyboardHeight+10));} completion:^(BOOL finished){}];
}
-(CAShapeLayer *)Line:(CGPoint)start_Point :(CGPoint)end_Point{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(end_Point.x, end_Point.y)];
    [path addLineToPoint:CGPointMake(start_Point.x, start_Point.y)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor darkGrayColor] CGColor];
    shapeLayer.lineWidth = .25;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    return shapeLayer;
}
- (void)orientationChanged{
    if (isOpenNoteView) {
        [self RemoveNotesView];
        [self performSelector:@selector(ViewAthletesNotes:) withObject:nil];
    }
    [SingletonClass ShareInstance].isPracticeLogUpdate = YES;
    [_PracticeDetailScrollView setContentSize:CGSizeMake(_PracticeDetailScrollView.frame.size.width, self.view.frame.size.height+(isIPAD ? 300 : 100))];
    _PracticeDetailScrollView.scrollEnabled = YES;
}
-(void)setFieldsProperty{
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    _lblDescriptionHeading.font = Textfont;
    _lblDrillHeading.font = Textfont;
    _lblNotesHeading.font = Textfont;
    _lblStartTimeHeading.font = Textfont;
    _lblEndTimeHeading.font = Textfont;
    _lblDescriptionHeading.textColor = GrayColor;
    _lblDrillHeading.textColor = GrayColor;
    _lblNotesHeading.textColor = GrayColor;
    _lblStartTimeHeading.textColor = GrayColor;
    _lblEndTimeHeading.textColor = GrayColor;
    _textviewDescription.layer.borderWidth = BORDERWIDTH;
    _textViewDrill.layer.borderWidth = BORDERWIDTH;
    _txtViewNotes.layer.borderWidth = BORDERWIDTH;
    _textviewDescription.layer.borderColor = BORDERCOLOR;
    _textViewDrill.layer.borderColor = BORDERCOLOR;
    _txtViewNotes.layer.borderColor = BORDERCOLOR;
    _textviewDescription.layer.cornerRadius = CornerRadius;
    _textViewDrill.layer.cornerRadius = CornerRadius;
    _txtViewNotes.layer.cornerRadius = CornerRadius;
    
    _textViewDrill.font = Textfont;
    _textviewDescription.font = Textfont;
    _txtViewNotes.font = Textfont;
    _txtViewNotes.textColor = LightGrayColor;
    _textviewDescription.textColor = LightGrayColor;
    _textViewDrill.textColor = LightGrayColor;
    _lblStartTime.font = Textfont;
    _lblStartTime.textColor = LightGrayColor;
    _lblEndTime.font = Textfont;
    _lblEndTime.textColor = LightGrayColor;
}
- (IBAction)ViewAthletesNotes:(id)sender {
    isOpenNoteView = YES;
    athleteNotesView = [[UIView alloc] initWithFrame:CGRectMake(BORDERWEIGHT, BORDERWEIGHT, self.view.frame.size.width-(BORDERWEIGHT+5), self.view.frame.size.height-(BORDERWEIGHT+5))];
    UIButton *btnRemoveView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRemoveView setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    btnRemoveView.frame = CGRectMake(athleteNotesView.frame.size.width-(ICON_HEIGHT_WEIGHT), athleteNotesView.frame.origin.y-(BORDERWEIGHT), ICON_HEIGHT_WEIGHT, ICON_HEIGHT_WEIGHT);
    athleteNotesView.backgroundColor = LightGrayColor;
    athleteNotesView.layer.cornerRadius = CornerRadius;
    athleteNotesView.layer.borderWidth = BORDERWIDTH;
    athleteNotesView.layer.borderColor = BORDERCOLOR;
    
    [btnRemoveView addTarget:self action:@selector(RemoveNotesView) forControlEvents:UIControlEventTouchUpInside];
    
    tblAthleteNotes = [[UITableView alloc] initWithFrame:CGRectMake(0,0, athleteNotesView.frame.size.width, athleteNotesView.frame.size.height) style:UITableViewStylePlain];
    tblAthleteNotes.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblAthleteNotes.delegate = self;
    tblAthleteNotes.dataSource = self;
    tblAthleteNotes.layer.cornerRadius = CornerRadius;
    tblAthleteNotes.layer.borderWidth = BORDERWIDTH;
    tblAthleteNotes.layer.borderColor = BORDERCOLOR;
    [UIView animateWithDuration:0.20f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [athleteNotesView addSubview:tblAthleteNotes];
        [athleteNotesView addSubview:btnRemoveView];
       [self.view addSubview:athleteNotesView];
    } completion:^(BOOL finished){
    } ];
}
-(void)RemoveNotesView{
    isOpenNoteView = NO;
    [athleteNotesView removeFromSuperview];
}
#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrAthletesNotes.count;
}
- (UITableViewCell *) tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ATHLETEPRACTICENOTESCELL";
    static NSString *CellNibName = @"AthletePracticeNotesCell";
    AthletePracticeNotesCell *cell = (AthletePracticeNotesCell *)[table dequeueReusableCellWithIdentifier:CellIdentifier];
    @try {
        if (cell == nil){
            NSArray *arrNib = [[NSBundle mainBundle] loadNibNamed:CellNibName owner:self options:nil];
            cell = [arrNib objectAtIndex:0];
            cell.contentView.userInteractionEnabled =YES;
        }
        cell.lblAthleteName.text = [[arrAthletesNotes objectAtIndex:indexPath.row] valueForKey:@"name"] != nil ? [[arrAthletesNotes objectAtIndex:indexPath.row] valueForKey:@"name"] : @"";
        cell.textviewNotes.text = [[arrAthletesNotes objectAtIndex:indexPath.row] valueForKey:@"notes"] != nil ? [[arrAthletesNotes objectAtIndex:indexPath.row] valueForKey:@"notes"] : @"";
        cell.textviewNotes.textColor = LightGrayColor;
        cell.lblAthleteName.font = Textfont;
        cell.textviewNotes.font = SmallTextfont;
        
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.layer addSublayer:[self Line:CGPointMake(0, cell.frame.size.height) :CGPointMake([[UIScreen mainScreen] bounds].size.width+500, cell.frame.size.height)]] ;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self EditNote:indexPath.row];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Athlete Note";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PRACTICENOTE_CELL_HEIGHT;
}
#pragma mark WebService Comunication Method
-(void)EditAthleteNote:(int)index{
    if ([SingletonClass  CheckConnectivity]) {
        self.navigationItem.rightBarButtonItem.enabled=NO;
        WebServiceClass *webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        [SingletonClass addActivityIndicator:self.view];
        if (_objEditPracticeData) {
            if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
            }
            NSDictionary *dicAthleteNote = [[NSDictionary alloc] initWithObjectsAndKeys:(arrAthletesNotes.count > index ? [[arrAthletesNotes objectAtIndex:index] valueForKey:@"id"] : @""),@"id",(arrAthletesNotes.count > index ? [[arrAthletesNotes objectAtIndex:index] valueForKey:@"notes"] : @""),@"notes", nil];
            [SingletonClass ShareInstance].isPracticeLogUpdate = TRUE;
            [webservice WebserviceCallwithDic:dicAthleteNote :webServiceEditAthleteNote :EditAthletNoteTag];
        }
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    switch (Tag){
        case EditAthletNoteTag :{
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Note has been saved successfully" delegate:self btn1:@"Ok"];
            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
