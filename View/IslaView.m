#import "IslaView.h"


@implementation IslaView {

	UIStackView *islaStackView;
	UIImageView *islaSpeakerImageView;
	UIView *islaHudView;
	UIView *islaSliderView;
	NSLayoutConstraint *islaSliderWidthAnchorConstraint;
	float outputVolume;

}

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupIslaView];

	[[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:0 context:nil];
	[[AVAudioSession sharedInstance] setActive:YES error: nil];

	outputVolume = [AVAudioSession sharedInstance].outputVolume;

	return self;

}


- (void)layoutSubviews {

	[super layoutSubviews];
	[self layoutIslaView];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	float newVolume = [AVAudioSession sharedInstance].outputVolume;

	[UIView transitionWithView:islaSliderView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{

		float newConstant = newVolume < 0.999 ? floor(newVolume * 229) : 229;

		islaSliderWidthAnchorConstraint.active = NO;
		islaSliderWidthAnchorConstraint = [islaSliderView.widthAnchor constraintEqualToConstant: newConstant];
		islaSliderWidthAnchorConstraint.active = YES;

		[self layoutIfNeeded];

	} completion:nil];

}


- (void)setupIslaView {

	self.translatesAutoresizingMaskIntoConstraints = NO;

	if(!islaStackView) islaStackView = [UIStackView new];
	islaStackView.axis = UILayoutConstraintAxisHorizontal;
	islaStackView.spacing = 5;
	islaStackView.alignment = UIStackViewAlignmentCenter;
	islaStackView.distribution = UIStackViewDistributionFill;
	islaStackView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview: islaStackView];

	UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithWeight: UIImageSymbolWeightBold];

	if(!islaSpeakerImageView) islaSpeakerImageView = [UIImageView new];
	islaSpeakerImageView.image = [UIImage systemImageNamed: @"speaker.wave.2" withConfiguration: configuration];
	islaSpeakerImageView.tintColor = UIColor.labelColor;
	islaSpeakerImageView.contentMode = UIViewContentModeScaleAspectFit;
	islaSpeakerImageView.clipsToBounds = YES;
	islaSpeakerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[islaStackView addArrangedSubview: islaSpeakerImageView];

	if(!islaHudView) islaHudView = [self setupUIViewWithBackgroundColor: UIColor.systemGrayColor];
	[islaStackView addArrangedSubview: islaHudView];

	if(!islaSliderView) islaSliderView = [self setupUIViewWithBackgroundColor: UIColor.labelColor];
	[islaHudView addSubview: islaSliderView];

}


- (void)layoutIslaView {

	NSDictionary *views = @{
		@"islaStackView": islaStackView,
		@"islaSpeakerImageView": islaSpeakerImageView,
		@"islaHudView": islaHudView,
		@"islaSliderView": islaSliderView
	};

	NSString *formatIslaStackViewTopBottom = @"V:|-[islaStackView]-|";
	NSString *formatIslaStackViewLeadingTrailing = @"H:|-[islaStackView]-|";
	NSString *formatIslaSpeakerWidth = @"H:[islaSpeakerImageView(==15)]";
	NSString *formatIslaSpeakerHeight = @"V:[islaSpeakerImageView(==15)]";
	NSString *formatIslaHudHeight = @"V:[islaHudView(==2)]";
	NSString *formatIslaSliderHeight = @"V:[islaSliderView(==2)]";

	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:formatIslaStackViewTopBottom options:0 metrics:nil views: views]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:formatIslaStackViewLeadingTrailing options:0 metrics:nil views: views]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:formatIslaSpeakerWidth options:0 metrics:nil views: views]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:formatIslaSpeakerHeight options:0 metrics:nil views: views]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:formatIslaHudHeight options:0 metrics:nil views: views]];
	[self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:formatIslaSliderHeight options:0 metrics:nil views: views]];

	islaSliderWidthAnchorConstraint.active = NO;
	islaSliderWidthAnchorConstraint = [islaSliderView.widthAnchor constraintEqualToConstant: floor(outputVolume * 229)];
	islaSliderWidthAnchorConstraint.active = YES;

}

// Reusable

- (UIView *)setupUIViewWithBackgroundColor:(UIColor *)color {

	UIView *view = [UIView new];
	view.backgroundColor = color;
	view.layer.cornerCurve = kCACornerCurveContinuous;
	view.layer.cornerRadius = 1;
	view.translatesAutoresizingMaskIntoConstraints = NO;
	return view;

}


- (void)dealloc { [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"]; }

@end
