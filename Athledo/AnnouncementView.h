//
//  AnnouncementView.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnouncementCell.h"
#import "SWTableViewCell.h"
#import "WebServiceClass.h"



@interface AnnouncementView : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,AnnouncementCellDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,WebServiceDelegate>
{
    
    IBOutlet UITableView *tblAnnouncementRecods;
    IBOutlet UITableView *tblUpdatesRecods;
    IBOutlet UITextField *tfSearch;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIDatePicker *datePicker;
    
    UIView* sideSwipeView;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    NSMutableArray* buttonsArray;
    UITableViewCell* sideSwipeCell;
    BOOL animatingSideSwipe;
    
   IBOutlet UISearchBar *SearchBar;
}
-(IBAction)searchData:(NSString *)searchText;
//-(IBAction)AddNewAnnouncement:(id)sender;
@end
