//
//  AddNewAnnouncement.h
//  Athledo
//
//  Created by Smartdata on 7/24/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//https://github.com/Smartdatasdei/Athledo-Univarsal-ios.git

#import <UIKit/UIKit.h>
#import "ALPickerView.h"

@interface AddNewAnnouncement : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,ALPickerViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *dateTxt;
    IBOutlet UITextField *timeTxt;

    IBOutlet UITextView *descTxt;
    
    IBOutlet UIButton *emailBtn1;
    IBOutlet UIButton *emailBtn2;
    IBOutlet UIButton *settingAllBtn;
    IBOutlet UIButton *settingCoachBtn;
    IBOutlet UIButton *settingAthleteBtn;
    IBOutlet UIButton *settingAluminiBtn;
    IBOutlet UIButton *settingManagerBtn;
    IBOutlet UIButton *selectGroupBtn;

    IBOutlet UIButton *selectDateBtn;
    IBOutlet UIButton *selectTimeBtn;
    
    UIDatePicker *datePicker;
    ALPickerView *pickerView;
    UIToolbar *toolBar;
    int scrollHeight;
    
}
- (IBAction)AllButtonEvent:(id)sender;
- (IBAction)CoachButtonEvent:(id)sender;
- (IBAction)AthleteButtonEvent:(id)sender;
- (IBAction)ManagerButtonEvent:(id)sender;
- (IBAction)AluminiButtonEvent:(id)sender;
- (IBAction)GroupsButtonEvent:(id)sender;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property (strong, nonatomic) NSString *ScreenTitle;

@property (strong, nonatomic) id obj;

- (IBAction)emailBtnClick:(id)sender;

- (IBAction)settingBtnClick:(id)sender;
- (IBAction)selectDate:(id)sender;
- (IBAction)selectTime:(id)sender;

- (IBAction)saveAnnouncement:(id)sender;

@end
