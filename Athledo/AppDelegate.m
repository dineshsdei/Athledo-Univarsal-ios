//
//  AppDelegate.m
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVeiw.h"
#import "DashBoard.h"
#import "MenuListView.h"
#import "ProfileView.h"
#import "SWRevealViewController.h"
#import "ForgotPassword.h"
#import "AnnouncementView.h"

@interface AppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // First time call webservice or buffer data
    
    [SingletonClass ShareInstance].isAnnouncementUpdate=TRUE;
    
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0 blue:0 alpha:1.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont boldSystemFontOfSize:15],
      UITextAttributeFont, nil]];
    
    
	self.window = window;
     _arrCellFieldTag=[[NSMutableArray alloc] init];
    
    AnnouncementView *frontViewController = [[AnnouncementView alloc] initWithNibName:@"AnnouncementView" bundle:nil];
	MenuListView *rearViewController = [[MenuListView alloc] initWithNibName:@"MenuListView" bundle:nil];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    //[frontNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"profileBg.png"] forBarMetrics:UIBarMetricsDefault];
    //frontNavigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [frontNavigationController.navigationBar setBarTintColor:[UIColor colorWithRed:149/255.0 green:19/255.0 blue:27/255.0 alpha:1]];
    [frontNavigationController.navigationBar setTranslucent:NO];
    
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    [rearNavigationController.navigationBar setBarTintColor:[UIColor colorWithRed:149/255.0 green:19/255.0 blue:27/255.0 alpha:1]];
    [rearNavigationController.navigationBar setTranslucent:NO];
    
    //[rearNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg.png"] forBarMetrics:UIBarMetricsDefault];
   // rearNavigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    mainRevealController.delegate = self;
    
	self.viewController = mainRevealController;
    
    ForgotPassword *forgotPasswordView= [[ForgotPassword alloc] initWithNibName:@"ForgotPassword" bundle:nil];
    LoginVeiw *login=[[LoginVeiw alloc] initWithNibName:@"LoginVeiw" bundle:nil];
    DashBoard *Dash=[[DashBoard alloc] init];
    
    self.NavViewController = [[UINavigationController alloc] initWithRootViewController:login];
    
    self.NavViewController.viewControllers=[NSArray arrayWithObjects:mainRevealController,Dash,forgotPasswordView,login, nil];
    
   // [self.NavViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.NavViewController setNavigationBarHidden:YES];    // Override point for customization after application launch.
   
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"USERINFORMATION"];
    NSDictionary *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    if (user.count > 0) {
        
        UserInformation *userdata=[UserInformation shareInstance];
        
        userdata.userEmail=[user objectForKey:@"email"];
        userdata.userId=[[user objectForKey:@"id"] intValue];
        userdata.userType=[[user objectForKey:@"type"] intValue];
        userdata.userPicUrl=[user valueForKey:@"image"];
        userdata.userFullName=[user valueForKey:@"sender"];
        userdata.userSelectedTeamid =[[user objectForKey:@"team_id"] intValue];
        userdata.userSelectedSportid =[[user objectForKey:@"sport_id"] intValue];

        
        NSArray *arrController=[self.NavViewController viewControllers];
        
        for (id object in arrController)
        {
            if ([object isKindOfClass:[SWRevealViewController class]])
                [self.NavViewController popToViewController:object animated:NO];
            
        }
    }else{
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.NavViewController;
    //[self.window setRootViewController:self.NavViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.restrictRotation)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskAll;
}
+(void) restrictRotation:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = restriction;
}

- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}


- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
}

- (void)revealController:(SWRevealViewController *)revealController willRevealRearViewController:(UIViewController *)rearViewController
{

}

- (void)revealController:(SWRevealViewController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
}

- (void)revealController:(SWRevealViewController *)revealController willHideRearViewController:(UIViewController *)rearViewController
{
 
}

- (void)revealController:(SWRevealViewController *)revealController didHideRearViewController:(UIViewController *)rearViewController
{
}

- (void)revealController:(SWRevealViewController *)revealController willShowFrontViewController:(UIViewController *)rearViewController
{
}

- (void)revealController:(SWRevealViewController *)revealController didShowFrontViewController:(UIViewController *)rearViewController
{
}

- (void)revealController:(SWRevealViewController *)revealController willHideFrontViewController:(UIViewController *)rearViewController
{

}

- (void)revealController:(SWRevealViewController *)revealController didHideFrontViewController:(UIViewController *)rearViewController

{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
