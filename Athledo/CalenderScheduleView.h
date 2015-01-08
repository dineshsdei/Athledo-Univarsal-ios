//
//  CalenderScheduleView.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface CalenderScheduleView :UIViewController <UISplitViewControllerDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIViewController *mainController;
@property (nonatomic,strong) UIPopoverController *currentPopoverController;

- (void) setupWithMainController:(UIViewController*)controller;
@end
