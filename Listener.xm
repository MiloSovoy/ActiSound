#import <libactivator/libactivator.h>
#import <AudioToolbox/AudioToolbox.h>
#import <notify.h>
#import <UIKit/UIKit.h>

@interface ActiSound : NSObject<LAListener>
{}
@end

static NSString *id1 = @"com.milodarling.actisound.sound1";
static NSString *id2 = @"com.milodarling.actisound.sound2";
static NSString *id3 = @"com.milodarling.actisound.sound3";
static NSString *id4 = @"com.milodarling.actisound.sound4";
static NSString *id5 = @"com.milodarling.actisound.sound5";
NSString *sound;
NSString *sound1;
NSString *sound2;
NSString *sound3;
NSString *sound4;
NSString *sound5;

static NSDictionary *prefs;

static inline unsigned char ActiSoundListenerName(NSString *listenerName) {
    unsigned char en;
    if ([listenerName isEqualToString:id1]) {
        en = 0;
    }
    if ([listenerName isEqualToString:id2]) {
        en = 1;
    }
    if ([listenerName isEqualToString:id3]) {
        en = 2;
    }
    if ([listenerName isEqualToString:id4]) {
        en = 3;
    }
    if ([listenerName isEqualToString:id5]) {
        en = 4;
    }
    return en;
}

@implementation ActiSound
SystemSoundID soundPref;

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    
    unsigned char en = ActiSoundListenerName(listenerName);
    NSString *title[5] = { sound1, sound2, sound3, sound4, sound5};
    sound = title[en];
    
    NSLog(@"ActiSound Listener Accepted");
    if (!sound) sound = @"None";
    if (![sound isEqualToString:@"None"]){
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/ActiSound/%@",sound]],&soundPref);
        AudioServicesPlaySystemSound(soundPref);
    } else {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:[NSString stringWithFormat:@"Please pick a sound"]
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        
        //Show the alert we made in the above line
        [alert1 show];
        
        //And release it so we don't use up any unnecessary memory.
        [alert1 release];
    }
    
}

+(void)load {
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.milodarling.actisound.sound1"];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.milodarling.actisound.sound2"];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.milodarling.actisound.sound3"];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.milodarling.actisound.sound4"];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.milodarling.actisound.sound5"];
    [p release];
}


- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
    return @"ActiSound";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    unsigned char en = ActiSoundListenerName(listenerName);
    NSString *title[5] = { @"Sound 1", @"Sound 2", @"Sound 3", @"Sound 4", @"Sound 5"};
    return title[en];
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    unsigned char en = ActiSoundListenerName(listenerName);
    NSString *title[5] = { sound1, sound2, sound3, sound4, sound5};
    return title[en];
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

@end

static void updatePrefs() {
    [prefs release];
    CFStringRef appID = CFSTR("com.milodarling.actisound");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (!keyList) {
        NSLog(@"There's been an error getting the key list!");
        return;
    }
    prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (!prefs) {
        NSLog(@"There's been an error getting the preferences dictionary!");
    }
    sound1 = [prefs objectForKey:@"sound1"] ?: @"None";
    NSLog(@"Sound 1: %@", sound1);
    sound2 = [prefs objectForKey:@"sound2"] ?: @"None";
    NSLog(@"Sound 2: %@", sound2);
    sound3 = [prefs objectForKey:@"sound3"] ?: @"None";
    NSLog(@"Sound 3: %@", sound3);
    sound4 = [prefs objectForKey:@"sound4"] ?: @"None";
    NSLog(@"Sound 4: %@", sound4);
    sound5 = [prefs objectForKey:@"sound5"] ?: @"None";
    NSLog(@"Sound 5: %@", sound5);
    
    CFRelease(keyList);

}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)updatePrefs,
                                    CFSTR("com.milodarling.actisound/prefsChanged"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
    updatePrefs();
}