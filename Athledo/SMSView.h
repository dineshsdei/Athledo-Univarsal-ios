//
//  SMSView.h
//  Athledo
//
//  Created by Dinesh Kumar on 3/26/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSCustomCell.h"
#import "CheckboxButton.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "AthleteDetail.h"
#import "History.h"

@interface SMSView : UIViewController<UITableViewDataSource,UITableViewDelegate,CellDelegate,SingletonClassDelegate,WebServiceDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *ObjSegment;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectAll;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectAll;
@property (strong, nonatomic) NSMutableArray *arrFilterdData;
@property (strong, nonatomic) NSMutableArray *arrGroupFilterdData;
@property (weak, nonatomic) id keyboardAppear;
@property (weak, nonatomic) id keyboardHide;
@end
