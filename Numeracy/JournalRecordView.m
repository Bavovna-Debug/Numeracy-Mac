//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "JournalRecordView.h"
#import "JournalBitLane.h"
#import "Journal.h"
#import "JournalRecord.h"

@implementation JournalRecordPrototype

- (void)loadView
{
    Journal *journal = [Journal sharedJournal];
    JournalRecord *journalRecord = [journal.records firstObject];
    JournalRecordView *view = [[JournalRecordView alloc] initWithJournalRecord:journalRecord];
    [self setView:view];
}

@end

@interface JournalRecordView ()

@property (weak, nonatomic) JournalRecord *journalRecord;

@end

@implementation JournalRecordView
{
    NSTrackingArea *trackingArea;
    NSTextField *recordLabel;
    NSButton *peekButton;
    NSButton *deleteButton;
    NSTextField *numeralSystemDisplay;
    NSTextField *numberDisplay;
    JournalBitLane *bitLane;
}

- (id)initWithJournalRecord:(JournalRecord *)theJournalRecord
{
    self = [super init];
    if (self == nil)
        return nil;

    [theJournalRecord setView:self];

    self.journalRecord = theJournalRecord;

    [self setFrame:CGRectMake(0.0f, 0.0f, 296.0f, 80.0f)];

    NSImageView *backgroundView = [[NSImageView alloc] initWithFrame:self.bounds];
    NSImage *backgroundImage = [NSImage imageNamed:@"Record"];
    [backgroundView setImage:backgroundImage];
    [self addSubview:backgroundView];

    CGRect recordLabelFrame = CGRectMake(16.0f, 52.0f, 200.0f, 20.0f);
    CGRect peekButtonFrame = CGRectMake(226.0f, 52.0f, 20.0f, 20.0f);
    CGRect deleteButtonFrame = CGRectMake(256.0f, 52.0f, 20.0f, 20.0f);
    CGRect numberDisplayFrame = CGRectMake(16.0f, 32.0f, 260.0f, 20.0f);
    CGRect numeralSystemDisplayFrame = CGRectMake(16.0f, 32.0f, 260.0f, 20.0f);
    CGRect bitLaneFrame = CGRectMake(16.0f, 12.0f, 260.0f, 16.0f);

    NSFont *recordLabelFont = [NSFont systemFontOfSize:14.0f];
    recordLabel = [[NSTextField alloc] initWithFrame:recordLabelFrame];
    [recordLabel setEditable:YES];
    [recordLabel setBordered:NO];
    [recordLabel setDrawsBackground:NO];
    [recordLabel setBackgroundColor:[NSColor clearColor]];
    [recordLabel setTextColor:[NSColor whiteColor]];
    [recordLabel setAlignment:NSLeftTextAlignment];
    [recordLabel setFont:recordLabelFont];
    [recordLabel setAlphaValue:0.9f];
    [recordLabel setFocusRingType:NSFocusRingTypeNone];

    NSDictionary *placeholderDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSColor darkGrayColor], NSForegroundColorAttributeName,
                                           recordLabelFont, NSFontAttributeName,
                                           nil];
    NSAttributedString *placeholderAttributes = [[NSAttributedString alloc] initWithString:@"Unnamed"
                                                                                attributes:placeholderDictionary];
    [recordLabel setPlaceholderAttributedString:placeholderAttributes];
    [self addSubview:recordLabel];

    numeralSystemDisplay = [[NSTextField alloc] initWithFrame:numeralSystemDisplayFrame];
    [numeralSystemDisplay setEditable:NO];
    [numeralSystemDisplay setBordered:NO];
    [numeralSystemDisplay setDrawsBackground:NO];
    [numeralSystemDisplay setBackgroundColor:[NSColor clearColor]];
    [numeralSystemDisplay setTextColor:[NSColor lightGrayColor]];
    [numeralSystemDisplay setAlignment:NSLeftTextAlignment];
    [numeralSystemDisplay setFont:[NSFont userFixedPitchFontOfSize:14.0f]];
    switch ([self.journalRecord numeralSystem])
    {
        case NumeralSystemBIN:
            [numeralSystemDisplay setStringValue:@"BIN"];
            break;

        case NumeralSystemOCT:
            [numeralSystemDisplay setStringValue:@"OCT"];
            break;

        case NumeralSystemDEC:
            [numeralSystemDisplay setStringValue:@"DEC"];
            break;

        case NumeralSystemHEX:
            [numeralSystemDisplay setStringValue:@"HEX"];
            break;
    }
    [numeralSystemDisplay setAlphaValue:0.8f];
    [self addSubview:numeralSystemDisplay];

    numberDisplay = [[NSTextField alloc] initWithFrame:numberDisplayFrame];
    [numberDisplay setEditable:NO];
    [numberDisplay setBordered:NO];
    [numberDisplay setDrawsBackground:NO];
    [numberDisplay setBackgroundColor:[NSColor clearColor]];
    [numberDisplay setTextColor:[NSColor whiteColor]];
    [numberDisplay setAlignment:NSRightTextAlignment];
    [numberDisplay setFont:[NSFont userFixedPitchFontOfSize:14.0f]];
    switch ([self.journalRecord numeralSystem])
    {
        case NumeralSystemBIN:
            [numberDisplay setStringValue:[Brain stringForBIN:[self.journalRecord number] bits:32]];
            break;

        case NumeralSystemOCT:
            [numberDisplay setStringValue:[Brain stringForOCT:[self.journalRecord number] formatted:YES]];
            break;

        case NumeralSystemDEC:
            [numberDisplay setStringValue:[Brain stringForDEC:[self.journalRecord number] formatted:YES]];
            break;

        case NumeralSystemHEX:
            [numberDisplay setStringValue:[Brain stringForHEX:[self.journalRecord number] formatted:YES]];
            break;
    }
    [numberDisplay setAlphaValue:0.8f];
    [self addSubview:numberDisplay];

    bitLane = [[JournalBitLane alloc] initWithFrame:bitLaneFrame];
    [self addSubview:bitLane];

    peekButton = [[NSButton alloc] initWithFrame:peekButtonFrame];
    [peekButton setBezelStyle:NSTexturedSquareBezelStyle];
    [peekButton setBordered:NO];
    [peekButton setButtonType:NSMomentaryChangeButton];
    [peekButton setImage:[NSImage imageNamed:@"Button Peek"]];
    [peekButton setAlphaValue:0.2f];
    [self addSubview:peekButton];

    deleteButton = [[NSButton alloc] initWithFrame:deleteButtonFrame];
    [deleteButton setBezelStyle:NSTexturedSquareBezelStyle];
    [deleteButton setBordered:NO];
    [deleteButton setButtonType:NSMomentaryChangeButton];
    [deleteButton setImage:[NSImage imageNamed:@"Button Delete"]];
    [deleteButton setAlphaValue:0.2f];
    [self addSubview:deleteButton];

    [peekButton setTarget:self];
    [peekButton setAction:@selector(peekButtonPressed:)];

    [deleteButton setTarget:self];
    [deleteButton setAction:@selector(deleteButtonPressed:)];

    return self;
}

