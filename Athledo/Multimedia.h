//
//  Mutimedia.h
//  Athledo
//
//  Created by Dinesh Kumar on 12/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultimediaCell.h"
#import "WebServiceClass.h"
#import "MultimediaVideo.h"

@interface Multimedia : UIViewController<WebServiceDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldSeason;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@end
