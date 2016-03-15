//
//  SNToast.m
//  SuningEBuy
//
//  Created by xzoscar on 15/11/16.
//  Copyright © 2015年 苏宁易购. All rights reserved.
//

#import "SNToast.h"

@interface SNToastView : UIView
@property (nonatomic,strong) UILabel *textLabel;

- (id)initWithString:(NSString *)toastString;

- (void)setToastString:(NSString *)toastString;

@end

@implementation SNToastView

- (id)initWithString:(NSString *)toastString {
    if (self = [super init]) {
        
        {
            self.backgroundColor    = [UIColor blackColor];
            self.clipsToBounds      = YES;
            self.layer.cornerRadius = 5.0f;
        }
        
        [self addSubview:self.textLabel];
        
        NSArray *hLys =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-14-[_textLabel]-14-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(_textLabel)];
        NSArray *vLys =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_textLabel]-14-|"
                                                options:0
                                                metrics:nil
                                                  views:NSDictionaryOfVariableBindings(_textLabel)];
        [self addConstraints:hLys];
        [self addConstraints:vLys];
        
        if (nil != toastString) {
            [self setToastString:toastString];
        }
    }
    return self;
}

- (UILabel *)textLabel {
    if (nil == _textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor    = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textLabel;
}

- (void)setToastString:(NSString *)toastString {
    self.textLabel.text = toastString;
}

@end

@interface SNToast ()
@property (nonatomic,strong) SNToastView *toastView;
@end

@implementation SNToast

+ (SNToast *)sharedToast {
    static dispatch_once_t once;
    static SNToast *obj = nil;
    dispatch_once(&once, ^{
        obj = [[SNToast alloc] init];
    });
    return obj;
}

- (SNToastView *)toastView {
    if (nil == _toastView) {
        _toastView = [[SNToastView alloc] initWithString:nil];
    }
    return _toastView;
}

- (void)animateToVisible {
    if (nil != _toastView && !_toastView.hidden) {
        // animate to show
        _toastView.alpha  = .0f;
        [UIView animateWithDuration:.35f animations:^{
            _toastView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hideToast) withObject:nil afterDelay:2.5f];
        }];
    }
}

- (void)hideToast {
    if (nil != _toastView) {
        [_toastView setHidden:YES];
    }
}

- (void)showToast {
    if (nil != _toastView) {
        [self.class cancelPreviousPerformRequestsWithTarget:self
                                                   selector:@selector(hideToast)
                                                     object:nil];
        [_toastView setHidden:NO];
        // bringSubviewToFront
        [_toastView.superview bringSubviewToFront:_toastView];
        [self animateToVisible];
    }
}

- (void)removeToastFromSuperView {
    if (nil != _toastView) {
        [_toastView removeFromSuperview];
    }
}

/*
 * toast on top 'fromView'
 * @xzoscar
 */

+ (void)toast:(NSString *)toastString view:(UIView *)fromView {
    if (nil == toastString || nil == fromView) {
        return;
    }
    [[self sharedToast] hideToast];
    
    if (![fromView.subviews containsObject:[self sharedToast].toastView]) {
        [fromView addSubview:[self sharedToast].toastView];
        
        // layout
        SNToastView *toastView = [self sharedToast].toastView;
        toastView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *xLyout =
        [NSLayoutConstraint constraintWithItem:fromView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toastView
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0f
                                      constant:.0f];
        NSLayoutConstraint *yLyout =
        [NSLayoutConstraint constraintWithItem:fromView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toastView
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0f
                                      constant:.0f];
        
        NSArray *hLays = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=44)-[toastView]-(>=44)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(toastView)];
        [fromView addConstraint:xLyout];
        [fromView addConstraint:yLyout];
        [fromView addConstraints:hLays];
    }
    
    [[self sharedToast].toastView setToastString:toastString];
    [[self sharedToast] showToast];
}

/*
 * toast on top window
 * @xzoscar
 */
+ (void)toast:(NSString *)toastString {
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [self.class toast:toastString view:win];
}

/*
 * hide Toast
 * @xzoscar
 */
+ (void)hideToast {
    [[self sharedToast] hideToast];
}

@end
