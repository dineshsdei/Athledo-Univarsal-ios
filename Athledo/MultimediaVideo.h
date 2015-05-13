//
//  MultimediaVideo.h
//  Athledo
//
//  Created by Smartdata on 12/16/14.
//  Copyright (c) 2014 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCYoutubeParser.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MultimediaCell.h"
#import "WebServiceClass.h"
#import<MobileCoreServices/UTCoreTypes.h>
#import "ASIFormDataRequest.h"


@interface MultimediaVideo : UIViewController<UITableViewDataSource,UITableViewDelegate,Playlink,WebServiceDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate,UITextViewDelegate>
{
    ASIFormDataRequest *request;
}
@property (strong, nonatomic) IBOutlet UITextField *tfSeason;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
@property (strong, nonatomic) IBOutlet UITextView *tfDescription;
@property (strong, nonatomic) IBOutlet UITextField *tfTitle;
@property (strong, nonatomic) IBOutlet UIView *uploadView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)ChooseFromGallery;
- (IBAction)CancelUpload;
- (IBAction)UploadVideo;
@end
