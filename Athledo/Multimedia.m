//
//  Mutimedia.m
//  Athledo
//
//  Created by Smartdata on 12/16/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "Multimedia.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "DisplayFolderContant.h"

//#define pickerhight [UIScreen mainScreen].bounds.size.height >= 1024 ? 600 : 216

@interface Multimedia ()
{
    WebServiceClass *webservice;
    NSMutableArray *multimediaData;
    NSArray *AllMultimediaData;
    NSDictionary *DicData;
    NSMutableArray *arrSeasons;
    UIPickerView *listPicker;
    UITextField *currentText;
    NSString *seasonId;
    NSString *AlbumId;
    int titleIndex;
    UIDeviceOrientation CurrentOrientation;
}
@end
@implementation Multimedia
#pragma mark UIViewController method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.title=@"Multimedia Photos";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=NAVIGATION_COMPONENT_COLOR;
    
    seasonId=EMPTYSTRING;
    AlbumId=EMPTYSTRING;
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    UITabBarItem *tabBarItem = [_tabBar.items objectAtIndex:1];
    [_tabBar setSelectedItem:tabBarItem];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    if (isIPAD)
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIPAD) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
   
    // Do any additional setup after loading the view from its nib.
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
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+50, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    seasonId=EMPTYSTRING;
    AlbumId=EMPTYSTRING;
    multimediaData=MUTABLEARRAY;
    AllMultimediaData=[[NSArray alloc] init];
    [self getMultimediaPic];
    [self getSeasonData];
}
#pragma mark Multimedia Other Utility Method
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray *arrController=[self.navigationController viewControllers];
    switch (item.tag) {
        case 0:
        {
            BOOL Status=FALSE;
            for (id object in arrController)
            {
                if ([object isKindOfClass:[MultimediaVideo class]])
                {
                    Status=TRUE;
                    [self.navigationController popToViewController:object animated:NO];
                }
            }
            if (Status==FALSE)
            {
                MultimediaVideo *arichive=[[MultimediaVideo alloc] initWithNibName:@"MultimediaVideo" bundle:nil];
                [self.navigationController pushViewController:arichive animated:NO];
            }
            break;
        }
        default:
            break;
    }
}

- (void)orientationChanged
{
    [SingletonClass deleteUnUsedLableFromTable:_tableView];
    if (CurrentOrientation == [[SingletonClass ShareInstance] CurrentOrientation:self]) {
        return;
    }
    CurrentOrientation =[SingletonClass ShareInstance].GloableOreintation;
    if (isIPAD) {
        [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
        [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+500):toolBar];
    }
    [_tableView reloadData];
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
                if ( [[[AllMultimediaData objectAtIndex:i] valueForKey:@"type"] intValue]==1) {
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
                if ( [[[AllMultimediaData objectAtIndex:i] valueForKey:@"type"] intValue]==2) {
                    [multimediaData addObject:[AllMultimediaData objectAtIndex:i]];
                }
            }
            [_tableView reloadData];
            break;
        }
        case 3:
        {
            [self getMultimediaAlbum];
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
-(void)doneClicked
{
    [UIView beginAnimations:@"tblViewMove" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.27f];
    [SingletonClass setListPickerDatePickerMultipickerVisible:NO :listPicker :toolBar];
    [SingletonClass setToolbarVisibleAt:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+50) :toolBar];
    [UIView commitAnimations];
    [self getMultimediaPic];
}
#pragma mark- UIPickerView Delegate method 
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (currentText.text.length==0) {
        arrSeasons.count > 0 ?currentText.text=[arrSeasons objectAtIndex:0] :EMPTYSTRING;
        seasonId=[self KeyForValue:@"Season":currentText.text];
    }
    return [arrSeasons count];
}

