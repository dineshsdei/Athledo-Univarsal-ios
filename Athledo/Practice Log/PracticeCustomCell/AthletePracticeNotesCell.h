//
//  AthletePracticeNotesCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 5/21/15.
//  Copyright (c) 2015 Smartdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AthletePracticeNotesCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblAthleteName;
@property (weak, nonatomic) IBOutlet UITextView *textviewNotes;

@end
