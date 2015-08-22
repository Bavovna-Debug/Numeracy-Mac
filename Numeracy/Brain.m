//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "Brain.h"

@implementation Brain

@synthesize numeralSystem = _numeralSystem;
@synthesize arithmetic = _arithmetic;
@synthesize number = _number;

+ (Brain *)sharedBrain
{
    static dispatch_once_t onceToken;
    static Brain *brain;

    dispatch_once(&onceToken, ^{
        brain = [[Brain alloc] init];
    });

    return brain;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    self.arithmetic = ArithmeticNone;
    self.arithmeticJustBegun = NO;
    self.numeralSystem = NumeralSystemDEC;
    self.number = 0;
    self.pocket = 0;
    self.listeners = [NSMutableArray array];

    return self;
}

- (void)setNumeralSystem:(NumeralSystem)numeralSystem
{
    _numeralSystem = numeralSystem;

    for (id<BrainListener> listener in self.listeners)
    {
        if ([listener respondsToSelector:@selector(numeralSystemDidChange)])
            [listener numeralSystemDidChange];
    }
}

- (void)setArithmetic:(Arithmetic)arithmetic
{
    _arithmetic = arithmetic;

    for (id<BrainListener> listener in self.listeners)
        if ([listener respondsToSelector:@selector(arithmeticDidChange)])
            [listener arithmeticDidChange];
}

- (void)setNumber:(UInt64)number
{
    _number = number;

    for (id<BrainListener> listener in self.listeners)
        if ([listener respondsToSelector:@selector(numberDidChange)])
            [listener numberDidChange];
}

- (void)clear
{
    self.number = 0;
    self.arithmeticJustBegun = NO;
}

- (void)translateDigit:(long)digit
{
    UInt64 number;

    if ((self.arithmetic != ArithmeticNone) && (self.arithmeticJustBegun == YES)) {
        self.arithmeticJustBegun = NO;
        number = 0;
    } else {
        number = self.number;
    }

    switch (self.numeralSystem)
    {
        case NumeralSystemBIN:
            number *= 2;
            number += digit;
            break;

        case NumeralSystemOCT:
            number *= 8;
            number += digit;
            break;

        case NumeralSystemDEC:
            number *= 10;
            number += digit;
            break;

        case NumeralSystemHEX:
            number *= 16;
            number += digit;
            break;
    }

    self.number = number;
}

- (void)translateInput:(NSString *)input
{
    UInt64 number = 0;
    UInt64 initialNumber;

    if ((self.arithmetic != ArithmeticNone) && (self.arithmeticJustBegun == YES)) {
        self.arithmeticJustBegun = NO;
        initialNumber = 0;
    } else {
        initialNumber = self.number;
    }

    switch (self.numeralSystem)
    {
        case NumeralSystemBIN:
            break;

        case NumeralSystemOCT:
            for (NSUInteger index = 0; index  < [input length]; index++)
            {
                number <<= 3;

                unichar digit = [input characterAtIndex:index];
                unichar zero = '0';
                UInt64 value = digit - zero;

                if (value > 7) {
                    number = initialNumber;
                    break;
                }

                number += value;
            }

            break;

        case NumeralSystemDEC:
            for (NSUInteger index = 0; index  < [input length]; index++)
            {
                number *= 10;

                unichar digit = [input characterAtIndex:index];
                unichar zero = '0';
                UInt64 value = digit - zero;

                if (value > 9) {
                    number = initialNumber;
                    break;
                }

                number += value;
            }

            break;

        case NumeralSystemHEX:
            for (NSUInteger index = 0; index  < [input length]; index++)
            {
                number <<= 4;

                NSString *digit = [input substringWithRange:NSMakeRange(index, 1)];
                unsigned int value;
                NSScanner *scanner = [NSScanner scannerWithString:digit];
                if (![scanner scanHexInt:&value]) {
                    number = initialNumber;
                    break;
                }

                number += value;
            }

            break;
    }

    self.number = number;
}

