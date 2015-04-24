//
//  AAttendanceBO.h
//  Athledo
//
//  Created by Dinesh Kumar on 4/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
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
