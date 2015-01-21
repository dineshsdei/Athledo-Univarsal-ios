//
//  DropDownField.m
//
//  Created by am on 08/03/13.
//  Copyright (c) 2013 am. All rights reserved.
//

#import "DropDownField.h"

@implementation DropDownField

- (id)initWithFrame:(CGRect)frame delegate:(id)del
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
        self.rightViewMode = UITextFieldViewModeAlways;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 8, 28, 28); //(0, 0, frame.size.height, frame.size.height)
        [btn setBackgroundImage:[UIImage imageNamed:@"btnDropDown.png"] forState:UIControlStateNormal];
        [btn addTarget:del action:@selector(dropDownClicked) forControlEvents:UIControlEventTouchUpInside];
        self.rightView = btn;
        
    }
    return self;
}
-(void)dropDownClicked
{
    
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
