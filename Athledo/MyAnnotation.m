//
//  MyAnnotation.m
//  Athledo
//
//  Created by Smartdata on 10/14/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize date = _date;
@synthesize coordinate = _coordinate;
@synthesize statusAction =  _statusAction;
@synthesize tagNumber = _tagNumber;

-(void)setTitle:(NSString *)title{
    _title = title;
}
-(void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
}

@end
