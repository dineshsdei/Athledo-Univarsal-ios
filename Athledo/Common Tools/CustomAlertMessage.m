//
//  CustomAlertMessage.m
//  HumTum
//
//  Created by Amrendra Roy on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertMessage.h"

@implementation CustomAlertMessage



- (void)layoutSubviews
{
    for (UIView *subview in self.subviews)
    { 
        //Fast Enumeration
        if ([subview isMemberOfClass:[UIImageView class]])
        {
            subview.hidden = YES; //Hide UIImageView Containing Blue Background
        }
        
        if ([subview isMemberOfClass:[UILabel class]]) 
        { 
            //Point to UILabels To Change Text
            UILabel *label = (UILabel*)subview;	//Cast From UIView to UILabel
            label.textColor =[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
            label.shadowColor = [UIColor blackColor];
            label.shadowOffset = CGSizeMake(0.0f, 1.0f);
            buttonOffset= label.frame.origin.y+label.frame.size.height+10; //10 is gap
        }
    }
}


-(void)drawRect:(CGRect)rect
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
