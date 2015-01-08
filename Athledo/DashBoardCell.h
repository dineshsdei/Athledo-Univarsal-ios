//
//  DashBoardCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardCell : UITableViewCell
{
    
}

@property(nonatomic,retain)IBOutlet UIImageView *teamLogo;
@property(nonatomic,retain)IBOutlet UILabel *teamName;
@property(nonatomic,retain)IBOutlet UITextView *teamDes;

@end
