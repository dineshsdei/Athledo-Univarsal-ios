//
//  ProfileView.m
//  Athledo
//
//  Created by Dinesh on 20/07/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "ProfileView.h"
#import "SWRevealViewController.h"
#import "DashBoard.h"
#import "AddAthleteHistory.h"
#import "CoachingHistory.h"
#import "Sports.h"
#import "Awards.h"
#import "AthleteHistory.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ProfileCell.h"
#import "AddCoachingHistory.h"
#import "AddAthleteHistory.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define isCamraDevice UIImagePickerControllerSourceTypeCamera
#define EDITPROFILENUMBER 100
#define GETPROFILEDATANUMBER 200
#define UploadImageTag 500


@interface ProfileView ()
{
    NSArray *arrCoachSection;
    NSArray *arrAthleteSection;
    NSArray *arrCellHeight;
    NSArray *arrAthleteCellHeight;
    
    NSMutableArray *arrCoaching;
    NSMutableArray *arrAwards;
    NSMutableDictionary *arrGenralinfo;
    NSMutableDictionary *arrSportInfo;
    
    
    
    SWRevealViewController *revealController;
    UIBarButtonItem *revealButtonItem;
    
    
    
    BOOL isEditProfilePic;
    
    BOOL isEntervale;
    UITextField *currentText;
    UIDeviceOrientation currentOrientation;
    
}

@end

@implementation ProfileView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSUInteger) supportedInterfaceOrientations
{
    UIDeviceOrientation orientation=[[SingletonClass ShareInstance] CurrentOrientation:self];
    
    if (isIPAD)
    {
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            return UIInterfaceOrientationMaskPortrait;
        }else if (orientation == UIDeviceOrientationPortrait) {
            return UIInterfaceOrientationMaskLandscape;
        }else{
            return UIInterfaceOrientationMaskPortrait;
        }
        
        
    }
    else
        return  UIInterfaceOrientationMaskPortrait;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)orientationChanged
{
    UIDeviceOrientation oreintation=[[SingletonClass ShareInstance] CurrentOrientation:self];
    
    if(currentOrientation ==oreintation)
    {
        return ;
    }
    currentOrientation=oreintation;
    
    if (isIPAD ) {
        [tblProfile reloadData];
    }
}
- (void)viewDidLoad
{
   
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    
   
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.title = @"Profile";
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                  [UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    tblProfile.backgroundColor=[UIColor clearColor];
    arrAthleteSection=[[NSArray alloc] initWithObjects:@"Genral Information",@"Sports",@"Athlete History", nil];
    arrCoachSection=[[NSArray alloc] initWithObjects:@"Genral Information",@"Coaching",@"Awards", nil];
    
    arrCellHeight=[[NSArray alloc] initWithObjects:@"220.0",@"150",@"150",@"165",@"165", nil];
    
    arrAthleteCellHeight=[[NSArray alloc] initWithObjects:@"220.0",@"114",@"114",@"114",@"114", nil];
    
    
    revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    [self.view addGestureRecognizer:revealController.tapGestureRecognizer];
    
    revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                        style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    
    btncamera.layer.masksToBounds = YES;
    // btncamera.layer.cornerRadius=50;
    btncamera.layer.cornerRadius= btncamera.frame.size.width/2;
    
    imageviewProfile.alpha=1;
    imageviewProfile.layer.masksToBounds = YES;
    imageviewProfile.layer.cornerRadius=imageviewProfile.frame.size.width/2;
    imageviewProfile.layer.borderWidth=3;
    imageviewProfile.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
}

- (void)getProfileData{
    
    self.navigationItem.leftBarButtonItem.enabled=NO;
    
    [activityIndicator startAnimating];
    [activityIndicator setHidden:NO];
    
    UserInformation *userInfo=[UserInformation shareInstance];
    
    if ([SingletonClass  CheckConnectivity]) {
        
        
        if (isEditProfilePic==NO) {
            ActiveIndicator *indicator = [[ActiveIndicator alloc] initActiveIndicator];
            indicator.tag = 50;
            [self.view addSubview:indicator];
        }
        
        NSString *strURL = [NSString stringWithFormat:@"{\"email\":\"%@\", \"id\":\"%d\", \"type\":\"%d\"}", [userInfo.userEmail lowercaseString],userInfo.userId,userInfo.userType];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webServiceProfileInfo]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *data = [NSMutableData data];
        
        [data appendData:[[NSString stringWithString:strURL] dataUsingEncoding: NSUTF8StringEncoding]];
        [request setHTTPBody:data];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if (data!=nil)
                                   {
                                       [self httpResponseReceived : data : GETPROFILEDATANUMBER];
                                   }else{
                                       self.navigationItem.leftBarButtonItem.enabled=YES;
                                       ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
                                       if(acti)
                                           [acti removeFromSuperview];
                                   }
                               }];
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    Objwebcervice =[WebServiceClass shareInstance];
    Objwebcervice.delegate=self;
    
    if ( [SingletonClass ShareInstance].isProfileSectionUpdate==TRUE) {
        
        arrAwards=nil;
        arrGenralinfo=nil;
        arrCoaching=nil;
        
        isEditProfilePic=NO;
        
        [UserInformation shareInstance].userProfilePicUrl=@"";
        
        // [tblProfile reloadData];
        
        [self performSelectorOnMainThread:@selector(getProfileData) withObject:nil waitUntilDone:YES];
        
        [SingletonClass ShareInstance].isProfileSectionUpdate=FALSE;
        
    }
    [super viewWillAppear:NO];
    
}

