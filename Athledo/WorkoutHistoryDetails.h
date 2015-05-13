//
//  WorkoutHistoryDetails.h
//  Athledo
//
//  Created by Smartdata on 11/12/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutHistoryDetails : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCreatedBy;
@property (weak, nonatomic) IBOutlet UILabel *lblworkoutType;
@property (weak, nonatomic) IBOutlet UILabel *lblseason;
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
@property (weak, nonatomic) IBOutlet UITextView *lbldescription;
@property (strong, nonatomic) id obj;
@end
