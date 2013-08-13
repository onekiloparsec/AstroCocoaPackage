//
//  KPCTimes.h
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import <Foundation/Foundation.h>

CFGregorianDate gregorianDateForDateTimeZone(NSDate *date, CFTimeZoneRef tz);
CFGregorianDate gregorianUTCDateForDate(NSDate *date);
CFGregorianDate gregorianUTCDateForDateWithHourValue(NSDate *date, double hour);

// Julian Days

double julianDayForDate(NSDate *date);
double julianDayForGregorianDate(CFGregorianDate date);
double modifiedJulianDayForDate(NSDate *date);
double modifiedJulianDayForJulianDay(double jd);

double julianCenturyForJulianDay(double jd);
double julianCenturyForDate(NSDate *aDate);

double UTCHoursFromJulianDay(double jd);
NSDate *dateFromJulianDay(double jd);
NSDate *dateFromModifiedJulianDay(double mjd);
CFGregorianDate gregorianDateForJulianDay(double jd);

// Local Sidereal Times

double localSiderealTimeForJulianDayLongitude(double jd, double longitude); // Convention: positive East
double localSiderealTimeForDateLongitude(NSDate *date, double longitude);
double localSiderealTimeForGregorianDateLongitude(CFGregorianDate date, double longitude);

