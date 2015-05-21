//
//  CompletedQuestsManager.m
//  Quest
//
//  Created by Rares Neagu on 21/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "CompletedQuestsManager.h"


static NSString * const kCompletedQuestsSettings = @"completedQuests";

@interface CompletedQuestsManager ()

@property (strong, nonatomic) NSMutableDictionary *completedQuests;

@end

@implementation CompletedQuestsManager

+ (instancetype)sharedManager {
    static CompletedQuestsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CompletedQuestsManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [defaults objectForKey:kCompletedQuestsSettings];
        _completedQuests = [NSMutableDictionary dictionaryWithDictionary: dict];
    }
    return self;
}

- (BOOL)objectForKeyedSubscript:(NSString *)key {
    return [self.completedQuests[key] boolValue];
}
- (void)setYesForKey:(NSString *)string {
    [self setBoolValue:YES forKey:string];
}
- (void)setNoForKey:(NSString *)string {
    [self setBoolValue:NO forKey:string];
}

- (void)setBoolValue:(BOOL)value forKey:(NSString *)string {
    if (string == nil) {
        NSLog(@"string is nil!");
        return;
    }
    self.completedQuests[string] = @(value);
    
    // dispatch async so that the UI is smoooth as a criminal #MichaelJackson
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.completedQuests forKey:kCompletedQuestsSettings];
    });
}

@end
