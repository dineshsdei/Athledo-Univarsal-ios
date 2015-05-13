//
//  CalenderEventDetails.h
//  Athledo
//
//  Created by Smartdata on 9/10/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"

@interface CalenderEventDetails : UIViewController<UIAlertViewDelegate,WebServiceDelegate>
@property(weak,nonatomic)id objNotificationData;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UITextView *lblEventDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblEventLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRepeat;
@property(nonatomic,retain)NSDictionary *eventDetailsDic;
@property(nonatomic,strong)NSString *strMoveControllerName;
@end
