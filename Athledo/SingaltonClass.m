//
//  SingaltonClass.m
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "SingaltonClass.h"
#import "Reachability.h"
#import "ALPickerView.h"

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

#pragma mark -manage control position 

+(void)setListPickerDatePickerMultipickerVisible :(BOOL)ShowHide :(id)picker :(UIToolbar *)toolbar
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=(SCREEN_WIDTH)/2;
    
    NSLog(@"screen height from gloable. %f",SCREEN_HEIGHT);
    
    
    if ([picker isKindOfClass:[UIDatePicker class]]) {
        
        UIDatePicker *pickerView=(UIDatePicker *)picker;
        if (ShowHide) {
            
            point.y=(SCREEN_HEIGHT)-(PickerHeight);
            [self setToolbarVisibleAt:CGPointMake(point.x,point.y-((PickerHeight)/2)-22):toolbar];
            
        }else{
            point.y=(SCREEN_HEIGHT)+(pickerView.frame.size.height/2);
           
        }
        
         pickerView.center = point;
    }else  if ([picker isKindOfClass:[ALPickerView class]]) {
        
        ALPickerView *pickerView=(ALPickerView *)picker;
        if (ShowHide) {
            
            point.y=(SCREEN_HEIGHT)-((PickerHeight));
            [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(pickerView.frame.size.height/2)-22):toolbar];
            
        }else{
            point.y=(SCREEN_HEIGHT)+(pickerView.frame.size.height/2);
        }
        
        pickerView.center = point;
    }else  if ([picker isKindOfClass:[UIPickerView class]]) {
        
        UIPickerView *pickerView=(UIPickerView *)picker;
        if (ShowHide) {
            
            point.y=(SCREEN_HEIGHT)-(PickerHeight);
            [self setToolbarVisibleAt:CGPointMake(point.x,point.y-((PickerHeight)/2)-22):toolbar];
            
        }else{
            point.y=(SCREEN_HEIGHT)+(pickerView.frame.size.height/2);
        }
        
        pickerView.center = point;
    }

    [UIView commitAnimations];
}

+(void)setToolbarVisibleAt:(CGPoint)point :(id)toolbar
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    
    UIToolbar *toolBar=(UIToolbar *)toolbar;
    
    toolBar.center = point;
    
    [UIView commitAnimations];
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



@end
