//
//  SingaltonClass.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SingletonClassDelegate <NSObject>
-(void)Done;
@end

@interface SingletonClass : NSObject
{
    
}
@property(nonatomic,retain) id <SingletonClassDelegate> delegate;
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
@property(nonatomic)UIDeviceOrientation GloableOreintation;

+(SingletonClass *)ShareInstance;
+(BOOL)CheckConnectivity;
+(BOOL)emailValidate:(NSString *)email;
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1 btn2:(NSString *)btn2 btn3:(NSString *)btn3 tagNumber:(int)tagNum;
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1 btn2:(NSString *)btn2 tagNumber:(int)tagNum;
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1;
+(void)RemoveActivityIndicator:(UIView *)view;
+(void)addActivityIndicator :(UIView *)view;
+(void)setListPickerDatePickerMultipickerVisible :(BOOL)ShowHide :(id)picker :(UIToolbar *)toolbar;
+(void)setToolbarVisibleAt:(CGPoint)point :(id)toolbar;
-(void)SaveUserInformation :(NSString *)email :(NSString *)user_id :(NSString *)type :(NSString *)imageUrl :(NSString *)sender :(NSString *)team_id :(NSString *)sport_id;
-(NSDictionary *)GetUSerSaveData;
+(UIDeviceOrientation )getOrientation;
-(UIDeviceOrientation )CurrentOrientation :(id)controller;

+(UILabel *)ShowEmptyMessage :(NSString *)text;
+(void)deleteUnUsedLableFromTable :(UITableView *)table;

-(UIToolbar *)toolBarWithDoneButton:(UIView *)view;
-(void)doneClicked;
+(NSString *)DocumentDirectoryPath;

@end
