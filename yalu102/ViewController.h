//
//  ViewController.h
//  yalu102
//
//  Created by qwertyoruiop on 05/01/2017.
//  Copyright © 2017 kimjongcracks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSliderView.h"

@interface ViewController : UIViewController <ActionSliderDelegate>
@property (strong, nonatomic) ActionSliderView *slider;

@end

