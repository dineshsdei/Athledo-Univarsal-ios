//
//  SMSView.h
//  Athledo
//
//  Created by Dinesh Kumar on 3/26/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSCustomCell.h"
#import "CheckboxButton.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"

@interface SMSView : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,CellDelegate,SingletonClassDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@end
