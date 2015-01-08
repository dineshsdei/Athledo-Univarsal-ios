//
//  TableViewCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 12/16/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Playlink <NSObject>

-(void)PlayVideo:(id)sender;

@end


@interface MultimediaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *First_imageview;
@property (weak, nonatomic) IBOutlet UILabel *First_lblName;
@property (weak, nonatomic) IBOutlet UITextView *First_textViewDes;
@property (weak, nonatomic) IBOutlet UIImageView *Second_imageview;
@property (weak, nonatomic) IBOutlet UILabel *Second_lblName;
@property (weak, nonatomic) IBOutlet UITextView *SecondTextviewDes;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic,weak)IBOutlet UIButton *btnPlay;
@property(weak,nonatomic)id <Playlink>delegate;
@end
