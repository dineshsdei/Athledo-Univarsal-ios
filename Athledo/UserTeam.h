//
//  UserTeam.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTeam : NSObject
@property(nonatomic,strong)NSString *userTeamId;
@property(nonatomic)int userTeamSport_id;
@property(nonatomic)int userTeamStatus;
@property(nonatomic,strong)NSString *userTeam_desc;
@property(nonatomic)int userTeam_id;
@property(nonatomic,strong)NSString *userTeam_logo;
@property(nonatomic,strong)NSString *userTeam_name;
@property(nonatomic,strong)NSString *userTeam_pic;
@property(nonatomic,strong)NSString *userTeam_user_id;
+(UserTeam *)shareInstance;
@end
