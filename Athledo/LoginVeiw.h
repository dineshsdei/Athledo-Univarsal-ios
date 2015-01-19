//
//  LoginVeiw.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface LoginVeiw : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
     int scrollHeight;
}
- (IBAction)ForgotPasswordClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *loginTableView;

@end
