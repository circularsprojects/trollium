//
//  DeviceScaleManager.m
//  
//
//  Created by lemin on 10/11/23.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import "DeviceScaleManager.h"

// Small Notch/Dynamic Island Definitions
#define SMALL_SIDE_WIDGET_SIZE 0.27435897   // Original Size (iPhone 13 Pro): 107
#define SMALL_CENTER_WIDGET_SIZE 0.34615385 // Original Size (iPhone 13 Pro): 135

// Large Notch Definitions
#define LARGE_SIDE_WIDGET_SIZE 0.19466667   // Original Size (iPhone X): 73
#define LARGE_CENTER_WIDGET_SIZE 0.50666667 // Original Size (iPhone X): 190

NSString* getDeviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

/*
 Sizes:
 0 = No Notch
 1 = Small Notch
 2 = Large Notch
 3 = Dynamic Island
 */
extern "C" NSInteger getDeviceSize(void);
NSInteger getDeviceSize()
{
    NSString *model = getDeviceName();
    
    // get the notch size
    if ([model rangeOfString: @"iPhone14"].location != NSNotFound) {
        // Small Notch
        return 1;
    } else if (
        [model rangeOfString: @"iPhone10,3"].location != NSNotFound     // account for iPhone 8
        || [model rangeOfString: @"iPhone10,6"].location != NSNotFound  // which is also iPhone10,_
        || [model rangeOfString: @"iPhone11"].location != NSNotFound
        || [model rangeOfString: @"iPhone12"].location != NSNotFound
        || [model rangeOfString: @"iPhone13"].location != NSNotFound
    ) {
        return 2;
    } else if (
        [model rangeOfString: @"iPhone15"].location != NSNotFound
        || [model rangeOfString: @"iPhone16"].location != NSNotFound
    ) {
        return 3;
    }
    return 0;
}

extern "C" double getSideWidgetSize(void);
double getSideWidgetSize()
{
    
    NSInteger deviceSize = getDeviceSize();
    
    if (deviceSize == 1 || deviceSize == 3) {
        // Small Notch/Dynamic Island
        return SMALL_SIDE_WIDGET_SIZE;
    } else if (deviceSize == 2) {
        // Large Notch
        return LARGE_SIDE_WIDGET_SIZE;
    }
    
    return LARGE_SIDE_WIDGET_SIZE;
}

extern "C" double getCenterWidgetSize(void);
double getCenterWidgetSize()
{
    
    NSInteger deviceSize = getDeviceSize();
    
    if (deviceSize == 1 || deviceSize == 3) {
        // Small Notch/Dynamic Island
        return SMALL_CENTER_WIDGET_SIZE;
    } else if (deviceSize == 2) {
        // Large Notch
        return LARGE_CENTER_WIDGET_SIZE;
    }
    
    return LARGE_CENTER_WIDGET_SIZE;
}

double getCenterWidgetVerticalOffset()
{
    NSInteger deviceSize = getDeviceSize();

    if (deviceSize == 3) {
        // Dynamic Island
        return 20;
    }

    return 0;
}

// get the max number of (sideNum, centerNum) widgets
extern "C" NSDictionary<NSString*, NSNumber*>* getMaxNumWidgets(void);
NSDictionary<NSString*, NSNumber*>* getMaxNumWidgets()
{
    NSInteger deviceSize = getDeviceSize();

    if (deviceSize == 1 || deviceSize == 3) {
        // Small Notch/Dynamic Island
        return @{
            @"sideNum": @(2),
            @"centerNum": @(3)
        };
    } else if (deviceSize == 2) {
        // Large Notch
        return @{
            @"sideNum": @(1),
            @"centerNum": @(4)
        };
    }
    
    // Unknown
    return @{
        @"sideNum": @(1),
        @"centerNum": @(1)
    };
}
