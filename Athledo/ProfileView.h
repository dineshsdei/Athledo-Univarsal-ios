//
//  ProfileView.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCell.h"
#import "AppDelegate.h"
#import "WebServiceClass.h"
#import "EditGenralInfo.h"



@interface ProfileView : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,AddProfileSelectionDelegate,WebServiceDelegate>
{
    IBOutlet UIImageView *imageviewProfile;
    
    __weak IBOutlet UIButton *btncamera;
    IBOutlet UITableView *tblProfile;
    WebServiceClass *Objwebcervice;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
}
@property(nonatomic)BOOL isUpdate;

- (IBAction)EditProfile:(id)sender;
- (IBAction)EditSavePIc:(id)sender;
@end
