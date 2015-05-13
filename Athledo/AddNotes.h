//
//  AddNotes.h
//  Athledo
//
//  Created by Smartdata on 2/23/15.
//  Copyright (c) 2015 Athledo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNoteCell.h"
#import "SWTableViewCell.h"

@interface AddNotes : UIViewController<UITextViewDelegate,SingletonClassDelegate,SWTableViewCellDelegate,WebServiceDelegate>
{
    IBOutlet UITableView *objTableView;
}
@property(nonatomic,strong)id objNotes;
@property (strong, nonatomic) id keyboardAppear;
@end
