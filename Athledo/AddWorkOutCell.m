//
//  AddWorkOutCell.m
//  Athledo
//
//  Created by Smartdata on 8/14/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import "AddWorkOutCell.h"
#define CellX isIPAD ? 30 : 10
#define Add_Delete_Size isIPAD ? 30 : 25
#define CellWeight isIPAD ? ( ([SingletonClass ShareInstance].GloableOreintation== UIDeviceOrientationLandscapeLeft ) || ([SingletonClass ShareInstance].GloableOreintation== UIDeviceOrientationLandscapeRight) ? 960 : 708 ) : 300
#define TextFeildHeight isIPAD ? 40 : 30
#define CheckBoxEmailTag 1000;
#define CheckBoxAthleteTag 2000;

#define PlaceHolderColor [UIColor lightGrayColor]
#define TextFieldColor [UIColor grayColor]
#define FIRST_BOAT_Y isIPAD ? -10 : 0
#define FIELD_GAP 30

@implementation AddWorkOutCell
@synthesize delegate;

- (void)awakeFromNib{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath cellFields :(NSMutableArray *)arrfixCellFields liftFields :(NSMutableArray *)liftPlaceholder :(NSMutableDictionary *)WorkOutDic :(int)LiftExerciseCount :(id)del;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        // Else section for only lift workout Type
        if (!([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_EXERCISE])) {
            //  If section will design ui for all but else for  Email Notification and Athletes section
            
            if( (!([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:STR_ATHLETES]) && !([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:STR_EMAIL_NOTIFICATION]))){
                UITextField *txtField;
               // Height increase of description textfield
                if ([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_DESCRIPTION]) {
                    if(IS_IPHONE_5){
                        txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX,0, CellWeight, ((TextFeildHeight)+30))];
                    }else{
                        txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX,0, CellWeight, ((TextFeildHeight)+30))];
                    }
                }else{
                    if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_CUSTOM_TAG] ||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_EXERCISE_TYPE] ){
                        txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX, 0, ((CellWeight)-((isIPAD) ? 70 : 60)), TextFeildHeight)];
                    }else{
                    txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX, 0, CellWeight, TextFeildHeight)];
                    }
                }
                txtField.borderStyle = UITextBorderStyleRoundedRect;
                txtField.tag = indexPath.section;
                txtField.delegate = del;
                txtField.font = Textfont;
                // Add Dic data in textfield and placeholder text
                txtField.text=[self ValuesForKey:(int)(indexPath.section) :WorkOutDic :arrfixCellFields];
                txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[arrfixCellFields objectAtIndex:indexPath.section] attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                txtField.textColor=TextFieldColor;
                
                txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
                if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_WORKOUT_TYPE] || [[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_CUSTOM_TAG] ||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Enter Date"]||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_EXERCISE_TYPE]||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_UNIT]){
                    // Add arrow image in textfield
                    UIImage *image;
                    if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Enter Date"] ){
                        image=[UIImage imageNamed:@"calendar.png"];
                    }else{
                        image=[UIImage imageNamed:@"arrow.png"];
                    }
                    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
                    imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+10, txtField.frame.size.height/2-7,15, 15);
                    [txtField addSubview:imageview];
                    if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_CUSTOM_TAG] || [[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_EXERCISE_TYPE] ){
                        UIButton *btnAdd=[UIButton buttonWithType:UIButtonTypeCustom];
                        [btnAdd setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
                        btnAdd.frame=CGRectMake(txtField.frame.size.width+((isIPAD) ? 40 : 17), txtField.frame.size.height/2-((Add_Delete_Size)/2),(Add_Delete_Size),(Add_Delete_Size));
                        [self addSubview:btnAdd];
                        UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
                        [btnDelete setBackgroundImage:[UIImage imageNamed:@"deleteBtn_icon.png"] forState:UIControlStateNormal];
                        btnDelete.frame=CGRectMake(txtField.frame.size.width+btnAdd.frame.size.width+((isIPAD) ? 50 : 20), txtField.frame.size.height/2-14,(Add_Delete_Size+5),(Add_Delete_Size+5));
                        
                        if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:KEY_CUSTOM_TAG] ){
                            [btnAdd addTarget:self action:@selector(addCustomTag:) forControlEvents:UIControlEventTouchUpInside];
                            [btnDelete addTarget:self action:@selector(deleteCustomTag:) forControlEvents:UIControlEventTouchUpInside];
                        }else{
                            [btnAdd addTarget:self action:@selector(addExercise:) forControlEvents:UIControlEventTouchUpInside];
                            [btnDelete addTarget:self action:@selector(deleteExercise:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        [self addSubview:btnDelete];
                        btnAdd=nil;
                        btnDelete=nil;
                    }
                }
                [self addSubview:txtField];
                txtField=nil;
            }else if ((arrfixCellFields.count > indexPath.section ))
            {
                if ((indexPath.section == 5 && indexPath.row == 1) && [[WorkOutDic valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
                    [self addBoatFieldsWithPlusButton :del :WorkOutDic];
                }
                else if(indexPath.section == 5 && indexPath.row > 1){
                    [self addBoatFieldsWithDeleteButton :indexPath.row :del :WorkOutDic];
                }
                else{
                    // Email notification and Athletes section section
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CellX, -10, CellWeight, 30)];
                    lbl.textColor=TextFieldColor;
                    lbl.font = [UIFont fontWithName:fontName size:BigfontSize];
                    NSMutableArray *arrlblText;
                    
                    if ([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:STR_ATHLETES] ){
                        lbl.text= STR_ATHLETES;
                        if([[WorkOutDic valueForKey:KEY_EXERCISE_TYPE] isEqualToString:STR_ROWING]){
                            arrlblText=[[NSMutableArray alloc] initWithObjects:STR_WHOLE_TEAM,STR_ATHLETES,STR_GROUPS,STR_BOATS, nil];
                        }
                        else{
                            arrlblText=[[NSMutableArray alloc] initWithObjects:STR_WHOLE_TEAM,STR_ATHLETES,STR_GROUPS, nil];
                        }
                    }
                    else{
                        lbl.text= STR_EMAIL_NOTIFICATION;
                        arrlblText=[[NSMutableArray alloc] initWithObjects:@"Yes",@"No" , nil];
                    }
                    [self addSubview:lbl];
                    UILabel *lblBtnNearText;
                    UIButton *btnWholeTeam;
                    
                    int gap=(isIPAD) ? 30:8,btnWight=25;;
                    for (int i=0; i< arrlblText.count; i++) {
                        int lblWight=(isIPAD) ? ((CellWeight)/(arrlblText.count)-15): i ==0 ? 85: ((CellWeight)/(arrlblText.count)-15);
                        btnWholeTeam=[UIButton buttonWithType:UIButtonTypeCustom];
                        if (i==0 )
                        {
                            // Athletes section
                            if ((arrlblText.count== 3 || arrlblText.count== 4) && ([[WorkOutDic objectForKey:STR_WHOLE_TEAM] isEqual:@"1"]) ) {
                                btnWholeTeam.selected=YES;
                                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                            }else if ((arrlblText.count== 3 || arrlblText.count== 4)){
                                
                                btnWholeTeam.selected=NO;
                                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                            }
                            // if Email Section section
                            if (arrlblText.count== 2 && [[WorkOutDic objectForKey:STR_EMAIL_NOTIFICATION] isEqual:@"Yes"]) {
                                btnWholeTeam.selected=YES;
                                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                            }
                            else if (arrlblText.count== 2 && [[WorkOutDic objectForKey:STR_EMAIL_NOTIFICATION] isEqual:@"No"]){
                                
                                btnWholeTeam.selected=NO;
                                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                            }
                        }else{
                            switch (i) {
                                case 0:
                                {
                                    btnWholeTeam.selected=NO;
                                    [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                                    break;
                                }
                                case 1:
                                {
                                    if (![[WorkOutDic objectForKey:STR_ATHLETES] isEqual:EMPTYSTRING] && (arrlblText.count== 3 || arrlblText.count== 4))
                                    {
                                        btnWholeTeam.selected=YES;
                                        [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                                    }else{
                                        if (arrlblText.count== 2 && [[WorkOutDic objectForKey:STR_EMAIL_NOTIFICATION] isEqual:@"No"]) {
                                            btnWholeTeam.selected=YES;
                                            [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                                        }else{
                                            btnWholeTeam.selected=NO;
                                            [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                                        }
                                    }
                                    break;
                                }
                                case 2:
                                {
                                    if (![[WorkOutDic objectForKey:STR_GROUPS] isEqual:EMPTYSTRING])
                                    {
                                        btnWholeTeam.selected=YES;
                                        [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                                        
                                    }else{
                                        btnWholeTeam.selected=NO;
                                        [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                                    }
                                    break;
                                }
                                case 3:
                                {
                                    if ([[WorkOutDic objectForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]){
                                        btnWholeTeam.selected=YES;
                                        [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                                    }else{
                                        btnWholeTeam.selected=NO;
                                        [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                                    }
                                    break;
                                }
                                default:
                                    break;
                            }
                        }
                        btnWholeTeam.frame=CGRectMake(gap-2, 20,btnWight,25);
                        // Method calling different -2 for different-2 section
                        if ((arrlblText.count==3 )||(arrlblText.count==4)) {
                            [btnWholeTeam addTarget:self action:@selector(buttonClickAthletes :) forControlEvents:UIControlEventTouchUpInside];
                            btnWholeTeam.tag=i+CheckBoxAthleteTag;
                        }
                        else{
                            [btnWholeTeam addTarget:self action:@selector(buttonClickEmail :) forControlEvents:UIControlEventTouchUpInside];
                            btnWholeTeam.tag=i+CheckBoxEmailTag;
                        }
                        [self addSubview:btnWholeTeam];
                        btnWholeTeam=nil;
                        lblBtnNearText = [[UILabel alloc] initWithFrame:CGRectMake(gap+btnWight+2, 17, lblWight, 30)];
                        lblBtnNearText.text= [arrlblText objectAtIndex:i];
                        lblBtnNearText.font = [UIFont fontWithName:fontName size:SmallfontSize];
                        lblBtnNearText.textColor=TextFieldColor;
                        [self addSubview:lblBtnNearText];
                        lbl=nil;
                        gap=(btnWight+ (i == 1 ?lblWight+7:lblWight))*(i+1);
                        
                    }
                    arrlblText=nil;
                }
                }
            else{
                // This code unsed to show save button below of list but now it in top that why code will not run.
                
                UIButton *btnSave=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnSave setBackgroundImage:[UIImage imageNamed:@"deleteBtn_icon.png"] forState:UIControlStateNormal];
                btnSave.frame=CGRectMake(CellWeight/3, 10,CellWeight/3,30);
                [btnSave setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
                [btnSave setTitle:@"Save" forState:UIControlStateNormal];
                [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [btnSave addTarget:self action:@selector(SaveWorkOutData:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btnSave];
                btnSave=nil;
            }
        }
        else if(arrfixCellFields.count > indexPath.section){
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CellX, -10, CellWeight, 30)];
            lbl.textColor=TextFieldColor;
            lbl.font = [UIFont fontWithName:fontName size:BigfontSize];
            lbl.text= KEY_EXERCISE;
            [self addSubview:lbl];
            UITextField *txtField;
            int count=[self CountOfExerciseObject:arrfixCellFields];
            int valueIndex=(int)(indexPath.section-(arrfixCellFields.count-(count)));
            txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX, lbl.frame.size.height-10, ((CellWeight)-((isIPAD) ? 50 :40)), TextFeildHeight)];
            txtField.backgroundColor = [UIColor whiteColor];
            txtField.borderStyle = UITextBorderStyleRoundedRect;
            txtField.tag =indexPath.section-(arrfixCellFields.count-(count));;
            txtField.delegate = del;
            txtField.font = [UIFont fontWithName:fontName size:BigfontSize];
            // Add Dic data in textfield and placeholder text
            //txtField.placeholder =@"Name";
            txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
            txtField.textColor = TextFieldColor;
            if (valueIndex >= 0) {
                txtField.text=[self LiftValuesForKey:(int)(indexPath.section-(arrfixCellFields.count-(count))) :
                                    liftPlaceholder :txtField.placeholder];
            }
            txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            UIButton *btnWholeTeam;
            btnWholeTeam=[UIButton buttonWithType:UIButtonTypeCustom];
            btnWholeTeam.frame=CGRectMake(txtField.frame.size.width+((isIPAD) ? 50:20), txtField.frame.origin.y+1, Add_Delete_Size, Add_Delete_Size);
            if (arrfixCellFields.count-(count)==indexPath.section){
                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
                [btnWholeTeam addTarget:self action:@selector(addExerciseSection:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                
                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"deleteBtn_icon.png"] forState:UIControlStateNormal];
                [btnWholeTeam addTarget:self action:@selector(deleteExerciseSection:) forControlEvents:UIControlEventTouchUpInside];
            }
            btnWholeTeam.tag=indexPath.section-(arrfixCellFields.count-(count));
            
            ////////////////
            UIImage *image;
            image=[UIImage imageNamed:@"arrow.png"];
            UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
            imageview.userInteractionEnabled = NO;
            imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+10, txtField.frame.size.height/2-7,15, 15);
            [txtField addSubview:imageview];
            ///////////////
            [self addSubview:btnWholeTeam];
            [self addSubview:txtField];
            btnWholeTeam=nil;
            txtField=nil;
            lbl=nil;
            
            int gap=(isIPAD ? 30 : 10),lblWight=(isIPAD ?  ((([SingletonClass ShareInstance].GloableOreintation == UIDeviceOrientationLandscapeLeft ) || ([SingletonClass ShareInstance].GloableOreintation == UIDeviceOrientationLandscapeRight)) ? 233 : 172) : 70);
            
            NSArray *arrPlaceholdertext=[[NSArray alloc] initWithObjects:STR_SETS,STR_REPS,STR_WEIGHT,STR_UNIT_DOT ,nil];
            
            for (int i=0; i< arrPlaceholdertext.count; i++) {
                UITextField *txtField=[[UITextField alloc] init];
                txtField.backgroundColor = [UIColor whiteColor];
                txtField.borderStyle = UITextBorderStyleRoundedRect;
                txtField.tag = indexPath.section-(arrfixCellFields.count-(count));;
                txtField.delegate = del;
                txtField.font = [UIFont fontWithName:fontName size:BigfontSize];
                // Add Dic data in textfield and placeholder text
                
                txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[arrPlaceholdertext objectAtIndex:i] attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                txtField.textColor=TextFieldColor;
                txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                if (valueIndex >= 0){
                    txtField.text=[self LiftValuesForKey:(int)(indexPath.section-(arrfixCellFields.count-(count))) :liftPlaceholder :txtField.placeholder];
                }
                txtField.frame=CGRectMake(gap, ((TextFeildHeight)+((isIPAD) ? 40 :40)),lblWight,TextFeildHeight);
                if (i==3) {
                    UIImage *image=[UIImage imageNamed:@"arrow.png"];
                    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
                    imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+15, (txtField.frame.size.height/2-7),15, 15);
                    [txtField addSubview:imageview];
                }
                [self addSubview:txtField];
                gap = gap+lblWight+7;
            }
        }
    }
    return self;
}
-(void)addBoatFieldsWithDeleteButton :(int)tag :(id)del :(NSMutableDictionary *)dicData{
    UITextField *txtFieldBoatName;
    UITextField *tfAthleteOrGroup;
    txtFieldBoatName = [[UITextField alloc] initWithFrame:CGRectMake(CellX,FIRST_BOAT_Y, CellWeight, TextFeildHeight)];
    txtFieldBoatName.backgroundColor = [UIColor whiteColor];
    txtFieldBoatName.borderStyle = UITextBorderStyleRoundedRect;
    txtFieldBoatName.font = [UIFont fontWithName:fontName size:BigfontSize];
    txtFieldBoatName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Boat Name" attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
    txtFieldBoatName.delegate = del;
    txtFieldBoatName.tag = tag-1;
    txtFieldBoatName.textColor = TextFieldColor;
    if ([[dicData valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
        txtFieldBoatName.text = arrTemp.count > txtFieldBoatName.tag ? [[[dicData valueForKey:STR_BOATS] objectAtIndex: txtFieldBoatName.tag]valueForKey:STRKEY_BOATNAME] : EMPTYSTRING;
    }
    txtFieldBoatName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UITextField *txtField;
    txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX, (txtFieldBoatName.frame.origin.y+txtFieldBoatName.frame.size.height/2 + FIELD_GAP), ((CellWeight)-((isIPAD) ? 50 :35)), TextFeildHeight)];
    txtField.backgroundColor = [UIColor whiteColor];
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.font = [UIFont fontWithName:fontName size:BigfontSize];
    txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Set Lineup" attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
    txtField.textColor = TextFieldColor;
    txtField.tag = tag-1;
    txtField.delegate = del;
    txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if ([[dicData valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
        txtField.text = arrTemp.count > txtField.tag ? [[[dicData valueForKey:STR_BOATS] objectAtIndex: txtField.tag]valueForKey:STRKEY_SETLINEUP] : EMPTYSTRING;
    }
    UIButton *btnWholeTeam;
    btnWholeTeam=[UIButton buttonWithType:UIButtonTypeCustom];
    btnWholeTeam.frame=CGRectMake(txtField.frame.size.width+((isIPAD) ? 50:20), (txtField.frame.origin.y+1), Add_Delete_Size, Add_Delete_Size);
    [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"deleteBtn_icon.png"] forState:UIControlStateNormal];
    btnWholeTeam.tag = tag-1;
    [btnWholeTeam addTarget:self action:@selector(deleteBoat:) forControlEvents:UIControlEventTouchUpInside];
    ////////////////
    UIImage *image;
    image=[UIImage imageNamed:@"arrow.png"];
    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
    imageview.userInteractionEnabled = NO;
    imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+10, txtField.frame.size.height/2-7,15, 15);
    [txtField addSubview:imageview];
    ///////////////
    
    if ([[dicData valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
        if (arrTemp.count >= txtField.tag) {
            
            if (![[[[dicData valueForKey:STR_BOATS] objectAtIndex:txtField.tag] valueForKey:STRKEY_SETLINEUP] isEqualToString:EMPTYSTRING]) {
                
                tfAthleteOrGroup = [[UITextField alloc] initWithFrame:CGRectMake(CellX,(txtField.frame.origin.y+txtFieldBoatName.frame.size.height/2 + FIELD_GAP), CellWeight, TextFeildHeight)];
                tfAthleteOrGroup.backgroundColor = [UIColor whiteColor];
                tfAthleteOrGroup.borderStyle = UITextBorderStyleRoundedRect;
                tfAthleteOrGroup.font = [UIFont fontWithName:fontName size:BigfontSize];
                
                tfAthleteOrGroup.delegate = del;
                tfAthleteOrGroup.tag = tag-1;
                tfAthleteOrGroup.textColor = TextFieldColor;
                tfAthleteOrGroup.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
                NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
                if(arrTemp.count > tfAthleteOrGroup.tag){
                    if ([[[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STRKEY_SETLINEUP] isEqualToString:STR_SELECTATHLETES]) {
                        tfAthleteOrGroup.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Athlete Name" attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                        if([[[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_ATHLETES] isKindOfClass:[NSArray class]])
                        {
                            NSString *strAthleteName = EMPTYSTRING;
                            for (NSString *strName in [[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_ATHLETES]) {
                                strAthleteName = strName.length > 0 ? [strAthleteName stringByAppendingString:[NSString stringWithFormat:@"%@,",strName]] : EMPTYSTRING;
                            }
                            tfAthleteOrGroup.text = strAthleteName;
                        }
                        
                    }else{
                        
                        tfAthleteOrGroup.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Group Name" attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                        if([[[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_GROUPS] isKindOfClass:[NSArray class]])
                        {
                            {
                                NSString *strGroupName = EMPTYSTRING;
                                for (NSString *strName in [[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_GROUPS]) {
                                    strGroupName = strName.length > 0 ? [strGroupName stringByAppendingString:[NSString stringWithFormat:@"%@,",strName]] : EMPTYSTRING;
                                }
                                tfAthleteOrGroup.text = strGroupName;
                            }
                        }
                    }
                }
                [self addSubview:tfAthleteOrGroup];
            }
        }
    }
    
    NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
    if (arrTemp.count > tag) {
        txtFieldBoatName.userInteractionEnabled = NO;
        txtField.userInteractionEnabled = NO;
        tfAthleteOrGroup.userInteractionEnabled = NO;
        btnWholeTeam.userInteractionEnabled = NO;
        
        txtFieldBoatName.backgroundColor = NON_EDIT_COLOR;
        txtField.backgroundColor = NON_EDIT_COLOR;
        tfAthleteOrGroup.backgroundColor = NON_EDIT_COLOR;
        btnWholeTeam.backgroundColor = NON_EDIT_COLOR;
    }
    [self addSubview:btnWholeTeam];
    [self addSubview:txtFieldBoatName];
    [self addSubview:txtField];
    btnWholeTeam=nil;
    txtField=nil;
}
-(void)addBoatFieldsWithPlusButton :(id)del :(NSMutableDictionary *)dicData
{
    UITextField *txtFieldBoatName;
    UITextField *tfAthleteOrGroup;;
    txtFieldBoatName = [[UITextField alloc] initWithFrame:CGRectMake(CellX,FIRST_BOAT_Y, CellWeight, TextFeildHeight)];
    txtFieldBoatName.backgroundColor = [UIColor whiteColor];
    txtFieldBoatName.borderStyle = UITextBorderStyleRoundedRect;
    txtFieldBoatName.font = [UIFont fontWithName:fontName size:BigfontSize];
    txtFieldBoatName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:BOATNAME_PLACEHOLDER attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
    txtFieldBoatName.delegate = del;
    txtFieldBoatName.tag = 0;
    txtFieldBoatName.textColor = TextFieldColor;
    txtFieldBoatName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if ([[dicData valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
        txtFieldBoatName.text = arrTemp.count > txtFieldBoatName.tag ? [[[dicData valueForKey:STR_BOATS] objectAtIndex: txtFieldBoatName.tag]valueForKey:STRKEY_BOATNAME] : EMPTYSTRING;
    }
    
    UITextField *txtField;
    txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX, (txtFieldBoatName.frame.origin.y+txtFieldBoatName.frame.size.height/2 + FIELD_GAP), ((CellWeight)-((isIPAD) ? 50 :35)), TextFeildHeight)];
    txtField.backgroundColor = [UIColor whiteColor];
    txtField.borderStyle = UITextBorderStyleRoundedRect;
    txtField.font = [UIFont fontWithName:fontName size:BigfontSize];
    txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SETLINEUP_PLACEHOLDER attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
    txtField.textColor = TextFieldColor;
    txtField.delegate = del;
    txtField.tag = 0;
    txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if ([[dicData valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
        txtField.text = arrTemp.count > txtField.tag ? [[[dicData valueForKey:STR_BOATS] objectAtIndex: txtField.tag]valueForKey:STRKEY_SETLINEUP] : EMPTYSTRING;
    }
    
    UIButton *btnWholeTeam;
    btnWholeTeam=[UIButton buttonWithType:UIButtonTypeCustom];
    btnWholeTeam.frame=CGRectMake(txtField.frame.size.width+((isIPAD) ? 50:20), (txtField.frame.origin.y+1), Add_Delete_Size, Add_Delete_Size);
    [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
    btnWholeTeam.tag = 0;
    [btnWholeTeam addTarget:self action:@selector(addBoat:) forControlEvents:UIControlEventTouchUpInside];
    ////////////////
    UIImage *image;
    image=[UIImage imageNamed:@"arrow.png"];
    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
    imageview.userInteractionEnabled = NO;
    imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+10, txtField.frame.size.height/2-7,15, 15);
    [txtField addSubview:imageview];
    /////////////  Athlete field //////////////////
    if ([[dicData valueForKey:STR_BOATS] isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
        if (arrTemp.count >= txtField.tag) {
            
            if (![[[[dicData valueForKey:STR_BOATS] objectAtIndex:txtField.tag] valueForKey:STRKEY_SETLINEUP] isEqualToString:EMPTYSTRING]) {
                
                
                tfAthleteOrGroup = [[UITextField alloc] initWithFrame:CGRectMake(CellX,(txtField.frame.origin.y+txtFieldBoatName.frame.size.height/2 + FIELD_GAP), CellWeight, TextFeildHeight)];
                tfAthleteOrGroup.backgroundColor = [UIColor whiteColor];
                tfAthleteOrGroup.borderStyle = UITextBorderStyleRoundedRect;
                tfAthleteOrGroup.font = [UIFont fontWithName:fontName size:BigfontSize];
                tfAthleteOrGroup.delegate = del;
                tfAthleteOrGroup.tag = 0;
                tfAthleteOrGroup.textColor = TextFieldColor;
                
                ///////
                
                ///////////
                tfAthleteOrGroup.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
                if(arrTemp.count > tfAthleteOrGroup.tag){
                    
                    if ([[[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STRKEY_SETLINEUP] isEqualToString:STR_SELECTATHLETES]) {
                        tfAthleteOrGroup.attributedPlaceholder = [[NSAttributedString alloc] initWithString:STR_ENTER_ATHLETENAME attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                        if([[[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_ATHLETES] isKindOfClass:[NSArray class]])
                        {
                            NSString *strAthleteName = EMPTYSTRING;
                            for (NSString *strName in [[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_ATHLETES]) {
                                strAthleteName = strName.length > 0 ? [strAthleteName stringByAppendingString:[NSString stringWithFormat:@"%@,",strName]] : EMPTYSTRING;
                            }
                            tfAthleteOrGroup.text = strAthleteName;
                        }
                        
                    }else{
                        
                        tfAthleteOrGroup.attributedPlaceholder = [[NSAttributedString alloc] initWithString:STR_ENTER_GROUPNAME attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                        if([[[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_GROUPS] isKindOfClass:[NSArray class]])
                        {
                            {
                                NSString *strGroupName = EMPTYSTRING;
                                for (NSString *strName in [[[dicData valueForKey:STR_BOATS] objectAtIndex:tfAthleteOrGroup.tag] valueForKey:STR_GROUPS]) {
                                    strGroupName = strName.length > 0 ? [strGroupName stringByAppendingString:[NSString stringWithFormat:@"%@,",strName]] : EMPTYSTRING;
                                }
                                tfAthleteOrGroup.text = strGroupName;
                            }
                        }
                    }
                    
                }
                
                
                [self addSubview:tfAthleteOrGroup];
            }
        }
    }
    ///////////////
    NSMutableArray *arrTemp = [dicData valueForKey:STR_BOATS];
    if (arrTemp.count > 1) {
        txtFieldBoatName.userInteractionEnabled = NO;
        txtField.userInteractionEnabled = NO;
        tfAthleteOrGroup.userInteractionEnabled = NO;
        txtFieldBoatName.backgroundColor = NON_EDIT_COLOR;
        txtField.backgroundColor = NON_EDIT_COLOR;
        tfAthleteOrGroup.backgroundColor = NON_EDIT_COLOR;
    }
    
    [self addSubview:btnWholeTeam];
    [self addSubview:txtFieldBoatName];
    [self addSubview:txtField];
    btnWholeTeam=nil;
    txtField=nil;
}
-(int)CountOfExerciseObject :(NSMutableArray *)arr{
    int temp=0;
    for (int i=0; i< arr.count; i++) {
        if ([[arr objectAtIndex:i] isEqual:KEY_EXERCISE]) {
            temp=temp+1;
        }
    }
    return temp;
}

-(NSString *)LiftValuesForKey :(int)index :(NSMutableArray *)data :(NSString *)key{
    id temp=[data objectAtIndex:index];
    NSString *strVales=EMPTYSTRING;
    if ([temp isKindOfClass:[NSMutableDictionary class]]){
        if ([key isEqualToString:STR_UNIT_DOT]) {
            key =KEY_UNIT;
        }
        strVales=[temp valueForKey:key];
    }
    return strVales;
}

-(NSString *)ValuesForKey : (int)index :(NSMutableDictionary *)data :(NSMutableArray *)keys{
    id temp=[data objectForKey:[keys objectAtIndex:index]];
    NSString *strVales=EMPTYSTRING;
    if ([temp isKindOfClass:[NSString class]] ){
        strVales=temp;
    }else if ([temp isKindOfClass:[NSDictionary class]]){
        NSArray *arrkeys=[temp allKeys];
        NSArray *arrValues=[temp allValues];
        NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
        for (int i=0; i<arrValues.count; i++) {
            if ([[arrValues objectAtIndex:i] intValue]==1){
                [arrTemp addObject:[arrkeys objectAtIndex:i] ];
            }
        }
        for (int i=0; i<arrTemp.count; i++) {
            if (i < arrTemp.count-1 )
                strVales= [strVales stringByAppendingString:[NSString stringWithFormat:@"%@,",arrTemp[i]]];
            else
                strVales=[strVales stringByAppendingString:[NSString stringWithFormat:@"%@",arrTemp[i]]];
        }
    }else if ([temp isKindOfClass:[NSNumber class]]) {
        strVales=[NSString stringWithFormat:@"%@",temp];
    }
    return strVales;
}
-(void)deleteBoat:(id)sender{
    [delegate deleteBoat:sender];
}
-(void)addBoat:(id)sender{
    [delegate addBoat:sender];
}
-(void)deleteExerciseSection :(id)sender{
    [delegate deleteExerciseSection:sender];
}
-(void)addExerciseSection :(id)sender{
    [delegate addExerciseSection:sender];
}
-(void)SaveWorkOutData :(id)sender{
    [delegate SaveWorkOutData:sender];
}
-(void)addCustomTag :(id)sender{
    [delegate addCustomTag:sender];
}
-(void)deleteCustomTag :(id)sender{
    [delegate deleteCustomTag:sender];
}
-(void)addExercise :(id)sender{
    [delegate addExercise:sender];
}
-(void)deleteExercise :(id)sender{
    [delegate deleteExercise:sender];
}
-(void)buttonClickAthletes :(id)sender{
    [delegate AthletesCheckBoxEvent:sender];
}
-(void)buttonClickEmail :(id)sender{
    [delegate EmailCheckBoxEvent:sender];
}
@end
