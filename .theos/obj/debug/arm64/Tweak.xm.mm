#line 1 "Tweak.xm"
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
	
  
	for (int i = (currentIndex + 1); i != currentIndex; i++) {
		if (i == [PREFS.modes count]) {
			i = 0; 
		}

		BOOL enabled = [[PREFS valueForSpecifier: @"enabled" mode: [PREFS modeForIndex: i]] boolValue];
		
		
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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class _UIActionSlider; @class SBPowerDownController; 
static void (*_logos_orig$_ungrouped$_UIActionSlider$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$_UIActionSlider$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST, SEL); static UIImageView* _logos_method$_ungrouped$_UIActionSlider$knobImageView(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$_UIActionSlider$setNewKnobImage$(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST, SEL, UIImage*); static void _logos_method$_ungrouped$_UIActionSlider$knobTapped(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBPowerDownController$activate)(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBPowerDownController$activate(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBPowerDownController$powerDown)(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBPowerDownController$powerDown(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBPowerDownController$cancel)(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBPowerDownController$cancel(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST, SEL); 

#line 51 "Tweak.xm"



static void _logos_method$_ungrouped$_UIActionSlider$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$_UIActionSlider$layoutSubviews(self, _cmd);
	NSString *modeString = [PREFS modeForIndex: currentIndex];
	
	NSString *_trackText = [PREFS valueForSpecifier: @"string" mode: modeString];
	UIImage *_knobImage = [PREFS iconForMode: modeString];

	self.trackText = _trackText;
	[self setNewKnobImage: _knobImage];
}


static UIImageView* _logos_method$_ungrouped$_UIActionSlider$knobImageView(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	return MSHookIvar<UIImageView*>(self, "_knobImageView");
}


static void _logos_method$_ungrouped$_UIActionSlider$setNewKnobImage$(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIImage* image) {
	image = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
	[self knobImageView].image = image;
	[self knobImageView].tintColor = [PREFS tintColorForMode: [PREFS modeForIndex: currentIndex]];
}


static void _logos_method$_ungrouped$_UIActionSlider$knobTapped(_LOGOS_SELF_TYPE_NORMAL _UIActionSlider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	int _nextValidIndex = nextValidIndex();
	
	if (_nextValidIndex != -1) {
		currentIndex = _nextValidIndex; 
		NSString *modeString = [PREFS modeForIndex: currentIndex];
	
		NSString *_trackText = [PREFS valueForSpecifier: @"string" mode: modeString];
		UIImage *_knobImage = [PREFS iconForMode: modeString];
	
		self.trackText = _trackText;
		[self setNewKnobImage: _knobImage];
	}
}





static void _logos_method$_ungrouped$SBPowerDownController$activate(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$SBPowerDownController$activate(self, _cmd);
	
	
	SBPowerDownAlertView *powerDownView = MSHookIvar<SBPowerDownAlertView*>(self, "_powerDownView");
	_SBInternalPowerDownView *internalView = MSHookIvar<_SBInternalPowerDownView*>(powerDownView, "_internalView");
	_UIActionSlider *actionSlider = MSHookIvar<_UIActionSlider*>(internalView, "_actionSlider");

	UITapGestureRecognizer *knobTap = [[UITapGestureRecognizer alloc] initWithTarget: actionSlider 
			action:@selector(knobTapped)];
	knobTap.numberOfTapsRequired = 1;
	[[actionSlider _knobView] addGestureRecognizer: knobTap];
}

static void _logos_method$_ungrouped$SBPowerDownController$powerDown(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSString *modeString = [PREFS modeForIndex: currentIndex];
	if ([modeString isEqualToString: @"PowerDown"]) {
		_logos_orig$_ungrouped$SBPowerDownController$powerDown(self, _cmd);
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
    const char *args[] = {"sh", "-c", "/usr/bin/sudo /usr/bin/ldrestart", NULL};
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
		_logos_orig$_ungrouped$SBPowerDownController$powerDown(self, _cmd);
	}	
}

static void _logos_method$_ungrouped$SBPowerDownController$cancel(_LOGOS_SELF_TYPE_NORMAL SBPowerDownController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	currentIndex = 0; 
	_logos_orig$_ungrouped$SBPowerDownController$cancel(self, _cmd);
}



static __attribute__((constructor)) void _logosLocalCtor_4d0914bd(int __unused argc, char __unused **argv, char __unused **envp) {
	PREFS = [PTPreferences new];
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, update,
		 CFSTR("com.subdiox.powertap.settingsupdated"), NULL,
		  CFNotificationSuspensionBehaviorDeliverImmediately);
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$_UIActionSlider = objc_getClass("_UIActionSlider"); MSHookMessageEx(_logos_class$_ungrouped$_UIActionSlider, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$_UIActionSlider$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$_UIActionSlider$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIImageView*), strlen(@encode(UIImageView*))); i += strlen(@encode(UIImageView*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$_UIActionSlider, @selector(knobImageView), (IMP)&_logos_method$_ungrouped$_UIActionSlider$knobImageView, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIImage*), strlen(@encode(UIImage*))); i += strlen(@encode(UIImage*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$_UIActionSlider, @selector(setNewKnobImage:), (IMP)&_logos_method$_ungrouped$_UIActionSlider$setNewKnobImage$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$_UIActionSlider, @selector(knobTapped), (IMP)&_logos_method$_ungrouped$_UIActionSlider$knobTapped, _typeEncoding); }Class _logos_class$_ungrouped$SBPowerDownController = objc_getClass("SBPowerDownController"); MSHookMessageEx(_logos_class$_ungrouped$SBPowerDownController, @selector(activate), (IMP)&_logos_method$_ungrouped$SBPowerDownController$activate, (IMP*)&_logos_orig$_ungrouped$SBPowerDownController$activate);MSHookMessageEx(_logos_class$_ungrouped$SBPowerDownController, @selector(powerDown), (IMP)&_logos_method$_ungrouped$SBPowerDownController$powerDown, (IMP*)&_logos_orig$_ungrouped$SBPowerDownController$powerDown);MSHookMessageEx(_logos_class$_ungrouped$SBPowerDownController, @selector(cancel), (IMP)&_logos_method$_ungrouped$SBPowerDownController$cancel, (IMP*)&_logos_orig$_ungrouped$SBPowerDownController$cancel);} }
#line 164 "Tweak.xm"
