//
//  CalendarMainViewController.m
//  Athledo
//
//  Created by Dinesh kumar on 01/08/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "CalendarMainViewController.h"
#import "CalenderScheduleView.h"
#import "CalendarMonthViewController.h"
#import "CalendarDayViewController.h"
#import "SWRevealViewController.h"
#import "WeekViewController.h"
#import "MapViewController.h"

#define getEventTag 119990
@interface CalendarMainViewController ()
{
WebServiceClass *webservice;
NSArray *startDateArr;
NSArray *endDateArr;
NSArray *eventArrDic;

}

@end

@implementation CalendarMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (instancetype) initWithStyle:(UITableViewStyle)s{
	if(!(self = [super initWithStyle:s])) return nil;
	self.title = @"Select Type";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	return self;
}

#define MONTH_GRID NSLocalizedString(@"Month View ", @"")
#define DAY_VIEW NSLocalizedString(@"Day View ", @"")
#define WEEK_VIEW NSLocalizedString(@"Week View ", @"")
#define MAP_VIEW NSLocalizedString(@"Map View ", @"")


#pragma mark Webservice call event
-(void)getEvents{
    
    if ([SingaltonClass  CheckConnectivity])
    {
        
    UserInformation *userInfo=[UserInformation shareInstance];

    NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];

    [SingaltonClass addActivityIndicator:self.view];

    [webservice WebserviceCall:webServiceGetEvents :strURL :getEventTag];


    }else{

    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }

}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingaltonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
    case getEventTag:
    {
    if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
    {// Now we Need to decrypt data

    eventArrDic =[MyResults objectForKey:@"data"];
    //NSLog(@"dict %@",eventArrDic);
    startDateArr = [[MyResults objectForKey:@"data"] valueForKey:@"start_date"];
    //NSLog(@"%@",startDateArr);
    endDateArr = [[MyResults objectForKey:@"data"] valueForKey:@"end_date"];
    //NSLog(@"%@",endDateArr);
    }
    }
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    
    [self getEvents];
    
    if ([UserInformation shareInstance].userType == 1)
    {
        self.title = NSLocalizedString(@"Calendar", nil);
    }else{
        self.title = NSLocalizedString(@"My Schedule", nil);
        
    }
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
     [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    self.data = @[
                  @{@"rows" : @[MONTH_GRID,DAY_VIEW,WEEK_VIEW,MAP_VIEW], @"title" : @""},];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor whiteColor];
   // self.tableView.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_bg.png"]];

}
#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.data[section][@"rows"] count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = self.data[indexPath.section][@"rows"][indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    cell.textLabel.textColor = [UIColor lightGrayColor];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=[UIColor clearColor];
    
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-2, 320, 1)];
    img1.image=[UIImage imageNamed:@"menu_sep.png"];
    
    [cell addSubview:img1];

	
    return cell;
}
- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
	UIViewController *vc;
	NSString *str = cell.textLabel.text;

    if([str isEqualToString:MONTH_GRID])
		vc = [[CalendarMonthViewController alloc] initWithSunday:YES];
	
	else if([str isEqualToString:DAY_VIEW])
		vc = CalendarDayViewController.new;
    else if ([str isEqualToString:WEEK_VIEW]){
        WeekViewController *weekView = [[WeekViewController alloc]initWithNibName:@"WeekViewController" bundle:[NSBundle mainBundle]];
        weekView.eventDic=(NSMutableArray *)eventArrDic;
        [self.navigationController pushViewController:weekView animated:YES];
    }
    else if ([str isEqualToString:MAP_VIEW]){
        MapViewController *mapView = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:mapView animated:YES];
    }
	if(self.calendarViewController && ([str isEqualToString:MONTH_GRID] || [str isEqualToString:DAY_VIEW]))
		[self.calendarViewController setupWithMainController:vc];
	else
		[self.navigationController pushViewController:vc animated:YES];
	
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.data[section][@"title"];
}
- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return self.data[section][@"footer"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
