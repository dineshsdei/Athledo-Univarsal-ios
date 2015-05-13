//
//  AAttendanceBO.h
//  Athledo
//
//  Created by Smartdata on 4/23/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAttendanceBO : NSObject
{
    
}
@property(nonatomic,retain)NSString *attendanceId;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,retain)NSString *imgUrl;
@property(nonatomic)BOOL isPresent;

+ (AAttendanceBO *)sharedInstance;
+ (void)resetSharedInstance;
@end
