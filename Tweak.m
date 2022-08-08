@import libhooker.libblackjack;
#import "View/IslaView.h"


@interface SBVolumeHUDViewController : UIViewController
@end


static IslaView *islaView;

static void (*origVDL)(SBVolumeHUDViewController *self, SEL);
static void overrideVDL(SBVolumeHUDViewController *self, SEL _cmd) {

	origVDL(self, _cmd);
	for(UIView *subview in self.view.subviews) {
		if(subview == islaView) continue;
		subview.hidden = YES;
	}

	if(!islaView) islaView = [IslaView new];
	islaView.alpha = 0;
	islaView.transform = CGAffineTransformMakeTranslation(0, -20);
	[self.view addSubview: islaView];

	[NSLayoutConstraint activateConstraints:@[
		[islaView.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor],
		[islaView.topAnchor constraintEqualToAnchor: self.view.topAnchor constant: 20],
		[islaView.widthAnchor constraintEqualToConstant: 265],
		[islaView.heightAnchor constraintEqualToConstant: 20]
	]];

}

static void (*origVWA)(SBVolumeHUDViewController *self, SEL, BOOL);
static void overrideVWA(SBVolumeHUDViewController *self, SEL _cmd, BOOL animated) {

	origVWA(self, _cmd, animated);

	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		islaView.transform = CGAffineTransformMakeTranslation(0, 0);
		islaView.alpha = 1;

	} completion:nil];

}


__attribute__((constructor)) static void init() {

	LBHookMessage(NSClassFromString(@"SBVolumeHUDViewController"), @selector(viewDidLoad), &overrideVDL, &origVDL);
	LBHookMessage(NSClassFromString(@"SBVolumeHUDViewController"), @selector(viewWillAppear:), &overrideVWA, &origVWA);

}
