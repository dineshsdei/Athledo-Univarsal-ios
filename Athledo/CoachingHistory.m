//
//  CoachingHistory.m
//  Athledo
//
//  Created by Smartdata on 7/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "CoachingHistory.h"
static CoachingHistory *objCoachingHistory=nil;
@implementation CoachingHistory

+(CoachingHistory *)shareInstance
{
    
    if (objCoachingHistory == nil) {
        
        objCoachingHistory=[[CoachingHistory alloc] init];
   
    }
    
    return objCoachingHistory;
}


@end
