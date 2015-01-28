//
//  CalendarEvent.h
//  Athledo
//
//  Created by Dinesh Kumar on 12/9/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarEvent : NSObject
{
    
}
+(CalendarEvent *)ShareInstance;
@property(nonatomic,strong)NSString *strEventAddOrEdit;
@property(nonatomic)BOOL CalendarRepeatStatus;
@property(nonatomic)int NoOfDay;
@property(nonatomic)int NoOfOccurrence;
@property(nonatomic,strong)NSString *strEventType;
@property(nonatomic,strong)NSString *strDailyEventSubType;
@property(nonatomic,strong)NSString *strRepeatSting;
@property(nonatomic,strong)NSString *strEndDate;
@property(nonatomic,strong)NSString *strStartDate;
@property(nonatomic,strong)NSString *strEventEditBy;
@property(nonatomic,strong)NSString *strNoOfDaysWeekCase;
@property(nonatomic)BOOL CalendarMonthViewUpdate;


// strStartdate date for calculation strActualStartDate fix but finally use strStartdate
@property(nonatomic,strong)NSString *strActualStartDate;
@end
