//
//  WorkOutDetailCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 10/1/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkOutDetailCell : UITableViewCell
- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath delegate :(id)del WorkOutType :(NSString *)Type :(int)FieldIndex;

@end
