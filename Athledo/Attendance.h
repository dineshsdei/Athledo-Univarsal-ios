//
//  Attendance.h
//  Athledo
//
//  Created by Dinesh Kumar on 4/21/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceCell.h"
#import <CoreGraphics/CoreGraphics.h>


@interface Attendance : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,WebServiceDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
