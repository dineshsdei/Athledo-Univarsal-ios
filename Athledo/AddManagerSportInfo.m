//
//  AddManagerSportInfo.m
//  Athledo
//
//  Created by Dinesh Kumar on 3/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "AddManagerSportInfo.h"

@interface AddManagerSportInfo ()

@end

@implementation AddManagerSportInfo
#pragma mark UIViewController Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self FieldsSetProperty];
      // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Class Utility Method

-(void)FieldsSetProperty
{
    _txtSportName.layer.borderWidth = .5;
    _txtweight.layer.borderWidth = .5;
    _txtLeague.layer.borderWidth = .5;
    _txtClassYear.layer.borderWidth = .5;
    _txtweight.layer.borderWidth = .5;
    _txtHeightInches.layer.borderWidth = .5;
    _txtHeight.layer.borderWidth = .5;
    _txtSportName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtweight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtLeague.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtClassYear.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtweight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtHeightInches.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtHeight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _txtSportName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtSportName.leftViewMode = UITextFieldViewModeAlways;
    _txtweight.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtweight.leftViewMode = UITextFieldViewModeAlways;
    _txtLeague.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtLeague.leftViewMode = UITextFieldViewModeAlways;
    _txtClassYear.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtClassYear.leftViewMode = UITextFieldViewModeAlways;
    _txtHeight.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtHeight.leftViewMode = UITextFieldViewModeAlways;
    _txtHeightInches.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PadingW, PadingH)];
    _txtHeightInches.leftViewMode = UITextFieldViewModeAlways;

}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
