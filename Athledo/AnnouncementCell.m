//
//  AnnouncementCell.m
//  Athledo
//
//  Created by Smartdata on 7/24/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AnnouncementCell.h"

@implementation AnnouncementCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath delegate:(id)del textData:(NSString *)txt
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 212, 40)];
        txtField.tag = indexPath.section+1000;
        txtField.backgroundColor = [UIColor clearColor];
        txtField.delegate = del;
        txtField.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField.borderStyle = UITextBorderStyleNone;
        txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        self.textLabel.text = @"Email";
        txtField.alpha = 1;
        txtField.userInteractionEnabled = NO;  //Email is not changeable
      
        [self addSubview:txtField];
        
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake(230, 40, 30, 30);
        [btn.titleLabel setText:@"Ok"];
        btn.titleLabel.text=@"Ok";
        
        btn.enabled = FALSE;
        [btn setTitle:@"Test" forState:UIControlStateNormal];
        btn.enabled = TRUE;
        
        [btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        //btn.backgroundColor=[UIColor redColor];
        btn.tag=indexPath.row;
        
          [self addSubview:btn];
        
    }
    
    return self;
}



-(IBAction)delete:(id)sender
{
    [delegate deleteCell:sender];
}

-(IBAction)edit:(id)sender
{
    [delegate editCell:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