#pragma mark-  Http call back

-(void)httpResponseReceived:(NSData *)webResponse :(int)tagNumber
{
    // tagNumber -> 100 Edit Profile
    // tagNumber -> 200 view Profile
    // tagNumber -> 300 country list Profile
    
    
    self.navigationItem.leftBarButtonItem.enabled=YES;
    // Now remove the Active indicator
    if (isEditProfilePic==NO) {
        ActiveIndicator *acti = (ActiveIndicator *)[self.view viewWithTag:50];
        if(acti)
            [acti removeFromSuperview];
    }
    
    NSError *error=nil;
    NSMutableDictionary* myResults = [NSJSONSerialization JSONObjectWithData:webResponse options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    
    // Now we Need to decrypt data
    
    switch (tagNumber) {
        case GETPROFILEDATANUMBER:
        {
            
            UserInformation *userInfo=[UserInformation shareInstance];
            arrAwards=nil;
            arrGenralinfo=nil;
            arrCoaching=nil;
            userInfo.userProfilePicUrl=@"";
            
            // ***Tag 100 for Profile data in web service UserType 2->Athlete 1->coach
            
            if([[myResults objectForKey:@"status"] isEqualToString:@"success"] && tagNumber==200)
            {
                
                
                switch (userInfo.userType) {
                    case 1:
                    {
                        // coach  Section
                        
                        // Genral Info
                        
                        arrGenralinfo=[[myResults objectForKey:@"data"] objectForKey:@"UserProfile"] ;
                        
                        //[arrGenralinfo setObject:@"Dinesh" forKey:@"firstname"];
                        
                        arrCoaching=[[myResults objectForKey:@"data"] objectForKey:@"cochng_hstry"];
                        
                        if (arrCoaching.count==0) {
                            
                            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"from",@"",@"description",@"",@"school_name",@"",@"sport_name", @"",@"to",nil];
                            [arrCoaching addObject:dic];
                            
                        }
                        arrAwards=[[myResults objectForKey:@"data"] objectForKey:@"awards"];
                        
                        if (arrAwards.count==0) {
                            
                            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"title",@"",@"description",@"",@"year_of_award", nil];
                            [arrAwards addObject:dic];
                            
                        }
                        
                        userInfo.userProfilePicUrl=[[[myResults objectForKey:@"data"] objectForKey:@"UserProfile"]objectForKey:@"profile_img"] ;
                        
                        break;
                    }
                    case 2:
                    {
                        // Genral Info
                        
                        arrGenralinfo=[[myResults objectForKey:@"data"] objectForKey:@"UserProfile"] ;
                        
                        if ([[[myResults objectForKey:@"data"] objectForKey:@"AthleteSport"] isEqual:@""]) {
                            
                            [arrCoaching addObject:@""];
                        }else{
                            
                            arrCoaching=[[myResults objectForKey:@"data"] objectForKey:@"AthleteSport"];
                            
                        }
                        
                    arrAwards=[[myResults objectForKey:@"data"] objectForKey:@"athltc_hstry"];
                        if (arrAwards.count==0) {
                            
                            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"team",@"",@"description", nil];
                            [arrAwards addObject:dic];
                            
                        }
                       userInfo.userProfilePicUrl=[[[myResults objectForKey:@"data"] objectForKey:@"UserProfile"]objectForKey:@"profile_img"] ;
                        
                        break;
                    }
                        
                    default:
                        break;
                }
                [self AddProfilePic : userInfo.userProfilePicUrl];
                
                NSArray *arrController=[self.navigationController viewControllers];
                
                for (id object in arrController) {
                    if ([object isKindOfClass:[DashBoard class]])
                        
                        [self.navigationController popToViewController:object animated:NO];
                }
            }else{
                
                NSString *str=[myResults objectForKey:@"message"];
                
                if (str !=nil) {
                    [SingletonClass initWithTitle:@"" message:str delegate:nil btn1:@"Ok"];
                }
            }
            
            [tblProfile reloadData];
            break;
        }
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)AddAwardsInfo :(long int)tag
{
    AddCoachingHistory *AddCoachingInfo=[[AddCoachingHistory alloc] init];
    AddCoachingInfo.SectionTag=(int)tag;
    AddCoachingInfo.objData=nil;
    AddCoachingInfo.strTitle=@"Award Info";
    [self.navigationController pushViewController:AddCoachingInfo animated:YES];
}

