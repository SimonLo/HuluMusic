//
//  HCPlayingCustomView.m
//  LittleFrog
//
//  Created by Simon Lo on 2017/4/10.
//  Copyright © 2017年 HuangCong. All rights reserved.
//

#import "HCPlayingCustomView.h"
#import "UIView+HCExtension.h"

@interface HCPlayingCustomView()

@property (nonatomic,assign) CGFloat flag;

@end

@implementation HCPlayingCustomView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panActionMove:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)panActionMove:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.y < 120) {
            [UIView animateWithDuration:0.2 animations:^{
                self.y = 0;
            }];
        } else {
            if (self.dismissBlock) {
                self.dismissBlock();
            }
            return;
        }
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"%f",point.y);
        if (point.y < 0) {
            if (self.y > 0) {
                self.transform = CGAffineTransformTranslate(self.transform,0,point.y);
                [gesture setTranslation:CGPointMake(0, 0) inView:self];
            } else {
                self.y = 0;
            }
            
            return;
        }
        
        if (self.y > 120) {
            if (self.dismissBlock) {
                self.dismissBlock();
            }
            return;
        }
        
        self.transform = CGAffineTransformTranslate(self.transform,0,point.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
    }
}


@end
