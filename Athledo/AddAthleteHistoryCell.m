//
//  AddAthleteHistoryCell.m
//  Athledo
//
//  Created by Smartdata on 8/5/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddAthleteHistoryCell.h"

#define placeHolderColor [UIColor lightGrayColor]
#define txtColor  [UIColor grayColor]


@implementation AddAthleteHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath delegate:(id)del textData :(NSArray *)arrAthleteHistoryInfo :(NSString *)TextFiledText
{
    CGRect screenSize=[[UIScreen mainScreen] bounds];
    
    UIDeviceOrientation deviceOrientation=[SingletonClass getOrientation];
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UITextField *txtField;
        if ((isIPAD) && (deviceOrientation==UIDeviceOrientationLandscapeLeft || deviceOrientation==UIDeviceOrientationLandscapeRight)) {
            txtField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0,984, self.frame.size.height-6)];
        }else{
            txtField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, screenSize.size.width-40, self.frame.size.height-6)];
        }
        txtField.backgroundColor = [UIColor clearColor];
        txtField.delegate = del;
        txtField.textColor = txtColor;
        txtField.text=TextFiledText;
        txtField.font =Textfont;
        txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField.borderStyle = UITextBorderStyleRoundedRect;
        txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        txtField.tag = indexPath.section+1000;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[arrAthleteHistoryInfo objectAtIndex:indexPath.section] attributes:@{ NSForegroundColorAttributeName :placeHolderColor }];
        txtField.attributedPlaceholder = str;
               
        [self addSubview:txtField];
    }
    self.backgroundColor=[UIColor clearColor];
    UIImageView *img1;
    if ((isIPAD) && (deviceOrientation==UIDeviceOrientationLandscapeLeft || deviceOrientation==UIDeviceOrientationLandscapeRight)) {
       img1=[[UIImageView alloc] initWithFrame:CGRectMake(0,(self.frame.size.height)+5, 1024, 1)];
    }else{
        img1=[[UIImageView alloc] initWithFrame:CGRectMake(0,(self.frame.size.height)+5, screenSize.size.width, 1)];
    }
    
    img1.image=[UIImage imageNamed:@"menu_sep.png"];
    [self addSubview:img1];
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
