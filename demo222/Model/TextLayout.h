//
//  TextLayout.h
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface TextLayout : NSObject

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *iconURL;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,strong) UIImage *textImage;
@property (nonatomic,assign) CGFloat restictWidth;
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSArray *imageURLS;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,assign) CGFloat imageHeight;
@property (nonatomic,strong) UIImage *bigImage;


- (void)paraseWithText:(NSString *)text restictWidth:(CGFloat)restictWidth complete:(void(^)())complete;
- (void)paraseWithDict:(NSDictionary *)dict restrictWidth:(CGFloat)restrictWidth complete:(void(^)())complete;
@end
