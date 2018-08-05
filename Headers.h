#import <UIKit/UIKit.h>
#import "substrate.h"

@interface SBPowerDownController

+ (SBPowerDownController*)sharedInstance;

@end

@interface SBPowerDownAlertView : UIView

@end

@interface _SBInternalPowerDownView : UIView

@end

@interface FBSystemService : NSObject

- (void)shutdownAndReboot:(BOOL)arg1;
- (void)exitAndRelaunch:(BOOL)arg1;

@end

@interface _UIActionSlider : UIView

@property (readwrite) NSString *trackText;
@property (readwrite) UIImage *knobImage;

- (UIView*)_knobView;
- (UIImageView*)knobImageView;
- (void)setNewKnobImage:(UIImage*)image;
- (void)knobTapped;

@end

@interface UIApplication (PowerOptions)

- (void)reboot;
- (void)_relaunchSpringBoardNow;
- (void)nonExistentMethod;

@end