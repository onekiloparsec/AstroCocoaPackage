//
//  KPCSky.h
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import <Foundation/Foundation.h>

double KPCSkyAltitudeForJulianDayRADecLongitudeLatitude(double jd, double RA, double dec, double longitude, double latitude);
double KPCSkyAzimuthForJulianDayRADecLongitudeLatitude(double jd, double RA, double dec, double longitude, double latitude);

// Returns the airmass value corresponding to the altitude (in degrees).
double airmassForAltitude(double altitude);

// Returns the altitude value (in degrees) corresponding to the airmass.
double altitudeForAirmass(double airmass);
