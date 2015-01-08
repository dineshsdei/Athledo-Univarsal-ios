//
//  AddWorkOutCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 8/14/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkOutCellDelegate <NSObject>

-(void)AthletesCheckBoxEvent:(id)sender;
-(void)EmailCheckBoxEvent:(id)sender;
-(void)addCustomTag:(id)sender;
-(void)deleteCustomTag:(id)sender;
-(void)addExercise:(id)sender;
-(void)deleteExercise:(id)sender;
-(void)SaveWorkOutData:(id)sender;
-(void)addExerciseSection:(id)sender;
-(void)deleteExerciseSection:(id)sender;

@end

@interface AddWorkOutCell : UITableViewCell
- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath cellFields :(NSMutableArray *)arrfixCellFields liftFields :(NSMutableArray *)liftPlaceholder :(NSMutableDictionary *)WorkOutDic :(int)LiftExerciseCount :(id)del;
@property(nonatomic,weak)id <WorkOutCellDelegate> delegate;
@end
