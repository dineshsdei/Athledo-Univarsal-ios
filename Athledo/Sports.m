//
//  Sports.m
//  Athledo
//
//  Created by Smartdata on 7/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "Sports.h"

@implementation Sports

static Sports *objSports=nil;

+(Sports *)shareInstance
{
    
    if (objSports == nil) {
        
        objSports=[[Sports alloc] init];
        
    }
    
    return objSports;
}


@end
