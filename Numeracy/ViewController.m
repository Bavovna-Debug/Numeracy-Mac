//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "ViewController.h"
#import "JournalRecordView.h"

@implementation ViewController
{
    Brain *brain;
    Journal *journal;
    NSImageView *panelView;
    NSTrackingArea *trackingArea;
    id eventMonitor;
    BOOL mouseIsIn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    brain = [Brain sharedBrain];
    journal = [Journal sharedJournal];

    [self.journalView setItemPrototype:[JournalRecordPrototype new]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextDidChange:)
                                                 name:NSControlTextDidChangeNotification
                                               object:nil];

    [brain.listeners addObject:self];

    [brain setNumeralSystem:NumeralSystemDEC];
    [brain setNumber:0];
}

- (void)viewDidLayout
{
    [super viewDidLayout];

    if (panelView == nil) {
        panelView = [[NSImageView alloc] initWithFrame:self.view.bounds];
        [panelView setImage:[NSImage imageNamed:@"Panel"]];
        [self.view addSubview:panelView
                   positioned:NSWindowBelow
                   relativeTo:self.view];
    }

    if (trackingArea == nil) {
        NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
        CGRect trackingRect = CGRectMake(0.0f,
                                         0.0f,
                                         CGRectGetWidth([self.view bounds]) - CGRectGetWidth([self.journalView bounds]),
                                         CGRectGetHeight([self.view bounds]));
        trackingArea = [[NSTrackingArea alloc] initWithRect:trackingRect
                                                    options:options
                                                      owner:self
                                                   userInfo:nil];
        [self.view addTrackingArea:trackingArea];
    }
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

- (void)mouseEntered:(NSEvent *)event
{
    // Drop focus from any record label in case one is focused.
    //
    [self.view.window makeFirstResponder:self.textFieldInput];

    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask
                                                         handler:^NSEvent* (NSEvent *event)
    {
        NSString *pressedKeys = event.charactersIgnoringModifiers;
        for (NSUInteger index = 0; index < [pressedKeys length]; index++)
            [self keyPressed:[pressedKeys characterAtIndex:index]];
        return event;
    }];

    mouseIsIn = YES;
}

- (void)mouseExited:(NSEvent *)event
{
    mouseIsIn = NO;

    id currentEventMonitor = eventMonitor;
    if (currentEventMonitor != nil) {
        eventMonitor = nil;
        [NSEvent removeMonitor:currentEventMonitor];
    }
}

- (void)keyPressed:(char)key
{
    if (mouseIsIn == NO)
        return;

    switch (key)
    {
        case '0':
            [self.buttonDigit0 performClick:self];
            break;

        case '1':
            [self.buttonDigit1 performClick:self];
            break;

        case '2':
            [self.buttonDigit2 performClick:self];
            break;

        case '3':
            [self.buttonDigit3 performClick:self];
            break;

        case '4':
            [self.buttonDigit4 performClick:self];
            break;

        case '5':
            [self.buttonDigit5 performClick:self];
            break;

        case '6':
            [self.buttonDigit6 performClick:self];
            break;

        case '7':
            [self.buttonDigit7 performClick:self];
            break;

        case '8':
            [self.buttonDigit8 performClick:self];
            break;

        case '9':
            [self.buttonDigit9 performClick:self];
            break;

        case 'a':
        case 'A':
            [self.buttonDigitA performClick:self];
            break;

        case 'b':
        case 'B':
            [self.buttonDigitB performClick:self];
            break;

        case 'c':
        case 'C':
            [self.buttonDigitC performClick:self];
            break;

        case 'd':
        case 'D':
            [self.buttonDigitD performClick:self];
            break;

        case 'e':
        case 'E':
            [self.buttonDigitE.cell performClick:self];
            break;

        case 'f':
        case 'F':
            [self.buttonDigitF performClick:self];
            break;

        case '+':
            [self.buttonArithmeticAdd performClick:self];
            break;

        case '-':
            [self.buttonArithmeticSubstruct performClick:self];
            break;

        case '*':
            [self.buttonArithmeticMultiply performClick:self];
            break;

        case '/':
            [self.buttonArithmeticDivide performClick:self];
            break;

        case '&':
            [self.buttonArithmeticAnd performClick:self];
            break;

        case '|':
            [self.buttonArithmeticOr performClick:self];
            break;

        case '^':
            [self.buttonArithmeticExclusiveOr performClick:self];
            break;

        case '=':
        case 0x0D:
            [self.buttonEquation performClick:self];
            break;

        case 0x7F:
            [self.buttonBackspace performClick:self];
            break;

        case 0x00:
            [brain shiftByteLeft];
            break;

        case 0x01:
            [brain shiftByteRight];
            break;

        case 0x02:
        case '<':
            [self.buttonShiftLeft performClick:self];
            break;

        case 0x03:
        case '>':
            [self.buttonShiftRight performClick:self];
            break;
            
        case 0x1B:
            [self.buttonClear.cell performClick:self];
            break;

        default:
#ifdef DEBUG
            NSLog(@"Key %02X", key);
#endif
            break;
    }
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (userInfo == nil)
        return;

    NSTextView *textView = [userInfo valueForKey:@"NSFieldEditor"];
    if (textView == nil)
        return;

    if (textView != (NSTextView *)self.textFieldInput)
        return;

    NSString *input = [textView string];
    if (input == nil)
        return;

    if ([input length] == 0) {
        [brain setNumber:0];
    } else {
        [brain translateInput:input];
    }
}

