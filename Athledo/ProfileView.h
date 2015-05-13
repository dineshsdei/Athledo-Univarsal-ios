//
//  ProfileView.h
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCell.h"
#import "AppDelegate.h"
#import "WebServiceClass.h"
#import "EditGenralInfo.h"
#import "AddManagerSportInfo.h"




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
