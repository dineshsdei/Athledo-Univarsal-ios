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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(IBAction)checkBoxEvent:(id)sender
{
    [_cellDelegate CheckBoxEvent:sender];
}

@end
