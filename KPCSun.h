//
//  KPCSun.h
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import <Foundation/Foundation.h>
#import "KPCCoordinatesElements.h"

double sunMeanAnomalyForJulianDay(double jd);
double sunMeanLongitudeForJulianDay(double jd);

void sunCoordinatesElementsForJulianDay(double jd, KPCCoordinatesElements *elements);

double sunAzimuthForJulianDayLongitudeLatitude(double jd, double longitude, double latitude);
double sunAltitudeForJulianDayLongitudeLatitude(double jd, double longitude, double latitude);

// Return the julian day of the equinox occuring during the month of march.
double marchEquinoxJulianDayForYear(double y);
