
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface JSMessageSoundEffect : NSObject

+ (void)playMessageReceivedSound;
+ (void)playMessageSentSound;

@end