//
//  UserTeam.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "UserTeam.h"
static UserTeam *objUserTeam=nil;
@implementation UserTeam
+(UserTeam *)shareInstance
{
    
    if (objUserTeam == nil) {
        
        objUserTeam=[[UserTeam alloc] init];
        
    }
    
    return objUserTeam;
}

@end
