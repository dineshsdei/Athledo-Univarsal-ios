//
//  SMSCustomCell.h
//  Athledo
//
//  Created by Smartdata on 3/27/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//


@protocol CellDelegate <NSObject>
-(void)CheckBoxEvent:(id)sender;
@end

#import <UIKit/UIKit.h>
@interface SMSCustomCell : UITableViewCell
{
    
}
@property(nonatomic,strong)id <CellDelegate>cellDelegate;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectContact;
-(IBAction)checkBoxEvent:(id)sender;
@end
