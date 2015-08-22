//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BitButton : NSControl

@property (assign, nonatomic) int bitPosition;

+ (CGSize)preferrableSize;

- (void)refresh;

@end
