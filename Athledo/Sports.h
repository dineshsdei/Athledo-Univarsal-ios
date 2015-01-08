//
//  Sports.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/23/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sports : NSObject
@property(nonatomic,strong)NSString *athleteAge;
@property(nonatomic,strong)NSString *athleteHeight;
@property(nonatomic,strong)NSString *athleteWeight;
@property(nonatomic,strong)NSString *athleteClassYear;
+(Sports *)shareInstance;
@end
