//
//  Numeracy
//
//  Copyright (c) 2015 Meine Werke. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "Brain.h"
#import "Journal.h"

@implementation ApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [Brain sharedBrain];
    [Journal sharedJournal];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
}

@end
