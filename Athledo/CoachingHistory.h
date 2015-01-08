//
//  CoachingHistory.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/23/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoachingHistory : NSObject
{
    
}
@property(nonatomic,strong)NSString *coachSchoolName;
@property(nonatomic,strong)NSString *coachSportName;
@property(nonatomic,strong)NSString *coachFromDate;
@property(nonatomic,strong)NSString *coachToDate;
@property(nonatomic,strong)NSString *coachCoachingDesc;
+(CoachingHistory *)shareInstance;
@end
