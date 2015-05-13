//
//  UserInformation.h
//  Athledo
//
//  Created by Smartdata on 7/21/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserTeam.h"

@interface UserInformation : NSObject
@property(nonatomic,strong)NSString *userFname;
@property(nonatomic,strong)NSString *userLname;
@property(nonatomic,strong)NSString *userPicUrl;
@property(nonatomic,strong)NSString *userFullName;
@property(nonatomic,strong)NSString *userStreetAdd;
@property(nonatomic,strong)NSString *userApptUnit;
@property(nonatomic,strong)NSString *userCountryName;
@property(nonatomic,strong)NSString *userCountryid;
@property(nonatomic,strong)NSString *userStateName;
@property(nonatomic,strong)NSString *userStateid;
@property(nonatomic,strong)NSString *userZipCode;
@property(nonatomic,strong)NSString *userPhone;

@property(nonatomic,strong)NSString *userEmail;
@property(nonatomic,strong)NSString *userProfilePicUrl;
@property(nonatomic)int userId;
@property(nonatomic)int userType;
@property(nonatomic)int userSelectedTeamid;
@property(nonatomic)int userSelectedSportid;
@property(nonatomic,retain)NSMutableArray *arrUserTeam;

@property(nonatomic,retain)NSMutableArray *arrCoachingHistory;
@property(nonatomic,retain)NSMutableArray *arrAwards;

@property(nonatomic,retain)NSMutableArray *arrSports;
@property(nonatomic,retain)NSMutableArray *arrAthleteHistory;


+(UserInformation *)shareInstance;
+ (void)resetSharedInstance;

@end
