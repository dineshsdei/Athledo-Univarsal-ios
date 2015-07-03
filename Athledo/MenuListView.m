//
//  MenuLIstView.m
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//
#import "Notes.h"
#import "MenuListView.h"
#import "ProfileView.h"
#import "DashBoard.h"
#import "LoginVeiw.h"
#import "SWRevealViewController.h"
#import "AnnouncementView.h"
#import "WorkOutView.h"
#import "CalenderScheduleView.h"
#import "MessangerView.h"
#import "LoginVeiw.h"
#import "AppDelegate.h"
#import "WorkOutView.h"
#import "CalendarMainViewController.h"
#import "UIImageView+WebCache.h"
#import "CalendarMonthViewController.h"
#import "MultimediaVideo.h"
#import <QuartzCore/QuartzCore.h>
#import "MAWeekView.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "PracticeLog.h"


@class CalenderScheduleView;

//#define getNotificationTag 11110
#define NUM_TOP_ITEMS 3
#define NUM_SUBITEMS 4

@interface MenuListView ()
{
    NSArray *arrMenuList;
    NSArray *arrCoachMenu;
    NSArray *arrAthleteMenu;
    UserInformation *userInfo;
    NSArray *arrImagesName;
    UIImageView *ProfilePic;
    UILabel *lblLoginName;
    NSDictionary *notificationData;
    
}

@end

@implementation MenuListView
@synthesize rearTableView = _rearTableView;

