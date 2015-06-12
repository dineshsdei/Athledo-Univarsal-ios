//
//  Attendance.h
//  Athledo
//
//  Created by Smartdata on 4/21/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceCell.h"
#import <CoreGraphics/CoreGraphics.h>


@interface Attendance : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,WebServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
