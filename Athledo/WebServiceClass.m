//
//  WebResponse.m
//  Athledo
//
//  Created by Dinesh Kumar on 8/22/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "WebServiceClass.h"

@implementation WebServiceClass

@synthesize delegate;

static WebServiceClass *objWebService=nil;

+(WebServiceClass *)shareInstance
{
    if (objWebService == nil) {
        objWebService=[[WebServiceClass alloc] init];
    }
    return objWebService;
}

-(void)WebserviceCall : (NSString *)StrUrl  :(NSString *)strParameters :(int)Tag
{
    if ([SingletonClass  CheckConnectivity]) {
    @try {
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StrUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSMutableData *data = [NSMutableData data];
    [data appendData:[[NSString stringWithString:strParameters] dataUsingEncoding: NSUTF8StringEncoding]];
    [request setHTTPBody:data];
    [NSURLConnection sendAsynchronousRequest:request
    queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
  
    if (data!=nil)
    {
    [self httpResponseReceived : data :Tag];
    }else{
    }
    }  ];
    }
    @catch (NSException *exception) {

    }
    @finally {
    }
    }else{
    [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}

-(void)WebserviceCallwithDic :(NSDictionary*)DicData :(NSString *)StrUrl :(int)Tag
{
    if ([SingletonClass  CheckConnectivity]) {

    @try {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:DicData options:0 error:NULL];
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:StrUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableData *data = [NSMutableData data];

    [data appendData:jsonData];
    [request setHTTPBody:data];

    [NSURLConnection sendAsynchronousRequest:request
       queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

    if (data!=nil)
    {
    [self httpResponseReceived : data :Tag];
    }else{
    }
    }  ];
        
    }
    @catch (NSException *exception) {

    }
    @finally {

    }
    }else{

    [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];

    }
}
-(void)httpResponseReceived :(NSData *)webResponse :(int)Tag
{
   NSError *error=nil;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    
    [delegate WebserviceResponse:myResults :Tag];
}
@end
