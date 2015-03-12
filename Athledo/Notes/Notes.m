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
    NSMutableArray *arrFilterdData;
    SWRevealViewController *revealController;
    UIBarButtonItem *revealButtonItem;
    WebServiceClass *webservice;
    int pdfNameIndex;
    int pdfShareIndex;
}
@end
@implementation Notes

-(void)viewDidDisappear:(BOOL)animated
{
    [self deletePDF];
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrFilterdData=[[NSMutableArray alloc] init];
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
    UIImage *imageAdd=[UIImage imageNamed:@"pdf_download.png"];
    btnDownload.bounds = CGRectMake( 0, 0, imageAdd.size.width, imageAdd.size.height );
    [btnDownload addTarget:self action:@selector(DownloadPDF) forControlEvents:UIControlEventTouchUpInside];
    [btnDownload setImage:imageAdd forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnDownload];
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(150, 5, 44, 44)];
    UIImage *imageHistory=[UIImage imageNamed:@"pdf_share.png"];
    [btnShare addTarget:self action:@selector(ShareAllNotes) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setImage:imageHistory forState:UIControlStateNormal];
    
    UIBarButtonItem *BarItemHistory = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemAdd,BarItemHistory, nil];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor lightGrayColor];
    
    [self getNotes];
}
-(void)getPdfLink:(NSString *)AthleteId
{
    if (arrNotesData.count ==0) {
        [SingletonClass initWithTitle:@"" message:@"PDF is not exist." delegate:nil btn1:@"Ok"];
        return;
    }
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"user_id\":\"%d\",\"athlete_id\":\"%@\"}",userInfo.userSelectedTeamid,userInfo.userId,AthleteId];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webservicePDFLink :strURL :getPDFLinkTag];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}
-(void)deletePDF
{
    NSString *path = [SingletonClass DocumentDirectoryPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error=nil;
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error == nil) {
        for (NSString *path1 in directoryContents) {
            NSString *fullPath = [path stringByAppendingPathComponent:path1];
            BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
            if (!removeSuccess) {
            }
        }
    }
}
-(void)DownloadPDF
{
    pdfNameIndex = (int)AllPDF;
    [self getPdfLink:@""];
}
-(void)downLoadpdfFromLink:(NSString *)link
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.navigationController.navigationItem.rightBarButtonItem.enabled=NO;
    // http://www.msy.com.au/Parts/PARTS.pdf
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *path = [[SingletonClass DocumentDirectoryPath] stringByAppendingPathComponent: arrFilterdData.count > pdfNameIndex ? [NSString stringWithFormat:@"%@_Notes.pdf", [[arrFilterdData objectAtIndex:pdfNameIndex ] valueForKey:@"firstname"]] : @"AllAthlete_Notes.pdf" ];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.navigationController.navigationItem.rightBarButtonItem.enabled=NO;
        NSLog(@"Successfully downloaded file to %@", path);
        [self openDocumentIn:path];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}
-(void)ShareAllNotes
{
    pdfShareIndex = (int)AllPDF;
    [self ShareNotes:@""];
}
-(void)ShareNotes:(NSString *)AthleteId
{
    if (arrNotesData.count ==0) {
        [SingletonClass initWithTitle:@"" message:@"Notes is not exist." delegate:nil btn1:@"Ok"];
        return;
    }
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"team_id\":\"%d\",\"user_id\":\"%d\",\"athlete_id\":\"%@\",\"coach_name\":\"%@\"}",userInfo.userSelectedTeamid,userInfo.userId,AthleteId,(arrFilterdData.count > pdfShareIndex) ? [[arrFilterdData objectAtIndex:pdfShareIndex] valueForKey:@"firstname"] : @"" ];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webserviceShareNotes :strURL:ShareNotesTag];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
    
    /*
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Performance status"];
    
    // Set up recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    // [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    // UIImage *coolImage = ...;
    //NSData *myData = UIImagePNGRepresentation(coolImage);
    //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
    
    NSString* fileName = @"filename123.pdf";
    NSString *path = [SingletonClass DocumentDirectoryPath];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    NSData *myData = [NSData dataWithContentsOfFile:pdfFileName];
    [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:fileName];
    // Fill out the email body text
    NSString *emailBody = @"My cool status is attached";
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
    */
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Open documents

