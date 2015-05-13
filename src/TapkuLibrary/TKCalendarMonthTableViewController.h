
@import UIKit;
#import "TKCalendarMonthViewController.h"

/** The `TKCalendarMonthTableViewController` class creates a controller object that manages a calendar month grid with a table view below it. */ 
@interface TKCalendarMonthTableViewController : TKCalendarMonthViewController <UITableViewDelegate, UITableViewDataSource>

/** Returns the table view managed by the controller object. */
@property (nonatomic,strong) UITableView *tableView;
/** Will adjust the table view to the changing month view height 
 @param animated Animation flag.
 */
- (void) updateTableOffset:(BOOL)animated;

@end
