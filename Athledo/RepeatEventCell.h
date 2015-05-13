//
//  RepeatEventCell.h
//  Athledo
//
//  Created by Smartdata on 10/20/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepeatEventCellDelegate <NSObject>

-(void)checkBoxClick:(id)sender;
-(void)comboBoxBoxClick:(id)sender;



@end

@interface RepeatEventCell : UITableViewCell
@property(nonatomic)NSInteger sectionIndex;
@property(nonatomic,assign)id <RepeatEventCellDelegate> delegate;

@end
