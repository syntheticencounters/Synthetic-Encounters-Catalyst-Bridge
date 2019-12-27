#import "CatalystBridge.h"

@implementation CatalystBridge

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

dispatch_queue_t mainQueue = NULL;
long *tag = NULL;
RCTResponseSenderBlock readCallback = NULL;
RCTResponseSenderBlock writeCallback = NULL;
RCTResponseSenderBlock connectCallback = NULL;

RCT_REMAP_METHOD(connect,
                 host:(NSString *)host
                 port:(nonnull NSNumber *)port
                 timeout:(nonnull NSNumber *)timeout
                 callback:(RCTResponseSenderBlock)callback)
{

    if(host == NULL || port == NULL) {
        callback(@[@"Missing required host and/or port", [NSNull null]]);
        return;
    }

    connectCallback = callback;
    mainQueue = dispatch_get_main_queue();
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];

    NSError *error = nil;
    if(![asyncSocket connectToHost:host onPort:port.shortValue viaInterface:NULL withTimeout:[timeout doubleValue] error:&error]) {
        callback(@[@"Connection was refused by the Comm Link", [NSNull null]]);
        return;
    }
}

RCT_REMAP_METHOD(read,
                 timeout:(nonnull NSNumber *)timeout
                 callback:(RCTResponseSenderBlock)callback)
{
        /*
    if(![asyncSocket isConnected]) {
        callback(@[@"The connection between your device and the Comm Link has been lost", [NSNull null]]);
        return;
    }
         */

    readCallback = callback;
    [asyncSocket readDataWithTimeout:[timeout doubleValue] tag:1];
}

RCT_REMAP_METHOD(write,
                 string:(NSString *)string
                 timeout:(nonnull NSNumber *)timeout
                 callback:(RCTResponseSenderBlock)callback)
{
        /*
    if(![asyncSocket isConnected]) {
        callback(@[@"The connection between your device and the Comm Link has been lost", [NSNull null]]);
        return;
    }
        */

    if(string == NULL) {
        callback(@[@"Missing required string for data", [NSNull null]]);
        return;
    }

    writeCallback = callback;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [asyncSocket writeData:data withTimeout:[timeout doubleValue] tag:2];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"sockettcp connect :%@", host);
    if(connectCallback != NULL) {
        connectCallback(@[[NSNull null], [NSString stringWithFormat:@"Connected to host %@", host]]);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if(writeCallback != NULL) {
        writeCallback(@[[NSNull null], [NSNull null]]);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", [NSString stringWithFormat:@"sockettcp response: %@", httpResponse]);
    if(readCallback != NULL) {
        readCallback(@[[NSNull null], httpResponse]);
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {

    if(readCallback != NULL) {
        readCallback(@[@"The connection to the Comm Link was unsuccessful. Please restart the Comm Link and try again", [NSNull null]]);
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {

    if(writeCallback != NULL) {
        writeCallback(@[@"The connection to the Comm Link was unsuccessful. Please restart the Comm Link and try again", [NSNull null]]);
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"sockettcp error");
    NSLog(@"%@", err.localizedDescription);
    if(connectCallback) {
        if(err.code == 3) {
            connectCallback(@[@"The connection to the Comm Link has been lost. Please restart the Comm Link and try again", [NSNull null]]);
        }
    }
}

@end
