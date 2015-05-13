//
//  Mutimedia.h
//  Athledo
//
//  Created by Smartdata on 12/16/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultimediaCell.h"
#import "WebServiceClass.h"
#import "MultimediaVideo.h"

@interface Multimedia : UIViewController<WebServiceDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UIToolbar *toolBar;
}

@property (weak, nonatomic) IBOutlet UITextField *textFieldSeason;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@end
