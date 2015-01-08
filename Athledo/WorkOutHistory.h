//
//  WorkOutHistory.h
//  Athledo
//
//  Created by Dinesh Kumar on 8/25/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "HistoryCell.h"

@interface WorkOutHistory : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,WebServiceDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIPickerView *listPicker;
    
    IBOutlet UITableView *tableview;
    
}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldSeason;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldWorkoutType;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldAthlete;

@end