#pragma mark- Picker delegate method
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    str = [arrSeasons objectAtIndex:row];
    NSArray *arr = [str componentsSeparatedByString:KEY_TRIPLE_STAR]; //For State, But will not effect to other
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
    NSString *strValue=EMPTYSTRING;
    for (int i=0; i<arrValues.count; i++) {
        if ([[arrValues objectAtIndex:i] isEqualToString:SubKey])
        {
            strValue=[arrkeys objectAtIndex:i];
            break;
        }
    }
    return strValue;
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
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)getMultimediaAlbum{
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"album_id\":\"%@\"}",userInfo.userId,AlbumId];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetMultimediaAlbum :strURL :getAlbumDataTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)getMultimediaPic{
    if ([SingletonClass  CheckConnectivity]) {
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"season_id\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,seasonId];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServiceGetMultimediaPic :strURL :getPicDataTag];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag)
    {
        case getPicDataTag :
        {
            [multimediaData removeAllObjects];
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                AllMultimediaData=[[MyResults valueForKey:DATA] copy];
                for (int i=0; i< AllMultimediaData.count; i++) {
                    NSDictionary *temp=[AllMultimediaData objectAtIndex:i];
                    [multimediaData addObject:temp];
                }
                _segmentControl.selectedSegmentIndex=0;
                 multimediaData.count == 0 ? ([_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No Photos":_tableView]]):[SingletonClass deleteUnUsedLableFromTable:_tableView];
                [_tableView reloadData];
            }else{
                [multimediaData removeAllObjects];
                [_tableView reloadData];
                 multimediaData.count == 0 ? ([_tableView addSubview:[SingletonClass ShowEmptyMessage:@"No Photos":_tableView]]):[SingletonClass deleteUnUsedLableFromTable:_tableView];
            }
             break;
        } case getSeasonTag:
        {
            if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
            {
                DicData=[MyResults  objectForKey:DATA];
                arrSeasons=MUTABLEARRAY;
                NSArray *arrtemp=(NSMutableArray *)[[[MyResults  objectForKey:DATA] objectForKey:@"Season"] allValues];
                //To remove off season
                for (int i=0;i<arrtemp.count; i++) {
                    if (![[arrtemp objectAtIndex:i] isEqualToString:KEY_OFF_SEASON]) {
                        [arrSeasons addObject:[arrtemp objectAtIndex:i]];
                    }
                }
            }else{
                //[SingaltonClass initWithTitle:EMPTYSTRING message:@"Try again" delegate:nil btn1:@"Ok"];
            }
            break;
        }
        case getAlbumDataTag :
        {
            if([AlbumId isEqualToString:EMPTYSTRING])
            {
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    [multimediaData removeAllObjects];
                    NSArray *temp=[[MyResults valueForKey:DATA] copy];
                    for (int i=0; i< temp.count; i++) {
                        NSDictionary *tempDic=[[temp objectAtIndex:i] valueForKey:@"MultimediaAlbum"];
                        [multimediaData addObject:tempDic];
                    }
                    [_tableView reloadData];
                } else
                {
                    [SingletonClass initWithTitle:EMPTYSTRING message:STR_NO_RECORD_FOUND delegate:nil btn1:@"Ok"];
                    AlbumId=EMPTYSTRING;
                }
            }else{
                
                if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS])
                {
                    NSArray *temp=[MyResults valueForKey:DATA] ;
                    DisplayFolderContant *obj=[[DisplayFolderContant alloc] initWithNibName:@"DisplayFolderContant" bundle:nil];
                    obj.picData=temp;
                    obj.screenTitle=[[multimediaData objectAtIndex:titleIndex] valueForKey:Key_name];
                    [self.navigationController pushViewController:obj animated:NO];
                    
                } else{
                    [SingletonClass initWithTitle:EMPTYSTRING message:STR_NO_RECORD_FOUND delegate:nil btn1:@"Ok"];
                    AlbumId=EMPTYSTRING;
                }
            }
        }
    }
}
#pragma mark -Tableview Delegate method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noOfRow=(int)(multimediaData.count/2);
    if (noOfRow==0) {
        if (multimediaData.count==1) {
            return (multimediaData.count/2+1);
        }else
            return (multimediaData.count/2);
    }else{
        return (multimediaData.count/2+1);
    }
    return (multimediaData.count/2);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"MultimediaCell_%d_%d",(int)indexPath.section,(int)indexPath.row ];
    static NSString *CellNib = @"MultimediaCell";
    MultimediaCell *cell;
    cell = (MultimediaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (MultimediaCell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (_segmentControl.selectedSegmentIndex==3)
    {
        UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(handlePinch:)];
        [pgr setNumberOfTouchesRequired:1];
        [pgr setNumberOfTapsRequired:1];
        [pgr setDelegate:self];
        cell.First_imageview.userInteractionEnabled=YES;
        cell.Second_imageview.userInteractionEnabled=YES;
        [cell.First_imageview addGestureRecognizer:pgr];
         UITapGestureRecognizer *pgr1 = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handlePinch:)];
        [pgr1 setNumberOfTouchesRequired:1];
        [pgr1 setNumberOfTapsRequired:1];
        [pgr1 setDelegate:self];
        [cell.Second_imageview addGestureRecognizer:pgr1];
         if (multimediaData.count > 2*indexPath.row ) {
            cell.First_imageview.tag=2*indexPath.row;
            [cell.First_imageview setImage:[UIImage imageNamed:@"folder_image.png"]];
            [cell.First_lblName setText:[[multimediaData objectAtIndex:(2*indexPath.row)] valueForKey:Key_name] ?[[multimediaData objectAtIndex:(2*indexPath.row)] valueForKey:Key_name] : EMPTYSTRING];
             [cell.First_textViewDes setText:[[multimediaData objectAtIndex:(2*indexPath.row) ] valueForKey:@"description"] ?[[multimediaData objectAtIndex:(2*indexPath.row) ] valueForKey:@"description"]  :EMPTYSTRING];
        }else
        {
            cell.First_imageview.hidden=YES;
            cell.First_lblName.hidden=YES;
            cell.First_textViewDes.hidden=YES;
        }
        if (multimediaData.count > 2*indexPath.row+1) {
            cell.Second_imageview.tag=2*indexPath.row+1;
            [cell.Second_imageview setImage:[UIImage imageNamed:@"folder_image.png"]];
            [cell.Second_lblName setText:[[multimediaData objectAtIndex:(2*indexPath.row+1)] valueForKey:Key_name] ?[[multimediaData objectAtIndex:(2*indexPath.row)+1] valueForKey:Key_name] : EMPTYSTRING];
            [cell.SecondTextviewDes setText:[[multimediaData objectAtIndex:(2*indexPath.row+1) ] valueForKey:@"description"] ?[[multimediaData objectAtIndex:(2*indexPath.row+1) ] valueForKey:@"description"]  :EMPTYSTRING];
        }else
        {
            cell.Second_imageview.hidden=YES;
            cell.Second_lblName.hidden=YES;
            cell.SecondTextviewDes.hidden=YES;
        }
    }else
    {
        if (multimediaData.count > 2*indexPath.row ) {
            [cell.First_imageview setImageWithURL:[[multimediaData valueForKey:@"img"] objectAtIndex:(2*indexPath.row)] placeholderImage:[UIImage imageNamed:@"profile_icon.png"]];
            [cell.First_lblName setText:[[multimediaData valueForKey:Key_name] objectAtIndex:(2*indexPath.row)]];
            [cell.First_textViewDes setText:[[multimediaData valueForKey:@"description"] objectAtIndex:(2*indexPath.row)]];
        }else
        {
            cell.First_imageview.hidden=YES;
            cell.First_lblName.hidden=YES;
            cell.First_textViewDes.hidden=YES;
        }
        if (multimediaData.count > 2*indexPath.row+1) {
            [cell.Second_imageview setImageWithURL:[[multimediaData valueForKey:@"img"] objectAtIndex:(2*indexPath.row+1)] placeholderImage:[UIImage imageNamed:@"profile_icon.png"]];
            [cell.Second_lblName setText:[[multimediaData valueForKey:Key_name] objectAtIndex:indexPath.row+1]];
            [cell.SecondTextviewDes setText:[[multimediaData valueForKey:@"description"] objectAtIndex:(2*indexPath.row+1)]];
        }else
        {
            cell.Second_imageview.hidden=YES;
            cell.Second_lblName.hidden=YES;
            cell.SecondTextviewDes.hidden=YES;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isIPAD) {
        return 240;
    }else{
        return 190;
    }
}
-(void)handlePinch :(UITapGestureRecognizer *)pinchGestureRecognizer{
    titleIndex=(int)pinchGestureRecognizer.view.tag;
    AlbumId=[[multimediaData objectAtIndex:pinchGestureRecognizer.view.tag] valueForKey:@"id"];
    [self getMultimediaAlbum];
}
#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    if (arrSeasons.count > 0) {
        currentText=textField;
        [listPicker reloadComponent:0];
        [SingletonClass setListPickerDatePickerMultipickerVisible:YES :listPicker :toolBar];
    }else{
        [SingletonClass initWithTitle:EMPTYSTRING message:@"Seasons list is not exist" delegate:nil btn1:@"Ok"];
    }
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
