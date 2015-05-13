//
//  MessageDetails.h
//  Athledo
//
//  Created by Smartdata on 9/10/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "WebServiceClass.h"

@interface MessageDetails : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource,WebServiceDelegate>
{
     WebServiceClass *webservice;
    
    NSArray *arrMessageConversation;
    NSArray *arrSenderids;
    
    int UserdataIndex;

}
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property(strong,nonatomic)NSString *webmail_id;
@property(strong,nonatomic)NSString *webmail_parent_id;
@end
