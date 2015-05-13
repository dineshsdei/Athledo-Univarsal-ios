//0
//  MessageDetails.m
//  Athledo
//
//  Created by Smartdata on 9/10/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "MessageDetails.h"

@interface MessageDetails ()

@end

@implementation MessageDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
   
    self.title = @"Messages";
    
    self.navigationController.navigationItem.leftItemsSupplementBackButton = NO;
    
    self.messages = [[NSMutableArray alloc] init];
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    [self getConversation];

    
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
}
#pragma mark Webservice call event
-(void)getConversation{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"webmail_id\":\"%d\",\"webmail_parent_id\":\"%d\"}",userInfo.userId,[_webmail_id intValue],[_webmail_parent_id intValue]];
        
        //[SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetConversation :strURL :getConversationTag];
        
    }else{
        
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
        
    }
}
-(void)sendConversation : (NSString * )description
{
    [SingletonClass ShareInstance].isMessangerSent =TRUE;
     [SingletonClass ShareInstance].isMessangerInbox =TRUE;
    
    NSString *strReceiver_id=EMPTYSTRING;
    
    for (int i= 0; i< arrSenderids.count; i++) {
        
        if (i != arrSenderids.count - 1) {
            
            strReceiver_id=[strReceiver_id stringByAppendingFormat:@"%@,", [arrSenderids objectAtIndex:i] ];
        }else{
             strReceiver_id=[strReceiver_id stringByAppendingFormat:@"%@", [arrSenderids objectAtIndex:i] ];
        }
    }
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        //{"user_id":"1", "webmail_id": "1" , "webmail_parent_id":"2", "description":"test reply to all", "receiver_id" :"27,52"}
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"webmail_id\":\"%d\",\"webmail_parent_id\":\"%d\",\"description\":\"%@\",\"receiver_id\":\"%@\"}",userInfo.userId,[_webmail_id intValue],[_webmail_parent_id intValue],description,strReceiver_id];
        
        //[SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceSendConversation :strURL :sendConversationTag];
        
    }else{
        
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
     }
    
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
        case getConversationTag:
        {
            
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {// Now we Need to decrypt data
                
               arrMessageConversation =[MyResults objectForKey:DATA];
                
                for (int i=0 ; i < arrMessageConversation.count; i++) {
                    
                    [self.messages addObject: [[arrMessageConversation objectAtIndex:i] valueForKey:@"desc"]];
                }
                arrSenderids=[MyResults objectForKey:@"receiver_id"];
                [self.tableView reloadData];
            }
            
            break;
        }
        case sendConversationTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                // Now we Need to decrypt data
 
            }
             break;
        }
        
    }
}

- (void)buttonPressed:(UIButton*)sender
{
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self sendConversation : text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
    
    if (arrMessageConversation.count > indexPath.row) {
        if ([UserInformation shareInstance].userId == [[[arrMessageConversation objectAtIndex:indexPath.row] valueForKey:@"sender_id"] intValue]) {
            
            return  JSBubbleMessageTypeOutgoing;
        }else{
            
            return  JSBubbleMessageTypeIncoming;
        }
    }else
    {
         return  JSBubbleMessageTypeOutgoing;
    }

}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleSquare;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
// - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self hasTimestampForRowAtIndexPath:indexPath];
//    return (indexPath.row > self.timestamps.count)  ? [NSDate date] : [self.timestamps objectAtIndex:indexPath.row];
    return [NSDate date] ;
}
-(NSString *)setImageWithUrl:(int)index
{
    if (arrMessageConversation.count > index)
    {
        if ([UserInformation shareInstance].userId == [[[arrMessageConversation objectAtIndex:index] valueForKey:@"sender_id"] intValue]) {
            UserdataIndex=index;
        }
        return [[arrMessageConversation objectAtIndex:index] valueForKey:@"image"];
    }else
    {
        if (UserdataIndex > 0 ) {
             return [[arrMessageConversation objectAtIndex:UserdataIndex] valueForKey:@"image"];
        }else
             return EMPTYSTRING;
    }
}
// Use this method when satatic images shows
// Uncommnet method from tableview cell

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}
// Use this method when satatic images shows
// Uncommnet method from tableview cell
- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
