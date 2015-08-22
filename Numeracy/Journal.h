//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brain.h"
#import "JournalRecord.h"

@protocol JournalDelegate;

@interface Journal : NSObject

@property (weak, nonatomic) id<JournalDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *records;

+ (Journal *)sharedJournal;

- (void)pokeNumber:(UInt64)number
     numeralSystem:(NumeralSystem)numeralSystem;

- (void)deleteRecord:(JournalRecord *)journalRecord;

@end

@protocol JournalDelegate <NSObject>

@required

- (void)journalContentDidChange;

@end