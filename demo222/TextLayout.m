//
//  TextLayout.m
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "TextLayout.h"
#import "DefineConstant.h"
#import <YYWebImage.h>

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

@interface TextLayout ()

@property (nonatomic,copy) void(^completeBlock)();
@property (nonatomic,strong) NSLock *lock;
@end

@implementation TextLayout

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)paraseWithDict:(NSDictionary *)dict restrictWidth:(CGFloat)restrictWidth complete:(void (^)())complete{
    _iconURL = dict[@"icon"];
    self.imageURLS = dict[@"images"];
    NSInteger imageCount = self.imageURLS.count;
    self.imageHeight = self.imageURLS.count > 0 ? imageW * ((imageCount - 1)/3 + 1) + imageCount / 3 * 5: 0;
    [self paraseWithText:dict[@"text"] restictWidth:restrictWidth complete:complete];
}

- (void)paraseWithText:(NSString *)text restictWidth:(CGFloat)restictWidth complete:(void (^)())complete{
    _text = text;
    self.completeBlock = complete;
    self.restictWidth = restictWidth;
    [self changeToAttributeString];
}

- (void)changeToAttributeString{
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:_text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName : [UIColor blackColor]}];
    attributeStr = [self parseHttpURLWithTextLayout:attributeStr];
    attributeStr = [self parseAccountWithText:attributeStr];
    
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(setterRef, CFRangeMake(0, 0), nil, CGSizeMake(self.restictWidth, CGFLOAT_MAX), nil);
    _height = size.height ;
    
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
        if (self.completeBlock) {
            self.completeBlock();
        }
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
        [mAttribute addAttribute:kTextShouldRespondTap value:content range:NSMakeRange(range.location - length, changeAttribute.length)];
        length = length + content.length - changeAttribute.length;
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

- (NSLock *)lock{
    if (_lock == nil) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

@end
