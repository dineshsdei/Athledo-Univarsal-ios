//
//  Notes.h
//  Athledo
//
//  Created by Smartdata on 2/23/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AddNotes.h"
#import "AFHTTPRequestOperation.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface Notes : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,WebServiceDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *tableview;
    UIDocumentInteractionController *documentController;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
