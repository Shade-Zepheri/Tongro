//
//  ActionSliderView.h
//  yalu102
//
//  Created by Shade Zepheri on 9/8/17.
//  Copyright © 2017 kimjongcracks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionSliderView;
@protocol ActionSliderDelegate <NSObject>

- (void)sliderDidComplete:(ActionSliderView *)slider;

@end

@interface ActionSliderView : UIView {
    CGPoint _initialPoint;
}
@property (strong, nonatomic) UIView *sliderKnob;
@property (strong, nonatomic) UIView *sliderTrack;
@property (strong, nonatomic) UILabel *trackLabel;

@property (nonatomic) BOOL enabled;

@property (weak, nonatomic) id <ActionSliderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

@end
