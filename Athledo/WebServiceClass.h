//
//  WebResponse.h
//  Athledo
//
//  Created by Dinesh Kumar on 8/22/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WebServiceDelegate <NSObject>

-(void)WebserviceResponse :(NSMutableDictionary *)MyResults : (int)Tag;

@end
@interface WebServiceClass : NSObject

+(WebServiceClass *)shareInstance;
-(void)WebserviceCall : (NSString *)StrUrl  :(NSString *)strParameters :(int)Tag;
-(void)WebserviceCallwithDic :(NSDictionary*)DicData :(NSString *)StrUrl :(int)Tag;
@property(nonatomic,weak)id <WebServiceDelegate> delegate;
@end
