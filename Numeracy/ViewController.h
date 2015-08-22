//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BinaryView.h"
#import "JournalView.h"

@interface ViewController : NSViewController <BrainListener>

@property (weak) IBOutlet NSTextField *textFieldArithmetic;
@property (weak) IBOutlet NSTextField *textFieldInput;
@property (weak) IBOutlet NSSegmentedControl *numeralSystemSelector;

@property (weak) IBOutlet NSTextField *textFieldDisplayDEC;
@property (weak) IBOutlet NSTextField *textFieldDisplayHEX;
@property (weak) IBOutlet NSTextField *textFieldDisplayOCT;
@property (weak) IBOutlet BinaryView *binaryView;

@property (weak) IBOutlet NSButton *buttonClear;
@property (weak) IBOutlet NSButton *buttonDigit0;
@property (weak) IBOutlet NSButton *buttonDigit1;
@property (weak) IBOutlet NSButton *buttonDigit2;
@property (weak) IBOutlet NSButton *buttonDigit3;
@property (weak) IBOutlet NSButton *buttonDigit4;
@property (weak) IBOutlet NSButton *buttonDigit5;
@property (weak) IBOutlet NSButton *buttonDigit6;
@property (weak) IBOutlet NSButton *buttonDigit7;
@property (weak) IBOutlet NSButton *buttonDigit8;
@property (weak) IBOutlet NSButton *buttonDigit9;
@property (weak) IBOutlet NSButton *buttonDigitA;
@property (weak) IBOutlet NSButton *buttonDigitB;
@property (weak) IBOutlet NSButton *buttonDigitC;
@property (weak) IBOutlet NSButton *buttonDigitD;
@property (weak) IBOutlet NSButton *buttonDigitE;
@property (weak) IBOutlet NSButton *buttonDigitF;
@property (weak) IBOutlet NSButton *buttonBackspace;
@property (weak) IBOutlet NSButton *buttonShiftLeft;
@property (weak) IBOutlet NSButton *buttonShiftRight;
@property (weak) IBOutlet NSButton *buttonArithmeticAdd;
@property (weak) IBOutlet NSButton *buttonArithmeticSubstruct;
@property (weak) IBOutlet NSButton *buttonArithmeticMultiply;
@property (weak) IBOutlet NSButton *buttonArithmeticDivide;
@property (weak) IBOutlet NSButton *buttonArithmeticAnd;
@property (weak) IBOutlet NSButton *buttonArithmeticOr;
@property (weak) IBOutlet NSButton *buttonArithmeticExclusiveOr;
@property (weak) IBOutlet NSButton *buttonEquation;

@property (weak) IBOutlet JournalView *journalView;

@end
