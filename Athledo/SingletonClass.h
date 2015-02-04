//
//  SingaltonClass.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonClass : NSObject
+(SingletonClass *)ShareInstance;
+(BOOL)CheckConnectivity;
+(BOOL)emailValidate:(NSString *)email;
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1 btn2:(NSString *)btn2 btn3:(NSString *)btn3 tagNumber:(int)tagNum;
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1 btn2:(NSString *)btn2 tagNumber:(int)tagNum;
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1;
+(void)RemoveActivityIndicator:(UIView *)view;
+(void)addActivityIndicator :(UIView *)view;
@property(nonatomic)BOOL isWorkOutSectionUpdate;
@property(nonatomic)BOOL isAnnouncementUpdate;
@property(nonatomic)BOOL isProfileSectionUpdate;
@property(nonatomic)BOOL isMessangerInbox;
@property(nonatomic)BOOL isMessangerSent;
@property(nonatomic)BOOL isMessangerArchive;
@property(nonatomic)BOOL isCalendarUpdate;

@property(nonatomic,strong)NSString *strCalendarEventType;
@property(nonatomic,strong)NSString *strCalendarRepeatSting;
@property(nonatomic,strong)NSString *strEventEndDate;

+(void)setListPickerDatePickerMultipickerVisible :(BOOL)ShowHide :(id)picker :(UIToolbar *)toolbar;
+(void)setToolbarVisibleAt:(CGPoint)point :(id)toolbar;
-(void)SaveUserInformation :(NSString *)email :(NSString *)user_id :(NSString *)type :(NSString *)imageUrl :(NSString *)sender :(NSString *)team_id :(NSString *)sport_id;
-(NSDictionary *)GetUSerSaveData;
+(UIDeviceOrientation )getOrientation;
+(UILabel *)ShowEmptyMessage :(NSString *)text;
+(void)deleteUnUsedLableFromTable :(UITableView *)table;

@end
