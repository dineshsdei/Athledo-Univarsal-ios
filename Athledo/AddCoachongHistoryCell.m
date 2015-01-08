//
//  AddCoachongHistoryCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/31/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "AddCoachongHistoryCell.h"

@implementation AddCoachongHistoryCell
#define placeHolderColor [UIColor lightGrayColor]
#define txtColor  [UIColor grayColor]



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath delegate:(id)del textData :(NSArray *)arrCoachongInfo :(NSString *)TextFeildText
{
   
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect screenSize=[[UIScreen mainScreen] bounds];
        
        UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, screenSize.size.width-40, self.frame.size.height-6)];
        
        //txtField.backgroundColor = [UIColor clearColor];
        txtField.delegate = del;
        txtField.text=TextFeildText;
         txtField.textColor = txtColor;
        txtField.font=Textfont;
        txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        txtField.borderStyle = UITextBorderStyleRoundedRect;
        txtField.backgroundColor=[UIColor whiteColor];
        txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        if(indexPath.section==0) //Email
        {
            txtField.tag = indexPath.section+1000;
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[arrCoachongInfo objectAtIndex:0] attributes:@{ NSForegroundColorAttributeName : placeHolderColor }];
            txtField.attributedPlaceholder = str;
        }
        else if(indexPath.section==1)
        {
            if (arrCoachongInfo.count== 3) {
                 txtField.tag = indexPath.section+1003;
            }else{
                txtField.tag = indexPath.section+1000;
            }
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[arrCoachongInfo objectAtIndex:1] attributes:@{ NSForegroundColorAttributeName : placeHolderColor }];
            txtField.attributedPlaceholder = str;
            
        }
        else if(indexPath.section == 2)
        {
            txtField.tag = indexPath.section+1000;
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[arrCoachongInfo objectAtIndex:2] attributes:@{ NSForegroundColorAttributeName : placeHolderColor }];
            txtField.attributedPlaceholder = str;
        }
        else if(indexPath.section == 3)
        {
            txtField.tag = indexPath.section+1000;
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[arrCoachongInfo objectAtIndex:3] attributes:@{ NSForegroundColorAttributeName : placeHolderColor }];
            txtField.attributedPlaceholder = str;
        }
        else if(indexPath.section == 4)
        {
            txtField.tag = indexPath.section+1000;
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:[arrCoachongInfo objectAtIndex:4] attributes:@{ NSForegroundColorAttributeName : placeHolderColor }];
            txtField.attributedPlaceholder = str;
        }
        
        
//        txtField.text = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        
        
        [self addSubview:txtField];
        
        
        UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(0,(self.frame.size.height)+5, screenSize.size.width, 1)];
        img1.image=[UIImage imageNamed:@"menu_sep.png"];
        [self addSubview:img1];
        
       
        
    }
    self.backgroundColor=[UIColor clearColor];
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
