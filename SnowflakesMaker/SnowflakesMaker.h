//
//  SnowflakesMaker.h
//  SnowflakesMaker
//
//  Created by Oleksiy Radyvanyuk on 07/11/2017.
//  Copyright © 2017 Oleksiy Radyvanyuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowflakesMaker : NSObject

- (instancetype)initWithSize:(CGSize)size screenScale:(CGFloat)screenScale;
- (UIImage *)createSnowflake;
- (CGImageRef)randomizeOneSnowflakeBranchInRect:(CGRect)rect;

@end
