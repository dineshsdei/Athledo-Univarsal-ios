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
    WebServiceClass *webservice;
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
    
    [self getNotes];
}
-(void)DownloadPDF
{
    if (arrNotesData.count ==0) {
         [SingletonClass initWithTitle:@"" message:@"PDF is not exist." delegate:nil btn1:@"Ok"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.msy.com.au/Parts/PARTS.pdf"]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"filename123.pdf"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        [self openDocumentIn:path];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}
-(void)SharePDF
{
    if (arrNotesData.count ==0) {
        [SingletonClass initWithTitle:@"" message:@"PDF is not exist." delegate:nil btn1:@"Ok"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Open documents

-(void)openDocumentIn:(NSString *)filepath {
//    NSString * filePath =
//    [[NSBundle mainBundle]
//     pathForResource:@"Courses for Q2 2011" ofType:@"pdf"];
    documentController =
    [UIDocumentInteractionController
     interactionControllerWithURL:[NSURL fileURLWithPath:filepath]];
    documentController.delegate = self;
    documentController.UTI = @"com.adobe.pdf";
    [documentController presentOpenInMenuFromRect:CGRectZero
                                           inView:self.view
                                         animated:YES];
}
-(void)documentInteractionController:(UIDocumentInteractionController *)controller
       willBeginSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller
          didEndSendingToApplication:(NSString *)application {
    
}

-(void)documentInteractionControllerDidDismissOpenInMenu:
(UIDocumentInteractionController *)controller {
    
}
#pragma webservice calling/Response

-(void)getNotes
{
    //    NSData *myFile = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.msy.com.au/Parts/PARTS.pdf"]];
    //    NSLog(@"path %@",[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"yourfilename.pdf"]);
    //    [myFile writeToFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"yourfilename.pdf"] atomically:YES];
    
    if ([SingletonClass  CheckConnectivity]) {
        
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webserviceNotesList :strURL :getNotesTag];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case getNotesTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                arrNotesData =[MyResults objectForKey:@"data"];
                [tableview reloadData];
            }
            break;
        }
    }
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
    @try {
        cell.lblName.text=[[[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"UserProfile"] valueForKey:@"firstname"] stringByAppendingString:[NSString stringWithFormat:@" %@",[[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"UserProfile"] valueForKey:@"lastname"]]];
        
        cell.lblWorkoutName.text=[[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"UserProfile"] valueForKey:@"address"];
        cell.lblName.font=Textfont;
        cell.lblWorkoutName.font=SmallTextfont;
        [cell.teamMemberPic setImageWithURL:[NSURL URLWithString:[[[arrNotesData objectAtIndex:indexPath.row] valueForKey:@"UserProfile"] valueForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        cell.teamMemberPic.layer.masksToBounds = YES;
        cell.teamMemberPic.layer.cornerRadius=(cell.teamMemberPic.frame.size.width)/2;
        cell.teamMemberPic.layer.borderWidth=2.0f;
        cell.teamMemberPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.rightUtilityButtons = [self rightButtons : indexPath.row];
        cell.delegate=self;

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddNotes *addNotes = [[AddNotes alloc] initWithNibName:@"AddNotes" bundle:nil];
    addNotes.objNotes = [arrNotesData objectAtIndex:indexPath.row];
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
        
        if (arrNotesData.count == 0) {
            [SingletonClass initWithTitle:@"" message:@"No Notes" delegate:nil btn1:@"Ok"];
        }
        
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
