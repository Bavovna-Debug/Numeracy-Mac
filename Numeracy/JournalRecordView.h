//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Brain.h"
#import "JournalRecord.h"

@interface JournalRecordPrototype : NSCollectionViewItem

@end

@interface JournalRecordView : NSView

- (id)initWithJournalRecord:(JournalRecord *)journalRecord;

@end