- (void)backspaceDigit
{
    if ((self.arithmetic != ArithmeticNone) && (self.arithmeticJustBegun == YES)) {
        self.arithmeticJustBegun = NO;
        self.number = 0;
    } else {
        switch (self.numeralSystem)
        {
            case NumeralSystemBIN:
                self.number >>= 1;
                break;

            case NumeralSystemOCT:
                self.number >>= 3;
                break;

            case NumeralSystemDEC:
                self.number /= 10;
                break;

            case NumeralSystemHEX:
                self.number >>= 4;
                break;
        }
    }
}

- (void)shiftLeft
{
    self.number <<= 1;
}

- (void)shiftRight
{
    self.number >>= 1;
}

- (void)shiftByteLeft
{
    self.number <<= 8;
}

- (void)shiftByteRight
{
    self.number >>= 8;
}

- (void)arithmetic:(Arithmetic)arithmetic
{
    if ((self.arithmetic != ArithmeticNone) && (self.arithmeticJustBegun == NO))
        [self equal];

    self.pocket = self.number;
    self.arithmetic = arithmetic;
    self.arithmeticJustBegun = YES;
}

- (void)equal
{
    switch (self.arithmetic)
    {
        case ArithmeticAdd:
            self.number = self.pocket + self.number;
            break;

        case ArithmeticSubstract:
            self.number = self.pocket - self.number;
            break;

        case ArithmeticMultiply:
            self.number = self.pocket * self.number;
            break;

        case ArithmeticDivide:
            self.number = self.pocket / self.number;
            break;

        case ArithmeticAnd:
            self.number = self.pocket & self.number;
            break;

        case ArithmeticOr:
            self.number = self.pocket | self.number;
            break;

        case ArithmeticExclusiveOr:
            self.number = self.pocket ^ self.number;
            break;

        default:
            break;
    }

    self.arithmetic = ArithmeticNone;
    self.arithmeticJustBegun = NO;
}

+ (NSString *)stringForBIN:(UInt64)number
                      bits:(int)bits
{
    NSString *string = (bits < 64) ? @"... " : @"";

    UInt64 mask = 1;
    mask <<= bits - 1;

    for (int bit = 0; bit < bits; bit++)
    {
        if ((number & mask) == mask) {
            string = [string stringByAppendingString:@"1"];
        } else {
            string = [string stringByAppendingString:@"0"];
        }

        mask >>= 1;
    }

    return string;
}

+ (NSString *)stringForOCT:(UInt64)number
                 formatted:(BOOL)formatted
{
    int cycle = 0;
    NSString *string = @"";

    do {
        if ((formatted == YES) && (cycle > 0) && (cycle % 4 == 0))
            string = [NSString stringWithFormat:@" %@", string];

        int rest = number % 8;
        string = [NSString stringWithFormat:@"%d%@", rest, string];

        number >>= 3;
        cycle++;
    } while (number > 0);

    return string;
}

+ (NSString *)stringForDEC:(UInt64)number
                 formatted:(BOOL)formatted
{
    int cycle = 0;
    NSString *string = @"";

    do {
        if ((formatted == YES) && (cycle > 0) && (cycle % 3 == 0))
            string = [NSString stringWithFormat:@",%@", string];

        int rest = number % 10;
        string = [NSString stringWithFormat:@"%d%@", rest, string];

        number -= rest;
        number /= 10;
        cycle++;
    } while (number > 0);

    return string;
}

+ (NSString *)stringForHEX:(UInt64)number
                 formatted:(BOOL)formatted
{
    int cycle = 0;
    NSString *string = @"";

    do {
        if ((formatted == YES) && (cycle > 0) && (cycle % 2 == 0))
            string = [NSString stringWithFormat:@":%@", string];

        int rest = number % 16;
        string = [NSString stringWithFormat:@"%X%@", rest, string];

        number >>= 4;
        cycle++;
    } while (number > 0);
    
    return string;
}

@end
