//
//  AthleteDetail.h
//  Athledo
//
//  Created by Smartdata on 4/1/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface AthleteDetail : UIViewController
@property(nonatomic,strong)id objAthleteDetails;
@property (weak, nonatomic) IBOutlet UIImageView *ProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblZip;
@property (strong, nonatomic) IBOutlet UILabel *lblemail;
@property (strong, nonatomic) IBOutlet UILabel *lblAge;
@property (strong, nonatomic) IBOutlet UILabel *lblClassYear;
@end
