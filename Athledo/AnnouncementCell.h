//
//  AnnouncementCell.h
//  Athledo
//
//  Created by Dinesh Kumar on 7/24/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnouncementCellDelegate <NSObject>

-(void)editCell:(id)sender;
-(void)deleteCell:(id)sender;

@end

@interface AnnouncementCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath delegate:(id)del textData:(NSString *)txt;
@property(nonatomic,strong)IBOutlet UITextField *lblAnnoName;
//@property(nonatomic,strong)IBOutlet UITextView *lblAnnoDesc;
@property (weak, nonatomic) IBOutlet UITextField *lblAnnoDesc;
@property (weak, nonatomic) IBOutlet UITextField *lblSenderName;

@property(nonatomic,strong)IBOutlet UITextField *lblAnnoDate;;
@property(nonatomic,strong)IBOutlet UIButton *btnDelete;
@property(nonatomic,strong)IBOutlet UIButton *btnEdit;

@property(nonatomic,weak)id <AnnouncementCellDelegate> delegate;
@end
