//
//  SMSView.h
//  Athledo
//
//  Created by Dinesh Kumar on 3/26/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSCustomCell.h"

@interface SMSView : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,CellDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end
