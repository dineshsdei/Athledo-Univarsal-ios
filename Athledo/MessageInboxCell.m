//
//  MessageInboxCell.m
//  Athledo
//
//  Created by Smartdata on 9/11/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "MessageInboxCell.h"

@implementation MessageInboxCell

- (void)awakeFromNib
{
    // Initialization code
}

-(IBAction)deleteMessage:(id)sender
{
    //[_delegate deleteMessage:sender];
}
-(IBAction)archiveMessage:(id)sender
{
   //[_delegate archiveMessage:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
