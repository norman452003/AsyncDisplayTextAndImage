//
//  DemoCell.h
//  demo222
//
//  Created by suning on 16/3/11.
//  Copyright © 2016年 suning. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TextLayout;

@interface DemoCell : UITableViewCell

//@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) TextLayout *layout;

@end
