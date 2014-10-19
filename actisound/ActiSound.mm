#import <AudioToolbox/AudioToolbox.h>
#import <Preferences/Preferences.h>

@interface ActiSoundListController: PSListController {
    NSMutableDictionary *prefs;
    NSArray *directoryContent;
    SystemSoundID selectedSound;
}

    - (NSArray *)getValues:(id)target;
    - (void)previewAndSet:(id)value forSpecifier:(id)specifier;
@end

@implementation ActiSoundListController
- (id)specifiers {
    directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/ActiSound" error:NULL];
    
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ActiSound" target:self] retain];
	}
	return _specifiers;
}

- (void)previewAndSet:(id)value forSpecifier:(id)specifier{
    // Sample sound and set
    AudioServicesDisposeSystemSoundID(selectedSound);
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/ActiSound/%@",value]],&selectedSound);
    AudioServicesPlaySystemSound(selectedSound);
    
    [super setPreferenceValue:value specifier:specifier];
}

// List our directory content
- (NSArray *)getValues:(id)target{
    return [[NSArray arrayWithObjects:@"None",nil] arrayByAddingObjectsFromArray:directoryContent];
}

@end

// vim:ft=objc
