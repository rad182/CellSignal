//
//  SignalStrength.m
//  CellSignal
//
//  Created by Royce Albert Dy on 15/11/2015.
//  Copyright © 2015 rad182. All rights reserved.
//  Source: http://stackoverflow.com/a/31583945/748184

#import "SignalStrength.h"

@implementation SignalStrength

+ (int)currentSignalStrength {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    int signalStrength = [[dataNetworkItemView valueForKey:@"signalStrengthRaw"] intValue];
    return signalStrength;
}

@end
