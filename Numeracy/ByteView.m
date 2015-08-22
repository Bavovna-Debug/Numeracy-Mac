//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "ByteView.h"
#import "BitButton.h"

@implementation ByteView
{
    NSMutableArray *bits;
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];

    CGRect bounds = self.bounds;
    CGSize bitSize = [BitButton preferrableSize];
    CGRect bitFrame = CGRectMake(CGRectGetMidX(bounds) - bitSize.width * 4,
                                 CGRectGetMidY(bounds) - bitSize.height / 2,
                                 bitSize.width,
                                 bitSize.height);

    bits = [NSMutableArray array];
    for (int bit = 7; bit >= 0; bit--)
    {
        BitButton *bitButton = [[BitButton alloc] initWithFrame:bitFrame];
        bitButton.bitPosition = (self.bytePosition * 8) + bit;
        [bits addObject:bitButton];
        [self addSubview:bitButton];

        bitFrame = CGRectOffset(bitFrame, CGRectGetWidth(bitFrame), 0.0f);
    }
}

- (void)refresh
{
    for (BitButton *bitButton in bits)
        [bitButton refresh];
}

@end
