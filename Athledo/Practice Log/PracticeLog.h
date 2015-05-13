//
//  PracticeLog.h
//  Athledo
//
//  Created by Smartdata on 5/11/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//
#import <TapkuLibrary/TapkuLibrary.h>
#import <UIKit/UIKit.h>
#import "AddPracticeLog.h"

@interface PracticeLog : TKCalendarMonthTableViewController<WebServiceDelegate>
@property(nonatomic,retain)TKCalendarMonthView *monthview;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *dataDictionary;
@end
