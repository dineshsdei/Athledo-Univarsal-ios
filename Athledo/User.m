//
//  User.m
//  Athledo
//
//  Created by Smartdata on 7/21/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
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
