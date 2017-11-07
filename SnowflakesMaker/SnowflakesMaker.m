//
//  SnowflakesMaker.m
//  SnowflakesMaker
//
//  Created by Oleksiy Radyvanyuk on 07/11/2017.
//  Copyright © 2017 Oleksiy Radyvanyuk. All rights reserved.
//

#import "SnowflakesMaker.h"

NSInteger const kMinRects = 10;
NSInteger const kMaxRects = 20;
CGFloat const kMinRectSizeRatio = 0.02f;
CGFloat const kMaxRectSizeRatio = 0.5f;

@interface SnowflakesMaker ()
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat screenScale;
@end

@implementation SnowflakesMaker

- (instancetype)initWithSize:(CGSize)size screenScale:(CGFloat)screenScale {
    if (self = [super init]) {
        self.size = size;
        self.screenScale = screenScale;
    }
    return self;
}

- (UIImage *)createSnowflake {
    // creating image for the quarter size of the image view
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize size = self.size;
    size.width = scale * roundf(size.width / 4);
    size.height = scale * roundf(size.height / 4);
    CGRect rect = CGRectMake(0.0f, 0.0f, floorf(size.width / 2), floorf(size.height / 2));

    CGImageRef branchRef = [self randomizeOneSnowflakeBranchInRect:rect];

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, size.width * 4, cs, kCGImageAlphaPremultipliedLast);
    CGRect bounds = CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);

    CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawImage(context, bounds, branchRef);

    CGFloat deltaAngle = -M_PI / 3;
    CGFloat dX = CGRectGetMidX(rect)*cosf(deltaAngle);
    CGFloat dY = -CGRectGetMidY(rect)*sinf(deltaAngle);

    for (int i = 1; i < 6; i++) {
        CGContextTranslateCTM(context, dX, dY);
        CGContextRotateCTM(context, deltaAngle);
        CGContextDrawImage(context, bounds, branchRef);
    }

    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];

    // tidy up
    CGImageRelease(branchRef);
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(cs);

    return image;
}

- (CGImageRef)randomizeOneSnowflakeBranchInRect:(CGRect)rect {
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, rect.size.width * 4, cs, kCGImageAlphaPremultipliedLast);

    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextClearRect(context, rect);

    // going top to bottom in the middle of the image
    CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGContextDrawPath(context, kCGPathStroke);

    NSInteger numRects = kMinRects + lroundf((CGFloat)random() / RAND_MAX * (kMaxRects - kMinRects));
    CGFloat h = CGRectGetHeight(rect);
    for (NSInteger i = 0; i < numRects; i++) {
        // calculating random size of the square
        CGFloat rectExtent = roundf(h * (kMinRectSizeRatio + (CGFloat)random() / RAND_MAX * (kMaxRectSizeRatio - kMinRectSizeRatio)));
        CGRect square = CGRectMake(0.0f, 0.0f, rectExtent, rectExtent);

        // calculate random position of the rect on line, excluding edge cases
        CGFloat minY = CGRectGetMinY(rect) + rectExtent / 2;
        CGFloat maxY = CGRectGetMaxY(rect) - rectExtent / 2;
        CGFloat yPos = roundf(minY + (CGFloat)random() / RAND_MAX * (maxY - minY));

        // shifting square to the middle of the rect horizontally
        // and by the random amount of points vertically
        square = CGRectOffset(square, CGRectGetMidX(rect) - rectExtent / 2, yPos);

        // centering and rotating context so that the rect is drawn as a romb
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMidX(square), CGRectGetMidY(square));
        CGContextRotateCTM(context, M_PI_4);
        CGRect bounds = CGRectMake(0.0f, 0.0f, square.size.width, square.size.height);
        // draw line from bottom left to bottom right corner
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        // draw line from bottom left to top left corner
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // stroke the lines
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }

    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(cs);
    return imageRef;
}

@end
