//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "BitButton.h"
#import "Brain.h"

@implementation BitButton
{
    NSImageView *buttonImageView;
    NSImageView *lightImageView;
    Brain *brain;
    UInt64 mask;
}

- (void)viewDidMoveToSuperview
{
    [super viewDidMoveToSuperview];

    mask = 1;
    mask <<= self.bitPosition;

    brain = [Brain sharedBrain];

    NSImage *buttonImage = [NSImage imageNamed:@"LED Frame"];
    NSImage *lightImage = [NSImage imageNamed:@"LED Light"];

    CGRect imageViewFrame = CGRectMake(0.0f, 12.0f, 32.0f, 32.0f);
    CGRect labelFrame = CGRectMake(0.0f, 0.0f, 32.0f, 16.0f);

    buttonImageView = [[NSImageView alloc] initWithFrame:imageViewFrame];
    [buttonImageView setImage:buttonImage];
    [self addSubview:buttonImageView];

    lightImageView = [[NSImageView alloc] initWithFrame:imageViewFrame];
    [lightImageView setImage:lightImage];
    [self addSubview:lightImageView];

    NSTextField *label = [[NSTextField alloc] initWithFrame:labelFrame];
    [label setEditable:NO];
    [label setBordered:NO];
    [label setDrawsBackground:NO];
    [label setAlignment:NSCenterTextAlignment];
    [label setFont:[NSFont userFixedPitchFontOfSize:10.0f]];
    [label setStringValue:[NSString stringWithFormat:@"%d", self.bitPosition]];
    [self addSubview:label];

    [self refresh];
}

+ (CGSize)preferrableSize
{
    return CGSizeMake(32.0f, 44.0f);
}

- (void)refresh
{
    UInt64 number = [brain number];
    if ((number & mask) == mask) {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:0.2f];
            [buttonImageView.animator setAlphaValue:1.0f];
            [lightImageView.animator setAlphaValue:1.0f];
        } completionHandler:^{
        }];
    } else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:0.4f];
            [buttonImageView.animator setAlphaValue:0.5f];
            [lightImageView.animator setAlphaValue:0.0f];
        } completionHandler:^{
        }];
    }
}

- (void)mouseUp:(NSEvent *)event
{
    [super mouseUp:event];

    UInt64 number = [brain number];
    number ^= mask;
    [brain setNumber:number];

    NSSound *sound = [NSSound soundNamed:@"Pop"];
    [sound play];
}

@end
