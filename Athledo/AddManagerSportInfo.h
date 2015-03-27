//
//  AddManagerSportInfo.h
//  Athledo
//
//  Created by Dinesh Kumar on 3/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "ProfileView.h"

@interface AddManagerSportInfo : UIViewController<UITextFieldDelegate,SingletonClassDelegate,UIPickerViewDataSource,UIPickerViewDelegate,WebServiceDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)id objData;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtSportName;
@property (strong, nonatomic) IBOutlet UITextField *txtHeight;
@property (strong, nonatomic) IBOutlet UITextField *txtHeightInches;
@property (strong, nonatomic) IBOutlet UITextField *txtweight;
@property (strong, nonatomic) IBOutlet UITextField *txtClassYear;
@property (strong, nonatomic) IBOutlet UITextField *txtLeague;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@end
