//
//  WorkoutHistoryDetails.m
//  Athledo
//
//  Created by Dinesh Kumar on 11/12/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WorkoutHistoryDetails.h"

@interface WorkoutHistoryDetails ()
{
    NSDateFormatter *formatter;
}

@end

@implementation WorkoutHistoryDetails

- (void)viewDidLoad {
    
    self.title = NSLocalizedString(@"Workout History Details", nil);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    [super viewDidLoad];
    
    formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D];
    
    if (_obj) {
    
    NSDate *date=[_obj valueForKey:@"date"] ?[formatter dateFromString:[_obj valueForKey:@"date"]]:nil;
    [formatter setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
    _lblName.text=[_obj valueForKey:@"name"] ?[_obj valueForKey:@"name"] : @"";
    //  _lblCreatedBy.text=[_obj valueForKey:@"name"];
    _lblseason.text=[[_obj valueForKey:@"season"] isEqualToString:@""] ? @"Off Season" :[_obj valueForKey:@"season"] ;
    _lblworkoutType.text=[_obj valueForKey:@"type"] ?[_obj valueForKey:@"type"]:@"" ;
    _lbldate.text=[formatter stringFromDate:date] ? [formatter stringFromDate:date] : @"";
    _lbldescription.text=[_obj valueForKey:@"desc"] ? [_obj valueForKey:@"desc"] :@"";
    
    _lblName.font=Textfont;
    _lblseason.font=SmallTextfont;
    _lbldescription.font=SmallTextfont;
    _lblworkoutType.font=SmallTextfont;
    _lblCreatedBy.font=SmallTextfont;
    _lbldate.font=SmallTextfont;

    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
