//
//  AthleteDetail.m
//  Athledo
//
//  Created by Smartdata on 4/1/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import "AthleteDetail.h"
@interface AthleteDetail ()
@end
@implementation AthleteDetail
#pragma mark UIViewController Delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Athlete Information";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    [self SetField_Property_Data];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Utility Method
-(void)SetField_Property_Data
{
    @try {
        if (_objAthleteDetails != nil) {
            _lblName.font = Textfont;
            _lblPhone.font = Textfont;
            _lblState.font = Textfont;
            _lblZip.font = Textfont;
            _lblCity.font = Textfont;
            _lblCountry.font = Textfont;
            _lblAddress.font = Textfont;
            _lblClassYear.font = Textfont;
            _lblAge.font = Textfont;
            _lblemail.font = Textfont;
            _ProfilePic.layer.borderWidth = .05;
            _ProfilePic.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [_ProfilePic setImageWithURL:[NSURL URLWithString:[_objAthleteDetails valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
            _lblName.text = [[_objAthleteDetails valueForKey:@"firstname"] stringByAppendingFormat:@" %@",[_objAthleteDetails valueForKey:@"lastname"]] != nil ?[[_objAthleteDetails valueForKey:@"firstname"] stringByAppendingFormat:@" %@",[_objAthleteDetails valueForKey:@"lastname"]] : EMPTYSTRING;
            _lblPhone.text = [_objAthleteDetails valueForKey:@"cellphone"] != nil ? [_objAthleteDetails valueForKey:@"cellphone"] : EMPTYSTRING;
            _lblState.text = [_objAthleteDetails valueForKey:@"state"] != nil ? [_objAthleteDetails valueForKey:@"state"] : EMPTYSTRING;
            _lblCountry.text = [_objAthleteDetails valueForKey:@"country"] != nil ? [_objAthleteDetails valueForKey:@"country"] : EMPTYSTRING;
            _lblCity.text = [_objAthleteDetails valueForKey:@"city"] !=nil ? [_objAthleteDetails valueForKey:@"city"] : EMPTYSTRING;
            _lblZip.text = [_objAthleteDetails valueForKey:@"zip"] !=nil ? [_objAthleteDetails valueForKey:@"zip"] : EMPTYSTRING;
            _lblAddress.text = [_objAthleteDetails valueForKey:@"address"] !=nil ? [_objAthleteDetails valueForKey:@"address"] : EMPTYSTRING;
            _lblAge.text = [_objAthleteDetails valueForKey:@"age"] != nil ? [_objAthleteDetails valueForKey:@"age"] : EMPTYSTRING;
            _lblClassYear.text = [_objAthleteDetails valueForKey:@"class_year"] != nil ?[_objAthleteDetails valueForKey:@"class_year"] :EMPTYSTRING;
            _lblemail.text = [_objAthleteDetails valueForKey:@"email"] != nil ? [_objAthleteDetails valueForKey:@"email"] : EMPTYSTRING;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
