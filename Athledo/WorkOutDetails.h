//
//  WorkOutDetails.h
//  Athledo
//
//  Created by Dinesh Kumar on 9/24/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "CustomTextField.h"

@interface WorkOutDetails : UIViewController<WebServiceDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    WebServiceClass *webservice;
    
    IBOutlet UITableView *table;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIPickerView *listPicker;
    __weak IBOutlet UIButton *btnSave;
       int scrollHeight;
      
     
}
@property(nonatomic)BOOL NotificationStataus;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property (weak, nonatomic) IBOutlet UIImageView *dropdownImageview;
@property (weak, nonatomic) IBOutlet UITextField *tfSelectUserType;
//+ (void)setContentOffset:(id)textField table:(UITableView*)m_TableView;
+ (void)setContentOffsetOfScrollView:(id)textField table:(UIScrollView*)m_TableView ;
@property (strong, nonatomic) id obj;
@property(strong,nonatomic)IBOutlet UIImageView *imgCreatedBy;
@property(strong,nonatomic)IBOutlet UILabel *lblCreatedBy;
@property(strong,nonatomic)IBOutlet UILabel *lblWorkOutName;
@property(strong,nonatomic)IBOutlet UILabel *lblSeasion;
@property(strong,nonatomic)IBOutlet UILabel *lblWorkoutType;
@property(strong,nonatomic)IBOutlet UILabel *lblWorkoutDate;
@property(strong,nonatomic)IBOutlet UILabel *lblMeOrALl;
@property(strong,nonatomic)IBOutlet UITextView *txtViewDescription;
@end
