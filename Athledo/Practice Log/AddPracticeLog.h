//
//  AddPracticeLog.h
//  Athledo
//
//  Created by Smartdata on 5/12/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeLog.h"

@interface AddPracticeLog : UIViewController<UITextFieldDelegate,UITextViewDelegate,SingletonClassDelegate,WebServiceDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDrill;
@property (weak, nonatomic) IBOutlet UITextView *txtViewNotes;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldStartTime;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEndTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,weak)NSString *strScreenTitle;
@property(nonatomic,strong)id objEditPracticeData;
@property(nonatomic,weak)NSDate *addPracticeOnDate;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
- (IBAction)GetPickerTime:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDrill;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblnotes;

@end
