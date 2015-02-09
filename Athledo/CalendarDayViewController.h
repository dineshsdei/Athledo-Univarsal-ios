//
//  CalendarDayViewController.h
//  Demo
//
//  Created by Devin Ross on 3/16/13.
//
//

#import <TapkuLibrary/TapkuLibrary.h>
@import UIKit;
#import "WebServiceClass.h"

@interface CalendarDayViewController : TKCalendarDayViewController<UITabBarDelegate,WebServiceDelegate>
{
     IBOutlet UITabBar *tabBar;
    NSDictionary *eventData;
    
    TKCalendarDayView *dayView;
   
}
@property(nonatomic,strong) NSDate *CalendarDisplayDate;
@property(nonatomic,strong)NSString *strComeFrom;
@property(nonatomic,strong) NSMutableArray *eventDic;
@property (nonatomic,strong) NSMutableArray *data;
@property(weak,nonatomic)id objNotificationData;
@end