-(void)AddCoachingInfo :(long int)tag
{
    AddCoachingHistory *AddCoachingInfo=[[AddCoachingHistory alloc] init];
    AddCoachingInfo.SectionTag=(int)tag;
    AddCoachingInfo.objData=nil;
    AddCoachingInfo.strTitle=@"Coaching Info";
    [self.navigationController pushViewController:AddCoachingInfo animated:YES];
    
}
-(void)AddHistoryInfo :(long int)tag
{
    AddAthleteHistory *objAthleteHistory=[[AddAthleteHistory alloc] init];
    objAthleteHistory.objData=nil;
    [self.navigationController pushViewController:objAthleteHistory animated:YES];
}

-(void)AddProfilePic :(NSString *)url
{
    NSString *temp=[url lastPathComponent];
    
    if ([temp isEqualToString:@"no_image.png"]) {
        
        url=@"";
        [activityIndicator setHidden:YES];
        // imageviewProfile.userInteractionEnabled=NO;
    }else {
        
        // imageviewProfile.userInteractionEnabled=NO;
        [UserInformation shareInstance].userPicUrl=url;
        [imageviewProfile setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
        
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:YES];
    }
    imageviewProfile.alpha=1;
    imageviewProfile.layer.masksToBounds = YES;
    imageviewProfile.layer.cornerRadius=imageviewProfile.frame.size.width/2;
    imageviewProfile.layer.borderWidth=3;
    imageviewProfile.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
}

- (IBAction)EditSavePIc:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Photo Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    ///[actionSheet showFromToolbar:self.navigationController.toolbar];
    [actionSheet showInView:self.view];
    
    
}

#pragma mark- UIActionSheet And ImagePicker
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0) // camera
    {
        
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isCameraDeviceAvailable:isCamraDevice]) {
            
            imgPicker.delegate = self;
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgPicker.allowsEditing = YES;
            [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        }
        
    }
    else if(buttonIndex==1)  //Library
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.allowsEditing = YES;
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // fullProfileImage.image=img;
    
    imageviewProfile.image=nil;
    activityIndicator.hidden=NO;
    [activityIndicator startAnimating];
    
    // imageviewProfile.image=img;
    
    [self UploadImage:img];
    
    // [btn setImage:[SingletonClass compressImage:img scaledToSize:CGSizeMake(btn.frame.size.width, btn.frame.size.height)] forState:UIControlStateNormal];
}

-(void)UploadImage:(UIImage *)Img
{
    isEditProfilePic=YES;
    NSData *imageData = UIImagePNGRepresentation(Img);
    
    if ([SingletonClass  CheckConnectivity]) {
        UserInformation *userInfo=[UserInformation shareInstance];
        
        NSString *strURL = [NSString stringWithFormat:@"{\"user_id\":\"%d\",\"image\":\"%@\"}",userInfo.userId,[imageData base64Encoding]];
        
        //[SingaltonClass addActivityIndicator:self.view];
        
        [Objwebcervice WebserviceCall:webServiceUploadImage :strURL :UploadImageTag];
        
    }else{
        
        [SingletonClass initWithTitle:@"" message:@"Internet connection is not available" delegate:nil btn1:@"Ok"];
        
    }
    
}

