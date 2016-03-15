//
//  DemoCell.m
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "DemoCell.h"
#import "TapImageView.h"
#import "DefineConstant.h"
#import "TextImageView.h"
#import "TextLayout.h"
#import "SNToast.h"
#import <YYWebImage/YYWebImage.h>
#import "UIView+Corner.h"
#import "NSArray+sf_objectAtIndex.h"

@interface DemoCell ()
@property (nonatomic,weak) UIImageView *iconView;
@property (nonatomic,weak) TextImageView *imageV;
@property (nonatomic,weak) UIImageView *bigImageView;
@end

@implementation DemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        TextImageView *imageV = [[TextImageView alloc] init];
        [self.contentView addSubview:imageV];
        self.imageV = imageV;
        imageV.clickBlock = ^(id content){
            [SNToast toast:content];
        };
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 55, 55)];
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        
        UIImageView *bigImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:bigImageView];
        self.bigImageView = bigImageView;
    }
    return self;
}

- (void)setLayout:(TextLayout *)layout{
    self.bigImageView.image = nil;
    _layout = layout;
    self.imageV.frameRef = layout.frameRef;
    self.imageV.image = layout.textImage;
    self.imageV.frame = CGRectMake(20, 80, layout.restictWidth, layout.height);
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:layout.iconURL] options:0 progress:nil transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        image = [UIView my_DrawRectCornerWithImage:image];
        self.iconView.image = image;
    }];
    self.bigImageView.frame = CGRectMake(0, CGRectGetMaxY(self.imageV.frame) + 5, kScreenWidth, self.layout.imageHeight);
    [self downloadImagesToGenegrateTheHoleImage];
}

- (void)downloadImagesToGenegrateTheHoleImage{
    static NSLock *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
    });
    NSMutableDictionary *mDict = @{}.mutableCopy;
    NSMutableArray *mArray = @[].mutableCopy;
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < self.layout.imageURLS.count; i++) {
        dispatch_group_enter(group);
        NSString *url = self.layout.imageURLS[i];
        [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:url] options:0 progress:nil transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            [mDict setObject:image forKey:@(i)];
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        [lock lock];
        for (int i = 0; i < mDict.count; i++) {
            UIImage *image = [mDict objectForKey:@(i)];
            [mArray addObject:image];
        }
        self.layout.images = mArray.copy;
        [lock unlock];
        
        [self fetchHoleImage];
    });
}


- (void)fetchHoleImage{
    NSInteger count = self.layout.images.count;
    CGSize size = CGSizeMake(kScreenWidth, self.layout.imageHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    for (int i = 0; i < count; i++) {
        CGFloat x = i % 3 * (imageW + 10) + 20;
        CGFloat y;
        y =((count - 1) / 3 - i / 3) * (imageW + 5);
        CGRect rect = CGRectMake(x, y, imageW, imageW);
        UIImage *img = [self.layout.images sf_objectAtIndex:i];
        CGContextDrawImage(context, rect, img.CGImage);
        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    }
    self.layout.bigImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bigImageView.image = self.layout.bigImage;
    });
}

- (UIImage *)scaleImage:(UIImage *)image ToResticSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
