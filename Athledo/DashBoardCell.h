//
//  DashBoardCell.h
//  Athledo
//
//  Created by Smartdata on 7/21/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardCell : UITableViewCell
{
    
}

@property(nonatomic,retain)IBOutlet UIImageView *teamLogo;
@property(nonatomic,retain)IBOutlet UILabel *teamName;
@property(nonatomic,retain)IBOutlet UITextView *teamDes;

@end
