//
//  KPCCoordinatesElements.h
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KPCCoordinatesUnits) {
	KPCCoordinatesUnitsDegrees,
	KPCCoordinatesUnitsRadians,
	KPCCoordinatesUnitsHoursAndDegrees, // For RA and Dec.
	KPCCoordinatesUnitsHours
};

typedef struct KPCCoordinatesElements {
    double theta;
    double phi;
    KPCCoordinatesUnits units;
} KPCCoordinatesElements;

KPCCoordinatesElements KPCMakeCoordinatesElementsFromString(id input);
KPCCoordinatesElements KPCMakeCoordinatesElementsFromData(NSData *input);

