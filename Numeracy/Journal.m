//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "Journal.h"
#import "JournalRecord.h"

@implementation Journal

+ (Journal *)sharedJournal
{
    static dispatch_once_t onceToken;
    static Journal *journal;

    dispatch_once(&onceToken, ^{
        journal = [[Journal alloc] init];
    });

    return journal;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    self.records = [NSMutableArray array];

    return self;
}

- (void)load
{
}

- (void)save
{
}

- (void)pokeNumber:(UInt64)number
     numeralSystem:(NumeralSystem)numeralSystem
{
    JournalRecord *record = [[JournalRecord alloc] init];
    record.number = number;
    record.numeralSystem = numeralSystem;

    [self.records insertObject:record atIndex:0];

    if (self.delegate != nil)
        [self.delegate journalContentDidChange];
}

- (void)deleteRecord:(JournalRecord *)journalRecord
{
    [self.records removeObject:journalRecord];
    
    if (self.delegate != nil)
        [self.delegate journalContentDidChange];
}

@end
