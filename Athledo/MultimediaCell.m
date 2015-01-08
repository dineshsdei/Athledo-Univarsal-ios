//
//  TableViewCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 12/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "MultimediaCell.h"

@implementation MultimediaCell
@synthesize imageView;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)PlayButton:(id)sender
{
    [_delegate PlayVideo:sender];
}
@end
