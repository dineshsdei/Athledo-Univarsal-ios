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
    UIToolbar *toolBar;
    UIDeviceOrientation CurrentOrientation;
    NSURL *urlvideo;
    BOOL isCancelNotification;
    int keyboardHeight;
}

@end

@implementation MultimediaVideo

#pragma mark - ViewController life cycle method
-(void)viewDidAppear:(BOOL)animated
{
    isCancelNotification = FALSE;
    [super viewDidAppear:animated];
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
    UITabBarItem *tabBarItem = [_tabBar.items objectAtIndex:0];
    [_tabBar setSelectedItem:tabBarItem];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
   
    if (!isCancelNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardAppear];
        [[NSNotificationCenter defaultCenter] removeObserver: self.keyboardHide];
        if (isIPAD)
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}
- (void)viewDidLoad {
    
    self.scrollview.layer.borderWidth = 1;
    self.scrollview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.scrollview.hidden = YES ;
    UIEdgeInsets ContentInset = _tfDescription.contentInset;
    ContentInset.top = 20;
    _tfDescription.contentInset = ContentInset;
    _tfDescription.layer.borderWidth = .50;
    _tfDescription.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [super viewDidLoad];
    self.keyboardAppear = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            NSDictionary* info = [note userInfo];
            CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
            keyboardHeight = kbSize.height;
        if (iosVersion < 8) {
            keyboardHeight=kbSize.height > 310 ? kbSize.width : kbSize.height ;
        }else{
            keyboardHeight=kbSize.height > 310 ? kbSize.height : kbSize.height ;
        }
            [UIView animateWithDuration:0.27f
                             animations:^{
                                 int dif=0;
                                 CGPoint point = [currentText convertPoint:currentText.frame.origin toView:self.uploadView];
                                 if ((point.y - kbSize.height) < (dif=([[SingletonClass ShareInstance] CurrentOrientation:self]==UIDeviceOrientationPortrait) ? 140: 180) ) {
                                     self.uploadView.frame=CGRectMake(self.uploadView.frame.origin.x, self.uploadView.frame.origin.y, self.uploadView.frame.size.width,  self.uploadView.frame.size.height);
                                     CGRect frame = self.uploadView.frame;
                                     frame.origin.y = self.uploadView.frame.origin.y - (currentText.frame.size.height/2+70);
                                     NSLog(@"frame %@",NSStringFromCGRect(frame));
                                     if (frame.origin.y >= -146) {
                                         self.uploadView.frame = frame;
                                     }
                                 }
                                 
                             }
                             completion:^(BOOL finished){
                             }];
       
    }];
    
    self.keyboardHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [UIView animateWithDuration:0.27f
                             animations:^{
                                 CGRect frame = self.uploadView.frame;
                                 frame.origin.y = 0;
                                 self.uploadView.frame = frame;
                                [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolBar];
                             }
                             completion:^(BOOL finished){
                             }];
    }];
    
    if (isIPAD) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    // Do any additional setup after loading the view from its nib
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
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, self.view.frame.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    seasonId=@"";
    multimediaData=[[NSMutableArray alloc] init];
    AllMultimediaData=[[NSArray alloc] init];
    arrVisitedIndex=[[NSMutableArray alloc] init];
    
    UIButton *btnAddWorkout = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageAdd=[UIImage imageNamed:@"add.png"];
    btnAddWorkout.bounds = CGRectMake( 0, 0, imageAdd.size.width, imageAdd.size.height );
    [btnAddWorkout addTarget:self action:@selector(SelectVideoFiles) forControlEvents:UIControlEventTouchUpInside];
    [btnAddWorkout setImage:imageAdd forState:UIControlStateNormal];
    UIBarButtonItem *BarItemAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAddWorkout];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemAdd, nil];
    [self getMultimediaVideos];
    [self getSeasonData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Class Utility method
- (void)orientationChanged
{
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [self.view endEditing:YES];
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+500):toolBar];
    }
}
// for hide picker or call service for refresh data
-(void)doneClicked
{
    if (self.scrollview.hidden) {
        [UIView animateWithDuration:0.27f
                         animations:^{
                             [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
                             [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolBar];
                         }
                         completion:^(BOOL finished){
                         }];
        [self getMultimediaVideos];
    }else{
        [UIView animateWithDuration:0.27f
                         animations:^{
                             [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
                             [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolBar];
                             [self.view endEditing:YES];
                         }
                         completion:^(BOOL finished){
                         }];
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray *arrController=[self.navigationController viewControllers];
    switch (item.tag) {
        case 1:
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
    [self sortedData:(int)(segment.selectedSegmentIndex)];
}

-(void)SelectVideoFiles
{
    self.scrollview.hidden = NO ;
    //[self ChooseFromGallery];
}

// Pick video file from media library
- (IBAction)ChooseFromGallery
{
    isCancelNotification = TRUE;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
    if (![sourceTypes containsObject:(NSString *)kUTTypeMovie]) {
        // No images
    }else
    {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
- (IBAction)CancelUpload
{
    self.scrollview.hidden = YES ;
}
- (IBAction)UploadVideo
{
    if (urlvideo) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *urlString=[urlvideo path];
        NSString *videoName = urlString.lastPathComponent;
        NSString *urlpath = webServiceUploadVideo;
        NSURL *url = [NSURL URLWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        request = [ASIFormDataRequest requestWithURL:url];
        [request addPostValue:[NSString stringWithFormat:@"%d", userInfo.userId ] forKey:@"user_id"];
        [request addPostValue:[NSString stringWithFormat:@"%d", userInfo.userSelectedTeamid ] forKey:@"team_id"];
        [request addPostValue:seasonId forKey:@"season_id"];
        [request addPostValue:[NSString stringWithFormat:@"%d", userInfo.userType ] forKey:@"type"];
        [request addPostValue:_tfTitle.text forKey:@"title"];
        [request addPostValue:[_tfDescription.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "] forKey:@"description"];
        [request setPostValue:videoName forKey:@"Filename"];
        [request setFile:urlString forKey:@"videoFile"];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setDidStartSelector:@selector(requestStarted:)];
        [request setDidFinishSelector:@selector(requestFinished:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setUploadProgressDelegate:self];
        [request setTimeOutSeconds:50000];
        [request startAsynchronous];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Please select video from device" delegate:nil btn1:@"Ok"];
    }
}

#pragma mark- ImagePicker Delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeVideo] || [type isEqualToString:(NSString *)kUTTypeMovie])
    {
        urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- ASIHTTPRequest class delegate

- (void)requestStarted:(ASIHTTPRequest *)theRequest {
    
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
    
    @try {
        _tfTitle.text = @"";
        _tfDescription.text = @"";
        _tfSeason.text =@"";
        NSLog(@"json string %@",[theRequest responseString]);
          NSLog(@"json string %@",[theRequest responseStatusMessage]);
        NSData *data = [[theRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [SingletonClass initWithTitle:[json valueForKey:@"status"] message:[json valueForKey:@"message"] delegate:nil btn1:@"Ok"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.scrollview.hidden=YES;
        if ([[json valueForKey:@"status"] isEqualToString:@"success"]) {
            urlvideo=nil;
            [self getMultimediaVideos];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
- (void)requestFailed:(ASIHTTPRequest *)theRequest {
    [SingletonClass initWithTitle:@"" message:@"Video Upload to server failed, please try again" delegate:nil btn1:@"Ok"];
}

#pragma mark Webservice call event
-(void)getSeasonData{
    if ([SingletonClass  CheckConnectivity]) {
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        [SingletonClass addActivityIndicator:self.view];
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        [webservice WebserviceCall:webServiceGetWorkOutdropdownList :strURL :getSeasonTag];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}
-(void)getMultimediaVideos{
    
    if ([SingletonClass  CheckConnectivity]) {
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        //self.navigationController.navigationItem.rightBarButtonItem.enabled = NO ;
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"season_id\":\"%@\",\"tag_video\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,seasonId,@""];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetMultimediaVideos :strURL :getPicDataTag];
    }else{
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    self.navigationController.navigationItem.rightBarButtonItem.enabled = YES ;
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
                [SingletonClass initWithTitle:@"" message:@"No records found" delegate:nil btn1:@"Ok"];
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
#pragma mark - Play video files
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
}
-(void)PlayVideo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",[[multimediaData objectAtIndex:btn.tag] valueForKey:@"filename1"]]]];
    //MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:@"medium"]]];
     MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://archive.org/download/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto-HawaiianHoliday1937-Video.mp4"]];
    //http://172.24.2.222:8024/files/videos/1426849025_conv_33_1425595102_bigbuckbunny.flv
   
    [self presentMoviePlayerViewControllerAnimated:mp];
}
#pragma mark - Tableview Delegate
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
        //NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",[[multimediaData objectAtIndex:indexPath.row] valueForKey:@"filename1"]]]];
        NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:@"http://archive.org/download/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto-HawaiianHoliday1937-Video.mp4"]];
        if (videos !=nil) {
            cell.btnPlay.hidden=NO;
            [cell.imageView setImageWithURL:[[videos valueForKey:@"moreInfo"] valueForKey:@"iurl"] placeholderImage:[UIImage imageNamed:@"youtubePlaceholder.jpg"]];
        }else{
            cell.btnPlay.hidden=YES;
            [cell.imageView setImageWithURL:[[videos valueForKey:@"moreInfo"] valueForKey:@"iurl"] placeholderImage:[UIImage imageNamed:@"error_icon.png"]];
        }
        cell.First_lblName.text=[[multimediaData objectAtIndex:indexPath.row] valueForKey:@"title"];
        cell.First_textViewDes.text=[[multimediaData objectAtIndex:indexPath.row] valueForKey:@"description"];
        [arrVisitedIndex addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    cell.delegate=self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self playVideo:@"http://172.24.2.222:8024/files/videos/1426849025_conv_33_1425595102_bigbuckbunny.flv" frame:self.view.frame];
    [self PlayVideo:tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}
#pragma mark- UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (currentText.text.length==0) {
        arrSeasons.count > 0 ?currentText.text=[arrSeasons objectAtIndex:0] :@"";
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
    currentText.text=arrSeasons.count > row ? [arrSeasons objectAtIndex:row] : [arrSeasons objectAtIndex:row-1];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[touches anyObject] locationInView:listPicker];
}
#pragma mark - Singleton class Delegate
-(void)Done
{
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
    [self.view endEditing:YES];
}
#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    currentText=nil;
    [UIView animateWithDuration:0.45f
                     animations:^{
                            [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-(keyboardHeight+22)) :toolBar];
                     }
                     completion:^(BOOL finished){
                     }];
    currentText = (UITextField *)textView;
    [SingletonClass ShareInstance].delegate = self;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
}
#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentText=textField;
    if ([textField.placeholder isEqualToString:@"Select Season"]) {
        if (arrSeasons.count > 0) {
            webservice =[WebServiceClass shareInstance];
            webservice.delegate=self;
            [listPicker reloadComponent:0];
            [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
            //[self setPickerVisibleAt:YES:arrSeasons];
        }else{
            [SingletonClass initWithTitle:@"" message:@"Seasons list is not exist" delegate:nil btn1:@"Ok"];
        }
        return NO;
    }else{
        [SingletonClass ShareInstance].delegate = self;
        textField.inputAccessoryView = [[SingletonClass ShareInstance] toolBarWithDoneButton:self.view];
       
        return YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
