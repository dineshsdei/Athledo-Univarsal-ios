//
//  UpdateDetails.h
//  Athledo
//
//  Created by Smartdata on 8/19/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "UIImageView+WebCache.h"

@interface UpdateDetails : UIViewController<WebServiceDelegate>
{
    WebServiceClass *webservice;
    
  IBOutlet  UIImageView *objPic;
}
@property(nonatomic,weak)IBOutlet UILabel *lblSenderName;
@property(nonatomic,weak)IBOutlet UILabel *lblName;
@property(nonatomic,weak)IBOutlet UILabel *lblDate;
@property(nonatomic,weak)IBOutlet UITextView *tvDes;
@property(nonatomic,weak)IBOutlet UILabel *lblMEorAll;

@property(nonatomic,retain) NSString *strName;
@property(nonatomic,retain) NSString *strDate;
@property(nonatomic,retain) NSString *strDes;
@property (strong, nonatomic) id obj;
@property(nonatomic)BOOL NotificationStataus;
@end
