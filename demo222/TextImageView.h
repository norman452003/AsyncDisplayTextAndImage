//
//  TextImageView.h
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface TextImageView : UIImageView

@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,copy) void (^clickBlock)(id content);

@end
