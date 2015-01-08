//
//  WorkOutDetailCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 10/1/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WorkOutDetailCell.h"
#import "CustomTextField.h"

#define OtherField_X isIPAD ? 30:20
#define OtherField_W isIPAD ? 354:140
#define IntervalFieldS_X isIPAD ? 30:20
#define IntervalFieldS_W isIPAD ? 354:140
#define LiftFieldS_X isIPAD ? 150:75
#define LiftFieldS_W isIPAD ? 300:110
#define FieldsGap isIPAD ? 5:5


@implementation WorkOutDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath delegate:(id)del WorkOutType:(NSString *)Type :(int)FieldIndex
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([Type isEqualToString:@"Lift"]){
            
            CustomTextField *txtFieldFirst = [[CustomTextField alloc] initWithFrame:CGRectMake(LiftFieldS_X, 5, LiftFieldS_W, 30)];
            txtFieldFirst.backgroundColor = [UIColor clearColor];
            
            txtFieldFirst.textColor = [UIColor grayColor];
            //txtField.text=TextFiledText;
            txtFieldFirst.font = Textfont;
            txtFieldFirst.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtFieldFirst.borderStyle = UITextBorderStyleRoundedRect;
            txtFieldFirst.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtFieldFirst.tag = 1001;
            txtFieldFirst.delegate=del;
            
            [self.contentView addSubview:txtFieldFirst];
            
            CustomTextField *txtFieldSecond = [[CustomTextField alloc] initWithFrame:CGRectMake(((LiftFieldS_X)+(FieldsGap)+(LiftFieldS_W)), 5, LiftFieldS_W, 30)];
            
            txtFieldSecond.backgroundColor = [UIColor clearColor];
            
            txtFieldSecond.textColor = [UIColor grayColor];
            //txtField.text=TextFiledText;
            txtFieldSecond.font = Textfont;
            txtFieldSecond.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtFieldSecond.borderStyle = UITextBorderStyleRoundedRect;
            txtFieldSecond.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtFieldSecond.delegate=del;
            
            txtFieldSecond.tag = 1002;
            [self.contentView addSubview:txtFieldSecond];
            
            UILabel *lblExerciseName=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 30)];
            lblExerciseName.textColor = [UIColor grayColor];
            lblExerciseName.numberOfLines=3;
            lblExerciseName.lineBreakMode=NSLineBreakByWordWrapping;
            
            lblExerciseName.font = (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:10];
            
            lblExerciseName.textAlignment=NSTextAlignmentCenter;
            lblExerciseName.tag = 1003;
            
            [self.contentView addSubview:lblExerciseName];
            
            UILabel *lblSets=[[UILabel alloc] initWithFrame:CGRectMake(62, 0, 10, 30)];
            lblSets.textColor = [UIColor grayColor];
            lblSets.numberOfLines=1;
            lblSets.lineBreakMode=NSLineBreakByWordWrapping;
            
            lblSets.font = (isIPAD) ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:10];
            
            lblSets.textAlignment=NSTextAlignmentCenter;
            lblSets.tag = 1004;
            
            [self.contentView addSubview:lblSets];
            
            
        }else  if ([Type isEqualToString:@"Interval"]) {
            
            CustomTextField *txtFieldPlaceHolder = [[CustomTextField alloc] initWithFrame:CGRectMake(IntervalFieldS_X, 5, IntervalFieldS_W, 30)];
            
            txtFieldPlaceHolder.backgroundColor = [UIColor clearColor];
            
            txtFieldPlaceHolder.textColor = [UIColor grayColor];
            //txtField.text=TextFiledText;
            txtFieldPlaceHolder.font = Textfont;
            txtFieldPlaceHolder.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtFieldPlaceHolder.borderStyle = UITextBorderStyleNone;
            txtFieldPlaceHolder.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtFieldPlaceHolder.userInteractionEnabled=NO;
            txtFieldPlaceHolder.tag = 1001;
            
            [self.contentView addSubview:txtFieldPlaceHolder];
            
            CustomTextField *txtField = [[CustomTextField alloc] initWithFrame:CGRectMake(((OtherField_X)+(OtherField_W)), 5, OtherField_W, 30)];
            
            txtField.backgroundColor = [UIColor clearColor];
            
            txtField.textColor = [UIColor grayColor];
            //txtField.text=TextFiledText;
            txtField.font = Textfont;
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtField.borderStyle = UITextBorderStyleRoundedRect;
            txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtField.delegate=del;
            
            txtField.tag = 1002;
            [self.contentView addSubview:txtField];
            

            
        }else
        {
            CustomTextField *txtFieldPlaceHolder = [[CustomTextField alloc] initWithFrame:CGRectMake(OtherField_X, 5, OtherField_W, 30)];
            
            txtFieldPlaceHolder.backgroundColor = [UIColor clearColor];
            
            txtFieldPlaceHolder.textColor = [UIColor grayColor];
            //txtField.text=TextFiledText;
            txtFieldPlaceHolder.font = Textfont;
            txtFieldPlaceHolder.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtFieldPlaceHolder.borderStyle = UITextBorderStyleNone;
            txtFieldPlaceHolder.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtFieldPlaceHolder.userInteractionEnabled=NO;
            txtFieldPlaceHolder.tag = 1001;
        
            [self.contentView addSubview:txtFieldPlaceHolder];
            
            CustomTextField *txtField = [[CustomTextField alloc] initWithFrame:CGRectMake(((OtherField_X)+(OtherField_W)), 5, OtherField_W, 30)];
            
            txtField.backgroundColor = [UIColor clearColor];
            
            txtField.textColor = [UIColor grayColor];
            //txtField.text=TextFiledText;
            txtField.font = Textfont;
            txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtField.borderStyle = UITextBorderStyleRoundedRect;
            txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtField.delegate=del;
            
            txtField.tag = 1002;
            [self.contentView addSubview:txtField];
        }
    }
    
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
