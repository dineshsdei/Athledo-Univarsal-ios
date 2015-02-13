
#import <UIKit/UIKit.h>
#import "MAWeekView.h" // MAWeekViewDataSource,MAWeekViewDelegate
#import "WebServiceClass.h"

@class MAEventKitDataSource;

@interface WeekViewController : UIViewController<MAWeekViewDataSource,MAWeekViewDelegate,UITabBarDelegate,WebServiceDelegate> {
    MAEventKitDataSource *_eventKitDataSource;
     IBOutlet UITabBar *tabBar;
    
    NSDate *WeekStartDate,*WeekEndDate;
    
    NSDictionary *eventData;
    
    MAWeekView *objWeekView;
    BOOL isServiceCall;
    
}
@property(nonatomic,strong) IBOutlet UIView* weekView;
@property(nonatomic,strong) NSMutableArray *eventDic;
@property(weak,nonatomic)id objNotificationData;

@end