//
//  WorkOutListCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 8/11/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WorkOutListCell.h"

@implementation WorkOutListCell
@synthesize del;
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)Edit:(id)sender
{
    [del EditWorkOut:sender];
}
-(IBAction)Delete:(id)sender
{
    [del DeleteWorkOut:sender];
}
-(IBAction)Reasign:(id)sender
{
    [del ReAsignWorkOut:sender];
    
}

@end
