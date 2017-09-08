//
//  ActionSliderView.m
//  yalu102
//
//  Created by Shade Zepheri on 9/8/17.
//  Copyright © 2017 kimjongcracks. All rights reserved.
//

#import "ActionSliderView.h"

@implementation ActionSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.enabled = YES;
        
        [self setupTrack];
        [self setupKnob];
    }
    
    return self;
}

- (void)setupTrack {
    self.sliderTrack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.sliderTrack.backgroundColor = [UIColor clearColor];
    
    self.sliderTrack.layer.borderColor = [UIColor grayColor].CGColor;
    self.sliderTrack.layer.borderWidth = 1.0;
    self.sliderTrack.layer.cornerRadius = 10.0;
    [self addSubview:self.sliderTrack];
    
    self.trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.frame.size.width - 80, self.frame.size.height)];
    self.trackLabel.text = @"Slide to Jailbreak";
    self.trackLabel.textColor = [UIColor whiteColor];
    self.trackLabel.textAlignment = NSTextAlignmentCenter;
    self.trackLabel.numberOfLines = 1;
    self.trackLabel.font = [UIFont systemFontOfSize:20];
    [self.sliderTrack addSubview:self.trackLabel];
    
    [self addLabelGlint];
}

- (void)addLabelGlint {
    CALayer *maskLayer = [CALayer layer];
    
    // Mask image ends with 0.15 opacity on both sides. Set the background color of the layer
    // to the same value so the layer can extend the mask image.
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] CGColor];
    maskLayer.contents = (id)[UIImage imageNamed:@"Mask"].CGImage;
    
    // Center the mask image on twice the width of the text layer, so it starts to the left
    // of the text layer and moves to its right when we translate it by width.
    CGRect frame = self.trackLabel.frame;
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(-CGRectGetWidth(frame), 0.0f, CGRectGetWidth(frame) * 2, CGRectGetHeight(frame));
    
    // Animate the mask layer's horizontal position
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = @(CGRectGetWidth(frame));
    maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 1.0f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    
    self.trackLabel.layer.mask = maskLayer;
}

- (void)setupKnob {
    self.sliderKnob = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 60, self.frame.size.height - 4)];
    self.sliderKnob.layer.cornerRadius = 10.0;
    [self.sliderTrack addSubview:self.sliderKnob];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, CGRectGetWidth(self.sliderKnob.frame), CGRectGetHeight(self.sliderKnob.frame));
    gradient.cornerRadius = 10.0;
    gradient.colors = @[(id)[UIColor colorWithRed:0.24 green:0.62 blue:0.92 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.04 green:0.44 blue:0.72 alpha:1.0].CGColor];
    [self.sliderKnob.layer insertSublayer:gradient atIndex:0];
    
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.sliderKnob.frame), CGRectGetHeight(self.sliderKnob.frame))];
    arrowImage.image = [UIImage imageNamed:@"Arrow"];
    [self.sliderKnob addSubview:arrowImage];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderDidMove:)];
    [self.sliderKnob addGestureRecognizer:panGesture];
}

- (void)updateLabelVisibiltyForPoint:(CGPoint)point {
    CGFloat base = CGRectGetWidth(self.sliderTrack.frame) - 32;
    CGFloat percentComplete = point.x / base;
    
    self.trackLabel.alpha = 1 - percentComplete;
}

- (void)sliderDidMove:(UIPanGestureRecognizer *)recognizer {
    if (!self.enabled) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _initialPoint = self.sliderKnob.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer translationInView:self.sliderTrack];
        
        CGFloat newX = _initialPoint.x + point.x;
        if (newX < _initialPoint.x || newX > (CGRectGetWidth(self.sliderTrack.frame) - 30)) {
            return;
        }
        
        CGPoint translation = CGPointMake(newX, _initialPoint.y);
        self.sliderKnob.center = translation;
        [self updateLabelVisibiltyForPoint:translation];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (self.sliderKnob.center.x > (CGRectGetWidth(self.sliderTrack.frame) - 40)) {
            [self.delegate sliderDidComplete:self];
        }
        
        self.enabled = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.sliderKnob.center = _initialPoint;
        } completion:^(BOOL fininshed) {
            if (fininshed) {
                _initialPoint = CGPointZero;
                self.enabled = YES;
                self.trackLabel.alpha = 1.0;
            }
        }];
    }
}

@end
