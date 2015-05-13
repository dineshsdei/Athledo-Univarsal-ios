//
//  SentItemsView.h
//  Athledo
//
//  Created by Smartdata on 9/11/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "MessageInboxCell.h"
#import "SWTableViewCell.h"

@interface SentItemsView : UIViewController<UITableViewDataSource,UITableViewDelegate,WebServiceDelegate,MessageViewCellDelegate,UITabBarDelegate,SWTableViewCellDelegate>

{
    WebServiceClass *webservice;
    NSMutableArray *arrMessages;
    
    IBOutlet UITableView *table;
    NSArray *messageArrDic;
    
    IBOutlet UITabBar *tabBar;
    
}

@end
