//
//  CheckboxButton.m
//  Athledo
//
//  Created by Dinesh kumar on 08/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "CheckboxButton.h"

@implementation CheckboxButton
@synthesize selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selected=NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
