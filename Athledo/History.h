//
//  History.h
//  Athledo
//
//  Created by Smartdata on 4/1/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSHistoryCell.h"

@interface History : UIViewController<WebServiceDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
