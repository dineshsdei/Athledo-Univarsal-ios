//
//  AppDelegate.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWRevealViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *NavViewController;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property(nonatomic)BOOL isStart;
@property(nonatomic)BOOL isProfileUpdate;
@property(nonatomic)BOOL isProfilePicUpload;
@property (strong, nonatomic) NSMutableArray *arrCellFieldTag;
@property (nonatomic) BOOL restrictRotation;
+(void) restrictRotation:(BOOL) restriction;
@end
