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

@class CalenderScheduleView;
@interface MenuLIstView : UIViewController<UITableViewDelegate, UITableViewDataSource,WebServiceDelegate>
{
    WebServiceClass *webservice;
}
@property (nonatomic,strong) CalenderScheduleView *calendarViewController;
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
- (IBAction)logout:(id)sender;
@end
