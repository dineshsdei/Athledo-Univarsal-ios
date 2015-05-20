//
//  PracticeLogDetail.m
//  Athledo
//
//  Created by Dinesh Kumar on 5/15/15.
//  Copyright (c) 2015 Smartdata. All rights reserved.
//

#import "PracticeLogDetail.h"

@interface PracticeLogDetail ()

@end

@implementation PracticeLogDetail

#pragma mark UIViewController Life cycle method

- (void)viewDidLayoutSubviews {
    [_PracticeDetailScrollView setContentSize:CGSizeMake(_PracticeDetailScrollView.frame.size.width, _PracticeDetailScrollView.frame.size.height+(isIPAD ? 300 :100))];
    _PracticeDetailScrollView.scrollEnabled = YES;

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isIPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
}
- (void)viewDidLoad {
     _btnViewNotes.hidden=YES;
    self.title = @"Practice Log Details";
    [super viewDidLoad];
    [_PracticeDetailScrollView setContentSize:CGSizeMake(_PracticeDetailScrollView.frame.size.width, _PracticeDetailScrollView.frame.size.height+(isIPAD ? 300 :100))];
    _PracticeDetailScrollView.scrollEnabled = YES;
   

    if (_objEditPracticeData) {
       
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:DATE_FORMAT_Y_M_D_H_M_S];
        NSDate *start_time = [df dateFromString:[[_objEditPracticeData  valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[_objEditPracticeData valueForKey:@"start_time"]]];
        NSDate *end_time = [df dateFromString:[[_objEditPracticeData  valueForKey:@"week_current_date"] stringByAppendingFormat:@" %@",[_objEditPracticeData valueForKey:@"end_time"]]];
        [df setDateFormat:DATE_FORMAT_M_D_Y_H_M];
        
        NSString *strstarttime = [df stringFromDate:start_time];
        NSString *strendtime = [df stringFromDate:end_time];
        
        start_time !=nil ?  [_objEditPracticeData setObject:strstarttime forKey:@"start_time"] :@"";
        end_time !=nil ?  [_objEditPracticeData setObject:strendtime forKey:@"end_time"] : @"";
        
        _lblStartTime.text = [_objEditPracticeData valueForKey:@"start_time"];
        _lblEndTime.text = [_objEditPracticeData valueForKey:@"end_time"];
        _textviewDescription.text = [_objEditPracticeData valueForKey:@"description"];
                _textViewDrill.text = [_objEditPracticeData valueForKey:@"drills"];
                _txtViewNotes.text = [_objEditPracticeData valueForKey:@"notes"];
        
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
- (void)orientationChanged
{
    [_PracticeDetailScrollView setContentSize:CGSizeMake(_PracticeDetailScrollView.frame.size.width, self.view.frame.size.height+(isIPAD ? 300 : 100))];
     _PracticeDetailScrollView.scrollEnabled = YES;
}
-(void)setFieldsProperty
{
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
}
@end
