//
//  NoteCell.h
//  Athledo
//
//  Created by Smartdata on 2/23/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface NoteCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblWorkoutName;
@property (strong, nonatomic) IBOutlet UIImageView *teamMemberPic;

@end
