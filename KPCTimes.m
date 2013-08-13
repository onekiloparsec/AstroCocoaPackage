//
//  KPCTimes.h
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import "KPCTimes.h"
#import "KPCScientificConstants.h"

CFGregorianDate gregorianDateForDateTimeZone(NSDate *date, CFTimeZoneRef tz)
{
	NSTimeInterval absoluteTimeOfDate = [date timeIntervalSinceReferenceDate]; // == AbsoluteTime since reference date
	return CFAbsoluteTimeGetGregorianDate((CFTimeInterval)absoluteTimeOfDate, tz); // tz = NULL = GMT
}

CFGregorianDate gregorianUTCDateForDate(NSDate *date)
{
	return gregorianDateForDateTimeZone(date, NULL);
}

CFGregorianDate gregorianUTCDateForDateWithHourValue(NSDate *date, double hour)
{
	hour = fmod(hour+ONE_DAY_IN_HOURS, ONE_DAY_IN_HOURS); // hour always positive. Make sure we don't change day.
	CFGregorianDate gregorianDate = gregorianUTCDateForDate(date);
	gregorianDate.hour = 0;
	gregorianDate.minute = 0;
	gregorianDate.second = 0.0;
	CFAbsoluteTime absTime = CFGregorianDateGetAbsoluteTime(gregorianDate, NULL) + hour*ONE_HOUR_IN_SECONDS;
	return CFAbsoluteTimeGetGregorianDate(absTime, NULL);
}

#pragma mark - Julian Days

double julianDayForDate(NSDate *date)
{
	return julianDayForGregorianDate(gregorianUTCDateForDate(date));
}

// Compute the Julian Day from a given date of the Gregorian (usual) calendar.
// see http://scienceworld.wolfram.com/astronomy/JulianDate.html
double julianDayForGregorianDate(CFGregorianDate date)
{
	double year  = (double)date.year;
	double month = (double)date.month; 
	double day   = (double)date.day;	
	double ut    = (double)date.hour + (double)date.minute/ONE_MINUTE_IN_SECONDS + date.second/ONE_HOUR_IN_SECONDS;
	
	double jd = 367.0*year - floor( 7.0*( year+floor((month+9.0)/12.0))/4.0 ) - 
	floor( 3.0*(floor((year+(month-9.0)/7.0)/100.0) +1.0)/4.0) + 
	floor(275.0*month/9.0) + day + 1721028.5 + ut/24.0;
	
	return jd;	
}

double modifiedJulianDayForDate(NSDate *date)
{
	return modifiedJulianDayForJulianDay(julianDayForDate(date));
}

double modifiedJulianDayForJulianDay(double jd)
{
	return jd - MODIFIED_JULIAN_DAY_ZERO;
}

double julianCenturyForJulianDay(double jd)
{
	return (jd - J2000)/(AVERAGE_JULIAN_YEAR * 100.0);
}

double julianCenturyForDate(NSDate *date)
{
	return julianCenturyForJulianDay(julianDayForDate(date));
}

double UTCHoursFromJulianDay(double jd)
{
	CFGregorianDate gregorianDate = gregorianDateForJulianDay(jd);
	return (double)gregorianDate.hour + (double)gregorianDate.minute/ONE_MINUTE_IN_SECONDS + gregorianDate.second/ONE_HOUR_IN_SECONDS;
}

NSDate *dateFromJulianDay(double jd)
{
	CFGregorianDate refGregorianDate = CFAbsoluteTimeGetGregorianDate(0, NULL); // Reference Gregorian Date. Jan 1 2001 00:00:00 GMT
	double refJulianDay = julianDayForGregorianDate(refGregorianDate);
	double timeInterval = jd - refJulianDay;
	return [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval*ONE_DAY_IN_SECONDS];
}

NSDate *dateFromModifiedJulianDay(double mjd)
{
	return dateFromJulianDay(mjd + MODIFIED_JULIAN_DAY_ZERO);
}

// Compute the date in the Gregorian (usual) calendar from the Julian Day;
// Found in source code of: http://astronomy.villanova.edu/links/jd.htm
CFGregorianDate gregorianDateForJulianDay(double jd)
{
	double X = jd+0.5;
	double Z = floor(X);
	double F = X - Z;
	double Y = floor((Z-1867216.25)/36524.25);
	double A = Z+1+Y-floor(Y/4);
	double B = A+1524;
	double C = floor((B-122.1)/365.25);
	double D = floor(365.25*C);
	double G = floor((B-D)/30.6001);
	double month = (G<13.5) ? (G-1) : (G-13);
	double year = (month<2.5) ? (C-4715) : (C-4716);
	double UT = B-D-floor(30.6001*G)+F;
	double day = floor(UT);
	UT -= floor(UT);
	UT *= 24.0;
	double hour = floor(UT);
	UT -= floor(UT);
	UT *= 60.0;
	double minute = floor(UT);
	UT -= floor(UT);
	UT *= 60.0;
	double second = round(UT);
    
	CFGregorianDate gregDate;
	gregDate.year = (int32_t)year;
	gregDate.month = (int8_t)month;
	gregDate.day = (int8_t)day;
	gregDate.hour = (int8_t)hour;
	gregDate.minute = (int8_t)minute;
	gregDate.second = second;
	
	return gregDate;
}


#pragma mark - Local Sidereal Times

// Ref: Jean Meeus' Astronomical Algorithms, p.87
double localSiderealTimeForJulianDayLongitude(double jd, double longitude)
{
	double t = julianCenturyForJulianDay(jd);

	// Greenwhich SiderealTime in degrees!
	double gmst = 280.46061837 + 360.98564736629*(jd-J2000) + 0.000387933*t*t - t*t*t/38710000.0;

	while (gmst < 0.) {
		gmst = gmst + 360.0;
	}
	gmst = fmod(gmst, 360.0);

	// Greenwhich SiderealTime in hours.
	gmst = gmst * ONE_DEG_IN_HOURS;

	// See AA. p92. LMST = theta_0 - L, for L the longitude, if L is positive West.
	// Hence, LMST = theta_0 + L if longitude is positive East, as we have here.
	double lmst = gmst + longitude*ONE_DEG_IN_HOURS;

	// Making sure LMST is positive;
	lmst = fmod(lmst + ONE_DAY_IN_HOURS, ONE_DAY_IN_HOURS);
	
	return lmst;
}

double localSiderealTimeForDateLongitude(NSDate *date, double longitude)
{
	return localSiderealTimeForJulianDayLongitude(julianDayForDate(date), longitude);
}

double localSiderealTimeForGregorianDateLongitude(CFGregorianDate date, double longitude)
{
	return localSiderealTimeForJulianDayLongitude(julianDayForGregorianDate(date), longitude);
}








