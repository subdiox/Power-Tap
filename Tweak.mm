#include <spawn.h>
#include <signal.h>
#import "Headers.h"
#import "PTPreferences.h"

static int nextValidIndex();
static void update (
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo
);

static int currentIndex = 0;
static PTPreferences *PREFS = nil;

static int nextValidIndex() {
	BOOL firstValuePassed = NO;
	
  //Stop when the loop is complete (i has reached its initial value again)
	for (int i = (currentIndex + 1); i != currentIndex; i++) {
		if (i == [PREFS.modes count]) {
			i = 0; //Reset if we have reached the end of the modes list
		}

		BOOL enabled = [[PREFS valueForSpecifier: @"enabled" mode: [PREFS modeForIndex: i]] boolValue];
		//Check if mode is enabled
		
		if (enabled) {
			return i;
		}
		
		firstValuePassed = YES;
	}
	return -1;
}

static void update (
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo
)

{
	PREFS = [PTPreferences new];
}

%hook _UIActionSlider

- (void)layoutSubviews
{
	%orig();
	NSString *modeString = [PREFS modeForIndex: currentIndex];
	
	NSString *_trackText = [PREFS valueForSpecifier: @"string" mode: modeString];
	UIImage *_knobImage = [PREFS iconForMode: modeString];

	self.trackText = _trackText;
	[self setNewKnobImage: _knobImage];
}

%new
- (UIImageView*)knobImageView {
	return MSHookIvar<UIImageView*>(self, "_knobImageView");
}

%new
- (void)setNewKnobImage:(UIImage*)image {
	image = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
	[self knobImageView].image = image;
	[self knobImageView].tintColor = [PREFS tintColorForMode: [PREFS modeForIndex: currentIndex]];
}

%new
- (void)knobTapped {
	int _nextValidIndex = nextValidIndex();
	
	if (_nextValidIndex != -1) {
		currentIndex = _nextValidIndex; //Switch indicies for next mode
		NSString *modeString = [PREFS modeForIndex: currentIndex];
	
		NSString *_trackText = [PREFS valueForSpecifier: @"string" mode: modeString];
		UIImage *_knobImage = [PREFS iconForMode: modeString];
	
		self.trackText = _trackText;
		[self setNewKnobImage: _knobImage];
	}
}

%end

%hook SBPowerDownController

- (void)activate {
	%orig();
	
	//Getting access to the current instance we need
	SBPowerDownAlertView *powerDownView = MSHookIvar<SBPowerDownAlertView*>(self, "_powerDownView");
	_SBInternalPowerDownView *internalView = MSHookIvar<_SBInternalPowerDownView*>(powerDownView, "_internalView");
	_UIActionSlider *actionSlider = MSHookIvar<_UIActionSlider*>(internalView, "_actionSlider");

	UITapGestureRecognizer *knobTap = [[UITapGestureRecognizer alloc] initWithTarget: actionSlider 
			action:@selector(knobTapped)];
	knobTap.numberOfTapsRequired = 1;
	[[actionSlider _knobView] addGestureRecognizer: knobTap];
}

- (void)powerDown {
	NSString *modeString = [PREFS modeForIndex: currentIndex];
	if ([modeString isEqualToString: @"PowerDown"]) {
		%orig;
	} else if ([modeString isEqualToString: @"Reboot"]) {
		[(FBSystemService *)[objc_getClass("FBSystemService") sharedInstance] shutdownAndReboot:YES];
	}	else if ([modeString isEqualToString: @"SoftReboot"]) {
		posix_spawn_file_actions_t action;
    posix_spawn_file_actions_init(&action);
    posix_spawn_file_actions_addclose (&action, STDIN_FILENO);
    posix_spawn_file_actions_addclose (&action, STDOUT_FILENO);
    posix_spawn_file_actions_addclose (&action, STDERR_FILENO);

    posix_spawnattr_t attrp;
    posix_spawnattr_init(&attrp);
    posix_spawnattr_setflags(&attrp, POSIX_SPAWN_SETPGROUP);
    posix_spawnattr_setpgroup(&attrp, 0);

    pid_t pid;
    const char *args[] = {"sh", "-c", "/usr/bin/ldrestart0", NULL};
    posix_spawn(&pid, "/bin/sh", &action, &attrp, (char* const*)args, NULL);
    posix_spawn_file_actions_destroy(&action);
    posix_spawnattr_destroy(&attrp);
	} else if ([modeString isEqualToString: @"Respring"]) {
		[(FBSystemService *)[objc_getClass("FBSystemService") sharedInstance] exitAndRelaunch:YES];
	} else if ([modeString isEqualToString: @"SafeMode"]) {
		[[UIApplication sharedApplication] nonExistentMethod];
	} else if ([modeString isEqualToString: @"UICache"]) {
		pid_t pid;
		int status;
		posix_spawn(&pid, "/usr/bin/uicache", NULL, NULL, NULL, NULL);
		if (waitpid(pid, &status, 0) == -1) {
			NSLog(@"UICache Failed!");
		}
		[(FBSystemService *)[objc_getClass("FBSystemService") sharedInstance] exitAndRelaunch:YES];
	} else {
		%orig;
	}	
}

- (void)cancel {
	currentIndex = 0; //Resets mode cycle
	%orig;
}

%end

%ctor {
	PREFS = [PTPreferences new];
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update,
		 CFSTR("com.subdiox.powertap.settingsupdated"), NULL,
		  CFNotificationSuspensionBehaviorDeliverImmediately);
}