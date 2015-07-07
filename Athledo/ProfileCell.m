//
//  ProfileCell.m
//  Athledo
//
//  Created by Smartdata on 7/28/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "ProfileCell.h"
#import "AppDelegate.h"
#import "LoginVeiw.h"


#define textAlignment NSTextAlignmentCenter


#define SchoolInfoDashX isIPAD ? 110 : 150
#define SchoolInfoDateW isIPAD ? 110 : 80
#define SchoolInfoDesW isIPAD ? 300 : 200
#define LINE_SEP_W isIPAD ? 468 : 220
#define AwardInfoW isIPAD ? 200 : 200
#define FName_W isIPAD ? 135 : 130

#define iconRightPosition 265
#define GenralInfoWeight isIPAD ? 210 : 150
#define Y_axis_Gap isIPAD ? 15 : 15
#define GenralInfoAlignment NSTextAlignmentLeft
#define SportInfoAlignment NSTextAlignmentLeft
#define ColorLightgray [UIColor lightGrayColor]
#define ColorGray [UIColor grayColor]
#define FieldClearBackground [UIColor clearColor]
#define FieldWhiteBackground [UIColor whiteColor]

#define VIEW_X  30
#define sportinfoFont isIPAD ? [UIFont fontWithName:@"HelveticaNeue" size:16] : [UIFont fontWithName:@"HelveticaNeue" size:13];

@implementation ProfileCell
@synthesize addProfileDelegate;

