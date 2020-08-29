//
//  SNToast.h
//  SuningEBuy
//
//  Created by xzoscar on 15/11/16.

#import <UIKit/UIKit.h>

@interface SNToast : NSObject

/*
 * toast on top window
 * @xzoscar
 */

+ (void)toast:(NSString *)toastString;

/*
 * toast on top 'fromView'
 * @xzoscar
 */

+ (void)toast:(NSString *)toastString view:(UIView *)fromView;

/*
 * hide Toast
 * You do not need call this function!
 * @xzoscar
 */
+ (void)hideToast;

@end
