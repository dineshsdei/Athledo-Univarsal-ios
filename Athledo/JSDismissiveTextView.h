
#import <UIKit/UIKit.h>

@protocol JSDismissiveTextViewDelegate <NSObject>

@optional
- (void)keyboardDidShow;
- (void)keyboardDidScrollToPoint:(CGPoint)pt;
- (void)keyboardWillBeDismissed;
- (void)keyboardWillSnapBackToPoint:(CGPoint)pt;

@end



@interface JSDismissiveTextView : UITextView

@property (weak, nonatomic) id<JSDismissiveTextViewDelegate> keyboardDelegate;
@property (strong, nonatomic) UIPanGestureRecognizer *dismissivePanGestureRecognizer;

@end
