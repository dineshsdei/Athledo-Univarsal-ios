//
//  Awards.h
//  Athledo
//
//  Created by Smartdata on 7/23/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Awards : NSObject
@property(nonatomic,strong)NSString *coachFirstAward;
@property(nonatomic,strong)NSString *coachYearAward;
@property(nonatomic,strong)NSString *coachAwardDesc;
+(Awards *)shareInstance;
@end
