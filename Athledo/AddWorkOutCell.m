//
//  AddWorkOutCell.m
//  Athledo
//
//  Created by Dinesh Kumar on 8/14/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import "AddWorkOutCell.h"
#define CellX isIPAD ? 30 : 10
#define Add_Delete_Size isIPAD ? 25 : 20
#define CellWeight isIPAD ? 708 : 300
#define TextFeildHeight isIPAD ? 40 : 30
#define CheckBoxEmailTag 1000;
#define CheckBoxAthleteTag 2000;

#define PlaceHolderColor [UIColor lightGrayColor]
#define TextFieldColor [UIColor grayColor]

@implementation AddWorkOutCell
@synthesize delegate;

- (void)awakeFromNib
{
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle :(UITableViewCellStyle)style reuseIdentifier :(NSString *)reuseIdentifier indexPath :(NSIndexPath *)indexPath cellFields :(NSMutableArray *)arrfixCellFields liftFields :(NSMutableArray *)liftPlaceholder :(NSMutableDictionary *)WorkOutDic :(int)LiftExerciseCount :(id)del;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Else section for only lift workout Type
        
        
        if (!([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Exercise"])  ) {
            
            
            //NSLog(@"Placeholder %@",[arrfixCellFields objectAtIndex:indexPath.section]);
            //  If section will design ui for all but else for  Email Notification and Athletes section
            // BTNSave - > for Save button in last cell
            if( (!([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Athletes"]) && !([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Email Notification"])) && !([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"BTNSave"]))
            {
                
                UITextField *txtField;
                
                // Height increase of description textfield
                
                if ([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Description"]) {
                    
                    if(IS_IPHONE_5)
                    {
                        txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX,0, CellWeight, ((TextFeildHeight)+30))];
                        
                    }else
                    {
                         txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX,0, CellWeight, ((TextFeildHeight)+30))];
                        
                    }
                    
                    
                }else{
                    
                    if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Custom Tags"] ||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Exercise Type"] )
                    {
                        
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
                txtField.text=[self ValuesForKey:indexPath.section :WorkOutDic :arrfixCellFields];
                //txtField.text=[WorkOutDic objectForKey:[arrfixCellFields objectAtIndex:indexPath.section]];
               // txtField.placeholder = [arrfixCellFields objectAtIndex:indexPath.section];
                txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[arrfixCellFields objectAtIndex:indexPath.section] attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
                txtField.textColor=TextFieldColor;
                
                txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
                if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Workout Type"] || [[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Custom Tags"] ||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Enter Date"]||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Exercise Type"]||[[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Unit"])
                {
                    // Add arrow image in textfield
                    UIImage *image;
                    if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Enter Date"] )
                    {
                        image=[UIImage imageNamed:@"calendar.png"];
                    }else{
                        
                        image=[UIImage imageNamed:@"arrow.png"];
                        
                    }
                    
                    UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
                    
                    imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+10, txtField.frame.size.height/2-7,15, 15);
                    
                    [txtField addSubview:imageview];
                    
                    if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Custom Tags"] || [[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Exercise Type"] )
                    {
                        UIButton *btnAdd=[UIButton buttonWithType:UIButtonTypeCustom];
                        [btnAdd setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
                        btnAdd.frame=CGRectMake(txtField.frame.size.width+((isIPAD) ? 40 : 30), txtField.frame.size.height/2-10,(Add_Delete_Size),(Add_Delete_Size));
                        
                        
                        
                        [self addSubview:btnAdd];
                        
                        
                        UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
                        [btnDelete setBackgroundImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
                        btnDelete.frame=CGRectMake(txtField.frame.size.width+btnAdd.frame.size.width+((isIPAD) ? 50 : 35), txtField.frame.size.height/2-10,(Add_Delete_Size),(Add_Delete_Size));
                        
                        if([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Custom Tags"] )
                        {
                            
                            [btnAdd addTarget:self action:@selector(addCustomTag:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [btnDelete addTarget:self action:@selector(deleteCustomTag:) forControlEvents:UIControlEventTouchUpInside];
                        }else
                        {
                            [btnAdd addTarget:self action:@selector(addExercise:) forControlEvents:UIControlEventTouchUpInside];
                            
                            [btnDelete addTarget:self action:@selector(deleteExercise:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        
                        [self addSubview:btnDelete];
                        btnAdd=nil;
                        btnDelete=nil;
                    }
                    
                }
                
                //txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
                [self addSubview:txtField];
                
                txtField=nil;
                
            }else if ((arrfixCellFields.count > indexPath.section ) && !([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"BTNSave"]))
            {
                
                // Email notification and Athletes section section
                
                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CellX, -10, CellWeight, 30)];
                
                lbl.textColor=TextFieldColor;
                lbl.font = [UIFont fontWithName:fontName size:BigfontSize];
                
                
                NSMutableArray *arrlblText;
                
                if ([[arrfixCellFields objectAtIndex:indexPath.section] isEqualToString:@"Athletes"] )
                {
                    lbl.text= @"Athletes";
                    
                    arrlblText=[[NSMutableArray alloc] initWithObjects:@"Whole Team",@"Athletes",@"Groups", nil];
                    
                }else{
                    
                    lbl.text= @"Email Notification";
                    
                    arrlblText=[[NSMutableArray alloc] initWithObjects:@"Yes",@"No" , nil];
                }
                
                [self addSubview:lbl];
                // lbl=nil;
                
                UILabel *lblBtnNearText;
                UIButton *btnWholeTeam;
                
                int gap=(isIPAD) ? 30:10,btnWight=25,lblWight=(isIPAD) ? 150 : 85;
                
                for (int i=0; i< arrlblText.count; i++) {
                    
                    btnWholeTeam=[UIButton buttonWithType:UIButtonTypeCustom];
                    // btnWholeTeam.tag=i;
                    if (i==0 )
                    {
                        // Athletes section
                        
                        if (arrlblText.count== 3 && ([[WorkOutDic objectForKey:@"Whole Team"] isEqual:@"1"]) ) {
                            btnWholeTeam.selected=YES;
                            [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                        }else if (arrlblText.count== 3){
                            
                            btnWholeTeam.selected=NO;
                            [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnDissable.png"] forState:UIControlStateNormal];
                            
                        }
                        
                         // if Email Section section
                        
                        if (arrlblText.count== 2 && [[WorkOutDic objectForKey:@"Email Notification"] isEqual:@"Yes"]) {
                            btnWholeTeam.selected=YES;
                            [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                        }else if (arrlblText.count== 2 && [[WorkOutDic objectForKey:@"Email Notification"] isEqual:@"No"]){
                            
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
                                if (![[WorkOutDic objectForKey:@"Athletes"] isEqual:@""] && arrlblText.count== 3)
                                {
                                    btnWholeTeam.selected=YES;
                                    [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"btnEnable.png"] forState:UIControlStateNormal];
                                    
                                }else{
                                    if (arrlblText.count== 2 && [[WorkOutDic objectForKey:@"Email Notification"] isEqual:@"No"]) {
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
                                //NSLog(@"%@",[WorkOutDic objectForKey:@"Groups"]);
                                
                                if (![[WorkOutDic objectForKey:@"Groups"] isEqual:@""])
                                {
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
                    
                    btnWholeTeam.frame=CGRectMake(gap+2, 20,btnWight,25);
                    
                    // Method calling different -2 for different-2 section
                    
                    if (arrlblText.count==3) {
                        
                        [btnWholeTeam addTarget:self action:@selector(buttonClickAthletes :) forControlEvents:UIControlEventTouchUpInside];
                        btnWholeTeam.tag=i+CheckBoxAthleteTag;
                        
                    }else{
                        
                        [btnWholeTeam addTarget:self action:@selector(buttonClickEmail :) forControlEvents:UIControlEventTouchUpInside];
                        btnWholeTeam.tag=i+CheckBoxEmailTag;
                        
                    }
                    
                    
                    [self addSubview:btnWholeTeam];
                    btnWholeTeam=nil;
                    
                    lblBtnNearText = [[UILabel alloc] initWithFrame:CGRectMake(gap+btnWight+5, 20, lblWight, 30)];
                    
                    lblBtnNearText.text= [arrlblText objectAtIndex:i];
                    lblBtnNearText.font = [UIFont fontWithName:fontName size:SmallfontSize];
                    lblBtnNearText.textColor=TextFieldColor;
                    
                    [self addSubview:lblBtnNearText];
                    lbl=nil;
                    
                    gap=(btnWight+lblWight)*(i+1);
                    
                }
                
                
                
                arrlblText=nil;
                
                
                
            }else{
                
                
                UIButton *btnSave=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnSave setBackgroundImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
                btnSave.frame=CGRectMake(CellWeight/3, 10,CellWeight/3,30);
                [btnSave setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
                [btnSave setTitle:@"Save" forState:UIControlStateNormal];
                [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [btnSave addTarget:self action:@selector(SaveWorkOutData:) forControlEvents:UIControlEventTouchUpInside];
                
                
                [self addSubview:btnSave];
                btnSave=nil;
                
                
            }
            

            
        
        }else if(arrfixCellFields.count > indexPath.section)
        {
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(CellX, -10, CellWeight, 30)];
            
            lbl.textColor=TextFieldColor;
            lbl.font = [UIFont fontWithName:fontName size:BigfontSize];
            
             lbl.text= @"Exercise";
            
            [self addSubview:lbl];
            
            UITextField *txtField;
            
             int count=[self CountOfExerciseObject:arrfixCellFields];
            int valueIndex=indexPath.section-(arrfixCellFields.count-(count));
            
            txtField = [[UITextField alloc] initWithFrame:CGRectMake(CellX, lbl.frame.size.height-10, ((CellWeight)-((isIPAD) ? 50 :40)), TextFeildHeight)];
            txtField.backgroundColor = [UIColor whiteColor];
            txtField.borderStyle = UITextBorderStyleRoundedRect;
            txtField.tag =indexPath.section-(arrfixCellFields.count-(count));;
            txtField.delegate = del;
            txtField.font = [UIFont fontWithName:fontName size:BigfontSize];
            // Add Dic data in textfield and placeholder text
             //txtField.placeholder =@"Name";
            txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: PlaceHolderColor}];
            txtField.textColor=TextFieldColor;

            
            if (valueIndex >= 0) {
                  
                  txtField.text=[self LiftValuesForKey:indexPath.section-(arrfixCellFields.count-(count)) :
                                liftPlaceholder :txtField.placeholder];
              }
            txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            
            
            UIButton *btnWholeTeam;
            
            btnWholeTeam=[UIButton buttonWithType:UIButtonTypeCustom];
            btnWholeTeam.frame=CGRectMake(txtField.frame.size.width+((isIPAD) ? 50:20), txtField.frame.origin.y+6, Add_Delete_Size, Add_Delete_Size);
            
           
          
            if (arrfixCellFields.count-(count)==indexPath.section)
            {
                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
                [btnWholeTeam addTarget:self action:@selector(addExerciseSection:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                
                [btnWholeTeam setBackgroundImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
                [btnWholeTeam addTarget:self action:@selector(deleteExerciseSection:) forControlEvents:UIControlEventTouchUpInside];
            }
            btnWholeTeam.tag=indexPath.section-(arrfixCellFields.count-(count));
            [self addSubview:btnWholeTeam];
            [self addSubview:txtField];
            btnWholeTeam=nil;
            txtField=nil;
            lbl=nil;
            
            int gap=(isIPAD ? 30 : 10),lblWight=(isIPAD ? 172 : 70);
            
            NSArray *arrPlaceholdertext=[[NSArray alloc] initWithObjects:@"Sets",@"Reps",@"Weight",@"Unit." ,nil];
        
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
                
                //txtField.placeholder =[arrPlaceholdertext objectAtIndex:i];
                txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
               if (valueIndex >= 0){
                    
                    txtField.text=[self LiftValuesForKey:indexPath.section-(arrfixCellFields.count-(count)) :liftPlaceholder :txtField.placeholder];
                }
              
                
                txtField.frame=CGRectMake(gap, ((TextFeildHeight)+((isIPAD) ? 40 :40)),lblWight,TextFeildHeight);
                
                
                if (i==3) {
                    
                 UIImage *image=[UIImage imageNamed:@"arrow.png"];
            UIImageView *imageview=[[UIImageView alloc] initWithImage:image];
                
                imageview.frame=CGRectMake(txtField.frame.size.width-imageview.frame.size.width+15, (txtField.frame.size.height/2-7),15, 15);
                
                [txtField addSubview:imageview];
                
                }
                
                

                [self addSubview:txtField];
                //txtField=nil;
                
                gap=gap+lblWight+7;
            }
            
            
        
        }
        
        
    }
  
    return self;
}

-(int)CountOfExerciseObject :(NSMutableArray *)arr
{
    int temp=0;
    
    for (int i=0; i< arr.count; i++) {
        
        if ([[arr objectAtIndex:i] isEqual:@"Exercise"]) {
            
            temp=temp+1;
        }
        
    }
    
    
    return temp;
}

-(NSString *)LiftValuesForKey :(int)index :(NSMutableArray *)data :(NSString *)key
{
    
    id temp=[data objectAtIndex:index];
    
    NSString *strVales=@"";
    if ([temp isKindOfClass:[NSMutableDictionary class]])
    {
        if ([key isEqualToString:@"Unit."]) {
            key =@"Unit";
        }

       strVales=[temp valueForKey:key];
    
    }else
    {
        
    }
    
    return strVales;

}

-(NSString *)ValuesForKey : (int)index :(NSMutableDictionary *)data :(NSMutableArray *)keys
{
    id temp=[data objectForKey:[keys objectAtIndex:index]];
    
    NSString *strVales=@"";
    if ([temp isKindOfClass:[NSString class]] )
    {
        
        strVales=temp;
        
        
    }else if ([temp isKindOfClass:[NSDictionary class]])
    {
        NSArray *arrkeys=[temp allKeys];
        NSArray *arrValues=[temp allValues];
        
        NSMutableArray *arrTemp=[[NSMutableArray alloc] init];
        
        for (int i=0; i<arrValues.count; i++) {
            
            if ([[arrValues objectAtIndex:i] intValue]==1)
            {
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
    }else
    {
        
    }
    
    return strVales;
    
}

-(void)deleteExerciseSection :(id)sender
{
      [delegate deleteExerciseSection:sender];
}

-(void)addExerciseSection :(id)sender
{
     [delegate addExerciseSection:sender];
}

-(void)SaveWorkOutData :(id)sender
{
    [delegate SaveWorkOutData:sender];
}

-(void)addCustomTag :(id)sender
{
    [delegate addCustomTag:sender];
}
-(void)deleteCustomTag :(id)sender
{
    [delegate deleteCustomTag:sender];
    
}

-(void)addExercise :(id)sender
{
    [delegate addExercise:sender];
}
-(void)deleteExercise :(id)sender
{
    [delegate deleteExercise:sender];
    
}


-(void)buttonClickAthletes :(id)sender
{
  
    [delegate AthletesCheckBoxEvent:sender];
    
    
}

-(void)buttonClickEmail :(id)sender
{
    
    [delegate EmailCheckBoxEvent:sender];

    
}


@end
