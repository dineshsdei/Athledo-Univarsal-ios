//
//  CalenderScheduleView.m
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "CalenderScheduleView.h"
#import "SWRevealViewController.h"

@interface CalenderScheduleView ()

@end

@implementation CalenderScheduleView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) setupWithMainController:(UIViewController*)controller{
    
    self.mainController = controller;
}
- (void) splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.currentPopoverController = pc;
}
- (void) splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil;
}
#pragma mark TableView Delegate & Data Source
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end
