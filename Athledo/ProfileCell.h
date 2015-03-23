//
//  ProfileCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/28/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProfileSelectionDelegate <NSObject>

-(void)AddCoachingInfo :(long int)index;
-(void)AddAwardsInfo :(long int)index;
-(void)AddHistoryInfo :(long int)index;
-(void)AddManagerSportInfo :(long int)index;

@end


@interface ProfileCell : UITableViewCell
{
    
}
@property(nonatomic,strong)id <AddProfileSelectionDelegate>addProfileDelegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath delegate:(id)del GenralInfo:(NSDictionary *)GenralInfo coachingInfo:(NSArray *)coachingInfo awardInfo:(NSArray *)awardInfo : (BOOL)isEdit;

@end
