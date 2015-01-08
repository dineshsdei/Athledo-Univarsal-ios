//
//  EditProfileGenral.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/22/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"

@interface AddAthleteHistory : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,WebServiceDelegate>
{
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UITableView *tableView;
    
     WebServiceClass *webservice;
    int scrollHeight;
}
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property(nonatomic,strong)id objData;
@end
