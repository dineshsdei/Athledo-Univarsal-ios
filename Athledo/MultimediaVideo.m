//
//  MultimediaVideo.m
//  Athledo
//
//  Created by Dinesh Kumar on 12/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "MultimediaVideo.h"
#import "Multimedia.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"

#define getPicDataTag 100
#define getSeasonTag 110
#define listPickerTag 70

@interface MultimediaVideo ()
{
    WebServiceClass *webservice;
    NSMutableArray *multimediaData;
    NSArray *AllMultimediaData;
    NSDictionary *DicData;
    NSMutableArray *arrSeasons;
    UIPickerView *listPicker;
    UITextField *currentText;
    NSString *seasonId;
    NSMutableArray *arrVisitedIndex;
    
}

@end

@implementation MultimediaVideo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //[self playVideo:@"http://www.youtube.com/watch?v=WL2l_Q1AR_Q" frame:CGRectMake(20, 70, 280, 250)];
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
     [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    listPicker=[[UIPickerView alloc] init];
    listPicker.frame =CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 216);
    listPicker.tag=listPickerTag;
    listPicker.delegate=self;
    listPicker.dataSource=self;
    listPicker.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:listPicker];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    seasonId=@"";
    multimediaData=[[NSMutableArray alloc] init];
    AllMultimediaData=[[NSArray alloc] init];
    arrVisitedIndex=[[NSMutableArray alloc] init];
    
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    [self getMultimediaVideos];
    [self getSeasonData];
}
-(void)doneClicked
{
    [self setPickerVisibleAt:NO:arrSeasons];
    [self getMultimediaVideos];
}
-(void)sortedData :(int)index
{
    switch (index) {
    case 0:
    {
    [multimediaData removeAllObjects];
    for (int i=0; i< AllMultimediaData.count; i++) {
        
        NSDictionary *temp=[AllMultimediaData objectAtIndex:i];
        
        [multimediaData addObject:temp];
        
    }

    [_tableView reloadData];
    break;
    }case 1:
    {
    [multimediaData removeAllObjects];

    for (int i=0; i< AllMultimediaData.count; i++) {
        
        if ( [[[AllMultimediaData objectAtIndex:i] valueForKey:@"type"] intValue]==2) {
            
            NSDictionary *temp=[AllMultimediaData objectAtIndex:i];
            
            [multimediaData addObject:temp];
        }
    }

    [_tableView reloadData];

    break;
    }
    case 2:
    {
    [multimediaData removeAllObjects];

    for (int i=0; i< AllMultimediaData.count; i++) {
        
        if ( [[[AllMultimediaData objectAtIndex:i] valueForKey:@"type"] intValue]==1) {
            
            [multimediaData addObject:[AllMultimediaData objectAtIndex:i]];
        }
    }

    [_tableView reloadData];

    break;
    }
    default:
    break;
    }
    
}
-(IBAction)SegmentSelected:(id)sender
{
    UISegmentedControl *segment=sender;
    
    [self sortedData:segment.selectedSegmentIndex];
}

#pragma mark Webservice call event
-(void)getSeasonData{
    
    if ([SingaltonClass  CheckConnectivity]) {

    UserInformation *userInfo=[UserInformation shareInstance];

    [SingaltonClass addActivityIndicator:self.view];

    NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid];

    [webservice WebserviceCall:webServiceGetWorkOutdropdownList :strURL :getSeasonTag];

    }else{

    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }
}
-(void)getMultimediaVideos{
    
    if ([SingaltonClass  CheckConnectivity]) {
    UserInformation *userInfo=[UserInformation shareInstance];

    NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"season_id\":\"%@\",\"tag_video\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,seasonId,@""];

    [SingaltonClass addActivityIndicator:self.view];

    [webservice WebserviceCall:webServiceGetMultimediaVideos :strURL :getPicDataTag];

    }else{

    [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];

    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingaltonClass RemoveActivityIndicator:self.view];

    switch (Tag)
    {
    case getPicDataTag :
    {
    [multimediaData removeAllObjects];

    if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
    {
    AllMultimediaData=[[MyResults valueForKey:@"data"] copy];

    for (int i=0; i< AllMultimediaData.count; i++) {
        
        NSDictionary *temp=[AllMultimediaData objectAtIndex:i];
        
        [multimediaData addObject:temp];
        
    }
    _segmentControl.selectedSegmentIndex=0;
    [_tableView reloadData];
    }else{
        [multimediaData removeAllObjects];
        [_tableView reloadData];
        [SingaltonClass initWithTitle:@"" message:@"No records found" delegate:nil btn1:@"Ok"];
    }

    break;
    } case getSeasonTag:
    {

    if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
    {
        DicData=[MyResults  objectForKey:@"data"];
        arrSeasons=[[NSMutableArray alloc] init];
        NSArray *arrtemp=(NSMutableArray *)[[[MyResults  objectForKey:@"data"] objectForKey:@"Season"] allValues];
    
        for (int i=0;i<arrtemp.count; i++) {
            
            if (![[arrtemp objectAtIndex:i] isEqualToString:@"Off Season"]) {
                [arrSeasons addObject:[arrtemp objectAtIndex:i]];
            }
        }
        
    }else{
        //[SingaltonClass initWithTitle:@"" message:@"Try again" delegate:nil btn1:@"Ok"];
    }

    break;
    }

    }
}
// this is not used but you can used to play video in webview

