//
//  AAttendanceBO.m
//  Athledo
//
//  Created by Smartdata on 4/23/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import "AAttendanceBO.h"

static AAttendanceBO *objAttendanceBO = nil;
@implementation AAttendanceBO
@synthesize attendanceId,imgUrl,userName,isPresent;

+ (AAttendanceBO *)sharedInstance
{
    if(objAttendanceBO == nil)
    {
        objAttendanceBO = [[AAttendanceBO alloc] init];
    }
    return objAttendanceBO;
}
+ (void)resetSharedInstance {
    objAttendanceBO = nil;
}
+ (void)setCurrentAttendance:(AAttendanceBO *)attendance
{
    objAttendanceBO = attendance;
}

-(id)init
{
    self = [super init];
    if (self)
    {   userName = @"";
        imgUrl = @"";
        attendanceId = @"";
        isPresent = YES;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:self.attendanceId forKey:@"Id"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isPresent] forKey:@"isCheck"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self= [super init]) {
        [self setAttendanceId:[aDecoder decodeObjectForKey:@"Id"]];
        [self setUserName:[aDecoder decodeObjectForKey:@"userName"]];
        [self setImgUrl:[aDecoder decodeObjectForKey:@"nickName"]];
        [self setIsPresent:[[aDecoder decodeObjectForKey:@"isCheck"] boolValue]];
    }
    return self;
}


@end
