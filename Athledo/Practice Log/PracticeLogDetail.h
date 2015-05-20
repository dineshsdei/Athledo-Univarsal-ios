//
//  PracticeLogDetail.h
//  Athledo
//
//  Created by Dinesh Kumar on 5/15/15.
//  Copyright (c) 2015 Smartdata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeLogDetail : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblEndTimeHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTimeHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblDrillHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblNotesHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UITextView *textviewDescription;
@property (weak, nonatomic) IBOutlet UITextView *textViewDrill;
@property (weak, nonatomic) IBOutlet UITextView *txtViewNotes;
@property(nonatomic,strong)id objEditPracticeData;
@property (weak, nonatomic) IBOutlet UIScrollView *PracticeDetailScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnViewNotes;
- (IBAction)ViewAthletesNotes:(id)sender;

@end