- (void)flashTheButton:(NSButton *)button
{
    /*
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration:2.0f];
        [button setAlphaValue:0.2f];
    } completionHandler:^{
        //[button setAlphaValue:1.0f];
    }];
     */
}

- (IBAction)clearPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain clear];
}

- (IBAction)digitPressed:(NSButton *)sender
{
    [self flashTheButton:sender];
    [brain translateDigit:sender.tag];
}

- (IBAction)backspacePressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain backspaceDigit];
}

- (IBAction)shiftLeftPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain shiftLeft];
}

- (IBAction)shiftRightPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain shiftRight];
}

- (IBAction)operationAddPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticAdd];
}

- (IBAction)operationSubstractPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticSubstract];
}

- (IBAction)operationMultiplyPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticMultiply];
}

- (IBAction)operationDividePressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticDivide];
}

- (IBAction)operationAndPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticAnd];
}

- (IBAction)operationOrPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticOr];
}

- (IBAction)operationExclusiveOrPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain arithmetic:ArithmeticExclusiveOr];
}

- (IBAction)equationPressed:(id)sender
{
    [self flashTheButton:(NSButton *)sender];
    [brain equal];
}

- (IBAction)saveDEC:(id)sender
{
    [journal pokeNumber:[brain number]
          numeralSystem:NumeralSystemDEC];
}

- (IBAction)saveHEX:(id)sender
{
    [journal pokeNumber:[brain number]
          numeralSystem:NumeralSystemHEX];
}

- (IBAction)saveOCT:(id)sender
{
    [journal pokeNumber:[brain number]
          numeralSystem:NumeralSystemOCT];
}

- (IBAction)numeralSystemChanged:(NSSegmentedControl *)sender
{
    switch ([self.numeralSystemSelector selectedSegment])
    {
        case 0:
            [brain setNumeralSystem:NumeralSystemDEC];
            break;

        case 1:
            [brain setNumeralSystem:NumeralSystemHEX];
            break;

        case 2:
            [brain setNumeralSystem:NumeralSystemOCT];
            break;

        case 3:
            [brain setNumeralSystem:NumeralSystemBIN];
            break;

        default:
            break;
    }
}

- (void)updateInputField
{
    UInt64 number = [brain number];

    switch ([brain numeralSystem])
    {
        case NumeralSystemBIN:
            [self.textFieldInput setStringValue:[Brain stringForBIN:number bits:16]];
            break;

        case NumeralSystemOCT:
            [self.textFieldInput setStringValue:[Brain stringForOCT:number formatted:NO]];
            break;

        case NumeralSystemDEC:
            [self.textFieldInput setStringValue:[Brain stringForDEC:number formatted:NO]];
            break;

        case NumeralSystemHEX:
            [self.textFieldInput setStringValue:[Brain stringForHEX:number formatted:NO]];
            break;
    }
}

- (void)updateDisplays
{
    UInt64 number = [brain number];

    [self.textFieldDisplayDEC setStringValue:[Brain stringForDEC:number formatted:YES]];

    [self.textFieldDisplayHEX setStringValue:[Brain stringForHEX:number formatted:YES]];

    [self.textFieldDisplayOCT setStringValue:[Brain stringForOCT:number formatted:YES]];
}

#pragma mark - Brain Delegate

