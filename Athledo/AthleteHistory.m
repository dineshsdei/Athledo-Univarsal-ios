//
//  AthleteHistory.m
//  Athledo
//
//  Created by Smartdata on 7/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AthleteHistory.h"

@implementation AthleteHistory

static AthleteHistory *objAthleteHistorys=nil;

+(AthleteHistory *)shareInstance
{
    
    if (objAthleteHistorys == nil) {
        
        objAthleteHistorys=[[AthleteHistory alloc] init];
        
    }
    
    return objAthleteHistorys;
}


@end
