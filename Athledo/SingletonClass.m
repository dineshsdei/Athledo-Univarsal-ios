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

+(void)addActivityIndicator :(UIView *)view
{
    ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
    indicator.tag = ACTIVITYTAG;
    [view addSubview:indicator];
}
+(void)RemoveActivityIndicator:(UIView *)view
{
    // Now remove the Active indicator
    ActiveIndicator *acti = (ActiveIndicator *)[view viewWithTag:ACTIVITYTAG];
    if(acti)
        [acti removeFromSuperview];
}

#pragma mark -manage control position 

+(void)setListPickerDatePickerMultipickerVisible :(BOOL)ShowHide :(id)picker :(UIToolbar *)toolbar
{
   
    CGPoint point;
    
    float SCREENWIDTH;
    float SCREENHEIGHT;
    
    UIDeviceOrientation orientation=[SingletonClass getOrientation];
    
    if (iosVersion < 8)
    {
        if (((orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight)))
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
    
    NSLog(@"screen height from gloable. %f",SCREENWIDTH);
    toolbar.frame=CGRectMake(SCREENWIDTH/2, SCREENHEIGHT+50, SCREENWIDTH, toolbar.frame.size.height);
    
    
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

+(void)setToolbarVisibleAt:(CGPoint)point :(id)toolbar
{
    UIDeviceOrientation orientation=[SingletonClass getOrientation];
    float SCREENWIDTH;
    float SCREENHEIGHT;
    
    if (iosVersion < 8)
    {
        if (((orientation==UIDeviceOrientationLandscapeLeft) || (orientation==UIDeviceOrientationLandscapeRight)))
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



@end
