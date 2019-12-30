#import "CatalystBridge.h"

@implementation CatalystBridge

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(setWindowSize:
                  (nonnull NSNumber *)width
                  height:(nonnull NSNumber *)height
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

RCT_EXPORT_METHOD(setMinWindowSize:
                  (nonnull NSNumber *)width
                  height:(nonnull NSNumber *)height
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {

    for (UIScene* scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene* windowScene = (UIWindowScene*) scene;
            windowScene.sizeRestrictions.minimumSize = CGSizeMake([width doubleValue], [height doubleValue]);
            windowScene.sizeRestrictions.maximumSize = CGSizeMake(10000, 10000);

            resolve(@"Window size set");
            return;
        }
    }
    reject(@"Unable to set window size", @"Unable to set window size", [NSError errorWithDomain:@"ecarra" code:400 userInfo:NULL]);
}

RCT_REMAP_METHOD(matchDisplaySize,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{

    for (UIScene* scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene* windowScene = (UIWindowScene*) scene;
            windowScene.sizeRestrictions.minimumSize = UIScreen.mainScreen.currentMode.size;
            windowScene.sizeRestrictions.maximumSize = CGSizeMake(10000, 10000);

            resolve(@"Window size set");
            return;
        }
    }
    reject(@"Unable to set window size", @"Unable to set window size", [NSError errorWithDomain:@"ecarra" code:400 userInfo:NULL]);
}

@end
