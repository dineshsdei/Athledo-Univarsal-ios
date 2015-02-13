//
//  SingaltonClass.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "SingletonClass.h"
#import "Reachability.h"
#import "ALPickerView.h"

static SingletonClass *objSingaltonClass=nil;

@implementation SingletonClass

+(SingletonClass *)ShareInstance
{
    if (objSingaltonClass == nil) {
        
        objSingaltonClass=[[SingletonClass alloc] init];
    }
    return objSingaltonClass;
    
}

#pragma mark- UIAlertview
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1 btn2:(NSString *)btn2 btn3:(NSString *)btn3 tagNumber:(int)tagNum
{
    CustomAlertMessage *al = [[CustomAlertMessage alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:btn1 otherButtonTitles:btn2,btn3, nil];
    al.tag = tagNum;
    [al show];
    
}
+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1 btn2:(NSString *)btn2 tagNumber:(int)tagNum
{
    CustomAlertMessage *al = [[CustomAlertMessage alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:btn1 otherButtonTitles:btn2, nil];
    al.tag = tagNum;
    [al show];
    
}

+(void)initWithTitle:(NSString *)title message:(NSString *)msg delegate:(id)del btn1:(NSString *)btn1
{
    CustomAlertMessage *al = [[CustomAlertMessage alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:btn1 otherButtonTitles:nil];
    [al show];
    
}


#pragma mark- Network Status
+(BOOL)CheckConnectivity
{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    
    [internetReach startNotifier];
    BOOL Status = [self updateInterfaceWithReachability:internetReach];
    // BOOL Status = NO;
    return Status;
    
}

+ (BOOL)updateInterfaceWithReachability:(Reachability*) curReach
{
    BOOL Status;
    if(curReach)
    {
        Status = [self getInternetStatus: curReach];
        
    }else{
        Status=NO;
    }
    
    return Status;
}

+(BOOL)getInternetStatus:(Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach connectionRequired];
    switch (netStatus)
    {
        case NotReachable:
            connectionRequired= NO;
            break;
            
        case ReachableViaWWAN:
            connectionRequired= YES;
            break;
        case ReachableViaWiFi:
            connectionRequired= YES;
            break;
    }
    return connectionRequired;
}

//Called by Reachability whenever status changes.
+(void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

#pragma mark- EmailValidate
+(BOOL)emailValidate:(NSString *)email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    return [regExPredicate evaluateWithObject:email];
}
#pragma Show Empty Data Messsage in lable
+(void)deleteUnUsedLableFromTable :(UITableView *)table
{
    UILabel *lblTemp= (UILabel *)[table viewWithTag:emptyLableMessagesTag];
    if (lblTemp !=nil) {
        [lblTemp removeFromSuperview];
    }
}
+(UILabel *)ShowEmptyMessage :(NSString *)text
{
    UILabel *lblShowEmptyMessage;
    
    UIDeviceOrientation orientation=[SingletonClass getOrientation];
    float SCREENWIDTH;
    float SCREENHEIGHT;
    
    if (iosVersion < 8)
    {
        if (((orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight)) && (isIPAD))
        {
            SCREENWIDTH=[[UIScreen mainScreen] bounds].size.height;
            SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.width;
            
        }else{
            SCREENWIDTH=[[UIScreen mainScreen] bounds].size.width;
            SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.height;
        }
    }else{
        
        SCREENWIDTH=[[UIScreen mainScreen] bounds].size.width;
        SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.height;
        
    }
    
    lblShowEmptyMessage=[[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-150, SCREENHEIGHT/3,300, 100)];
    lblShowEmptyMessage.text=text;
    lblShowEmptyMessage.tag=emptyLableMessagesTag;
    lblShowEmptyMessage.textAlignment=NSTextAlignmentCenter;
    lblShowEmptyMessage.font=(isIPAD )?[UIFont systemFontOfSize:30] : [UIFont systemFontOfSize:24] ;
    lblShowEmptyMessage.textColor=[UIColor grayColor];
    
    return lblShowEmptyMessage;
}

#pragma Add/Remove ActivityIndicator

+(void)addActivityIndicator :(UIView *)view
{
    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    indicator.tag = ACTIVITYTAG;
    [view addSubview:indicator];
}
+(void)RemoveActivityIndicator:(UIView *)view
{
    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[view viewWithTag:ACTIVITYTAG];
    // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    if(acti)
        [acti removeFromSuperview];
}

#pragma mark -manage control position

+(void)setListPickerDatePickerMultipickerVisible :(BOOL)ShowHide :(id)picker :(UIToolbar *)toolbar
{
    @try {
        
        CGPoint point;
        
        float SCREENWIDTH;
        float SCREENHEIGHT;
        
        UIDeviceOrientation orientation=[SingletonClass ShareInstance].GloableOreintation;
        
        if (iosVersion < 8)
        {
            if (((orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight || orientation==UIDeviceOrientationFaceUp)) && (isIPAD))
            {
                SCREENWIDTH=[[UIScreen mainScreen] bounds].size.height;
                SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.width;
                
            }else{
                SCREENWIDTH=[[UIScreen mainScreen] bounds].size.width;
                SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.height;
            }
        }else{
            
            SCREENWIDTH=[[UIScreen mainScreen] bounds].size.width;
            SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.height;
            
        }
        
        point.x=(SCREENWIDTH)/2;
        if ([picker isKindOfClass:[UIDatePicker class]]) {
            
            UIDatePicker *pickerView=(UIDatePicker *)picker;
            pickerView.frame=CGRectMake(SCREENWIDTH/2, SCREENHEIGHT+50, SCREENWIDTH, PickerHeight);
            if (ShowHide) {
                
                point.y=(SCREENHEIGHT+15)-(PickerHeight);
                [self setToolbarVisibleAt:CGPointMake(point.x,point.y-((PickerHeight)/2)-22):toolbar];
                
            }else{
                point.y=(SCREENHEIGHT)+(pickerView.frame.size.height+350);
                
            }
            
            pickerView.center= point;
            
        }else  if ([picker isKindOfClass:[ALPickerView class]]) {
            
            ALPickerView *pickerView=(ALPickerView *)picker;
            if (iosVersion < 8) {
                //pickerView.frame=CGRectMake(SCREENWIDTH/2, SCREENHEIGHT+50, SCREENWIDTH, PickerHeight);
            }
            
            if (ShowHide) {
                point.y=(SCREENHEIGHT+15)-((PickerHeight));
                [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(pickerView.frame.size.height/2)-22):toolbar];
                
            }else{
                point.y=(SCREENHEIGHT)+(pickerView.frame.size.height+350);
            }
            
            pickerView.center = point;
        }else  if ([picker isKindOfClass:[UIPickerView class]]) {
            
            UIPickerView *pickerView=(UIPickerView *)picker;
            //if (iosVersion < 8) {
            pickerView.frame=CGRectMake(SCREENWIDTH/2, SCREENHEIGHT+50, SCREENWIDTH, PickerHeight);
            //}
            
            if (ShowHide) {
                
                point.y=(SCREENHEIGHT+15)-(PickerHeight);
                [self setToolbarVisibleAt:CGPointMake(point.x,point.y-((PickerHeight)/2)-22):toolbar];
                
            }else{
                point.y=(SCREENHEIGHT)+(pickerView.frame.size.height+350);
            }
            pickerView.center = point;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+(void)setToolbarVisibleAt:(CGPoint)point :(id)toolbar
{
    @try {
        UIDeviceOrientation orientation=[SingletonClass ShareInstance].GloableOreintation;
        float SCREENWIDTH;
        float SCREENHEIGHT;
        
        if (iosVersion < 8)
        {
            if (((orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight || orientation==UIDeviceOrientationFaceUp)) && (isIPAD))
            {
                SCREENWIDTH=[[UIScreen mainScreen] bounds].size.height;
                SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.width;
                
            }else{
                SCREENWIDTH=[[UIScreen mainScreen] bounds].size.width;
                SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.height;
            }
        }else{
            
            SCREENWIDTH=[[UIScreen mainScreen] bounds].size.width;
            SCREENHEIGHT=[[UIScreen mainScreen] bounds].size.height;
            
        }
        
        UIToolbar *toolBar=(UIToolbar *)toolbar;
        toolBar.frame=CGRectMake(SCREENWIDTH/2, SCREENHEIGHT+50, SCREENWIDTH, toolBar.frame.size.height);
        toolBar.center = point;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(NSDictionary *)GetUSerSaveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"USERINFORMATION"];
    NSDictionary *Dic = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    return Dic;
}
-(void)SaveUserInformation :(NSString *)email :(NSString *)user_id :(NSString *)type :(NSString *)imageUrl :(NSString *)sender :(NSString *)team_id :(NSString *)sport_id
{
    NSMutableDictionary *Userdata;
    if (![team_id isEqualToString:@""]) {
        Userdata =[[NSMutableDictionary alloc] initWithObjects:@[email,user_id,type,imageUrl,sender,team_id,sport_id] forKeys:@[@"email",@"id",@"type",@"image",@"sender",@"team_id",@"sport_id"]];
    }else{
        
        Userdata =[[NSMutableDictionary alloc] initWithObjects:@[email,user_id,type,imageUrl,sender,] forKeys:@[@"email",@"id",@"type",@"image",@"sender"]];
    }
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:Userdata];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"USERINFORMATION"];
    [defaults synchronize];
    
}

+(UIDeviceOrientation )getOrientation
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    return deviceOrientation;
}
-(UIDeviceOrientation )CurrentOrientation :(id)controller
{
    UIViewController *viewcontroller=(UIViewController *)controller;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    // NSString *device = [[UIDevice currentDevice]localizedModel];
    UIInterfaceOrientation cachedOrientation = [viewcontroller preferredInterfaceOrientationForPresentation];
    
    if (orientation == UIDeviceOrientationUnknown ||
        orientation == UIDeviceOrientationFaceUp ||
        orientation == UIDeviceOrientationFaceDown) {
        
        orientation = (UIDeviceOrientation)cachedOrientation;
    }
    
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        
        orientation=UIDeviceOrientationLandscapeLeft;
    }
    
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        orientation=UIDeviceOrientationPortrait;
    }
    _GloableOreintation=orientation;
    return orientation;
}
@end
