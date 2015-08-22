//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "Brain.h"

@interface JournalRecord : NSObject

@property (assign, nonatomic) UInt64 number;
@property (assign, nonatomic) NumeralSystem numeralSystem;
@property (weak,   nonatomic) NSView *view;

@end
