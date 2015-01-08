//
//  SingaltonClass.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "SingaltonClass.h"
#import "Reachability.h"

static SingaltonClass *objSingaltonClass=nil;

@implementation SingaltonClass

+(SingaltonClass *)ShareInstance
{
    if (objSingaltonClass == nil) {
    
        objSingaltonClass=[[SingaltonClass alloc] init];
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

@end
