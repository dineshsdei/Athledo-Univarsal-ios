//
//  PracticeCell.h
//  Athledo
//
//  Created by Smartdata on 5/11/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface PracticeCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblPracticeTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPracticeDesc;

@end
