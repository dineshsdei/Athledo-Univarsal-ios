//
//  DashBoard.m
//  Athledo
//
//  Created by Smartdata on 20/07/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "DashBoard.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"

#define CellHeight isIPAD ? 120 : 80

@interface DashBoard ()
{
    NSMutableArray *arrUserTeam;
    
    
}

@end

    BOOL isPush=FALSE;

@implementation DashBoard

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)MoveToReveal:(id)sender {
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    isPush=FALSE;
}

- (void)viewDidLoad
{
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dashboardTableView.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.dashboardTableView addGestureRecognizer:tap];
    [super viewDidLoad];
   
}

-(void)didTapOnTableView:(UIGestureRecognizer*) recognizer {
    
    CGPoint tapLocation = [recognizer locationInView:self.dashboardTableView];
    NSIndexPath *indexPath = [self.dashboardTableView indexPathForRowAtPoint:tapLocation];
   // NSLog(@"%d",CellHeight);
    // NSLog(@"%f",tapLocation.y );
   // NSLog(@"%d",((tapLocation.y) / CellHeight) );
     //NSLog(@"%d",indexPath.row);
    int touchlocation=tapLocation.y;
    int cellheight=CellHeight;
    int cellNO=(touchlocation /cellheight ) ;
    if ( cellNO > indexPath.row ) {
        
        return;
    }
    
    if (isPush==FALSE) {
    isPush=TRUE;
    @try {
        //NSLog(@"%d",indexPath.row);
         NSLog(@"%@",[UserInformation shareInstance].arrUserTeam);
      
    NSDictionary *team = [[UserInformation shareInstance].arrUserTeam objectAtIndex:indexPath.row] ;
    [UserInformation shareInstance].userSelectedTeamid =[[team objectForKey:KEY_TEAM_ID] intValue];
    [UserInformation shareInstance].userSelectedSportid =[[team objectForKey:KEY_SPORT_ID] intValue];
        
    SingletonClass *obj=[SingletonClass ShareInstance];
        NSDictionary *user=[obj GetUSerSaveData];
    [obj  SaveUserInformation:[user objectForKey:@"email"] :[user objectForKey:@"id"] :[user objectForKey:@"type"] :[user valueForKey:@"image"] :[user valueForKey:@"sender"] :[team objectForKey:KEY_TEAM_ID] :[team objectForKey:KEY_SPORT_ID]];
    

    NSArray *arrController=[self.navigationController viewControllers];

    for (id object in arrController) {
        if ([object isKindOfClass:[SWRevealViewController class]])
            
            [self.navigationController popToViewController:object animated:NO];
    }
    }
    @catch (NSException *exception) {

    }
    @finally {

    }

    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [UserInformation shareInstance].arrUserTeam.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"DashBoardCell";
    static NSString *CellNib = @"DashBoardCell";

    DashBoardCell *cell = (DashBoardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];

    if (isIPAD) {
     cell = (DashBoardCell *)[nib objectAtIndex:1];
    }else{
     cell = (DashBoardCell *)[nib objectAtIndex:0];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //[cell.contentView setUserInteractionEnabled:NO];
    }
    cell.teamName.textColor=[UIColor lightGrayColor];
    // [cell.teamName setFont:[UIFont boldSystemFontOfSize:15]];
    [cell.teamLogo setImageWithURL:[NSURL URLWithString:[[[UserInformation shareInstance].arrUserTeam objectAtIndex:indexPath.row] objectForKey:@"team_logo"] ] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
    cell.teamLogo.layer.masksToBounds = YES;
    if (isIPAD) {
    cell.teamLogo.layer.cornerRadius=50;
    }else
    {
    cell.teamLogo.layer.cornerRadius=30;
    }
    cell.teamName.text=[[[UserInformation shareInstance].arrUserTeam objectAtIndex:indexPath.row] objectForKey:@"team_name"];
    cell.teamName.textColor=[UIColor whiteColor];
    cell.teamName.font=Textfont;
    cell.teamDes.textColor=[UIColor whiteColor];
    cell.teamDes.font=SmallTextfont;
    cell.teamDes.text=[[[UserInformation shareInstance].arrUserTeam objectAtIndex:indexPath.row] objectForKey:@"team_desc"];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (isPush==FALSE) {

    isPush=TRUE;

    @try {

    NSDictionary *team = [[UserInformation shareInstance].arrUserTeam objectAtIndex:indexPath.row] ;
    [UserInformation shareInstance].userSelectedTeamid =[[team objectForKey:KEY_TEAM_ID] intValue];

    NSArray *arrController=[self.navigationController viewControllers];

    for (id object in arrController) {
    if ([object isKindOfClass:[SWRevealViewController class]])

    [self.navigationController popToViewController:object animated:NO];
    }

    }
    @catch (NSException *exception) {

    }
    @finally {

    }
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
