//
//  KPCSky.m
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import "KPCSky.h"
#import "KPCTimes.h"
#import "KPCScientificConstants.h"

double altitudeForJulianDayRADecLongitudeLatitude(double jd, double RA, double dec, double longitude, double latitude)
{
	double hourAngle = localSiderealTimeForJulianDayLongitude(jd, longitude) - RA;

	double cosdec = cos(dec * ONE_DEG_IN_RADIANS);
	double sindec = sin(dec * ONE_DEG_IN_RADIANS);
	double cosha  = cos(hourAngle / ONE_RAD_IN_HOURS);
	double coslat = cos(latitude * ONE_DEG_IN_RADIANS);
	double sinlat = sin(latitude * ONE_DEG_IN_RADIANS);
	
	return asin(cosdec*cosha*coslat + sindec*sinlat) * ONE_RAD_IN_DEGREES;
}

double azimuthForJulianDayRADecLongitudeLatitude(double jd, double RA, double dec, double longitude, double latitude)
{
	double hourAngle = localSiderealTimeForJulianDayLongitude(jd, longitude) - RA;

	double cosdec = cos(dec * ONE_DEG_IN_RADIANS);
	double sindec = sin(dec * ONE_DEG_IN_RADIANS);
	double cosha  = cos(hourAngle / ONE_RAD_IN_HOURS);
	double sinha  = sin(hourAngle / ONE_RAD_IN_HOURS);
	double coslat = cos(latitude * ONE_DEG_IN_RADIANS);
	double sinlat = sin(latitude * ONE_DEG_IN_RADIANS);

	double y = sindec*coslat - cosdec*cosha*sinlat; // due North computation.
	double z = -1.0 *cosdec*sinha;					// due East computation.
	
	return atan2(z, y) * ONE_RAD_IN_DEGREES;
}

