//
//  AddCoachingHistory.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/31/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"

@interface AddCoachingHistory : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,WebServiceDelegate>
{
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UITableView *tableView;
    
    IBOutlet UIPickerView *listPicker;
     WebServiceClass *webservice;
    
     int scrollHeight;
    UIToolbar *toolBar;
}
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property(nonatomic,strong)id objData;
@property(readwrite,nonatomic)NSString *strTitle;
@property(nonatomic)int SectionTag;
@end
