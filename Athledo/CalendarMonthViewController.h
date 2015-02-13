

#import <TapkuLibrary/TapkuLibrary.h>
#import "WebServiceClass.h"
#import "CalenderEventDetails.h"
#import "CalendarDayViewController.h"
@import UIKit;

#pragma mark - CalendarMonthViewController
@interface CalendarMonthViewController : TKCalendarMonthTableViewController<WebServiceDelegate,UITabBarDelegate>
{
    IBOutlet UITabBar *tabBar;
    
    NSString *strCurrentMonth;
    
    NSDate *SelectedMonthStart;
    NSDate *SelectedMonthEnd;
    UIDeviceOrientation currentOrientation;
}
@property(nonatomic,retain)TKCalendarMonthView *monthview;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *dataDictionary;
@property(weak,nonatomic)id objNotificationData;

//- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

@end
