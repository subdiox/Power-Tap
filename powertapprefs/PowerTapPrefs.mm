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
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=A9Y267DUCKU3L"]
                                   options:@{}
                         completionHandler:nil];
}

@end

// vim:ft=objc
