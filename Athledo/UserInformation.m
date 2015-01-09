//
//  UserInformation.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "UserInformation.h"

static UserInformation *objUserInfo=nil;
@implementation UserInformation

+(UserInformation *)shareInstance
{
    if (objUserInfo == nil) {
        
        objUserInfo=[[UserInformation alloc] init];
        
        objUserInfo.arrUserTeam=[[NSMutableArray alloc] init];
        objUserInfo.arrAthleteHistory=[[NSMutableArray alloc] init];
        objUserInfo.arrAwards=[[NSMutableArray alloc] init];
        objUserInfo.arrCoachingHistory=[[NSMutableArray alloc] init];
        objUserInfo.arrSports=[[NSMutableArray alloc] init];
        
    }
    
    return objUserInfo;
}



+ (void)resetSharedInstance {
    
    objUserInfo = nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.userFname forKey:@"userfirstname"];
   
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.userFname = [decoder decodeObjectForKey:@"userfirstname"];
//        self.categoryName = [decoder decodeObjectForKey:@"category"];
//        self.subCategoryName = [decoder decodeObjectForKey:@"subcategory"];
    }
    return self;
}

@end
