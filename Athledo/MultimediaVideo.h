//
//  MultimediaVideo.h
//  Athledo
//
//  Created by Dinesh Kumar on 12/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCYoutubeParser.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MultimediaCell.h"
#import "WebServiceClass.h"
#import<MobileCoreServices/UTCoreTypes.h>

@interface MultimediaVideo : UIViewController<UITableViewDataSource,UITableViewDelegate,Playlink,WebServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@end
