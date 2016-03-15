//
//  NSArray+sf_objectAtIndex.m
//  demo222
//
//  Created by suning on 16/3/15.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "NSArray+sf_objectAtIndex.h"

@implementation NSArray (sf_objectAtIndex)
- (id)sf_objectAtIndex:(NSUInteger)index{
    if (index >= self.count) {
        return nil;
    }else{
        return self[index];
    }
    
}
@end