- (void)playVideo:(NSString *)urlString frame:(CGRect)frame
{
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, urlString, frame.size.width, frame.size.height];
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    [videoView loadHTMLString:html baseURL:nil];
    [self.view addSubview:videoView];
    
    NSLog(@"%@",html);
}

-(void)PlayVideo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
     NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",[[multimediaData objectAtIndex:btn.tag] valueForKey:@"filename1"]]]];
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:@"medium"]]];
    [self presentMoviePlayerViewControllerAnimated:mp];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // self.navigationItem.leftBarButtonItem=nil;
    //self.navigationItem.hidesBackButton=YES;
    self.title=@"Multimedia Videos";
    
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    UITabBarItem *tabBarItem = [_tabBar.items objectAtIndex:1];
    
    [_tabBar setSelectedItem:tabBarItem];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //NSLog(@"tag %d",item.tag);
    
    NSArray *arrController=[self.navigationController viewControllers];

    switch (item.tag) {
    case 0:
    {
    BOOL Status=FALSE;
    for (id object in arrController)
    {
        if ([object isKindOfClass:[Multimedia class]])
        {
            Status=TRUE;
            [self.navigationController popToViewController:object animated:NO];
        }
    }

    if (Status==FALSE)
    {
        Multimedia *arichive=[[Multimedia alloc] initWithNibName:@"Multimedia" bundle:nil];
        
        [self.navigationController pushViewController:arichive animated:NO];
        
    }
    break;
    }
    default:
    break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return multimediaData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"MultimediaCell";
    static NSString *CellNib = @"MultimediaCell";
    
    MultimediaCell *cell = (MultimediaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
    cell = (MultimediaCell *)[nib objectAtIndex:1];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //cell.btnPlay.hidden=YES;
    cell.btnPlay.tag=indexPath.row;
    cell.imageView.layer.borderWidth=.50;
    cell.imageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        
    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",[[multimediaData objectAtIndex:indexPath.row] valueForKey:@"filename1"]]]];
        if (videos !=nil) {
            cell.btnPlay.hidden=NO;
              [cell.imageView setImageWithURL:[[videos valueForKey:@"moreInfo"] valueForKey:@"iurl"] placeholderImage:[UIImage imageNamed:@"youtubePlaceholder.jpg"]];
        }else{
            cell.btnPlay.hidden=YES;
            [cell.imageView setImageWithURL:[[videos valueForKey:@"moreInfo"] valueForKey:@"iurl"] placeholderImage:[UIImage imageNamed:@"error_icon.png"]];

        }
  
    cell.First_lblName.text=[[multimediaData objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.First_textViewDes.text=[[multimediaData objectAtIndex:indexPath.row] valueForKey:@"description"];
    [arrVisitedIndex addObject:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    cell.delegate=self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
    
}
#pragma mark- UIPickerView
-(void)setToolbarVisibleAt :(CGPoint)point
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [self.view viewWithTag:40].center = point;
    [UIView commitAnimations];
}
-(void)setPickerVisibleAt :(BOOL)ShowHide :(NSArray*)data
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    CGPoint point;
    point.x=self.view.frame.size.width/2;
    
    if (ShowHide) {

    if (currentText.text.length > 0) {
    for (int i=0; i< data.count; i++) {

    if ([[data objectAtIndex:i] isEqual:currentText.text]) {

    [listPicker selectRow:i inComponent:0 animated:YES];

    break;
    }
    }
        }
        point.y=self.view.frame.size.height-(listPicker.frame.size.height/2);
        [self setToolbarVisibleAt:CGPointMake(point.x,point.y-(listPicker.frame.size.height/2)-22)];
        
    }else{
        [self setToolbarVisibleAt:CGPointMake(point.x,self.view.frame.size.height+50)];
        point.y=self.view.frame.size.height+(listPicker.frame.size.height/2);
    }
    [self.view viewWithTag:listPickerTag].center = point;
    [UIView commitAnimations];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (currentText.text.length==0) {
        currentText.text=[arrSeasons objectAtIndex:0];
        seasonId=[self KeyForValue:@"Season":currentText.text];
    }
    return [arrSeasons count];
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    
    str = [arrSeasons objectAtIndex:row];
    NSArray *arr = [str componentsSeparatedByString:@"****"]; //For State, But will not effect to other
    
    return [arr objectAtIndex:0];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentText.text=arrSeasons.count > row ? [arrSeasons objectAtIndex:row] : [arrSeasons objectAtIndex:row-1] ;
    seasonId=[self KeyForValue:@"Season":currentText.text];
    
}
-(NSString *)KeyForValue :(NSString *)superKey :(NSString *)SubKey
{
    NSArray *arrValues=[[DicData objectForKey:superKey] allValues];

    NSArray *arrkeys=[[DicData objectForKey:superKey] allKeys];

    NSString *strValue=@"";

    for (int i=0; i<arrValues.count; i++) {

    if ([[arrValues objectAtIndex:i] isEqualToString:SubKey])
    {
        strValue=[arrkeys objectAtIndex:i];
        
        break;
        
    }

    }
    return strValue;
    
}
#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentText=textField;
    [listPicker reloadComponent:0];
    [self setPickerVisibleAt:YES:arrSeasons];
    
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
