#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))
@interface CNChangeHistoryHelper : NSObject

+ (nullable NSDictionary<NSString *, id> *)fetchChangesSince:(nullable NSData *)token
                                          additionalKeys:(NSArray<id<CNKeyDescriptor>> *)keys
                                                   error:(NSError **)error;

+ (nullable NSData *)currentHistoryToken;

@end

NS_ASSUME_NONNULL_END
