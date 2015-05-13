

#import "JSMessageInputView.h"
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"

#define SEND_BUTTON_WIDTH 50.0f

@interface JSMessageInputView ()

- (void)setup;
- (void)setupTextView;

@end



@implementation JSMessageInputView

@synthesize sendButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
           delegate:(id<UITextViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        self.textView.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}
#pragma mark - Setup
- (void)setup
{
    self.image = [UIImage inputBar];
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    [self setupTextView];
}

- (void)setupTextView
{
    CGFloat width = self.frame.size.width - SEND_BUTTON_WIDTH;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    self.textView = [[JSDismissiveTextView  alloc] initWithFrame:CGRectMake(6.0f, 3.0f, width, height)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.textView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.font = [JSBubbleView font];
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    [self addSubview:self.textView];
	
    UIImageView *inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                0.0f,
                                                                                self.textView.frame.size.width + 2.0f,
                                                                                self.frame.size.height)];
    inputFieldBack.image = [UIImage inputField];
    inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    inputFieldBack.backgroundColor = [UIColor clearColor];
    [self addSubview:inputFieldBack];
}

#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if(sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    sendButton.frame = CGRectMake(sendButton.frame.origin.x+20, sendButton.frame.origin.y, 30, 25);
    [self addSubview:self.sendButton];
}

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    if (changeInHeight < 0) {
        return;
    }
    
    CGRect prevFrame = self.textView.frame;
    
    int numLines = (int)(MAX([JSBubbleView numberOfLinesForMessage:self.textView.text],
                       [self.textView.text numberOfLines]));
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);

    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    if(numLines >2) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        
        if (bottomOffset.y > 0) {
             [self.textView setContentOffset:bottomOffset animated:YES];
        }
    }
}
+ (CGFloat)textViewLineHeight
{
    return 30.0f; // for fontSize 15.0f
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 5.0f : 5.0f;

   // return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
       return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}

@end