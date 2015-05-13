//
//  DashBoard.h
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashBoardCell.h"

@interface DashBoard : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dashboardTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