- (void)numeralSystemDidChange
{
    switch ([brain numeralSystem])
    {
        case NumeralSystemDEC:
            [self.buttonDigit0 setEnabled:YES];
            [self.buttonDigit1 setEnabled:YES];
            [self.buttonDigit2 setEnabled:YES];
            [self.buttonDigit3 setEnabled:YES];
            [self.buttonDigit4 setEnabled:YES];
            [self.buttonDigit5 setEnabled:YES];
            [self.buttonDigit6 setEnabled:YES];
            [self.buttonDigit7 setEnabled:YES];
            [self.buttonDigit8 setEnabled:YES];
            [self.buttonDigit9 setEnabled:YES];
            [self.buttonDigitA setEnabled:NO];
            [self.buttonDigitB setEnabled:NO];
            [self.buttonDigitC setEnabled:NO];
            [self.buttonDigitD setEnabled:NO];
            [self.buttonDigitE setEnabled:NO];
            [self.buttonDigitF setEnabled:NO];
            break;

        case NumeralSystemHEX:
            [self.buttonDigit0 setEnabled:YES];
            [self.buttonDigit1 setEnabled:YES];
            [self.buttonDigit2 setEnabled:YES];
            [self.buttonDigit3 setEnabled:YES];
            [self.buttonDigit4 setEnabled:YES];
            [self.buttonDigit5 setEnabled:YES];
            [self.buttonDigit6 setEnabled:YES];
            [self.buttonDigit7 setEnabled:YES];
            [self.buttonDigit8 setEnabled:YES];
            [self.buttonDigit9 setEnabled:YES];
            [self.buttonDigitA setEnabled:YES];
            [self.buttonDigitB setEnabled:YES];
            [self.buttonDigitC setEnabled:YES];
            [self.buttonDigitD setEnabled:YES];
            [self.buttonDigitE setEnabled:YES];
            [self.buttonDigitF setEnabled:YES];
            break;

        case NumeralSystemOCT:
            [self.buttonDigit0 setEnabled:YES];
            [self.buttonDigit1 setEnabled:YES];
            [self.buttonDigit2 setEnabled:YES];
            [self.buttonDigit3 setEnabled:YES];
            [self.buttonDigit4 setEnabled:YES];
            [self.buttonDigit5 setEnabled:YES];
            [self.buttonDigit6 setEnabled:YES];
            [self.buttonDigit7 setEnabled:YES];
            [self.buttonDigit8 setEnabled:NO];
            [self.buttonDigit9 setEnabled:NO];
            [self.buttonDigitA setEnabled:NO];
            [self.buttonDigitB setEnabled:NO];
            [self.buttonDigitC setEnabled:NO];
            [self.buttonDigitD setEnabled:NO];
            [self.buttonDigitE setEnabled:NO];
            [self.buttonDigitF setEnabled:NO];
            break;

        case NumeralSystemBIN:
            [self.buttonDigit0 setEnabled:YES];
            [self.buttonDigit1 setEnabled:YES];
            [self.buttonDigit2 setEnabled:NO];
            [self.buttonDigit3 setEnabled:NO];
            [self.buttonDigit4 setEnabled:NO];
            [self.buttonDigit5 setEnabled:NO];
            [self.buttonDigit6 setEnabled:NO];
            [self.buttonDigit7 setEnabled:NO];
            [self.buttonDigit8 setEnabled:NO];
            [self.buttonDigit9 setEnabled:NO];
            [self.buttonDigitA setEnabled:NO];
            [self.buttonDigitB setEnabled:NO];
            [self.buttonDigitC setEnabled:NO];
            [self.buttonDigitD setEnabled:NO];
            [self.buttonDigitE setEnabled:NO];
            [self.buttonDigitF setEnabled:NO];
            break;
    }

    [self updateInputField];
}

- (void)numberDidChange
{
    [self updateInputField];
    [self updateDisplays];
}

- (void)arithmeticDidChange
{
    switch ([brain arithmetic])
    {
        case ArithmeticNone:
            [self.textFieldArithmetic setStringValue:@""];
            break;

        case ArithmeticAdd:
            [self.textFieldArithmetic setStringValue:@"ADD"];
            break;

        case ArithmeticSubstract:
            [self.textFieldArithmetic setStringValue:@"SUB"];
            break;

        case ArithmeticMultiply:
            [self.textFieldArithmetic setStringValue:@"MUL"];
            break;

        case ArithmeticDivide:
            [self.textFieldArithmetic setStringValue:@"DIV"];
            break;

        case ArithmeticAnd:
            [self.textFieldArithmetic setStringValue:@"AND"];
            break;

        case ArithmeticOr:
            [self.textFieldArithmetic setStringValue:@"OR"];
            break;

        case ArithmeticExclusiveOr:
            [self.textFieldArithmetic setStringValue:@"XOR"];
            break;
    }
}

@end
