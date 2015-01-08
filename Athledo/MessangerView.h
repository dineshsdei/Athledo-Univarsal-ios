//
//  MessangerView.h
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"

#import "WebServiceClass.h"
#import "MessageInboxCell.h"
#import "SWTableViewCell.h"





@interface MessangerView : UIViewController <UITableViewDataSource,UITableViewDelegate,WebServiceDelegate,MessageViewCellDelegate,UITabBarDelegate,SWTableViewCellDelegate,UIAlertViewDelegate>
{
     WebServiceClass *webservice;
    NSMutableArray *arrMessages;
    
    IBOutlet UITableView *table;
    NSArray *messageArrDic;
    IBOutlet UITabBar *tabBar;
}



@end
