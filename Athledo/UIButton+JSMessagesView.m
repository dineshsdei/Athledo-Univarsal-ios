
#import "UIButton+JSMessagesView.h"

@implementation UIButton (JSMessagesView)

+ (UIButton *)defaultSendButton
{
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
  sendButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 13.0f, 30.0f, 13.0f);
    [sendButton setImageEdgeInsets:insets];
       UIImage *sendBack = [UIImage imageNamed:@"btnSend.png"] ;
    [sendButton setBackgroundImage:sendBack forState:UIControlStateNormal];
    [sendButton setBackgroundImage:sendBack forState:UIControlStateDisabled];
    return sendButton;
}

@end