//
//  AddCoachongHistoryCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/31/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCoachongHistoryCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath delegate:(id)del textData:(NSArray *)arrCoachongInfo :(NSString *)TextFeildText;
@end
