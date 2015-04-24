//
//  AttendanceCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 4/21/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftUserImage;
@property (weak, nonatomic) IBOutlet UILabel *leftLblName;
@property (weak, nonatomic) IBOutlet UIImageView *rightUserImage;
@property (weak, nonatomic) IBOutlet UILabel *rightLblName;

@end