-(void)openDocumentIn:(NSString *)filepath {
    documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filepath]];
    documentController.delegate = self;
    documentController.UTI = @"com.adobe.pdf";
    [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
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
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"athlete_id\":\"%@\",\"searchType\":\"%@\",\"keyword\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,@"",@"",@""];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webserviceNotesList :strURL :getNotesTag];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}

-(void)SearchNotes:(NSString *)searchKeyboard
{
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"athlete_id\":\"%@\",\"searchType\":\"%@\",\"keyword\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,@"",@"user",searchKeyboard];
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
                [arrFilterdData addObjectsFromArray:[arrNotesData valueForKey:@"UserProfile"]];
                [tableview reloadData];
            }
            break;
        }
        case getPDFLinkTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                NSString *strUrl = [MyResults valueForKey:@"message"];
                [self downLoadpdfFromLink:strUrl];
            }
            break;
        }case ShareNotesTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
            {
                 [SingletonClass initWithTitle:@"" message:@"Notes have been suceessfully shared." delegate:nil btn1:@"Ok"];
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
    return arrFilterdData.count;
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
        
        cell.lblName.text=[[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"firstname"] stringByAppendingString:[NSString stringWithFormat:@" %@",[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"lastname"]]];
        cell.lblWorkoutName.text=[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"address"];
        cell.lblName.font=Textfont;
        cell.lblWorkoutName.font=SmallTextfont;
        [cell.teamMemberPic setImageWithURL:[NSURL URLWithString:[[arrFilterdData objectAtIndex:indexPath.row] valueForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
        cell.teamMemberPic.layer.masksToBounds = YES;
        cell.teamMemberPic.layer.cornerRadius=(cell.teamMemberPic.frame.size.width)/2;
        cell.teamMemberPic.layer.borderWidth=2.0f;
        cell.teamMemberPic.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    addNotes.objNotes = [arrFilterdData objectAtIndex:indexPath.row];
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
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:149/255.0 green:29/255.0 blue:27/255.0 alpha:1.0f] icon:[UIImage imageNamed:@"pdf_share.png"] :(int)btnTag];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:41/255.0 green:58/255.0 blue:71/255.0 alpha:1.0] icon:[UIImage imageNamed:@"pdf_download.png"] :(int)btnTag];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSArray *arrButtons=cell.rightUtilityButtons;
    UIButton *btn=(UIButton *)[arrButtons objectAtIndex:index];
    switch (index) {
        case 0:
        {
            [self ShareSelectedUserNotes:btn.tag];
            break;
        }
        case 1:
        {
            pdfNameIndex = (int)btn.tag;
            [self DownloadSelectedUserPDF:btn.tag];
            break;
        }
        default:
            break;
    }
}
-(void)DownloadSelectedUserPDF :(NSInteger)userTag
{
    [self getPdfLink:[NSString stringWithFormat:@"%i",userTag]];
}

-(void)ShareSelectedUserNotes :(NSInteger)userTag
{
    [self ShareNotes:[[arrFilterdData objectAtIndex:userTag] valueForKey:@"user_id"]];
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
    [arrFilterdData removeAllObjects];
    [arrFilterdData addObjectsFromArray:[arrNotesData valueForKey:@"UserProfile"]];
    [tableview reloadData];
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
                    [arrFilterdData removeAllObjects];
                    NSPredicate *lowerCase= [NSPredicate predicateWithFormat:
                                             [@"SELF['firstname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[theSearchBar.text lowercaseString]]];
                    NSPredicate *orginaltext = [NSPredicate predicateWithFormat:
                                                [@"SELF['firstname'] CONTAINS " stringByAppendingFormat:@"\'%@\'",[[[theSearchBar.text substringToIndex:1] uppercaseString] stringByAppendingString:[theSearchBar.text substringFromIndex:1] ]]];
                    NSArray *res = [arrNotesData  valueForKey:@"UserProfile"];
                    [arrFilterdData addObjectsFromArray:[res filteredArrayUsingPredicate:lowerCase]] ;
                    [arrFilterdData addObjectsFromArray:[res filteredArrayUsingPredicate:orginaltext]] ;
                    [tableview reloadData];
                    [theSearchBar endEditing:YES];
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
