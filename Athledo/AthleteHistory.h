//
//  AthleteHistory.h
//  Athledo
//
//  Created by Smartdata on 7/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AthleteHistory : NSObject
@property(nonatomic,strong)NSString *athleteTeam;
@property(nonatomic,strong)NSString *athleteTeamDesc;
+(AthleteHistory *)shareInstance;
@end
