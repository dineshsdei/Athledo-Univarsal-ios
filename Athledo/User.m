//
//  User.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "User.h"

static User *objUser=nil;
@implementation User


+(User *)shareInstance
{
    if (objUser == nil) {
        
        objUser=[[User alloc] init];
        
    }
    
    return objUser;
}


@end
