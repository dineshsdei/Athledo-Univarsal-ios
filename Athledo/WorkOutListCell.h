//
//  WorkOutListCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 8/11/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@protocol WorkOutDelegate <NSObject>

-(void)EditWorkOut:(id)sender;
-(void)DeleteWorkOut:(id)sender;
-(void)ReAsignWorkOut:(id)sender;

@end

@interface WorkOutListCell : SWTableViewCell
{
//    IBOutlet UILabel *lblWorkoutName;
//    IBOutlet UILabel *lblWorkoutSeason;
//    IBOutlet UILabel *lblWorkoutType;
//    IBOutlet UILabel *lblWorkoutCratedBy;
//     IBOutlet UILabel *lblWorkoutDate;
    
}
@property(nonatomic,strong) IBOutlet UILabel *lblWorkoutName;
@property(nonatomic,strong) IBOutlet UILabel *lblWorkoutSeason;
@property(nonatomic,strong) IBOutlet UILabel *lblWorkoutType;
@property(nonatomic,strong) IBOutlet UILabel *lblWorkoutCratedBy;
@property(nonatomic,strong) IBOutlet UILabel *lblWorkoutDate;
@property(nonatomic,strong) IBOutlet UIButton *btnEdit;
@property(nonatomic,strong) IBOutlet UIButton *btnDelete;
@property(nonatomic,strong) IBOutlet UIButton *btnReAssign;
@property(nonatomic,strong)id <WorkOutDelegate>del;
-(IBAction)Edit:(id)sender;
-(IBAction)Delete:(id)sender;
-(IBAction)Reasign:(id)sender;

@end
