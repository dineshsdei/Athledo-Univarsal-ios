//
//  Awards.m
//  Athledo
//
//  Created by Smartdata on 7/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "Awards.h"

@implementation Awards

static Awards *objAwards=nil;

+(Awards *)shareInstance
{
    
    if (objAwards == nil) {
        
        objAwards=[[Awards alloc] init];
        
    }
    
    return objAwards;
}

@end