-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag
{
    [SingletonClass RemoveActivityIndicator:self.view];
    
    switch (Tag)
    {
        case UploadImageTag:
        {
            if([[MyResults objectForKey:@"status"] isEqualToString:@"sucess"])
            {
              // Now we Need to decrypt data
                
                [self getProfileData];
            }
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- UITextField Method

#pragma mark- TableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    if (arrGenralinfo.count > 0 && [UserInformation shareInstance].userType==1) {
        
        //return 1;
        return (1+arrCoaching.count+arrAwards.count);
        
    }else if (arrGenralinfo.count > 0 && [UserInformation shareInstance].userType==2) {
        
        //arrCoaching.count/4 because Athlete sport info is fixed 4 so it will 1
        return (1+(arrCoaching.count)+arrAwards.count);
        
    }else{
        
        return 0;
        
    }
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if(cell == nil)
    {
        cell = [[ProfileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"strIdentifier" indexPath:indexPath delegate:self GenralInfo:arrGenralinfo coachingInfo:arrCoaching awardInfo:arrAwards :NO];
        cell.addProfileDelegate=self;
        
        
    }else{
        
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section>0) {
        
        
    }
    if([UserInformation shareInstance].userType==2 && indexPath.section==1)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }else
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.frame=CGRectMake(0, 0, self.view.frame.size.width, cell.frame.size.height);
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([UserInformation shareInstance].userType)
    {
            
        case 1:
        {
            
            if (indexPath.section == 0)
            {
                
                return 220.0;
            }else  if (indexPath.section <  1+(arrCoaching.count))
            {
                
                return 150;
                
                
            }else  if (indexPath.section <  1+(arrCoaching.count)+arrAwards.count)
            {
                long int index=indexPath.section - (1+ arrCoaching.count);
                
                if (index == 0) {
                    
                    return 165;
                }else
                {
                    
                    return 114;
                }
                
            }
            
            
            break;
        }
            
        case 2:
        {
            if (indexPath.section == 0)
            {
                return 220.0;
            }else
            {
                return 115;
            }
            break;
        }
            
        default:
            
            return 130 ;
            
            break;
    }
    return 0 ;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([UserInformation shareInstance].userType)
    {
        case 1:
        {
            if (indexPath.section == 0)
            {
                NSArray *arrController=[self.navigationController viewControllers];
                BOOL Status=FALSE;
                for (id object in arrController)
                {
                    if ([object isKindOfClass:[EditGenralInfo class]])
                    {
                        Status=TRUE;
                        EditGenralInfo *objGenralInfo=(EditGenralInfo *)object;
                         objGenralInfo.objData=arrGenralinfo ;
                        [self.navigationController popToViewController:objGenralInfo animated:NO];
                    }
                }
                if (Status==FALSE)
                {
                    EditGenralInfo *AddInfo=[[EditGenralInfo alloc] initWithNibName:@"EditGenralInfo" bundle:nil];
                    AddInfo.objData=arrGenralinfo ;
                    [self.navigationController pushViewController:AddInfo animated:YES];

                }
                
            }else  if (indexPath.section <  1+(arrCoaching.count))
            {
                
                NSArray *arrController=[self.navigationController viewControllers];
                BOOL Status=FALSE;
                for (id object in arrController)
                {
                    if ([object isKindOfClass:[AddCoachingHistory class]])
                    {
                        Status=TRUE;
                        AddCoachingHistory *objCoachingInfo=(AddCoachingHistory *)object;
                        objCoachingInfo.SectionTag=1;
                        objCoachingInfo.objData=[[arrCoaching objectAtIndex:indexPath.section-1] valueForKey:@"id"] ?[arrCoaching objectAtIndex:indexPath.section-1] : nil ;
                        objCoachingInfo.strTitle=@"Coaching Info";
                        [self.navigationController popToViewController:objCoachingInfo animated:NO];
                    }
                }
                if (Status==FALSE)
                {
                    AddCoachingHistory *AddCoachingInfo=[[AddCoachingHistory alloc] initWithNibName:@"AddCoachingHistory" bundle:nil];
                    AddCoachingInfo.SectionTag=1;
                    AddCoachingInfo.objData=[[arrCoaching objectAtIndex:indexPath.section-1] valueForKey:@"id"] ?[arrCoaching objectAtIndex:indexPath.section-1] : nil ;
                    AddCoachingInfo.strTitle=@"Coaching Info";
                    [self.navigationController pushViewController:AddCoachingInfo animated:YES];

                    
                }
                
            }else  if (indexPath.section <  1+(arrCoaching.count)+arrAwards.count)
            {
                long int index=indexPath.section - (1+ arrCoaching.count);
                
                NSArray *arrController=[self.navigationController viewControllers];
                BOOL Status=FALSE;
                for (id object in arrController)
                {
                    if ([object isKindOfClass:[AddCoachingHistory class]])
                    {
                        Status=TRUE;
                        AddCoachingHistory *objCoachingInfo=(AddCoachingHistory *)object;
                        objCoachingInfo.objData=[[arrAwards objectAtIndex:index] valueForKey:@"id"] ?[arrAwards objectAtIndex:index] : nil;
                        objCoachingInfo.SectionTag=2;
                        objCoachingInfo.strTitle=@"Award";
                        [self.navigationController popToViewController:objCoachingInfo animated:NO];
                    }
                }
                if (Status==FALSE)
                {
                    AddCoachingHistory *AddCoachingInfo=[[AddCoachingHistory alloc] init];
                    AddCoachingInfo.objData=[[arrAwards objectAtIndex:index] valueForKey:@"id"] ?[arrAwards objectAtIndex:index] : nil;
                    AddCoachingInfo.SectionTag=2;
                    AddCoachingInfo.strTitle=@"Award";
                    [self.navigationController pushViewController:AddCoachingInfo animated:YES];
                    
                    
                }
                
            }
            break;
        }
            
        case 2:
        {
            if (indexPath.section == 0)
            {
                NSArray *arrController=[self.navigationController viewControllers];
                BOOL Status=FALSE;
                for (id object in arrController)
                {
                    if ([object isKindOfClass:[AddCoachingHistory class]])
                    {
                        Status=TRUE;
                        EditGenralInfo *objCoachingInfo=(EditGenralInfo *)object;
                        objCoachingInfo.objData=[arrGenralinfo valueForKey:@"id"] ? arrGenralinfo : nil ;
                        [self.navigationController popToViewController:objCoachingInfo animated:NO];
                    }
                }
                if (Status==FALSE)
                {
                    EditGenralInfo *AddInfo=[[EditGenralInfo alloc] init];
                    AddInfo.objData=[arrGenralinfo valueForKey:@"id"] ? arrGenralinfo : nil ;
                    [self.navigationController pushViewController:AddInfo animated:YES];
                }
            }else  if (indexPath.section <  1+(arrCoaching.count))
            {
                
            }else  if (indexPath.section <  1+(arrCoaching.count)+arrAwards.count)
            {
                long int index=indexPath.section - (1+ arrCoaching.count);
                
               
                
                NSArray *arrController=[self.navigationController viewControllers];
                BOOL Status=FALSE;
                for (id object in arrController)
                {
                    if ([object isKindOfClass:[AddAthleteHistory class]])
                    {
                        Status=TRUE;
                        AddAthleteHistory *objCoachingInfo=(AddAthleteHistory *)object;
                         objCoachingInfo.objData=[[arrAwards objectAtIndex:index] valueForKey:@"id"] ?[arrAwards objectAtIndex:index] : nil ;
                        [self.navigationController popToViewController:objCoachingInfo animated:NO];
                    }
                }
                if (Status==FALSE)
                {
                    AddAthleteHistory *objAthleteHistory=[[AddAthleteHistory alloc] initWithNibName:@"AddAthleteHistory" bundle:nil];
                    objAthleteHistory.objData=[[arrAwards objectAtIndex:index] valueForKey:@"id"] ?[arrAwards objectAtIndex:index] : nil ;
                    [self.navigationController pushViewController:objAthleteHistory animated:YES];
                }
                
                
                
            }
            
            break;
        }
    }
}



@end
