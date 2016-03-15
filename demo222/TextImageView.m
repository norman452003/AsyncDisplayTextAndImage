//
//  TextImageView.m
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "TextImageView.h"
#import "DefineConstant.h"

@interface TextImageView ()

@end

@implementation TextImageView


- (instancetype)init{
    if (self = [super init]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self];
    //返回每一行
    CFArrayRef lines = CTFrameGetLines(self.frameRef);
    CGPoint origins[CFArrayGetCount(lines)];
    //获取每行原点坐标
    CTFrameGetLineOrigins(self.frameRef, CFRangeMake(0, 0), origins);
    
    CGPathRef path = CTFrameGetPath(self.frameRef);
    CGRect boundRect = CGPathGetBoundingBox(path);
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeTranslation(0, boundRect.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self _getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        CGRect adjustRect = CGRectMake(rect.origin.x + boundRect.origin.x,
                                       rect.origin.y + boundRect.origin.y,
                                       rect.size.width,
                                       rect.size.height);
        if (CGRectContainsPoint(adjustRect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(adjustRect),
                                                point.y - CGRectGetMinY(adjustRect));
            // 获得当前点击坐标对应的字符串偏移
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            //获取点击的Run
            CTRunRef touchedRun;
            NSArray* runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
            for (NSUInteger i = 0 ; i < runObjArray.count; i++) {
                CTRunRef runObj = (__bridge CTRunRef)[runObjArray objectAtIndex:i];
                CFRange range = CTRunGetStringRange((CTRunRef)runObj);
                if (NSLocationInRange(index, NSMakeRange(range.location, range.length))) {
                    touchedRun = runObj;
                    NSDictionary* runAttribues = (NSDictionary *)CTRunGetAttributes(touchedRun);
                    if ([runAttribues objectForKey:kTextShouldRespondTap]) {
                        id content = runAttribues[kTextShouldRespondTap];
                        if (self.clickBlock) {
                            self.clickBlock(content);
                        }
                    }
                    
                }
            }
        }
    }
    
}

- (CGRect)_getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

@end
