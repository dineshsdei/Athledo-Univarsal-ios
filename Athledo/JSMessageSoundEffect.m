
#import "JSMessageSoundEffect.h"

@interface JSMessageSoundEffect ()

+ (void)playSoundWithName:(NSString *)name type:(NSString *)type;

@end



@implementation JSMessageSoundEffect

+ (void)playSoundWithName:(NSString *)name type:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
    }
}

+ (void)playMessageReceivedSound
{
    [JSMessageSoundEffect playSoundWithName:@"messageReceived" type:@"aiff"];
}

+ (void)playMessageSentSound
{
    [JSMessageSoundEffect playSoundWithName:@"messageSent" type:@"aiff"];
}

@end