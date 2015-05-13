//
//  RepeatCalendarEvent.h
//  Athledo
//
//  Created by Smartdata on 10/20/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatEventCell.h"

@interface RepeatCalendarEvent : UIViewController<RepeatEventCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UISegmentedControl *segment;
    NSString *strRepeatEvent;
    int CellIndex;
    
    RepeatEventCell *cell;
    NSArray *nib;
    int scrollHeight;
    
    IBOutlet UIPickerView *listPicker;
    
    NSMutableArray *arrEventSting;
    NSDateFormatter *dformate;
    NSString *strSelectedEndDate;
    UIToolbar *toolBar;
}
@property (strong, nonatomic) id obj;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) UIDatePicker *datePicker;

- (IBAction)ValueChange:(id)sender;

@end
