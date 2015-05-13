//
//  HistoryCell.h
//  Athledo
//
//  Created by Smartdata on 4/1/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblSenderName;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UITextView *txtViewMessage;

@end
