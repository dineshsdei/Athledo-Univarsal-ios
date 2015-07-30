//
//  UpdateDetails.m
//  Athledo
//
//  Created by Smartdata on 8/19/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "UpdateDetails.h"
#import "AnnouncementView.h"
#import "AddNewAnnouncement.h"

#define deleteAnnouncement 1122220
#define editAnnouncement 120
@interface UpdateDetails ()
@end
@implementation UpdateDetails
@synthesize strDate,strDes,strName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad{
    webservice = [WebServiceClass shareInstance];
    webservice.delegate=self;
    self.title = @"Detail";
    _lblName.text=strName;
    _lblDate.text=strDate;
    _tvDes.text=strDes;
    _tvDes.layer.borderWidth = .50;
    _tvDes.layer.cornerRadius = 10;
    _tvDes.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _lblSenderName.text = [_obj valueForKey:@"sender"];
    _lblName.font = Textfont;
    _lblDate.font = SmallTextfont;
    _lblSenderName.font = SmallTextfont;
    _lblMEorAll.font = SmallTextfont;
    self.navigationController.navigationBar.titleTextAttributes= [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 NAVIGATION_COMPONENT_COLOR,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:NavFontSize],NSFontAttributeName,nil];
    self.navigationController.navigationBar.tintColor = NAVIGATION_COMPONENT_COLOR;
    // Only Coach can edit and delete announcement
    if ([UserInformation shareInstance].userType == 1 || [UserInformation shareInstance].userType == 4) {
        _lblMEorAll.text = @"To All";
        // newView used for set button on middle of view if have need use it
        CGRect applicationFrame;
        if (isIPAD) {
            applicationFrame = CGRectMake(508, 0, 260, 50);
        }else{
            applicationFrame = CGRectMake(50, 0, 260, 50);
        }
        UIView * newView = [[UIView alloc] initWithFrame:applicationFrame] ;
        newView.backgroundColor = [UIColor clearColor];
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageDelete = [UIImage imageNamed:@"navDeleteBtn.png"];
        btnDelete.bounds = CGRectMake( 80, 0, imageDelete.size.width, imageDelete.size.height );
        [btnDelete addTarget:self action:@selector(DeleteAnnouncement:) forControlEvents:UIControlEventTouchUpInside];
        [btnDelete setImage:imageDelete forState:UIControlStateNormal];
        UIBarButtonItem *BarItemDelete = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
        UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageEdit = [UIImage imageNamed:@"edit.png"];
        btnEdit.bounds = CGRectMake( 200, 0, imageDelete.size.width, imageDelete.size.height );
        [btnEdit addTarget:self action:@selector(EditAnnouncement:) forControlEvents:UIControlEventTouchUpInside];
        [btnEdit setImage:imageEdit forState:UIControlStateNormal];
        
        UIBarButtonItem *BarItemEdit = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
        [newView addSubview:btnDelete];
        [newView addSubview:btnEdit];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:BarItemEdit,BarItemDelete, nil];
    }else{
        _lblMEorAll.text=@"To Me";
    }
    [objPic setImageWithURL:[NSURL URLWithString:[_obj valueForKey:@"user_image"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageCacheMemoryOnly];
    //objPic.contentMode=UIViewContentModeScaleAspectFit;
    objPic.layer.borderWidth = .50;
    objPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if (_NotificationStataus) {
        [self DeleteNotificationFromWeb];
    }
    [super viewDidLoad];
    //Do any additional setup after loading the view from its nib.
}
-(void)EditAnnouncement:(id)sender{
    AddNewAnnouncement *addNew = [[AddNewAnnouncement alloc] initWithNibName:@"AddNewAnnouncement" bundle:nil];
    addNew.obj = _obj;
    addNew.ScreenTitle = @"Edit Announcement";
    [self.navigationController pushViewController:addNew animated:YES];
}
-(void)DeleteNotificationFromWeb{
    //NOTE ---  type=(1=>announcement, 2=>event, 3=>workout)
    if ([SingletonClass  CheckConnectivity]) {
        if (_obj) {
            UserInformation *userInfo= [UserInformation shareInstance];
            NSString *strURL = [NSString stringWithFormat:@"{\"type\":\"%d\",\"parent_id\":\"%d\",\"team_id\":\"%d\",\"user_id\":\"%d\"}",1,[[_obj objectForKey:@"id"] intValue],userInfo.userSelectedTeamid,userInfo.userId];
            //[SingaltonClass addActivityIndicator:self.view];
            [webservice WebserviceCall:webServiceDeleteNotification :strURL : deleteNotificationTag];
        }
    }else{
        //[SingaltonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
    }
}
-(void)DeleteAnnouncement:(id)sender{
    [SingletonClass initWithTitle:EMPTYSTRING message: @"Do you want to delete announcement?" delegate:self btn1:@"No" btn2:@"Yes" tagNumber:1];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [SingletonClass ShareInstance].isAnnouncementUpdate = TRUE;
        [self deletCellFromWeb];
    }else  if (buttonIndex == 0 && alertView.tag==10){
        NSArray *arrController = [self.navigationController viewControllers];
        BOOL Status = FALSE;
        for (id object in arrController){
            if ([object isKindOfClass:[AnnouncementView class]]){
                Status = TRUE;
                [self.navigationController popToViewController:object animated:NO];
            }
        }
        if (Status == FALSE){
            AnnouncementView *annView = [[AnnouncementView alloc] init];
            [self.navigationController pushViewController:annView animated:NO];
        }
    }
}
- (void)deletCellFromWeb{
    if ([SingletonClass  CheckConnectivity]) {
        int Ann_id = [[_obj valueForKey:@"id"] intValue];
        NSString *strURL = [NSString stringWithFormat:@"{\"ancmnt_id\":\"%d\"}",Ann_id];
        [SingletonClass addActivityIndicator:self.view];
        [webservice WebserviceCall:webServicedeleteAnnouncement :strURL :deleteAnnouncement];
    }else{
    [SingletonClass initWithTitle:EMPTYSTRING message:INTERNET_NOT_AVAILABLE delegate:nil btn1:@"Ok"];
 }
}
-(void)WebserviceResponse:(NSMutableDictionary *)MyResults :(int)Tag{
    [SingletonClass RemoveActivityIndicator:self.view];
    switch (Tag){
        case deleteAnnouncement:{
             if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
                [SingletonClass initWithTitle:EMPTYSTRING message:@"Announcement has been deleted successfully" delegate:self btn1:@"Ok" btn2:nil tagNumber:10];
            }
        }
        case deleteNotificationTag:{
        if([[MyResults objectForKey:STATUS] isEqualToString:SUCCESS]){
            // Do nothing
            }
            break;
        }
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
