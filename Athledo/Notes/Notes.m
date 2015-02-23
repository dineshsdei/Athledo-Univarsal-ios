//
//  Notes.m
//  Athledo
//
//  Created by Dinesh Kumar on 2/23/15.
//  Copyright (c) 2015 Dinesh. All rights reserved.
//

#import "Notes.h"
#import "NoteCell.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface Notes ()
{
    NSArray *arrNotesData;
    SWRevealViewController *revealController;
    UIBarButtonItem *revealButtonItem;
}

@end

@implementation Notes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Notes";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Dinesh",@"name",@"8 Stroke",@"workoutName",@"rewewe",@"image", nil];
    
    arrNotesData=[[NSArray alloc] initWithObjects:dic1, nil];
    
    UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageAdd=[UIImage imageNamed:@"download.png"];
    btnDownload.bounds = CGRectMake( 0, 0, imageAdd.size.width, imageAdd.size.height );
    [btnDownload addTarget:self action:@selector(SharePDF) forControlEvents:UIControlEventTouchUpInside];
    [btnDownload setImage:imageAdd forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnDownload];
    
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(150, 5, 44, 44)];
    UIImage *imageHistory=[UIImage imageNamed:@"download.png"];
    [btnShare addTarget:self action:@selector(DownloadPDF) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setImage:imageHistory forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemHistory = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemAdd,BarItemHistory, nil];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor lightGrayColor];

    
    
    
    
}
-(void)DownloadPDF
{
    
}

-(void)SharePDF
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrNotesData.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"NotesCell";
    static NSString *CellNib = @"NoteCell";
    
    NoteCell *cell = (NoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (NoteCell *)[nib objectAtIndex:0];
    }
    
    cell.lblName.text=[[arrNotesData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.lblWorkoutName.text=[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"workoutName"];
    cell.lblName.font=Textfont;
    cell.lblWorkoutName.font=SmallTextfont;
    [cell.teamMemberPic setImageWithURL:[NSURL URLWithString:[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
    cell.teamMemberPic.layer.masksToBounds = YES;
    cell.teamMemberPic.layer.cornerRadius=(cell.teamMemberPic.frame.size.width)/2;
    cell.teamMemberPic.layer.borderWidth=2.0f;
    cell.teamMemberPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.rightUtilityButtons = [self rightButtons : indexPath.section];
    cell.delegate=self;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddNotes *addNotes = [[AddNotes alloc] initWithNibName:@"AddNotes" bundle:nil];
    [self.navigationController pushViewController:addNotes animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD)
    return 120;
    else
    return 81;
}

#pragma SWTableviewCell delegate

- (NSArray *)rightButtons :(NSInteger)btnTag
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"download.png"] :(int)btnTag];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:41/255.0 green:58/255.0 blue:71/255.0 alpha:1.0] icon:[UIImage imageNamed:@"download.png"] :(int)btnTag];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:0];
    
    switch (index) {
        case 0:
        {
            [self DownloadSelectedUserPDF:btn.tag];
            
            break;
        }
        case 1:
        {
            
            [self ShareSelectedUserPDF:btn.tag];
            
            break;
        }
        default:
            break;
    }
}

-(void)DownloadSelectedUserPDF :(int)userTag
{
    
}
-(void)ShareSelectedUserPDF :(int)userTag
{
    
}
#pragma SearchBar Delegate



-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
     searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
     searchBar.showsCancelButton=YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar
{
    @try {
        
        if(theSearchBar.text.length>0)
        {
            if ([SingletonClass  CheckConnectivity]) {
                
                //Check for empty Text box
                NSString *strError = @"";
                if(theSearchBar.text.length < 1 )
                {
                    strError = @"Please enter searching text";
                }
                
                if(strError.length > 1)
                {
                    [SingletonClass initWithTitle:@"" message:strError delegate:nil btn1:@"Ok"];
                    return;
                }else{
                    
                   // [arrAnnouncements removeAllObjects];
                   // [self SearchAnnouncement : theSearchBar.text];
                }
                
            }else{
                
                [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


@end
