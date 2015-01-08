//
//  ForgotPassword.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/21/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPassword : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txtFieldUserId;
    IBOutlet UINavigationBar *NavBar;

}
- (IBAction)submitdata:(id)sender;

@end
