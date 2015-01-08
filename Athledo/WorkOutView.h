//
//  WorkOutView.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOutListCell.h"
#import "SWTableViewCell.h"

@interface WorkOutView : UIViewController<UITableViewDataSource,UITableViewDelegate,WorkOutDelegate,SWTableViewCellDelegate>
{
    IBOutlet UITableView *tblList;
     IBOutlet UISearchBar *SearchBar;
}
@property(nonatomic,strong)id notificationData;
@end