#pragma mark Tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrMenuList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int cellHeight;
    cellHeight = (SCREEN_HEIGHT == 480 && !(isIPAD)) ? 38 : (SCREEN_HEIGHT == 568 ? 45 : ((SCREEN_HEIGHT > 568 && !(isIPAD)) ? 50 : (SCREEN_HEIGHT == 1024 ? 60 : 60)));
    
    if(isIPAD){
        return cellHeight;
    }else{
        return cellHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        UIImageView *cellImageView;
         cellImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20,(cell.frame.size.height/2)-(isIPAD ? 5: 15),30,30)];
        cellImageView.tag=101;
        [cell addSubview:cellImageView];
        cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"Cell_Bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        
        UILabel *profileLbl=[[UILabel alloc] initWithFrame:CGRectMake(60,(cell.frame.size.height/2)-(isIPAD ? 5: 15),200,30)];
        profileLbl.textAlignment=NSTextAlignmentLeft;
        profileLbl.tag=100;
        profileLbl.font=[UIFont boldSystemFontOfSize:18];
        profileLbl.textColor=NAVIGATION_COMPONENT_COLOR;
        profileLbl.backgroundColor=[UIColor clearColor];
        [cell addSubview:profileLbl];
        
        UILabel *lblShowUpdate=[[UILabel alloc] initWithFrame:CGRectMake(200,(cell.frame.size.height/2)-(isIPAD ? 0: 10),40,20)];
        lblShowUpdate.textAlignment=NSTextAlignmentCenter;
        lblShowUpdate.tag=110;
        lblShowUpdate.font=[UIFont boldSystemFontOfSize:13];
        lblShowUpdate.textColor=NAVIGATION_COMPONENT_COLOR;
        lblShowUpdate.backgroundColor=[UIColor colorWithRed:148/255.0 green:18/255.0 blue:27/255.0 alpha:1];
        [lblShowUpdate.layer setCornerRadius:5];
        lblShowUpdate.layer.masksToBounds=YES;
        [cell addSubview:lblShowUpdate];
    }
    UILabel *lbl=(UILabel *)[cell viewWithTag:100];
    UILabel *lblShowUpdate=(UILabel *)[cell viewWithTag:110];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    lbl.text=[arrMenuList objectAtIndex:indexPath.row];
    lbl.font=MenuTextfont;
    switch (indexPath.row) {
        case 0:{
            lblShowUpdate.hidden=NO;
            NSArray *arrTemp=[notificationData valueForKey:@"announcements"];
            if (arrTemp.count > 0)
                lblShowUpdate.text= [NSString stringWithFormat:@"%d",(int)arrTemp.count];
            else
                lblShowUpdate.hidden=YES;
            break;
        }
        case 1:{
            lblShowUpdate.hidden=NO;
            NSArray *arrTemp=[notificationData valueForKey:@"workouts"];
            if (arrTemp.count > 0)
                lblShowUpdate.text= [NSString stringWithFormat:@"%d",(int)arrTemp.count];
            else
                lblShowUpdate.hidden=YES;
            break;
        }
        case 2:{
            if([UserInformation shareInstance].userType == isAthlete){
                if ([[NSString stringWithFormat:@"%@",[notificationData valueForKey:@"message"]] intValue] > 0){
                    lblShowUpdate.hidden=NO;
                    lblShowUpdate.text= [NSString stringWithFormat:@"%d",[[notificationData valueForKey:@"message"] intValue]];
                }else
                    lblShowUpdate.hidden=YES;
            }else
                lblShowUpdate.hidden=YES;
            break;
        }
        case 4:{
            if([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger ){
                if ([[NSString stringWithFormat:@"%@",[notificationData valueForKey:@"message"]] intValue] > 0){
                    lblShowUpdate.hidden=NO;
                    lblShowUpdate.text= [NSString stringWithFormat:@"%d",[[notificationData valueForKey:@"message"] intValue]];
                }
                else
                    lblShowUpdate.hidden=YES;
            }else if([UserInformation shareInstance].userType == isAthlete){
                
                lblShowUpdate.hidden=NO;
                NSArray *arrTemp=[notificationData valueForKey:@"events"];
                if (arrTemp.count > 0)
                    lblShowUpdate.text= [NSString stringWithFormat:@"%d",(int)arrTemp.count];
                else
                    lblShowUpdate.hidden=YES;
            }
            break;
        }
        case 6:{
            if([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger ){
                lblShowUpdate.hidden=NO;
                NSArray *arrTemp=[notificationData valueForKey:@"events"];
                if (arrTemp.count > 0)
                    lblShowUpdate.text= [NSString stringWithFormat:@"%d",(int)arrTemp.count];
                else
                    lblShowUpdate.hidden=YES;
                break;
            }
        }
        default:{
            lblShowUpdate.hidden=YES;
            break;
        }
    }
    UIImageView *cellimage=(UIImageView *)[cell viewWithTag:101];
    [cellimage setImage:[self SetImage:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    lblLoginName.text=[UserInformation shareInstance].userFullName;
    [SingletonClass ShareInstance].isProfileSectionUpdate=TRUE;
    //[SingaltonClass ShareInstance].isAnnouncementUpdate=TRUE;
    [SingletonClass ShareInstance].isMessangerInbox=TRUE;
    [SingletonClass ShareInstance].isMessangerSent=TRUE;
    [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
    [SingletonClass ShareInstance].isCalendarUpdate=TRUE;
    [SingletonClass ShareInstance].isMessangerArchive=TRUE;
    [SingletonClass ShareInstance].isPracticeLogUpdate=TRUE;
    if ([UserInformation shareInstance].userType == isManeger || [UserInformation shareInstance].userType == isCoach) {
        [self isCoahOrManagerMoveToController:indexPath.row];
    }else{
        [self isAthleteOrOtherUserMoveToController:indexPath.row];
    }
}
#pragma mark - Calling method when cell seleted
-(void)isAthleteOrOtherUserMoveToController:(NSInteger)row{
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    UINavigationController *frontNavigationController =nil;
    
    if ( [frontViewController isKindOfClass:[UINavigationController class]] )
        frontNavigationController = (id)frontViewController;
    if (row == 0)
    {
        if ( ![frontNavigationController.topViewController isKindOfClass:[AnnouncementView class]] )
        {
            AnnouncementView *mapViewController = [[AnnouncementView alloc] initWithNibName:@"AnnouncementView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else
        {
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                AnnouncementView *mapViewController = [[AnnouncementView alloc] initWithNibName:@"AnnouncementView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                 [revealController revealToggleAnimated:YES];
            }
           
        }
    }
    else if (row == 1){
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[WorkOutView class]] ){
            WorkOutView *workoutViewController = [[WorkOutView alloc] initWithNibName:@"WorkOutView" bundle:nil];
            workoutViewController.notificationData=[notificationData valueForKey:@"workouts"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:workoutViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                WorkOutView *workoutViewController = [[WorkOutView alloc] initWithNibName:@"WorkOutView" bundle:nil];
                workoutViewController.notificationData=[notificationData valueForKey:@"workouts"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:workoutViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
               
            }else{
                [revealController revealToggleAnimated:YES];
            }

        }
    }
    else if (row == 2){
        if ( ![frontNavigationController.topViewController isKindOfClass:[MessangerView class]] )
        {
            MessangerView *ViewController = [[MessangerView alloc] initWithNibName:@"MessangerView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                MessangerView *ViewController = [[MessangerView alloc] initWithNibName:@"MessangerView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
                
            }else{
                [revealController revealToggleAnimated:YES];
            }
        }
    }else if (row == 3){

        if ( ![frontNavigationController.topViewController isKindOfClass:[PracticeLog class]] ){
            PracticeLog   *vc =  [[PracticeLog alloc] initWithSunday:YES];
             vc.comesFromMenuStatus = TRUE;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                PracticeLog   *vc =  [[PracticeLog alloc] initWithSunday:YES];
                 vc.comesFromMenuStatus = TRUE;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                    [SingletonClass ShareInstance].isUserLogOut = FALSE;
                    PracticeLog   *vc =  [[PracticeLog alloc] initWithSunday:YES];
                     vc.comesFromMenuStatus = TRUE;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                    [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                    [navigationController.navigationBar setTranslucent:NO];
                    [revealController pushFrontViewController:navigationController animated:YES];
                    
                }else{
                    [revealController revealToggleAnimated:YES];
                }
            }
           
        }
    }else if (row == 4){
        if ( ![frontNavigationController.topViewController isKindOfClass:[CalendarMainViewController class]] ){
            CalendarMonthViewController   *vc =  [[CalendarMonthViewController alloc] initWithSunday:YES];
            vc.objNotificationData=notificationData ;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                CalendarMonthViewController   *vc =  [[CalendarMonthViewController alloc] initWithSunday:YES];
                vc.objNotificationData=notificationData ;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];

                
            }else{
                [revealController revealToggleAnimated:YES];
            }
        }
    }else if (row == 5){
        if ( ![frontNavigationController.topViewController isKindOfClass:[MultimediaVideo class]] )
        {
            MultimediaVideo *frontViewController = [[MultimediaVideo alloc] initWithNibName:@"MultimediaVideo" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                MultimediaVideo *frontViewController = [[MultimediaVideo alloc] initWithNibName:@"MultimediaVideo" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
                
            }else{
                [revealController revealToggleAnimated:YES];
            }
        }
    }else if (row == 6){
        if ( ![frontNavigationController.topViewController isKindOfClass:[ProfileView class]] ){
            ProfileView *frontViewController = [[ProfileView alloc] initWithNibName:@"ProfileView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                ProfileView *frontViewController = [[ProfileView alloc] initWithNibName:@"ProfileView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
                
            }else{
                [revealController revealToggleAnimated:YES];
            }
        }
    }
}
-(void)isCoahOrManagerMoveToController:(NSInteger)row{
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    UINavigationController *frontNavigationController =nil;
    
    if ( [frontViewController isKindOfClass:[UINavigationController class]] )
        frontNavigationController = (id)frontViewController;
    if (row == 2)
    {
        if ( ![frontNavigationController.topViewController isKindOfClass:[Notes class]] )
        {
            Notes *notesViewController = [[Notes alloc] initWithNibName:@"Notes" bundle:nil];            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notesViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else
        {
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                Notes *notesViewController = [[Notes alloc] initWithNibName:@"Notes" bundle:nil];            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:notesViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];

            }else{
                [revealController revealToggleAnimated:YES];
  
            }
                    }
    }else if (row == 0){
        if ( ![frontNavigationController.topViewController isKindOfClass:[AnnouncementView class]] )
        {
            AnnouncementView *mapViewController = [[AnnouncementView alloc] initWithNibName:@"AnnouncementView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else
        {
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                AnnouncementView *mapViewController = [[AnnouncementView alloc] initWithNibName:@"AnnouncementView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                 [revealController revealToggleAnimated:YES];
            }
           
        }
    }
    else if (row == 1){
        if ( ![frontNavigationController.topViewController isKindOfClass:[WorkOutView class]] ){
            WorkOutView *workoutViewController = [[WorkOutView alloc] initWithNibName:@"WorkOutView" bundle:nil];
            workoutViewController.notificationData=[notificationData valueForKey:@"workouts"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:workoutViewController];
            
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                WorkOutView *workoutViewController = [[WorkOutView alloc] initWithNibName:@"WorkOutView" bundle:nil];
                workoutViewController.notificationData=[notificationData valueForKey:@"workouts"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:workoutViewController];
                
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                 [revealController revealToggleAnimated:YES];
            }
           
        }
    }
    else if (row == 3){
        if ( ![frontNavigationController.topViewController isKindOfClass:[SMSView class]] ){
            SMSView *ViewController = [[SMSView alloc] initWithNibName:@"SMSView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                SMSView *ViewController = [[SMSView alloc] initWithNibName:@"SMSView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
            
        }
    }
    else if (row == 4){
        if ( ![frontNavigationController.topViewController isKindOfClass:[MessangerView class]] ){
            MessangerView *ViewController = [[MessangerView alloc] initWithNibName:@"MessangerView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                MessangerView *ViewController = [[MessangerView alloc] initWithNibName:@"MessangerView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                  [revealController revealToggleAnimated:YES];
            }
          
        }
    }else if (row == 5){
        if ( ![frontNavigationController.topViewController isKindOfClass:[Attendance class]] ){
            Attendance *ViewController = [[Attendance alloc] initWithNibName:@"Attendance" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                Attendance *ViewController = [[Attendance alloc] initWithNibName:@"Attendance" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                 [revealController revealToggleAnimated:YES];
            }
           
        }
    }else if (row == 6){
        if ( ![frontNavigationController.topViewController isKindOfClass:[PracticeLog class]] ){
            PracticeLog   *vc =  [[PracticeLog alloc] initWithSunday:YES];
            vc.comesFromMenuStatus = TRUE;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            
        if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                PracticeLog   *vc =  [[PracticeLog alloc] initWithSunday:YES];
                vc.comesFromMenuStatus = TRUE;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
                   }
    }else if (row == 7){
        if ( ![frontNavigationController.topViewController isKindOfClass:[CalendarMainViewController class]] ){
            CalendarMonthViewController   *vc =  [[CalendarMonthViewController alloc] initWithSunday:YES];
            vc.objNotificationData=notificationData ;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                CalendarMonthViewController   *vc =  [[CalendarMonthViewController alloc] initWithSunday:YES];
                vc.objNotificationData=notificationData ;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                 [revealController revealToggleAnimated:YES];
            }
           
        }
    }else if (row == 8){
        if ( ![frontNavigationController.topViewController isKindOfClass:[MultimediaVideo class]] ){
            MultimediaVideo *frontViewController = [[MultimediaVideo alloc] initWithNibName:@"MultimediaVideo" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }else{
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                MultimediaVideo *frontViewController = [[MultimediaVideo alloc] initWithNibName:@"MultimediaVideo" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
                [revealController revealToggleAnimated:YES];
            }
        }
    }else if (row == 9){
        if ( ![frontNavigationController.topViewController isKindOfClass:[ProfileView class]] ){
            ProfileView *frontViewController = [[ProfileView alloc] initWithNibName:@"ProfileView" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
            [navigationController.navigationBar setTranslucent:NO];
            [revealController pushFrontViewController:navigationController animated:YES];
        }
        // Seems the user attempts to 'switch' to exactly the same controller he came from!
        else
        {
            if ([SingletonClass ShareInstance].isUserLogOut == TRUE){
                [SingletonClass ShareInstance].isUserLogOut = FALSE;
                ProfileView *frontViewController = [[ProfileView alloc] initWithNibName:@"ProfileView" bundle:nil];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [navigationController.navigationBar setBarTintColor:NAVIGATIONBAR_COLOR];
                [navigationController.navigationBar setTranslucent:NO];
                [revealController pushFrontViewController:navigationController animated:YES];
            }else{
            [revealController revealToggleAnimated:YES];
            }
        }
    }
}
#pragma mark Webservice response
//this method, get webservice response from web
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    // [SingaltonClass RemoveActivityIndicator:self.view];
    switch (Tag){
        case getNotificationTag:{
            notificationData=nil;
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                notificationData=[MyResults objectForKey:DATA];
            }
            [_rearTableView reloadData];
            break;
        }
    }
}
#pragma mark - View life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [self EnableDisableTouch:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    if (isIPAD){
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ChangeOrientation)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (isIPAD)
        [self ChangeOrientation];
    [self EnableDisableTouch:NO];
    userInfo=[UserInformation shareInstance];
    [ProfilePic setImageWithURL:[NSURL URLWithString:[UserInformation shareInstance].userPicUrl] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    switch (userInfo.userType) {
        case isCoach:{
            arrMenuList=[[NSArray alloc] initWithObjects:@"Announcements",@"Workouts",@"Notes",@"SMS",@"Messenger",@"Attendance",@"Practice Log",@"Calendar",@"Multimedia",@"Profile", nil];
            break;
        }
        case isAthlete:{
            arrMenuList=[[NSArray alloc] initWithObjects:@"Announcements",@"Workouts",@"Messenger",@"Practice Log",@"Schedule",@"Multimedia",@"Profile", nil];
            break;
        }
        case isManeger:{
            arrMenuList=[[NSArray alloc] initWithObjects:@"Announcements",@"Workouts",@"Notes",@"SMS",@"Messenger",@"Attendance",@"Practice Log",@"Calendar",@"Multimedia",@"Profile", nil];
            break;
        }
        default:
            arrMenuList=[[NSArray alloc] initWithObjects:@"Announcements",@"Workouts",@"Messenger",@"Practice Log",@"Schedule",@"Multimedia",@"Profile", nil];
            break;
    }
    if ([UserInformation shareInstance].userType == isCoach || [UserInformation shareInstance].userType == isManeger) {
        arrImagesName=[[NSArray alloc] initWithObjects:@"annouce_icon.png",@"workout_icon.png",@"notes.png",@"sms_icon.png",@"message_icon.png",@"attendance_icon.png",@"practice_icon.png",@"schedule_icon.png",@"multimedia_icon.png",@"profile_menu_icon.png", @"profile_menu_icon.png",nil];
    }else{
        arrImagesName=[[NSArray alloc] initWithObjects:@"update_menu_icon.png",@"workout_icon.png",@"message_icon.png",@"practice_icon.png",@"schedule_icon.png",@"multimedia_icon.png",@"profile_menu_icon.png",@"profile_menu_icon.png", nil];
    }
    [_rearTableView reloadData];
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    [self getNotificationData];
    lblLoginName.text=[UserInformation shareInstance].userFullName;
}
- (void)viewDidLoad{
    if (!(isIPAD)) {
        [AppDelegate restrictRotation:YES];
    }
    self.view.backgroundColor=[UIColor colorWithRed:41.0/255.0 green:58.0/255 blue:71.0/255 alpha:1];
    [super viewDidLoad];
    _btnLanscapLogout.hidden=YES;
    [self setNeedsStatusBarAppearanceUpdate];
    ProfilePic= [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    ProfilePic.layer.masksToBounds = YES;
    ProfilePic.layer.cornerRadius=15;
    
    UserInformation *userdata=[UserInformation shareInstance];
    UIBarButtonItem *BarItemEdit = [[UIBarButtonItem alloc] initWithCustomView:ProfilePic];
    lblLoginName=[[UILabel alloc] initWithFrame:CGRectMake(32,0,200,30)];
    lblLoginName.text=userdata.userFullName;
    lblLoginName.font=[UIFont boldSystemFontOfSize:15];
    lblLoginName.textColor=NAVIGATION_COMPONENT_COLOR;
    lblLoginName.backgroundColor=[UIColor clearColor];
    
    UIBarButtonItem *BarItemEdit1 = [[UIBarButtonItem alloc] initWithCustomView:lblLoginName];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:BarItemEdit,BarItemEdit1, nil];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:iv];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"profileBg.png"] forBarMetrics:UIBarMetricsDefault];
    self.rearTableView.backgroundColor=[UIColor clearColor];
    self.rearTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    int tableHeight =0;
    UIDeviceOrientation orentation = [[SingletonClass ShareInstance] CurrentOrientation:self];
    tableHeight = (SCREEN_HEIGHT == 480 && !(isIPAD)) ? 300 : (SCREEN_HEIGHT == 568 ? 460 : (orentation == UIDeviceOrientationPortrait) ? 970 : 700);
    self.rearTableView.frame = CGRectMake(self.rearTableView.frame.origin.x
                                          , self.rearTableView.frame.origin.y, self.rearTableView.frame.size.width, tableHeight);
    
    
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:grandParentRevealController action:@selector(revealToggle:)];
    if ( grandParentRevealController ){
        NSInteger level=0;
        UIViewController *controller = grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        NSString *title = [NSString stringWithFormat:@"Detail Level %ld", (long)level];
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;
    }
}
# pragma mark Notification method
//this method, call to get notification number to show on
-(void)getNotificationData{
    if ([SingletonClass  CheckConnectivity]) {
        userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];
        [webservice WebserviceCall:webServiceGetNotification :strURL :getNotificationTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)ChangeOrientation{
    UIDeviceOrientation deviceOrientation = [[SingletonClass ShareInstance] CurrentOrientation:self];
    if ((isIPAD) && ((deviceOrientation==UIDeviceOrientationLandscapeLeft) || (deviceOrientation==UIDeviceOrientationLandscapeRight || deviceOrientation==UIDeviceOrientationFaceUp))){
        _btnLanscapLogout.hidden=NO;
    }else{
        _btnLanscapLogout.hidden=YES;
    }
    [self.rearTableView reloadData];
}
#pragma mark Utility method
//this method, enable or disable touch on frontview in swip inout viewcontroller
-(void)EnableDisableTouch :(BOOL)status{
    NSArray *navArray=[[[self.revealViewController childViewControllers] objectAtIndex:1] viewControllers];
    for (UIViewController * viewCotroller in navArray) {
        WorkOutView *WorkviewCntrler  = (WorkOutView *)viewCotroller;
        NSArray *arrSubViews = (NSArray *) [WorkviewCntrler.view subviews];
        for (id object in arrSubViews) {
            if ([object isKindOfClass:[UITableView class]]) {
                UITableView *table= (UITableView *)object;
                table.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[UISearchBar class]]) {
                UISearchBar *searchBar= (UISearchBar *)object;
                searchBar.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[UITextField class]]) {
                UITextField *textField= (UITextField *)object;
                textField.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[UISegmentedControl class]]) {
                UISegmentedControl *segmentControll= (UISegmentedControl *)object;
                segmentControll.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[TKCalendarMonthView class]]) {
                TKCalendarMonthView *Controll= (TKCalendarMonthView *)object;
                Controll.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[TKCalendarDayView class]]) {
                TKCalendarDayView *Controll= (TKCalendarDayView *)object;
                Controll.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[MAWeekView class]]) {
                MAWeekView *Controll= (MAWeekView *)object;
                Controll.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[UITextView class]]) {
                UITextView *table= (UITextView *)object;
                table.userInteractionEnabled=status;
            }
            if ([object isKindOfClass:[MKMapView class]]) {
                MKMapView *Controll= (MKMapView *)object;
                Controll.userInteractionEnabled=status;
            }
        }
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

// This method, Add tableview cell images
-(UIImage *)SetImage:(NSInteger)index{
    UIImage *image;
    NSString *imageName=[arrImagesName objectAtIndex:index];
    image=[UIImage imageNamed:imageName];
    return image;
}
- (IBAction)logout:(id)sender {
    [SingletonClass ShareInstance].isProfileSectionUpdate=TRUE;
    [SingletonClass ShareInstance].isAnnouncementUpdate=TRUE;
    [SingletonClass ShareInstance].isMessangerInbox=TRUE;
    [SingletonClass ShareInstance].isMessangerSent=TRUE;
    [SingletonClass ShareInstance].isWorkOutSectionUpdate=TRUE;
    [SingletonClass ShareInstance].isUserLogOut = TRUE;

    notificationData=nil;
    [UserInformation resetSharedInstance];
    BOOL isLoginView=FALSE;
    NSArray *arrController=[self.navigationController viewControllers];
    for (id object in arrController){
        if ([object isKindOfClass:[LoginVeiw class]]){
            isLoginView=TRUE;
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
    if (isLoginView == FALSE){
        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginVeiw *login=[[LoginVeiw alloc] init];
        [delegate.NavViewController pushViewController:login animated:NO];
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
