//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BrainListener;

@interface Brain : NSObject

typedef enum
{
    NumeralSystemBIN = 2,
    NumeralSystemOCT = 8,
    NumeralSystemDEC = 10,
    NumeralSystemHEX = 16
} NumeralSystem;

typedef enum
{
    ArithmeticNone,
    ArithmeticAdd,
    ArithmeticSubstract,
    ArithmeticMultiply,
    ArithmeticDivide,
    ArithmeticAnd,
    ArithmeticOr,
    ArithmeticExclusiveOr
} Arithmetic;

@property (assign, nonatomic) NumeralSystem numeralSystem;
@property (assign, nonatomic) Arithmetic arithmetic;
@property (assign, nonatomic) BOOL arithmeticJustBegun;
@property (assign, nonatomic) UInt64 number;
@property (assign, nonatomic) UInt64 pocket;
@property (strong, nonatomic) NSMutableArray *listeners;

+ (Brain *)sharedBrain;

- (void)load;

- (void)save;

- (void)clear;

- (void)translateDigit:(long)digit;

- (void)translateInput:(NSString *)input;

- (void)backspaceDigit;

- (void)shiftLeft;

- (void)shiftRight;

- (void)shiftByteLeft;

- (void)shiftByteRight;

- (void)arithmetic:(Arithmetic)arithmetic;

- (void)equal;

+ (NSString *)stringForBIN:(UInt64)number
                      bits:(int)bits;

+ (NSString *)stringForOCT:(UInt64)number
                 formatted:(BOOL)formatted;

+ (NSString *)stringForDEC:(UInt64)number
                 formatted:(BOOL)formatted;

+ (NSString *)stringForHEX:(UInt64)number
                 formatted:(BOOL)formatted;

@end

@protocol BrainListener <NSObject>

@required

- (void)numberDidChange;

@optional

- (void)numeralSystemDidChange;
- (void)arithmeticDidChange;

@end
