//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "JournalBitLane.h"
#import "Brain.h"

@implementation JournalBitLane

- (void)viewDidMoveToSuperview
{
    [super viewDidMoveToSuperview];

    UInt64 number = [[Brain sharedBrain] number];
    UInt64 mask = 1;

    NSImage *bitOff = [NSImage imageNamed:@"Bit Off"];
    NSImage *bitOn = [NSImage imageNamed:@"Bit On"];

    CGRect bitFrame = CGRectZero;
    for (int bit = 0; bit < 64; bit++)
    {
        if (bit == 0) {
            bitFrame = CGRectMake(CGRectGetWidth(self.bounds) - 8.0f, 0.0f, 8.0f, 8.0f);
        } else if (bit == 32) {
            bitFrame = CGRectMake(CGRectGetWidth(self.bounds) - 8.0f, 8.0f, 8.0f, 8.0f);
        } else if ((bit == 48) || (bit == 16)) {
            bitFrame = CGRectOffset(bitFrame, -CGRectGetWidth(bitFrame) - 4.0f, 0.0f);
        } else {
            bitFrame = CGRectOffset(bitFrame, -CGRectGetWidth(bitFrame), 0.0f);
        }

        NSImageView *bitView = [[NSImageView alloc] initWithFrame:CGRectInset(bitFrame, -1.0f, -1.0f)];
        if ((number & mask) == mask) {
            [bitView setImage:bitOn];
        } else {
            [bitView setImage:bitOff];
        }
        [self addSubview:bitView];

        mask <<= 1;
    }
}

@end
