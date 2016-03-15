//
//  TapImageView.m
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "TapImageView.h"
#import <CoreText/CoreText.h>
#import "DefineConstant.h"


static inline NSRegularExpression* EmojiRegularExpression() {
    static NSRegularExpression* _EmojiRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _EmojiRegularExpression = [[NSRegularExpression alloc] initWithPattern:EmojiRegular options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    return _EmojiRegularExpression;
}

static inline NSRegularExpression* URLRegularExpression() {
    static NSRegularExpression* _URLRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _URLRegularExpression = [[NSRegularExpression alloc] initWithPattern:URLRegular options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    return _URLRegularExpression;
}

static inline NSRegularExpression* AccountRegularExpression() {
    static NSRegularExpression* _AccountRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _AccountRegularExpression = [[NSRegularExpression alloc] initWithPattern:AccountRegular options:NSRegularExpressionAnchorsMatchLines error:nil];
    });
    return _AccountRegularExpression;
}


static inline NSRegularExpression* TopicRegularExpression() {
    static NSRegularExpression* _TopicRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _TopicRegularExpression = [[NSRegularExpression alloc] initWithPattern:TopicRegular options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return _TopicRegularExpression;
}

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}


@interface TapImageView ()
@property (nonatomic,strong) UIImage *textImage;
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat restictWidth;
@end

@implementation TapImageView

- (instancetype)initWithText:(NSString *)text x:(CGFloat)x y:(CGFloat)y restictWidth:(CGFloat)width{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        _x = x;
        _y = y;
        self.restictWidth = width;
        _text = text;
        if (_text != nil && text.length > 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self changeToAttributeString];
            });
        }
    }
    return self;
}

- (void)setText:(NSString *)text{
    if (_text != text) {
        _text = text;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self changeToAttributeString];
        });    }
}

- (void)changeToAttributeString{
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName : [UIColor blackColor]}];
    attributeStr = [self parseHttpURLWithTextLayout:attributeStr];
    attributeStr = [self parseAccountWithText:attributeStr];
    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(setterRef, CFRangeMake(0, 0), nil, CGSizeMake(self.restictWidth, CGFLOAT_MAX), nil);
    _height = size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width  , size.height)];
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, attributeStr.length), path.CGPath, NULL);
    self.frameRef = frameRef;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(frameRef, context);
    _textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = _textImage;
        self.frame = CGRectMake(_x, _y, size.width, size.height);
    });
    
    CFRelease(setterRef);
}

- (NSAttributedString *)parseHttpURLWithTextLayout:(NSAttributedString *)attributeStr{
    NSMutableAttributedString *mAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attributeStr];
    NSString *text = attributeStr.string;
    NSArray* resultArray = [URLRegularExpression() matchesInString:text
                                                           options:0
                                                             range:NSMakeRange(0,text.length)];
    int i = 0;
    NSInteger length = 0;
    for(NSTextCheckingResult* match in resultArray) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
        NSAttributedString *changeAttribute = [[NSAttributedString alloc] initWithString:@"#网页链接#" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor blueColor]}];
        [mAttribute replaceCharactersInRange:NSMakeRange(range.location - length, range.length) withAttributedString:changeAttribute];
        [mAttribute addAttribute:kTextShouldRespondTap value:content range:NSMakeRange(range.location - length, 6)];
        length = length + content.length - 6;
        i++;
    }
    return mAttribute.copy;
}

- (NSAttributedString *)parseAccountWithText:(NSAttributedString *)attributeStr{
    NSMutableAttributedString *mAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attributeStr];
    NSString *text= attributeStr.string;
    NSArray* resultArray = [AccountRegularExpression() matchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0,text.length)];
    for(NSTextCheckingResult* match in resultArray) {
        NSRange range = [match range];
        NSString* content = [text substringWithRange:range];
//        NSAttributedString *changeAttributeStr = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:25],NSForegroundColorAttributeName : [UIColor redColor],NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
        NSAttributedString *changeAttributeStr = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor redColor]}];
        [mAttribute replaceCharactersInRange:range withAttributedString:changeAttributeStr];
        [mAttribute addAttribute:kTextShouldRespondTap value:content range:range];
    }
    return mAttribute.copy;
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
