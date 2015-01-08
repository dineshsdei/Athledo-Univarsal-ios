//
//  RepeatEventCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 10/20/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "RepeatEventCell.h"

@implementation RepeatEventCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)checkBoxClick:(id)sender {
    
      [_delegate checkBoxClick:sender];
    
}
- (IBAction)comboBoxBoxClick:(id)sender
{
    [_delegate comboBoxBoxClick:sender];
  }


@end
