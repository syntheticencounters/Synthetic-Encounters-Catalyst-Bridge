#import "CatalystBridge.h"

@implementation CatalystBridge

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(setWindowSize:
                  width:(nonnull NSNumber *)
                  height:(nonnull NSNumber *)
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {

    for (UIScene* scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene* windowScene = (UIWindowScene*) scene;
            windowScene.sizeRestrictions.minimumSize = CGSizeMake([width doubleValue], [height doubleValue]);
            windowScene.sizeRestrictions.maximumSize = CGSizeMake([width doubleValue], [height doubleValue]);

            resolve(@"Window size set");
            return;
        }
    }
    reject(@"Unable to set window size", @"Unable to set window size", [NSError errorWithDomain:@"ecarra" code:400 userInfo:NULL]);
}

@end
