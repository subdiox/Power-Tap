#import <Preferences/PSListController.h>

@interface PowerTapPrefsListController: PSListController {
}
@end


@implementation PowerTapPrefsListController

- (id)specifiers {
	if(!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"PowerTapPrefs" target:self];
	}
	
	return _specifiers;
}

-(void)openPaypalLink:(id)param {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://subdiox.com/blitzmodder/contact.html"]
                                   options:@{}
                         completionHandler:nil];
}

@end

// vim:ft=objc
