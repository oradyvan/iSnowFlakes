//
//  ViewController.m
//  SnowflakesMaker
//
//  Created by Oleksiy Radyvanyuk on 1/2/13.
//  Copyright (c) 2013 Oleksiy Radyvanyuk. All rights reserved.
//

/*
#import "ViewController.h"
#import "SnowflakesMaker.h"

NSInteger const kNumberOfSnowflakes = 128;
CGFloat const kMinSnowflakeRatio = 0.05f;
CGFloat const kMaxSnowflakeRatio = 0.1f;
NSTimeInterval const kTimerRate = 0.05;
CGFloat const kFallSpeed = 5.0f;
NSInteger const kMinPhases = 1;
NSInteger const kMaxPhases = 3;

@interface ViewController ()

@property (nonatomic, strong) SnowflakesMaker *maker;

@end

@implementation ViewController {
    NSMutableArray *snowflakes;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.maker = [[SnowflakesMaker alloc] initWithSize:self.imgView.frame.size screenScale:UIScreen.mainScreen.scale];

    NSDate *date = [NSDate date];
    srandom((unsigned int)(NSTimeIntervalSince1970 - [date timeIntervalSinceReferenceDate]));

    self.imgView.image = [self.maker createSnowflake];

    snowflakes = [[NSMutableArray alloc] initWithCapacity:kNumberOfSnowflakes];
    [NSTimer scheduledTimerWithTimeInterval:kTimerRate target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

- (IBAction)onRefresh:(id)sender {
    self.imgView.image = [self.maker createSnowflake];
}

- (void)onTimer:(NSTimer *)timer {
    NSMutableArray *flakesToRemove = [[NSMutableArray alloc] init];

    // move existing snowflakes down one step
    [snowflakes enumerateObjectsUsingBlock:^(UIImageView *snowflake, NSUInteger idx, BOOL *stop) {
        CGFloat fallSpeed = kFallSpeed;

        CGRect frame = snowflake.frame;
        frame.origin.y += fallSpeed;
        CGFloat x = frame.origin.y / self.view.frame.size.height * snowflake.tag * M_PI;

        frame.origin.x += fallSpeed * sinf(x / 2) * cosf(5 * x / 6);
        snowflake.frame = frame;

        // if the snowflake falls off the screen, mark it for removal
        if (frame.origin.y > self.view.frame.size.height) {
            [flakesToRemove addObject:snowflake];
            [snowflake removeFromSuperview];
        }
    }];

    // remove snowflakes that are out of view
    [snowflakes removeObjectsInArray:flakesToRemove];

    // add new snowflake
    if ([snowflakes count] < kNumberOfSnowflakes) {
        CGFloat flakeSize = self.view.frame.size.width * (kMinSnowflakeRatio + (CGFloat)random() / RAND_MAX * (kMaxSnowflakeRatio - kMinSnowflakeRatio));
        CGFloat minX = - flakeSize;
        CGFloat maxX = self.view.frame.size.width - flakeSize / 2;
        CGFloat flakeX = minX + (CGFloat)random() / RAND_MAX * (maxX - minX);
        CGRect flakeFrame = CGRectIntegral(CGRectMake(flakeX, -flakeSize, flakeSize, flakeSize));
        UIImageView *snowflake = [[UIImageView alloc] initWithFrame:flakeFrame];
        // choosing random value of number of phases
        snowflake.tag = kMinPhases + lroundf((CGFloat)random() / RAND_MAX * (kMaxPhases - kMinPhases));
        snowflake.image = [self.maker createSnowflake];
        [self.view addSubview:snowflake];
        [snowflakes addObject:snowflake];
    }
}

@end
*/
