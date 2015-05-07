//
//  AddNotes.h
//  Athledo
//
//  Created by Dinesh Kumar on 2/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface AddNoteCell : SWTableViewCell
{

}
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property(nonatomic,retain)IBOutlet UITextView *cellTextView;
@end
