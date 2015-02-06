//
//  ActiveIndicator.m
//
//  Created by am on 08/11/12.
//  Copyright (c) 2012 am. All rights reserved.
//

#import "ActiveIndicator.h"

@implementation ActiveIndicator

- (id)initActiveIndicator
{
    int toolBarPosition = [[UIScreen mainScreen] bounds].size.height;
    
    int X_Prosition;
    int Y_Position;
    
    UIDeviceOrientation deviceOrientation = [SingletonClass ShareInstance].GloableOreintation;
    if ((isIPAD) && ((deviceOrientation==UIDeviceOrientationLandscapeLeft) || (deviceOrientation==UIDeviceOrientationLandscapeRight || deviceOrientation==UIDeviceOrientationFaceUp)))
    {
        if (iosVersion < 8) {
            X_Prosition=[[UIScreen mainScreen] bounds].size.height/2-50;
            Y_Position=[[UIScreen mainScreen] bounds].size.width/2-50;
        }else{
            X_Prosition=[[UIScreen mainScreen] bounds].size.width/2-50;
            Y_Position=[[UIScreen mainScreen] bounds].size.height/2-50;
        }
    }else if ((isIPAD) &&(deviceOrientation==UIDeviceOrientationUnknown))
    {
        if (iosVersion < 8) {
            X_Prosition=[[UIScreen mainScreen] bounds].size.width/2-50;
            Y_Position=[[UIScreen mainScreen] bounds].size.height/2-50;
        }else{
            X_Prosition=[[UIScreen mainScreen] bounds].size.width/2-50;
            Y_Position=[[UIScreen mainScreen] bounds].size.height/2-50;
        }
        
    }else{
         X_Prosition=[[UIScreen mainScreen] bounds].size.width/2-50;
         Y_Position=[[UIScreen mainScreen] bounds].size.height/2-50;
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, toolBarPosition)];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoadingScreen.png"]];
    if (self)
    {
        UIView *progress;
        
        if (isIPAD) {
             progress = [[UIView alloc] initWithFrame:CGRectMake(X_Prosition, Y_Position, 100, 100)];
        }else{
             progress = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-40, self.frame.size.height/2-80, 80, 80)];
        }
    
        //progress.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_btn.png"]];
        progress.backgroundColor = [UIColor colorWithRed:35/255.0 green:47/255.0 blue:(58/255.0) alpha:1];
        progress.layer.cornerRadius = 10;
        
        progress.tag=222;
        UIActivityIndicatorView *actvity;
        UILabel *lblWaitPlease;
        if (isIPAD) {
            
            actvity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(35,20,30,30)];
            
            actvity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [actvity startAnimating];
            [progress addSubview:actvity];
            
            lblWaitPlease= [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 100,40)];
            lblWaitPlease.text = @"Loading...";
            lblWaitPlease.textColor = [UIColor whiteColor];
            lblWaitPlease.font = [UIFont boldSystemFontOfSize:18];
            lblWaitPlease.backgroundColor = [UIColor clearColor];
            lblWaitPlease.textAlignment = NSTextAlignmentCenter;
            
        }else{
            
            actvity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(25,20,30,30)];
            
            actvity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [actvity startAnimating];
            [progress addSubview:actvity];
            
             lblWaitPlease= [[UILabel alloc] initWithFrame:CGRectMake(2, 50, 80,30)];
            lblWaitPlease.text = @"Loading...";
            lblWaitPlease.textColor = [UIColor whiteColor];
            lblWaitPlease.font = [UIFont boldSystemFontOfSize:10];
            lblWaitPlease.backgroundColor = [UIColor clearColor];
            lblWaitPlease.textAlignment = NSTextAlignmentCenter;
        }
    
        [progress addSubview:lblWaitPlease];
//        [self addSubview:lblWaitPlease];
        [self addSubview:progress];
        [lblWaitPlease release];
        lblWaitPlease = nil;
        
        [actvity release];
        actvity = nil;
        
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
}


@end
