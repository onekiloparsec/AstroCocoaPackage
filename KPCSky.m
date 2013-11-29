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

// See Equ. 13.6, p. 93 of AA.
double KPCSkyAltitudeForJulianDayRADecLongitudeLatitude(double jd, double RA, double dec, double longitude, double latitude)
{
	double hourAngle = localSiderealTimeForJulianDayLongitude(jd, longitude) - RA;

	double cosdec = cos(dec * DEG2RAD);
	double sindec = sin(dec * DEG2RAD);
	double cosha  = cos(hourAngle * HOUR2RAD);
	double coslat = cos(latitude * DEG2RAD);
	double sinlat = sin(latitude * DEG2RAD);
	
	double alt = asin(cosdec*cosha*coslat + sindec*sinlat) * RAD2DEG;
	return alt;
}

// See Equ. 13.5, p. 93 of AA.
// Azimuth is measured westward from the South (yes, South). It is a convention of astronomers not doing the same
// way of navigators and meteorologists. The reason is because we also measure hour angles from the South,
// at least in the Northern hemisphere... See AA p91, for more explanations.
double KPCSkyAzimuthForJulianDayRADecLongitudeLatitude(double jd, double RA, double dec, double longitude, double latitude)
{
	double hourAngle = localSiderealTimeForJulianDayLongitude(jd, longitude) - RA;

	double cosha  = cos(hourAngle * HOUR2RAD);
	double sinha  = sin(hourAngle * HOUR2RAD);
	double coslat = cos(latitude * DEG2RAD);
	double sinlat = sin(latitude * DEG2RAD);
	double tandec = tan(dec * DEG2RAD);

	double y = cosha*sinlat - tandec*coslat;
	double z = sinha;

	// atan2(z, y) == arctan(z/y) using the signs of both arguments to determine the quadrant of the return value.
	double az = atan2(z, y) * RAD2DEG;
	return az;
}


double airmassForAltitude(double altitude)
{
	return 1./cos(M_PI_2 - altitude*DEG2RAD);
}

double altitudeForAirmass(double airmass)
{
	return 90. - acos(1./airmass)*RAD2DEG;
}
