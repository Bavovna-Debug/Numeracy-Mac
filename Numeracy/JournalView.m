//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "JournalView.h"
#import "JournalRecordView.h"

@implementation JournalView
{
    Journal *journal;
}

- (void)viewDidMoveToSuperview
{
    [super viewDidMoveToSuperview];

    journal = [Journal sharedJournal];

    [journal setDelegate:self];
}

#pragma mark - Journal Delegate

- (void)journalContentDidChange
{
    NSMutableArray *records = [[Journal sharedJournal] records];
    [self setContent:records];
}
-(void)keyDown:(NSEvent *)theEvent{

    NSLog(@"left key pressed");

}

@end
