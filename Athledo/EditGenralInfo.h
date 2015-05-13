//
//  EditGenralInfo.h
//  Athledo
//
//  Created by Smartdata on 9/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"

@interface EditGenralInfo : UIViewController<UITextFieldDelegate,UITextFieldDelegate,UIAlertViewDelegate,WebServiceDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UITableView *table;
    WebServiceClass *webservice;

    IBOutlet UIPickerView *listPicker;

    int scrollHeight;
    UIToolbar *toolBar;
    
 
}
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property(nonatomic,strong)id objData;
@end
