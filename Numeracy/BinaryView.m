//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

//#import <QuartzCore/QuartzCore.h>
#import "BinaryView.h"
#import "ByteView.h"

@implementation BinaryView
{
    NSMutableArray *bytes;
}

//#define degreesToRadians(degrees) (degrees * (M_PI / 180.0f))

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];

    self.wantsLayer = YES;

    NSView *panelView = [[NSView alloc] initWithFrame:self.bounds];
    [self addSubview:panelView];

/*
    CGFloat rotateX = degreesToRadians(0.0f);
    CGFloat rotateY = degreesToRadians(20.0f);
    CGFloat rotateZ = degreesToRadians(2.0f);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0f / 500.0f;
    transform = CATransform3DRotate(transform, rotateX, 1, 0, 0);
    transform = CATransform3DRotate(transform, rotateY, 0, 1, 0);
    transform = CATransform3DRotate(transform, rotateZ, 0, 0, 1);
    panelView.wantsLayer = YES;
    panelView.layer.transform = transform;
    //panelView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawNever;
*/

    CGRect bounds = self.bounds;
    CGRect byteFrame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(bounds), CGRectGetHeight(bounds) / 8);
    bytes = [NSMutableArray array];
    for (int byte = 0; byte < 8; byte++)
    {
        ByteView *byteView = [[ByteView alloc] initWithFrame:byteFrame];
        byteView.bytePosition = byte;
        [bytes addObject:byteView];
        [panelView addSubview:byteView];

        byteFrame = CGRectOffset(byteFrame, 0.0f, CGRectGetHeight(byteFrame));
    }

    Brain *brain = [Brain sharedBrain];
    [brain.listeners addObject:self];
}

- (void)numberDidChange
{
    for (ByteView *byteView in bytes)
        [byteView refresh];
}

@end
