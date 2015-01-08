//
//  AddWorkOut.h
//  Athledo
//
//  Created by Dinesh Kumar on 8/14/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddWorkOutCell.h"
#import "ALPickerView.h"
#import "WebServiceClass.h"

@interface AddWorkOut : UIViewController<WorkOutCellDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ALPickerViewDelegate,WebServiceDelegate>
{
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIPickerView *listPicker;
    
    IBOutlet UIPickerView *listPickerRemoveTag;
    IBOutlet UITableView *tableview;
    
     ALPickerView *pickerView;
    
      int scrollHeight;
    
    BOOL isChangeWorkoutType;
}
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property (strong, nonatomic) id objEditModeData;
- (void)setContentOffsetDown :(id)textField table :(UITableView*)m_TableView ;
-(NSString *)KeyForValue :(NSString *)superKey :(NSString *)SubKey;
@end
