//
//  SMSCustomCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 3/27/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "SMSCustomCell.h"

@implementation SMSCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)checkBoxEvent:(id)sender
{
    [_cellDelegate CheckBoxEvent:sender];
}

@end