- (void)updateTrackingAreas
{
    if (trackingArea == nil) {
        NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
        trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                    options:options
                                                      owner:self
                                                   userInfo:nil];
        [self addTrackingArea:trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)event
{
    [recordLabel setAlphaValue:1.0f];
    [numeralSystemDisplay setAlphaValue:1.0f];
    [numberDisplay setAlphaValue:1.0f];
    [peekButton setAlphaValue:1.0f];
    [deleteButton setAlphaValue:1.0f];
}

- (void)mouseExited:(NSEvent *)event
{
    [recordLabel setAlphaValue:0.9f];
    [numeralSystemDisplay setAlphaValue:0.8f];
    [numberDisplay setAlphaValue:0.8f];
    [peekButton setAlphaValue:0.2f];
    [deleteButton setAlphaValue:0.2f];
}

- (void)peekButtonPressed:(id)sender
{
    NSButton *button = sender;
    JournalRecordView *view = (JournalRecordView *)button.superview;
    JournalRecord *journalRecord = view.journalRecord;
    [[Brain sharedBrain] setNumber:[journalRecord number]];
}

- (void)deleteButtonPressed:(id)sender
{
    NSButton *button = sender;
    JournalRecordView *view = (JournalRecordView *)button.superview;
    JournalRecord *journalRecord = view.journalRecord;
    [[Journal sharedJournal] deleteRecord:journalRecord];
}

@end
