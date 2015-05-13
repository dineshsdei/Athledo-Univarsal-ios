//
//  CalendarEvent.m
//  Athledo
//
//  Created by Smartdata on 12/9/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "CalendarEvent.h"
static CalendarEvent *objCalendarEvent=nil;
@implementation CalendarEvent

+(CalendarEvent *)ShareInstance
{
    if (objCalendarEvent == nil) {
        
        objCalendarEvent=[[CalendarEvent alloc] init];
        
    }
    
    
    return objCalendarEvent;
    
}

@end
