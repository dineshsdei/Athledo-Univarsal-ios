//
//  AddCalendarEvent.h
//  Athledo
//
//  Created by Smartdata on 10/16/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJGeocoder.h"
#import "WebServiceClass.h"

@interface AddCalendarEvent : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,WebServiceDelegate,MJGeocoderDelegate>{
    
    NSDateFormatter *dformate;
    NSString* dateIs;
    
    int scrollHeight;
    
    double startTime,endTime;
    
   IBOutlet UIView *tempView;
}
@property (weak, nonatomic) IBOutlet UITextField *lblDescHeader;
@property (weak, nonatomic) IBOutlet UITextField *lblStartdateHeader;
@property (weak, nonatomic) IBOutlet UITextField *lblEndDateHeader;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfLocation;
@property (weak, nonatomic) IBOutlet UITextView *texviewDescription;
@property (weak, nonatomic) IBOutlet UITextField *tfStartTime;
@property (weak, nonatomic) IBOutlet UITextField *tfEndTime;
@property (weak, nonatomic) IBOutlet UILabel *tfRepeat;
@property (weak, nonatomic) IBOutlet UIButton *btnRepeat;
@property (weak, nonatomic) IBOutlet UIImageView *EnableDesableBtn;

@property(nonatomic,strong)NSString *screentitle;
- (IBAction)RepeatClick:(id)sender;
- (void)setContentOffset:(id)textField table:(UIScrollView*)m_ScrollView ;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(weak,nonatomic)NSString *strRepeat;
@property(nonatomic,retain)NSDictionary *eventDetailsDic;
@property(nonatomic,strong)NSString *strMoveControllerName;
@end
