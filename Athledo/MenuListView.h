//
//  MenuLIstView.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "Multimedia.h"
#import "WebServiceClass.h"
#import "SMSView.h"
#import "Attendance.h"

@class CalenderScheduleView;
@interface MenuListView : UIViewController<UITableViewDelegate, UITableViewDataSource,WebServiceDelegate>
{
    WebServiceClass *webservice;
}
@property (strong, nonatomic) IBOutlet UIButton *btnLanscapLogout;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
@property (nonatomic,strong) CalenderScheduleView *calendarViewController;
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
- (IBAction)logout:(id)sender;
@end
