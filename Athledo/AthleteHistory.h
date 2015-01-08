//
//  AthleteHistory.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/23/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AthleteHistory : NSObject
@property(nonatomic,strong)NSString *athleteTeam;
@property(nonatomic,strong)NSString *athleteTeamDesc;
+(AthleteHistory *)shareInstance;
@end
