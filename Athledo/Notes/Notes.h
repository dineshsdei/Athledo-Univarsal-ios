//
//  Notes.h
//  Athledo
//
//  Created by Dinesh Kumar on 2/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AddNotes.h"

@interface Notes : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,WebServiceDelegate>
{
    IBOutlet UITableView *tableview;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
