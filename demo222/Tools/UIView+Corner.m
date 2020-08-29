//
//  UIView+Corner.m
//  cornerDemo
//
//  Created by suning on 16/2/29.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

+ (UIImage *)my_DrawRectCornerWithImage:(UIImage *)image{
    return [self my_DrawRectWithRoundCorner:image.size.width * 0.5 size:image.size boardWith:0 backgroundColor:nil boardColor:nil backgroundImage:image];
}

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size{
    return [self my_DrawRectWithRoundCorner:radius size:size boardWith:0 backgroundColor:nil boardColor:nil];
}

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWidth{
    return [self my_DrawRectWithRoundCorner:radius size:size boardWith:boardWidth backgroundColor:nil boardColor:nil];
}

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWidth backgroundColor:(UIColor *)backgroundColor{
    return [self my_DrawRectWithRoundCorner:radius size:size boardWith:boardWidth backgroundColor:backgroundColor boardColor:nil];
}

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWith backgroundColor:(UIColor *)backgroundColor boardColor:(UIColor *)boardColor{
    return [self my_DrawRectWithRoundCorner:radius size:size boardWith:boardWith backgroundColor:backgroundColor boardColor:boardColor backgroundImage:nil];
}

+ (UIImage *)my_DrawRectWithRoundCorner:(CGFloat)radius size:(CGSize)size boardWith:(CGFloat)boardWith backgroundColor:(UIColor *)backgroundColor boardColor:(UIColor *)boardColor backgroundImage:(UIImage *)backgroundImage{
    if (backgroundColor == nil) {
        backgroundColor = [UIColor whiteColor];
    }
    
    if (boardColor == nil) {
        boardColor = [UIColor whiteColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, boardWith);
    CGContextSetStrokeColorWithColor(ctx, boardColor.CGColor);
    CGContextSetFillColorWithColor(ctx, backgroundColor.CGColor);
    
    CGContextMoveToPoint(ctx, size.width,radius);
    CGContextAddArcToPoint(ctx, size.width, size.height, 0, size.height, radius);
    CGContextAddArcToPoint(ctx, 0, size.height, 0, 0, radius);
    CGContextAddArcToPoint(ctx, 0, 0, size.width, 0, radius);
    CGContextAddArcToPoint(ctx, size.width, 0, size.width, size.height, radius);
    CGContextDrawPath(ctx, kCGPathFillStroke); //根据坐标绘制路径
    
    if (backgroundImage) {
        CGRect rect = CGRectMake(boardWith, boardWith, size.width - boardWith * 2, size.height - boardWith * 2);
        CGContextAddPath(ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius - boardWith].CGPath);
        CGContextClip(ctx);
        [backgroundImage drawInRect:rect];
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
