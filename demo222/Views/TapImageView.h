//
//  TapImageView.h
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapImageView : UIImageView

@property (nonatomic,assign) NSString *text;
@property (nonatomic,copy) void(^clickBlock)(id content);

- (instancetype)initWithText:(NSString *)text x:(CGFloat)x y:(CGFloat)y restictWidth:(CGFloat)width  NS_DESIGNATED_INITIALIZER;



@end