int GenralInfoX;
int TeamInfoX;
int SchoolInfoX;
int SchoolInfoDateX;
int LINE_SEP_X;
int AwardInfoCupX;
int AwardInfoX;
int AthleteSportX;
int iconleftPosition;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)refreshValues
{
    SingletonClass *Obj=[SingletonClass ShareInstance];
    UIDeviceOrientation orientation=Obj.GloableOreintation;
    if ((orientation==UIDeviceOrientationLandscapeRight || orientation==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationPortrait || orientation==UIDeviceOrientationFaceUp)) {
        iconleftPosition=isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) ? 440  :300) : 80 ;
        GenralInfoX = isIPAD ?  (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight || orientation==UIDeviceOrientationFaceUp) ? 505  :365) : 150;
        TeamInfoX =isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight ) || (orientation==UIDeviceOrientationFaceUp) ? 410  :270) : 60;
        SchoolInfoX=isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) || (orientation==UIDeviceOrientationFaceUp) ? 360  :240) : 60;
        SchoolInfoDateX=isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) || (orientation==UIDeviceOrientationFaceUp) ? 400  :270) : 70;
        LINE_SEP_X=isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) || (orientation==UIDeviceOrientationFaceUp) ? 310  :170) : 50;
        AwardInfoCupX=isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) || (orientation==UIDeviceOrientationFaceUp)? 500  :360)  : 140;
        AwardInfoX =isIPAD ? (([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) || (orientation==UIDeviceOrientationFaceUp) ? 430  :290)   : 60;
        AthleteSportX=isIPAD ?(([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight) || (orientation==UIDeviceOrientationFaceUp) ? 450  :330) : 90;
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath delegate:(id)del GenralInfo:(NSDictionary *)GenralInfo coachingInfo:(NSArray *)coachingInfo awardInfo:(NSArray *)awardInfo :(BOOL)isEdit
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self refreshValues];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIColor *colorPlaceHolder = [UIColor lightGrayColor];
    if (self)
    {
        if(indexPath.section==0)
        {
            ///   Coach / Athlete Genral info section
            
            int Fsection=1;
            NSMutableArray *arrIndex=MUTABLEARRAY;
            
            UITextField *txtFName = [[UITextField alloc] initWithFrame:CGRectMake(((GenralInfoX)-((FName_W)+5)), 0, FName_W, 30)];
            txtFName.tag = (indexPath.section+1)*1000+Fsection;
            txtFName.backgroundColor =isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtFName.delegate = del;
            txtFName.font = Textfont;
            //txtFName.borderStyle = UITextBorderStyleRoundedRect;
            txtFName.layer.borderWidth = 1;
            txtFName.layer.borderColor=(__bridge CGColorRef)([UIColor grayColor]);
            txtFName.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtFName.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtFName.borderStyle =isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            txtFName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtFName setTextAlignment:NSTextAlignmentRight];
            txtFName.text = [GenralInfo objectForKey:@"firstname"];
            // txtFName.placeholder = @"firstname";
            
            txtFName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"firstname" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtFName.alpha = 1.0;
            txtFName.userInteractionEnabled = isEdit;
            
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtFName.tag]];
            
            [self addSubview:txtFName];
            Fsection=Fsection+1;
            
            UITextField *txtLName = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, 0, GenralInfoWeight, 30)];
            txtLName.tag = (indexPath.section+1)*1000+Fsection;
            txtLName.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtLName.delegate = del;
            txtLName.font = Textfont;
            txtLName.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtLName.clearButtonMode = UITextFieldViewModeWhileEditing;
            txtLName.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            txtLName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtLName setTextAlignment:NSTextAlignmentLeft];
            txtLName.text = [GenralInfo  objectForKey:@"lastname"];
            // txtLName.placeholder = @"lastname";
            txtLName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"lastname" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtLName.alpha = 1.0;
            txtLName.userInteractionEnabled = isEdit;
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtLName.tag]];
            [self addSubview:txtLName];
            Fsection=Fsection+1;
            UIImageView *imageAddIndicator=[[UIImageView alloc] initWithFrame:CGRectMake(iconleftPosition, 32, 13, 15)];
            imageAddIndicator.image=[UIImage imageNamed:@"location_icon.png"];
            [self addSubview:imageAddIndicator];
            
             CGSize maxLabelSize = CGSizeMake(GenralInfoWeight, 60);
            CGSize expectedLabelSize = [[GenralInfo objectForKey:@"address"] sizeWithFont:txtLName.font constrainedToSize:maxLabelSize lineBreakMode:NSLineBreakByWordWrapping];
            UILabel *txtViewAddress = [[UILabel alloc] initWithFrame:CGRectMake(((GenralInfoX)), (Y_axis_Gap)+(txtFName.frame.origin.y + txtFName.frame.size.height/2), GenralInfoWeight, expectedLabelSize.height)];
            txtViewAddress.tag = (indexPath.section+1)*1000+Fsection;
            txtViewAddress.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtViewAddress.font =Textfont;
            txtViewAddress.textColor=isEdit ? ColorLightgray : ColorGray;;
            [txtViewAddress setTextAlignment:GenralInfoAlignment];
            
            txtViewAddress.text =[GenralInfo objectForKey:@"address"];
            txtViewAddress.lineBreakMode=NSLineBreakByWordWrapping;
            txtViewAddress.numberOfLines=2;
            txtViewAddress.alpha = 1.0;
            txtViewAddress.userInteractionEnabled = isEdit;
            
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtViewAddress.tag]];
            [self addSubview:txtViewAddress];
            
            Fsection=Fsection+1;
            
            //(Y_axis_Gap)+(txtFName.frame.origin.y + txtFName.frame.size.height/2)
            UITextField *txtfieldCountry = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, (Y_axis_Gap)+(txtViewAddress.frame.origin.y + txtViewAddress.frame.size.height/2), GenralInfoWeight, 20)];
            txtfieldCountry.tag = (indexPath.section+1)*1000+Fsection;
            txtfieldCountry.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtfieldCountry.delegate = del;
            txtfieldCountry.font = Textfont;
            txtfieldCountry.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtfieldCountry.borderStyle=isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            txtfieldCountry.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtfieldCountry setTextAlignment:GenralInfoAlignment];
            txtfieldCountry.text = [GenralInfo  objectForKey:@"country_name"];
            
            txtfieldCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"country_name" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            txtfieldCountry.alpha = 1.0;
            txtfieldCountry.userInteractionEnabled = isEdit;
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtfieldCountry.tag]];
            [self addSubview:txtfieldCountry];
            Fsection=Fsection+1;
            
            UITextField *txtfieldState = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, (Y_axis_Gap)+(txtfieldCountry.frame.origin.y + txtfieldCountry.frame.size.height/2), GenralInfoWeight, 20)];
            txtfieldState.tag = (indexPath.section+1)*1000+Fsection;
            txtfieldState.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtfieldState.delegate = del;
            txtfieldState.font = Textfont;
            //txtfieldState.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            txtfieldState.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtfieldState.borderStyle= isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            //txtfieldState.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtfieldState setTextAlignment:GenralInfoAlignment];
            
            txtfieldState.text = [GenralInfo  objectForKey:@"state_name"];
            //txtfieldState.placeholder = @"state_name";
            txtfieldState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"state_name" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtfieldState.alpha = 1.0;
            txtfieldState.userInteractionEnabled = isEdit;
            
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtfieldState.tag]];
            
            [self addSubview:txtfieldState];
            Fsection=Fsection+1;
            
            UITextField *txtfieldCity = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, (Y_axis_Gap)+(txtfieldState.frame.origin.y + txtfieldState.frame.size.height/2), GenralInfoWeight, 20)];
            txtfieldCity.tag = (indexPath.section+1)*1000+Fsection;
            txtfieldCity.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtfieldCity.delegate = del;
            txtfieldCity.font = Textfont;
            //txtfieldState.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            txtfieldCity.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtfieldCity.borderStyle= isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            //txtfieldState.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [txtfieldCity setTextAlignment:GenralInfoAlignment];
            
            txtfieldCity.text = [GenralInfo  objectForKey:@"city"];
            //txtfieldState.placeholder = @"state_name";
            txtfieldCity.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"city" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtfieldCity.alpha = 1.0;
            txtfieldCity.userInteractionEnabled = isEdit;
            
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtfieldCity.tag]];
            
            [self addSubview:txtfieldCity];
            Fsection=Fsection+1;

            
            UILabel *lblapt= [[UILabel alloc] initWithFrame:CGRectMake(iconleftPosition, (Y_axis_Gap)+(txtfieldCity.frame.origin.y + txtfieldCity.frame.size.height/2), 65, 20)];
            lblapt.text = @"Unit No-";
            lblapt.font = isIPAD ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:13];
            lblapt.textColor=isEdit ? ColorLightgray : ColorGray;;
            lblapt.alpha = 1.0;
            lblapt.userInteractionEnabled = isEdit;
            
            [self addSubview:lblapt];
            
            UITextField *txtfieldAppt = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, (Y_axis_Gap)+(txtfieldCity.frame.origin.y + txtfieldCity.frame.size.height/2), GenralInfoWeight, 20)];
            txtfieldAppt.tag = (indexPath.section+1)*1000+Fsection;
            txtfieldAppt.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtfieldAppt.delegate = del;
            txtfieldAppt.font = Textfont;
            txtfieldAppt.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtfieldAppt.borderStyle= isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            [txtfieldAppt setTextAlignment:GenralInfoAlignment];
            txtfieldAppt.text =[GenralInfo objectForKey:@"apt_no"];
            //txtfieldAppt.placeholder = @"apt_no";
            txtfieldAppt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"apt_no" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtfieldAppt.alpha = 1.0;
            txtfieldAppt.keyboardType=UIKeyboardTypeNumberPad;
            txtfieldAppt.userInteractionEnabled = isEdit;
            
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtfieldAppt.tag]];
            
            [self addSubview:txtfieldAppt];
            Fsection=Fsection+1;
            
            UILabel *lblZip= [[UILabel alloc] initWithFrame:CGRectMake(iconleftPosition, (Y_axis_Gap)+(txtfieldAppt.frame.origin.y + txtfieldAppt.frame.size.height/2), 45, 20)];
            lblZip.text = @"Zip-";
            lblZip.font =isIPAD ? [UIFont fontWithName:@"HelveticaNeue" size:15] : [UIFont fontWithName:@"HelveticaNeue" size:13];
            lblZip.textColor=isEdit ? ColorLightgray : ColorGray;;
            lblZip.alpha = 1.0;
            lblZip.userInteractionEnabled = NO;
            
            [self addSubview:lblZip];
            
            UITextField *txtfieldZip = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, (Y_axis_Gap)+(txtfieldAppt.frame.origin.y + txtfieldAppt.frame.size.height/2), GenralInfoWeight, 20)];
            txtfieldZip.tag = (indexPath.section+1)*1000+Fsection;
            txtfieldZip.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtfieldZip.delegate = del;
            txtfieldZip.font =Textfont;
            //txtfieldZip.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            txtfieldZip.textColor=isEdit ? ColorLightgray : ColorGray;;
            txtfieldZip.borderStyle =isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            [txtfieldZip setTextAlignment:GenralInfoAlignment];
            // txtfieldZip.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            txtfieldZip.text =[GenralInfo objectForKey:@"zip"];
            txtfieldZip.keyboardType=UIKeyboardTypeNumberPad;
            // txtfieldZip.placeholder = @"zip";
            txtfieldZip.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"zip" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtfieldZip.alpha = 1.0;
            txtfieldZip.userInteractionEnabled = isEdit;
            
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtfieldZip.tag]];
            
            [self addSubview:txtfieldZip];
            Fsection=Fsection+1;
            
           
            UIImageView *img2=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X, (Y_axis_Gap)+(txtfieldZip.frame.origin.y + txtfieldZip.frame.size.height/2), LINE_SEP_W, 1)];
            img2.image=[UIImage imageNamed:@"menu_sep.png"];
            [self addSubview:img2];
            
            UITextField *txtViewPhone = [[UITextField alloc] initWithFrame:CGRectMake(GenralInfoX, (Y_axis_Gap)/2+(img2.frame.origin.y), GenralInfoWeight, 20)];
            txtViewPhone.tag = (indexPath.section+1)*1000+Fsection;
            txtViewPhone.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtViewPhone.delegate = del;
            txtViewPhone.font = Textfont;
            //txtViewPhone.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            txtViewPhone.textColor=isEdit ? ColorLightgray : ColorGray;;
            [txtViewPhone setTextAlignment:GenralInfoAlignment];
            
            txtViewPhone.borderStyle =isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
            txtViewPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"cellphone" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            txtViewPhone.keyboardType=UIKeyboardTypeNumberPad;
            txtViewPhone.text = [GenralInfo objectForKey:@"cellphone"];
            txtViewPhone.alpha = 1.0;
            txtViewPhone.userInteractionEnabled = isEdit;
            [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtViewPhone.tag]];
            
            [self addSubview:txtViewPhone];
            Fsection=Fsection+1;
            
            UIImageView *imagePhoneIndicator=[[UIImageView alloc] initWithFrame:CGRectMake(iconleftPosition,  ((txtViewPhone.frame.origin.y + (Y_axis_Gap)/2) - 5), 15, 15)];
            imagePhoneIndicator.image=[UIImage imageNamed:@"phone_icon.png"];
            
            [self addSubview:imagePhoneIndicator];
            
            UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X, (Y_axis_Gap)+(txtViewPhone.frame.origin.y + txtViewPhone.frame.size.height/2), LINE_SEP_W, 1)];
            img.image=[UIImage imageNamed:@"menu_sep.png"];
            
            [self addSubview:img];
            
            
            UITextField *txtViewEmail = [[UITextField alloc] initWithFrame:CGRectMake((GenralInfoX)-40, (img.frame.origin.y + (Y_axis_Gap)/2), (GenralInfoWeight)+20, 20)];
            txtViewEmail.tag = (indexPath.section+1)*1000+Fsection;
            txtViewEmail.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
            txtViewEmail.delegate = del;
            txtViewEmail.font = Textfont;
            txtViewEmail.textColor=isEdit ? ColorLightgray : ColorGray;;
            [txtViewEmail setTextAlignment:GenralInfoAlignment];
            txtViewEmail.borderStyle =isEdit ? UITextBorderStyleNone : UITextBorderStyleNone;
            txtViewEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //txtViewEmail.placeholder = @"Email id";
            txtViewEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email id" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
            
            txtViewEmail.text =[UserInformation shareInstance].userEmail;
            txtViewEmail.alpha = 1.0;
            txtViewEmail.userInteractionEnabled = NO;
            
            [self addSubview:txtViewEmail];
            
            UIImageView *imageEmailIndicator=[[UIImageView alloc] initWithFrame:CGRectMake(iconleftPosition,(img.frame.origin.y + (Y_axis_Gap) - 5), 15, 10)];
            imageEmailIndicator.image=[UIImage imageNamed:@"email_icon.png"];
            [self addSubview:imageEmailIndicator];

            
            if (delegate.arrCellFieldTag.count > (indexPath.section + Fsection)) {
                [delegate.arrCellFieldTag replaceObjectAtIndex:indexPath.section withObject:arrIndex];
            }else{
                [delegate.arrCellFieldTag addObject:arrIndex];
            }
            
        }
        else if(indexPath.section < (1+ ([UserInformation shareInstance].userType == isCoach ? coachingInfo.count : coachingInfo.count)) )
        {
            int Ssection=1;
            NSMutableArray *arrIndex=MUTABLEARRAY;
            
            if ([UserInformation shareInstance].userType == 1)
            {
                ///   Coach Coaching info section
                
                long int index=indexPath.section-1;
                
                if (index==0)
                {
                    UIImageView *img3=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X, 5, LINE_SEP_W, 2)];
                    img3.image=[UIImage imageNamed:@"red_line.png"];
                    
                    [self addSubview:img3];
                    UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake((LINE_SEP_X)+(LINE_SEP_W)+10, 0, 20, 20)];
                    UIImage *imageEdit=[UIImage imageNamed:@"plus_icon.png"];
                    btnEdit.tag=1;
                    [btnEdit setBackgroundImage:imageEdit forState:UIControlStateNormal];
                    
                    [btnEdit addTarget:self action:@selector(addProfileCoachingInfo: ) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self addSubview:btnEdit];
                }
                UITextField *txtSchoolName = [[UITextField alloc] initWithFrame:CGRectMake(SchoolInfoX, 22, SchoolInfoDesW, 20)];
                txtSchoolName.tag = (indexPath.section+1)*1000+Ssection;
                
                txtSchoolName.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtSchoolName.delegate = del;
                txtSchoolName.font =Textfont;
                txtSchoolName.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtSchoolName.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtSchoolName.borderStyle =isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtSchoolName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [txtSchoolName setTextAlignment:textAlignment];
                txtSchoolName.text = [[coachingInfo objectAtIndex:index] objectForKey:@"school_name"];
                txtSchoolName.alpha = 1.0;
                txtSchoolName.userInteractionEnabled = isEdit;
                // txtSchoolName.placeholder=@"school_name";
                
                txtSchoolName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"school_name" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtSchoolName.tag]];
                [self addSubview:txtSchoolName];
                Ssection=Ssection+1;
                UITextField *txtGame = [[UITextField alloc] initWithFrame:CGRectMake(SchoolInfoX, 45, SchoolInfoDesW, 20)];
                txtGame.tag = (indexPath.section+1)*1000+Ssection;
                txtGame.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtGame.delegate = del;
                txtGame.font = Textfont;
                //txtGame.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                txtGame.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtGame.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtGame.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [txtGame setTextAlignment:textAlignment];
                txtGame.text = [[coachingInfo objectAtIndex:index] objectForKey:@"sport_name"] ;
                txtGame.alpha = 1.0;
                txtGame.userInteractionEnabled = isEdit;
                //txtGame.placeholder=@"sport_name";
                txtGame.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"sport_name" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtGame.tag]];
                [self addSubview:txtGame];
                Ssection=Ssection+1;
                
                UITextField *txtFromDate = [[UITextField alloc] initWithFrame:CGRectMake(SchoolInfoDateX, 67,SchoolInfoDateW, 20)];
                txtFromDate.tag = (indexPath.section+1)*1000+Ssection;
                txtFromDate.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtFromDate.delegate = del;
                txtFromDate.font = Textfont;
                //txtFromDate.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                txtFromDate.textColor=isEdit ? ColorLightgray : ColorGray;;
                
                txtFromDate.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtFromDate.borderStyle= isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtFromDate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [txtFromDate setTextAlignment:NSTextAlignmentRight];
                
                txtFromDate.text =[self dateFormate :[[coachingInfo objectAtIndex:index] objectForKey:@"from"]] ;
                txtFromDate.alpha = 1.0;
                txtFromDate.userInteractionEnabled = isEdit;
                txtFromDate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"from" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtFromDate.tag]];
                [self addSubview:txtFromDate];
                Ssection=Ssection+1;
                UILabel *lblDash = [[UILabel alloc] initWithFrame:CGRectMake(((SchoolInfoDateX)+(SchoolInfoDateW)), 67, 10, 20)];
                lblDash.text = @" - ";
                [lblDash setTextAlignment:NSTextAlignmentCenter];
                lblDash.alpha = 1.0;
                lblDash.userInteractionEnabled = isEdit;
                lblDash.textColor=isEdit ? ColorLightgray : ColorGray;;
                [self addSubview:lblDash];
                UITextField *txtToDate = [[UITextField alloc] initWithFrame:CGRectMake(((SchoolInfoDateX)+(SchoolInfoDateW) + (lblDash.frame.size.width+5)), 67, SchoolInfoDateW, 20)];
                txtToDate.tag = (indexPath.section+1)*1000+Ssection;
                txtToDate.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtToDate.delegate = del;
                txtToDate.font =Textfont;
                txtToDate.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtToDate.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtToDate.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtToDate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [txtToDate setTextAlignment:NSTextAlignmentLeft];
                //txtToDate.text =[[coachingInfo objectAtIndex:index] objectForKey:@"from"];
                txtToDate.text =[self dateFormate :[[coachingInfo objectAtIndex:index] objectForKey:@"to"]] ;
                txtToDate.alpha = 1.0;
                txtToDate.userInteractionEnabled = isEdit;
                // txtToDate.placeholder=@"from";
                txtToDate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"to" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtToDate.tag]];
                
                [self addSubview:txtToDate];
                Ssection=Ssection+1;
                UITextView *txtDescription = [[UITextView alloc] initWithFrame:CGRectMake(SchoolInfoX, 87,SchoolInfoDesW, 60)];
                txtDescription.tag = (indexPath.section+1)*1000+Ssection;
                txtDescription.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtDescription.delegate = del;
                txtDescription.editable=NO;
                txtDescription.font = Textfont;
                //txtDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                txtDescription.textColor=isEdit ? ColorLightgray : ColorGray;;
                [txtDescription setTextAlignment:textAlignment];
                txtDescription.text =[[coachingInfo objectAtIndex:index] objectForKey:@"description"];
                txtDescription.alpha = 1.0;
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtDescription.tag]];
                Ssection=Ssection+1;
                
                [self addSubview:txtDescription];
                if (index==coachingInfo.count-1) {
                    
                }
                else{
                    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,155, LINE_SEP_W, 1)];
                    img.image=[UIImage imageNamed:@"menu_sep.png"];
                    [self addSubview:img];
                }
            }else
            {
                 long int index=indexPath.section-1;
                
                if ([UserInformation shareInstance].userType == isManeger && indexPath.section == 1) {
                   
                    UIButton *btnEdit =[[UIButton alloc] initWithFrame:CGRectMake((LINE_SEP_X)+(LINE_SEP_W)+10, 0, 20, 20)];
                    btnEdit.tag=1;
                    UIImage *imageEdit=[UIImage imageNamed:@"plus_icon.png"];
                    [btnEdit setBackgroundImage:imageEdit forState:UIControlStateNormal];
                    [btnEdit addTarget:self action:@selector(AddManagerSportInfo : ) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:btnEdit];
                    
                    UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,5, LINE_SEP_W, 2)];
                    img1.image=[UIImage imageNamed:@"red_line.png"];
                    [self addSubview:img1];
                }else {
                    if (index == 0) {
                        UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,0, LINE_SEP_W, 2)];
                        img1.image=[UIImage imageNamed:@"red_line.png"];
                        [self addSubview:img1];
                    }else{
                        UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,0, LINE_SEP_W, 1)];
                        img1.image=[UIImage imageNamed:@"menu_sep.png"];
                        [self addSubview:img1];
                    }
                }
                ///   Athlete Sport info section
                UILabel *lblAge= [[UILabel alloc] initWithFrame:CGRectMake(iconleftPosition, 15, 95, 25)];
                if ([UserInformation shareInstance].userType == isManeger) {
                     lblAge.text = @"Sport name :";
                }else
                {
                     lblAge.text = @"Age :";
                }
                lblAge.font = sportinfoFont;
                lblAge.textColor=isEdit ? ColorLightgray : ColorGray;;
                lblAge.alpha = 1.0;
                lblAge.userInteractionEnabled = isEdit;
                
                [self addSubview:lblAge];
                
                UITextField *txtAge = [[UITextField alloc] initWithFrame:CGRectMake(((AthleteSportX)+lblAge.frame.size.width-5), 15, 98, 20)];
                txtAge.tag = (indexPath.section+1)*1000+Ssection;
                txtAge.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtAge.delegate = del;
                txtAge.font = Textfont;
                txtAge.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtAge.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
                txtAge.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtAge.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                [txtAge setTextAlignment:SportInfoAlignment];
                if ([UserInformation shareInstance].userType == isManeger) {
                    txtAge.text =[[coachingInfo objectAtIndex:index] objectForKey:@"sport_name"];
                    txtAge.alpha = 1.0;
                    txtAge.userInteractionEnabled = isEdit;
                    txtAge.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"sport_name" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                }else
                {
                    txtAge.text =[[coachingInfo objectAtIndex:index] objectForKey:@"age"];
                    txtAge.alpha = 1.0;
                    txtAge.userInteractionEnabled = isEdit;
                    txtAge.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"age" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                }
              
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtAge.tag]];
                [self addSubview:txtAge];
                Ssection=Ssection+1;
                
                UILabel *lblHeight= [[UILabel alloc] initWithFrame:CGRectMake(iconleftPosition, 37, 90, 25)];
                lblHeight.text = @"Height :";
                lblHeight.font = sportinfoFont;
                lblHeight.textColor=isEdit ? ColorLightgray : ColorGray;;
                lblHeight.alpha = 1.0;
                lblHeight.userInteractionEnabled = isEdit;
                [self addSubview:lblHeight];
                
                UITextField *txtHeight = [[UITextField alloc] initWithFrame:CGRectMake(((AthleteSportX)+lblHeight.frame.size.width), 37, 98, 20)];
                txtHeight.tag = (indexPath.section+1)*1000+Ssection;
                txtHeight.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtHeight.delegate = del;
                txtHeight.font =Textfont;
                txtHeight.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtHeight.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
                
                txtHeight.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtHeight.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                [txtHeight setTextAlignment:SportInfoAlignment];
                txtHeight.text =[[[coachingInfo objectAtIndex:index] objectForKey:@"height"] stringByAppendingFormat:@" %@",@"ft"];
                txtHeight.alpha = 1.0;
                txtHeight.userInteractionEnabled = isEdit;
                txtHeight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"height" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtHeight.tag]];
                [self addSubview:txtHeight];
                Ssection=Ssection+1;
                
                UILabel *lblWeight= [[UILabel alloc] initWithFrame:CGRectMake(iconleftPosition, 59, 90, 25)];
                lblWeight.text = @"Weight :";
                lblWeight.font =sportinfoFont;
                lblWeight.textColor=isEdit ? ColorLightgray : ColorGray;;
                lblWeight.alpha = 1.0;
                lblWeight.userInteractionEnabled = isEdit;
                [self addSubview:lblWeight];
                
                UITextField *txtWeight = [[UITextField alloc] initWithFrame:CGRectMake(((AthleteSportX)+lblWeight.frame.size.width), 59, 98, 20)];
                txtWeight.tag = (indexPath.section+1)*1000+Ssection;
                txtWeight.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtWeight.delegate = del;
                txtWeight.font = Textfont;
                // txtWeight.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                txtWeight.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtWeight.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
                
                txtWeight.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtWeight.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                [txtWeight setTextAlignment:SportInfoAlignment];
                txtWeight.text =[[[coachingInfo objectAtIndex:index] objectForKey:@"weight"] stringByAppendingFormat:@" %@",@"lbs"];
                //txtWeight.placeholder=@"weight";
                txtWeight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"weight" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                
                txtWeight.alpha = 1.0;
                txtWeight.userInteractionEnabled = isEdit;
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtWeight.tag]];
                [self addSubview:txtWeight];
                Ssection=Ssection+1;
                
                UILabel *lblYear= [[UILabel alloc] initWithFrame:CGRectMake(iconleftPosition, 81, 90, 25)];
                lblYear.text = @"Class Year :";
                lblYear.font = sportinfoFont;
                lblYear.textColor=isEdit ? ColorLightgray : ColorGray;;
                lblYear.alpha = 1.0;
                lblYear.userInteractionEnabled = isEdit;
                [self addSubview:lblYear];
                
                UITextField *txtYear = [[UITextField alloc] initWithFrame:CGRectMake(((AthleteSportX)+lblYear.frame.size.width), 81, 78, 20)];
                txtYear.tag = (indexPath.section+1)*1000+Ssection;
                txtYear.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtYear.delegate = del;
                txtYear.font = Textfont;
                // txtYear.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                txtYear.textColor=isEdit ? ColorLightgray : ColorGray;;
                [txtYear setTextAlignment:SportInfoAlignment];
                txtYear.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtYear.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtYear.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                txtYear.text =[[coachingInfo objectAtIndex:index] objectForKey:@"class_year"];
                //txtYear.placeholder=@"class_year";
                txtYear.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"class_year" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                txtYear.alpha = 1.0;
                txtYear.userInteractionEnabled = isEdit;
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtYear.tag]];
                [self addSubview:txtYear];
            }
            
            if (delegate.arrCellFieldTag.count > (indexPath.section + Ssection)) {
                [delegate.arrCellFieldTag replaceObjectAtIndex:indexPath.section withObject:arrIndex];
            }else{
                [delegate.arrCellFieldTag addObject:arrIndex];
            }
            
        }
        else if(indexPath.section < (1+([UserInformation shareInstance].userType == isCoach ? coachingInfo.count : coachingInfo.count)+awardInfo.count))
        {
            
            long int index=indexPath.section-(1+([UserInformation shareInstance].userType == isCoach ? coachingInfo.count : coachingInfo.count));
            int Thsection=1;
            NSMutableArray *arrIndex=MUTABLEARRAY;
            if ([UserInformation shareInstance].userType == 1)
            {
                ///   Coach Awards info section
                UITextField *txtyear;
                UITextField *txtAwardName;
                UITextView *txtdescription;
                
                if (index==0) {
                    UIImageView *imgLine=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X, 5, LINE_SEP_W, 2)];
                    imgLine.image=[UIImage imageNamed:@"red_line.png"];
                    [self addSubview:imgLine];
                    
                    UIButton *btnEdit =[[UIButton alloc] initWithFrame:CGRectMake((LINE_SEP_X)+(LINE_SEP_W)+10, 0, 20, 20)];
                    UIImage *imageEdit=[UIImage imageNamed:@"plus_icon.png"];
                    btnEdit.tag=2;
                    [btnEdit setBackgroundImage:imageEdit forState:UIControlStateNormal];
                    
                    [btnEdit addTarget:self action:@selector(addProfileAwardsInfo :) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self addSubview:btnEdit];
                    
                    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(AwardInfoCupX,15, 50, 60)];
                    img.image=[UIImage imageNamed:@"cup_icon.png"];
                    [self addSubview:img];
                    UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,162, LINE_SEP_W, 1)];
                    img1.image=[UIImage imageNamed:@"menu_sep.png"];
                    [self addSubview:img1];
                    
                    txtyear = [[UITextField alloc] initWithFrame:CGRectMake(AwardInfoX, 83, AwardInfoW, 20)];
                    txtAwardName = [[UITextField alloc] initWithFrame:CGRectMake(AwardInfoX, 110, AwardInfoW, 20)];
                    txtdescription = [[UITextView alloc] initWithFrame:CGRectMake(AwardInfoX, 125, AwardInfoW, 35)];
                }
                else {
                    
                    txtyear = [[UITextField alloc] initWithFrame:CGRectMake(AwardInfoX, 10, AwardInfoW, 20)];
                    
                    txtAwardName = [[UITextField alloc] initWithFrame:CGRectMake(AwardInfoX, 40, AwardInfoW, 20)];
                    txtdescription = [[UITextView alloc] initWithFrame:CGRectMake(AwardInfoX, 60, AwardInfoW, 35)];
                    
                    UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,100, LINE_SEP_W, 1)];
                    img1.image=[UIImage imageNamed:@"menu_sep.png"];
                    [self addSubview:img1];
                    
                }
                
                txtyear.tag = (indexPath.section+1)*1000+Thsection;
                txtyear.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtyear.delegate = del;
                txtyear.font = Textfont;
                [txtyear setTextAlignment:textAlignment];
                txtyear.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtyear.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtyear.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
                txtyear.text = [[awardInfo objectAtIndex:index] objectForKey:@"year_of_award"];;
                txtyear.alpha = 1.0;
                txtyear.userInteractionEnabled = isEdit;
                // txtyear.placeholder=@"year_of_award";
                txtyear.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"year_of_award" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtyear.tag]];
                [self addSubview:txtyear];
                Thsection=Thsection+1;
                
                txtAwardName.tag = (indexPath.section+1)*1000+Thsection;
                txtAwardName.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtAwardName.delegate = del;
                //txtAwardName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
                txtAwardName.font = Textfont;
                txtAwardName.textColor=isEdit ? ColorLightgray : ColorGray;;
                
                txtAwardName.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtAwardName.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtAwardName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [txtAwardName setTextAlignment:textAlignment];
                txtAwardName.text = [[awardInfo objectAtIndex:index] objectForKey:@"title"];
                txtAwardName.alpha = 1.0;
                txtAwardName.userInteractionEnabled = isEdit;
                //txtAwardName.placeholder=@"title";
                txtAwardName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"title" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtAwardName.tag]];
                [self addSubview:txtAwardName];
                Thsection=Thsection+1;
                
                txtdescription.tag = (indexPath.section+1)*1000+Thsection;
                txtdescription.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtdescription.delegate = del;
                txtdescription.font =Textfont;
                txtdescription.textColor=isEdit ? ColorLightgray : ColorGray;;
                txtdescription.text =  [[awardInfo objectAtIndex:index] objectForKey:@"description"];
                [txtdescription setTextAlignment:textAlignment];
                txtdescription.alpha = 1.0;
                txtdescription.editable=NO;
                
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtdescription.tag]];
                [self addSubview:txtdescription];
                
            }else
            {
                ///   Athelete History info section
                
                if (index == 0)
                {
                    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X,5, LINE_SEP_W, 2)];
                    img.image=[UIImage imageNamed:@"red_line.png"];
                    [self addSubview:img];
                    UIButton *btnEdit =[[UIButton alloc] initWithFrame:CGRectMake((LINE_SEP_X)+(LINE_SEP_W)+10, 0, 20, 20)];
                    btnEdit.tag=1;
                    UIImage *imageEdit=[UIImage imageNamed:@"plus_icon.png"];
                    [btnEdit setBackgroundImage:imageEdit forState:UIControlStateNormal];
                    [btnEdit addTarget:self action:@selector(AddProfileHistoryInfo : ) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:btnEdit];
                }
                
                
                UITextField *txtTeam = [[UITextField alloc] initWithFrame:CGRectMake((TeamInfoX), 22, 200, 20)];
                txtTeam.tag = (indexPath.section+1)*1000+Thsection;
                txtTeam.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtTeam.delegate = del;
                txtTeam.font =Textfont;
                
                txtTeam.textColor=isEdit ? ColorLightgray : ColorGray;
                
                txtTeam.clearButtonMode = UITextFieldViewModeWhileEditing;
                txtTeam.borderStyle = isEdit ? UITextBorderStyleLine : UITextBorderStyleNone;
                txtTeam.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [txtTeam setTextAlignment:textAlignment];
                txtTeam.text =[[awardInfo objectAtIndex:index] objectForKey:@"team"];;
                //txtTeam.placeholder=@"team";
                txtTeam.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Add Team info" attributes:@{NSForegroundColorAttributeName: colorPlaceHolder}];
                
                txtTeam.alpha = 1.0;
                txtTeam.userInteractionEnabled = isEdit;
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtTeam.tag]];
                
                [self addSubview:txtTeam];
                Thsection=Thsection+1;
                
                UITextView *txtTeamDiscription = [[UITextView alloc] initWithFrame:CGRectMake((TeamInfoX), 47, 200, 60)];
                txtTeamDiscription.tag = (indexPath.section+1)*1000+Thsection;
                txtTeamDiscription.backgroundColor = isEdit ? FieldWhiteBackground : FieldClearBackground;
                txtTeamDiscription.delegate = del;
                //txtTeamDiscription.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
                txtTeamDiscription.font = Textfont;
                txtTeamDiscription.textColor=isEdit ? ColorLightgray : ColorGray;;
                [txtTeamDiscription setTextAlignment:textAlignment];
                
                txtTeamDiscription.text =[[awardInfo objectAtIndex:index] objectForKey:@"description"];;
                txtTeamDiscription.alpha = 1.0;
                txtTeamDiscription.editable=NO;
                txtTeamDiscription.textColor=isEdit ? ColorLightgray : ColorGray;;
                [txtTeamDiscription setTextAlignment:textAlignment];
                [arrIndex addObject:[NSString stringWithFormat:@"%ld",(long)txtTeamDiscription.tag]];
                [self addSubview:txtTeamDiscription];
                
                UIImageView *img1=[[UIImageView alloc] initWithFrame:CGRectMake(LINE_SEP_X, 120, LINE_SEP_W, 1)];
                img1.image=[UIImage imageNamed:@"menu_sep.png"];
                [self addSubview:img1];
            }
            if (delegate.arrCellFieldTag.count > (indexPath.section + Thsection)) {
                [delegate.arrCellFieldTag replaceObjectAtIndex:indexPath.section withObject:arrIndex];
            }else{
                [delegate.arrCellFieldTag addObject:arrIndex];
            }
        }
        else
        {
            
        }
    }
    return self;
}
#pragma mark UITableviewCell Delegate 
-(void)AddManagerSportInfo :(id)sender
{
    UIButton *btn=sender;
    long int tag=btn.tag;
    [self.addProfileDelegate AddManagerSportInfo:tag];
}

-(void)addProfileCoachingInfo :(id)sender
{
    UIButton *btn=sender;
    long int tag=btn.tag;
    [self.addProfileDelegate AddCoachingInfo :tag];
}

-(void)addProfileAwardsInfo :(id)sender
{
    UIButton *btn=sender;
    long int tag=btn.tag;
    [self.addProfileDelegate AddAwardsInfo :tag];
}

-(void)AddProfileHistoryInfo :(id)sender
{
    UIButton *btn=sender;
    long int tag=btn.tag;
    [self.addProfileDelegate AddHistoryInfo :tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(NSString *)dateFormate : (NSString *)strdate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATE_FORMAT_D_M_Y];
    NSDate *date=[df dateFromString:strdate];
    [df setDateFormat:DATE_FORMAT_dd_MMM_yyyy];
    if(date==nil)
    {
        return @"Present";
    }else{
        return [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
    }
}

@end
