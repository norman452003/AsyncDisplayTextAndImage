//
//  UIView+Corner.h
//  cornerDemo
//
//  Created by suning on 16/2/29.
//  Copyright © 2016年 suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)

/**
 *  快速生成一个圆角图片的方法 此方法只针对图片为正方形的情况
 *
 *  @param image 要剪裁圆角的图片
 *
 *  @return 返回剪裁好的图片
 */
+ (UIImage *)my_DrawRectCornerWithImage:(UIImage *)image;

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size;

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWidth;

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWidth backgroundColor:(UIColor *)backgroundColor;

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWith backgroundColor:(UIColor *)backgroundColor boardColor:(UIColor *)boardColor;

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWith backgroundColor:(UIColor *)backgroundColor boardColor:(UIColor *)boardColor backgroundImage:(UIImage *)backgroundImage;

@end
