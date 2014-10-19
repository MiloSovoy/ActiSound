#import "libactivator.h"
#import <AudioToolbox/AudioToolbox.h>
#import <notify.h>

@interface ActiSound : NSObject<LAListener>
{}
@end

@implementation ActiSound
SystemSoundID soundPref;

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    
    NSLog(@"ActiSound Listener Accepted");
    
    NSString *settingsPath = @"/var/mobile/Library/Preferences/com.milodarling.actisound.plist";
    
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    
    NSString *sound = [prefs objectForKey:@"sound"];
    if (sound == nil) sound = @"WilhelmScream.wav";
    
    if (![sound isEqualToString:@"None"]){
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/ActiSound/%@",sound]],&soundPref);
        AudioServicesPlaySystemSound(soundPref);
    }
    
}

+(void)load {
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.milodarling.actisound"];
    [p release];
}

@end
