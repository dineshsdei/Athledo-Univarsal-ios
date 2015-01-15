//
//  Mutimedia.m
//  Athledo
//
//  Created by Dinesh Kumar on 12/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "Multimedia.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "DisplayFolderContant.h"

#define getPicDataTag 100
#define getAlbumDataTag 120
#define getSeasonTag 110
#define listPickerTag 70
#define pickerhight [UIScreen mainScreen].bounds.size.height >= 1024 ? 600 : 216

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
    
}
@end
@implementation Multimedia
-(void)viewWillAppear:(BOOL)animated
{
    self.title=@"Multimedia Photos";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    seasonId=@"";
    AlbumId=@"";
    webservice =[WebServiceClass shareInstance];
    webservice.delegate=self;
    UITabBarItem *tabBarItem = [_tabBar.items objectAtIndex:1];
    [_tabBar setSelectedItem:tabBarItem];
    [super viewWillAppear:animated];
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    NSLog(@"view weight %f",[UIScreen mainScreen].bounds.size.height);
    NSLog(@"view weight %f",[UIScreen mainScreen].bounds.size.width);
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    listPicker=[[UIPickerView alloc] init];
    listPicker.frame =CGRectMake(0, [UIScreen mainScreen].bounds.size.height+50, [UIScreen mainScreen].bounds.size.width, 216);
    listPicker.tag=listPickerTag;
    listPicker.delegate=self;
    listPicker.dataSource=self;
    listPicker.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:listPicker];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height+50, [UIScreen mainScreen].bounds.size.width, 44)];
    toolBar.tag = 40;
    toolBar.items = [NSArray arrayWithObjects:flex,btnDone,nil];
    [self.view addSubview:toolBar];
    
    seasonId=@"";
    AlbumId=@"";
    multimediaData=[[NSMutableArray alloc] init];
    AllMultimediaData=[[NSArray alloc] init];
    
    
    [self getMultimediaPic];
    [self getSeasonData];
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
    [self setPickerVisibleAt:NO:arrSeasons];
    [self getMultimediaPic];
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
#pragma mark Webservice call event
-(void)getSeasonData{
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        
        UserInformation *userInfo=[UserInformation shareInstance];
        
        [SingaltonClass addActivityIndicator:self.view];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"sport_id\":\"%d\"}",userInfo.userId,userInfo.userSelectedTeamid,userInfo.userSelectedSportid];
        
        [webservice WebserviceCall:webServiceGetWorkOutdropdownList :strURL :getSeasonTag];
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}
-(void)getMultimediaAlbum{
    
    if ([SingaltonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"album_id\":\"%@\"}",userInfo.userId,AlbumId];
        
        [SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetMultimediaAlbum :strURL :getAlbumDataTag];
        
    }else{
        
        [SingaltonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
}
-(void)getMultimediaPic{
    
    if ([SingaltonClass  CheckConnectivity]) {
        
        webservice =[WebServiceClass shareInstance];
        webservice.delegate=self;
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"team_id\":\"%d\",\"season_id\":\"%@\"}",userInfo.userId,userInfo.userSelectedTeamid,seasonId];
        
        [SingaltonClass addActivityIndicator:self.view];
        
        [webservice WebserviceCall:webServiceGetMultimediaPic :strURL :getPicDataTag];
        
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
                //To remove off season
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
        case getAlbumDataTag :
        {
            
            if([AlbumId isEqualToString:@""])
            {
                if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
                {
                    [multimediaData removeAllObjects];
                    
                    NSArray *temp=[[MyResults valueForKey:@"data"] copy];
                    
                    for (int i=0; i< temp.count; i++) {
                        NSDictionary *tempDic=[[temp objectAtIndex:i] valueForKey:@"MultimediaAlbum"];
                        [multimediaData addObject:tempDic];
                    }
                    [_tableView reloadData];
                } else
                {
                    [SingaltonClass initWithTitle:@"" message:@"No record found!" delegate:nil btn1:@"Ok"];
                    AlbumId=@"";
                    
                }
                
                
            }else{
                
                if([[MyResults objectForKey:@"status"] isEqualToString:@"success"])
                {
                    NSArray *temp=[MyResults valueForKey:@"data"] ;
                    
                    //            for (int i=0; i< temp.count; i++) {
                    //                NSDictionary *tempDic=[[temp objectAtIndex:i] valueForKey:@"MultimediaAlbum"];
                    //                [multimediaData addObject:tempDic];
                    //            }
                    
                    DisplayFolderContant *obj=[[DisplayFolderContant alloc] initWithNibName:@"DisplayFolderContant" bundle:nil];
                    obj.picData=temp;
                    obj.screenTitle=[[multimediaData objectAtIndex:titleIndex] valueForKey:@"name"];
                    [self.navigationController pushViewController:obj animated:NO];
                    
                } else
                {
                    [SingaltonClass initWithTitle:@"" message:@"No record found!" delegate:nil btn1:@"Ok"];
                    AlbumId=@"";
                    
                }
            }
            
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
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
        cell.First_imageview.layer.borderWidth=.50;
        cell.Second_imageview.layer.borderWidth=.50;
        cell.First_imageview.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.Second_imageview.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
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
        //pgr=nil;
        
        UITapGestureRecognizer *pgr1 = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handlePinch:)];
        [pgr1 setNumberOfTouchesRequired:1];
        [pgr1 setNumberOfTapsRequired:1];
        [pgr1 setDelegate:self];
        [cell.Second_imageview addGestureRecognizer:pgr1];
        
        // pgr1=nil;
        
        if (multimediaData.count > 2*indexPath.row ) {
            cell.First_imageview.tag=2*indexPath.row;
            [cell.First_imageview setImage:[UIImage imageNamed:@"folder_image.png"]];
            
            [cell.First_lblName setText:[[multimediaData objectAtIndex:(2*indexPath.row)] valueForKey:@"name"] ?[[multimediaData objectAtIndex:(2*indexPath.row)] valueForKey:@"name"] : @""];
            [cell.First_textViewDes setText:[[multimediaData objectAtIndex:(2*indexPath.row) ] valueForKey:@"description"] ?[[multimediaData objectAtIndex:(2*indexPath.row) ] valueForKey:@"description"]  :@""];
            
        }else
        {
            cell.First_imageview.hidden=YES;
            cell.First_lblName.hidden=YES;
            cell.First_textViewDes.hidden=YES;
        }
        
        if (multimediaData.count > 2*indexPath.row+1) {
            cell.Second_imageview.tag=2*indexPath.row+1;
            [cell.Second_imageview setImage:[UIImage imageNamed:@"folder_image.png"]];
            [cell.Second_lblName setText:[[multimediaData objectAtIndex:(2*indexPath.row+1)] valueForKey:@"name"] ?[[multimediaData objectAtIndex:(2*indexPath.row)+1] valueForKey:@"name"] : @""];
            [cell.SecondTextviewDes setText:[[multimediaData objectAtIndex:(2*indexPath.row+1) ] valueForKey:@"description"] ?[[multimediaData objectAtIndex:(2*indexPath.row+1) ] valueForKey:@"description"]  :@""];
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
            [cell.First_lblName setText:[[multimediaData valueForKey:@"name"] objectAtIndex:(2*indexPath.row)]];
            [cell.First_textViewDes setText:[[multimediaData valueForKey:@"description"] objectAtIndex:(2*indexPath.row)]];
        }else
        {
            cell.First_imageview.hidden=YES;
            cell.First_lblName.hidden=YES;
            cell.First_textViewDes.hidden=YES;
        }
        
        
        if (multimediaData.count > 2*indexPath.row+1) {
            
            [cell.Second_imageview setImageWithURL:[[multimediaData valueForKey:@"img"] objectAtIndex:(2*indexPath.row+1)] placeholderImage:[UIImage imageNamed:@"profile_icon.png"]];
            [cell.Second_lblName setText:[[multimediaData valueForKey:@"name"] objectAtIndex:indexPath.row+1]];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIPAD) {
        return 240;
    }else{
        return 190;
    }
    
    
}
-(void)handlePinch :(UITapGestureRecognizer *)pinchGestureRecognizer
{
    
    
    titleIndex=(int)pinchGestureRecognizer.view.tag;
    AlbumId=[[multimediaData objectAtIndex:pinchGestureRecognizer.view.tag] valueForKey:@"id"];
    [self getMultimediaAlbum];
    
    
}

#pragma mark- UITextfield Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (arrSeasons.count > 0) {
        currentText=textField;
        [listPicker reloadComponent:0];
        [self setPickerVisibleAt:YES:arrSeasons];
        
    }else{
        [SingaltonClass initWithTitle:@"" message:@"Seasons list is not exist" delegate:nil btn1:@"Ok"];
    }
    
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
