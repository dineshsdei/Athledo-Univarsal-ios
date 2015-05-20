//
//  WorkoutHistoryDetails.m
//  Athledo
//
//  Created by Smartdata on 11/12/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "WorkoutHistoryDetails.h"
@interface WorkoutHistoryDetails ()
{
    NSDateFormatter *formatter;
}
@end
@implementation WorkoutHistoryDetails
- (void)viewDidLoad {
    self.title = NSLocalizedString(@"Workout History Detail", nil);
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    [super viewDidLoad];
    formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT_Y_M_D];
    
    if (_obj) {
        
        NSDate *date=[_obj valueForKey:@"date"] ?[formatter dateFromString:[_obj valueForKey:@"date"]]:nil;
        [formatter setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
        _lblName.text=[_obj valueForKey:@"name"] ?[_obj valueForKey:@"name"] : EMPTYSTRING;
        //  _lblCreatedBy.text=[_obj valueForKey:@"name"];
        _lblseason.text=[[_obj valueForKey:@"season"] isEqualToString:EMPTYSTRING] ? @"Off Season" :[_obj valueForKey:@"season"] ;
        _lblworkoutType.text=[_obj valueForKey:@"type"] ? [_obj valueForKey:@"type"]:EMPTYSTRING ;
        _lbldate.text=[formatter stringFromDate:date] ? [formatter stringFromDate:date] : EMPTYSTRING;
        _lbldescription.text=[_obj valueForKey:@"desc"] ? [_obj valueForKey:@"desc"] :EMPTYSTRING;
        _lblName.font=Textfont;
        _lblseason.font=SmallTextfont;
        _lbldescription.font=SmallTextfont;
        _lblworkoutType.font=SmallTextfont;
        _lblCreatedBy.font=SmallTextfont;
        _lbldate.font=SmallTextfont;
        _lbldescription.layer.borderWidth = .50;
        _lbldescription.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _lbldescription.layer.cornerRadius = 10;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
