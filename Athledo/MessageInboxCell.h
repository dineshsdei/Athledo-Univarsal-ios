//
//  MessageInboxCell.h
//  Athledo
//
//  Created by Smartdata on 9/11/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MessageViewCellDelegate <NSObject>

-(void)deleteMessage:(id)sender;
-(void)archiveMessage:(id)sender;

@end

@interface MessageInboxCell :SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *senderPic;
@property (weak, nonatomic) IBOutlet UIImageView *senderTypePic;
@property (weak, nonatomic) IBOutlet UILabel *lblSenderName;
@property (weak, nonatomic) IBOutlet UILabel *lblReceivingDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btndelete;
@property (weak, nonatomic) IBOutlet UIButton *btnarchive;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property(nonatomic,weak)id <MessageViewCellDelegate> del;
-(IBAction)deleteMessage:(id)sender;
-(IBAction)archiveMessage:(id)sender;
@end
