//
//  CalendarEvent.m
//  Athledo
//
//  Created by Dinesh Kumar on 12/9/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
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
