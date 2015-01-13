//
//  CalendarMainViewController.h
//  Athledo
//
//  Created by Dinesh kumar on 01/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "WebServiceClass.h"
@class CalenderScheduleView;

@interface CalendarMainViewController : TKTableViewController<WebServiceDelegate>
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) CalenderScheduleView *calendarViewController;
@end
