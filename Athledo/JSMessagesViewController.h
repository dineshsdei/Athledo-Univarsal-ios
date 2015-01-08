
#import <UIKit/UIKit.h>
#import "JSBubbleMessageCell.h"
#import "JSMessageInputView.h"
#import "JSMessageSoundEffect.h"
#import "UIButton+JSMessagesView.h"

typedef enum {
    JSMessagesViewTimestampPolicyAll = 0,
    JSMessagesViewTimestampPolicyAlternating,
    JSMessagesViewTimestampPolicyEveryThree,
    JSMessagesViewTimestampPolicyEveryFive,
    JSMessagesViewTimestampPolicyCustom
} JSMessagesViewTimestampPolicy;


typedef enum {
    JSMessagesViewAvatarPolicyIncomingOnly = 0,
    JSMessagesViewAvatarPolicyBoth,
    JSMessagesViewAvatarPolicyNone
} JSMessagesViewAvatarPolicy;


@protocol JSMessagesViewDelegate <NSObject>
@required
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text;
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath;
- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (JSMessagesViewTimestampPolicy)timestampPolicy;
- (JSMessagesViewAvatarPolicy)avatarPolicy;
- (JSAvatarStyle)avatarStyle;

@optional
- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@protocol JSMessagesViewDataSource <NSObject>
@required
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)avatarImageForIncomingMessage;
- (UIImage *)avatarImageForOutgoingMessage;
- (NSString *)setImageWithUrl:(int )index;
@end



@interface JSMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) id<JSMessagesViewDelegate> delegate;
@property (weak, nonatomic) id<JSMessagesViewDataSource> dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) JSMessageInputView *inputToolBarView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;

#pragma mark - Initialization
- (UIButton *)sendButton;

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender;

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)finishSend;
- (void)setBackgroundColor:(UIColor *)color;
- (void)scrollToBottomAnimated:(BOOL)animated;

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification;
- (void)handleWillHideKeyboard:(NSNotification *)notification;
- (void)keyboardWillShowHide:(NSNotification *)notification;

@end