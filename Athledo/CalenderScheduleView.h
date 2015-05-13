//
//  CalenderScheduleView.h
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface CalenderScheduleView :UIViewController <UISplitViewControllerDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIViewController *mainController;
@property (nonatomic,strong) UIPopoverController *currentPopoverController;

- (void) setupWithMainController:(UIViewController*)controller;
@end
