//
//  AddAthleteHistoryCell.h
//  Athledo
//
//  Created by Smartdata on 8/5/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAthleteHistoryCell : UITableViewCell
- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath delegate:(id)del textData :(NSArray *)arrAthleteHistoryInfo :(NSString *)TextFiledText;
@end
