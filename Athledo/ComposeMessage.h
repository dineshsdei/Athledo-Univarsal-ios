//
//  ComposeMessage.h
//  Athledo
//
//  Created by Dinesh Kumar on 9/11/14.
//  Copyright (c) 2014 Dinesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceClass.h"
#import "ALPickerView.h"


@interface ComposeMessage : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,WebServiceDelegate,UITextViewDelegate,ALPickerViewDelegate>
{
    IBOutlet UIPickerView *listPicker;
    ALPickerView *pickerView;
    
   IBOutlet UIScrollView *m_ScrollView;
    
    int option_id;
    NSString *receiver_ids;
    
    NSString *strUser;
    
    BOOL isU_Type;
    int scrollHeight;

}
@property (strong, nonatomic) id keyboardAppear;
@property (strong, nonatomic) id keyboardHide;
- (IBAction)SendMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtTo;
@property (weak, nonatomic) IBOutlet UITextView *textviewDesc;
@end
