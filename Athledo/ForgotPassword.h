//
//  ForgotPassword.h
//  Athledo
//
//  Created by Smartdata on 7/21/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassword : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *txtFieldUserId;
    IBOutlet UINavigationBar *NavBar;

}
- (IBAction)submitdata:(id)sender;

@end
