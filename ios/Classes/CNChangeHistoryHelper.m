#import "CNChangeHistoryHelper.h"

@implementation CNChangeHistoryHelper

+ (nullable NSDictionary<NSString *, id> *)fetchChangesSince:(nullable NSData *)token
                                          additionalKeys:(NSArray<id<CNKeyDescriptor>> *)keys
                                                   error:(NSError **)error {
    CNContactStore *store = [[CNContactStore alloc] init];
    CNChangeHistoryFetchRequest *request = [[CNChangeHistoryFetchRequest alloc] init];

    if (token != nil) {
        request.startingToken = token;
    }
    request.additionalContactKeyDescriptors = keys;

    NSError *fetchError = nil;
    CNFetchResult<NSEnumerator<CNChangeHistoryEvent *> *> *fetchResult =
        [store enumeratorForChangeHistoryFetchRequest:request error:&fetchError];

    if (fetchError != nil) {
        if (error != NULL) {
            *error = fetchError;
        }
        return nil;
    }

    NSMutableArray<NSDictionary *> *updated = [NSMutableArray array];
    NSMutableArray<NSString *> *deleted = [NSMutableArray array];

    for (CNChangeHistoryEvent *event in fetchResult.value) {
        if ([event isKindOfClass:[CNChangeHistoryAddContactEvent class]]) {
            CNChangeHistoryAddContactEvent *addEvent = (CNChangeHistoryAddContactEvent *)event;
            [updated addObject:@{@"contact": addEvent.contact}];
        } else if ([event isKindOfClass:[CNChangeHistoryUpdateContactEvent class]]) {
            CNChangeHistoryUpdateContactEvent *updateEvent = (CNChangeHistoryUpdateContactEvent *)event;
            [updated addObject:@{@"contact": updateEvent.contact}];
        } else if ([event isKindOfClass:[CNChangeHistoryDeleteContactEvent class]]) {
            CNChangeHistoryDeleteContactEvent *deleteEvent = (CNChangeHistoryDeleteContactEvent *)event;
            [deleted addObject:deleteEvent.contactIdentifier];
        }
    }

    NSData *newToken = fetchResult.currentHistoryToken;

    return @{
        @"updated": updated,
        @"deleted": deleted,
        @"token": newToken ?: [NSNull null],
    };
}

+ (nullable NSData *)currentHistoryToken {
    CNContactStore *store = [[CNContactStore alloc] init];
    return store.currentHistoryToken;
}

@end
