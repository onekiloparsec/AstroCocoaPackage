//
//  KPCCoordinatesComponents.m
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import "KPCCoordinatesComponents.h"

KPCCoordinatesComponents KPCMakeCoordinatesComponents(id input)
{
	// We rely on the fact that the Foundation 'doubleValue' method (and related methods)
	// works both on NSNumbers and NSStrings.

	KPCCoordinatesComponents elements;
	elements.theta = NOT_A_SCIENTIFIC_NUMBER;
	elements.phi = NOT_A_SCIENTIFIC_NUMBER;
	elements.units = KPCCoordinatesUnitsUndefined;

	// Expecting an archived dictionary.
	if ([input isKindOfClass:[NSData class]]) {
		id unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithData:input];

		if (unarchivedData && [unarchivedData isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dic = (NSDictionary *)unarchivedData;

			if (dic[@"theta"] && dic[@"phi"] && dic[@"units"]) {
				elements.theta = [dic[@"theta"] doubleValue];
				elements.phi = [dic[@"phi"] doubleValue];
				elements.units = [dic[@"units"] unsignedIntegerValue];
			}
		}
	}
	else if ([input isKindOfClass:[NSString class]] || [input isKindOfClass:[NSArray class]]) {
		NSArray *components = ([input isKindOfClass:[NSString class]]) ? [input componentsSeparatedByString:@" "] : input;

		if ([components count] == 2 || [components count] == 3) {
			elements.theta = [components[0] doubleValue];
			elements.phi = [components[1] doubleValue];
			elements.units = ([components count] == 2) ? KPCCoordinatesUnitsDegrees : [components[2] unsignedIntegerValue];
		}
		else if ([components count] == 6 || [components count] == 7) {
			double raHour   = [components[0] doubleValue];
			double raMinute = [components[1] doubleValue];
			double raSecond = [components[2] doubleValue];
			elements.theta = raHour + raMinute/60.0 + raSecond/3600.0;

			double decDegrees = [components[3] doubleValue];
			double decMinute  = [components[4] doubleValue];
			double decSecond  = [components[5] doubleValue];
			double sign = (decDegrees < 0.0 || decMinute < 0.0 || decSecond < 0.0) ? -1.0 : 1.0;
			elements.phi = sign * (fabs(decDegrees) + fabs(decMinute/60.0) + fabs(decSecond/3600.0));

			elements.units = ([components count] == 6) ? KPCCoordinatesUnitsHoursAndDegrees : [components[6] unsignedIntegerValue];
		}
	}

	return elements;
}

KPCSexagesimalComponents KPCMakeSexagesimalComponents(int d, int m, double s)
{
	KPCSexagesimalComponents components;
	components.sign = (d < 0 || m < 0 || s < 0.0) ? -1 : 1;
	components.degrees = fabs(d);
	components.minutes = fabs(m);
	components.seconds = fabs(s);
	return components;
}

double KPCSexagesimalComponentsValue(KPCSexagesimalComponents components)
{
	return components.sign * (fabs(components.degrees) + fabs(components.minutes/60.0) + fabs(components.seconds/3600.0));
}

KPCSexagesimalComponents KPCMakeSexagesimalComponentsFromValue(double value)
{
	double sign = (value < 0.0) ? -1.0 : 1.0;

	double d = floor(fabs(value));
	double m = floor((fabs(value) - d)*60.);
	double s = ((fabs(value) - d)*60. - m)*60.;

    if (s == 60.0) {
        s = 0.0;
        m += 1.0;
    }

    if (m == 60.0) {
        m = 0.0;
        d += 1.0;
    }

	if (d != 0.0) {
		d *= sign;
	}
	else if (m != 0.0) {
		m *= sign;
	}
	else if (s != 0.0) {
		s *= sign;
	}

	return KPCMakeSexagesimalComponents((int)d, (int)m, s);
}

KPCSexagesimalComponents KPCMakeSexagesimalComponentsFromArray(NSArray *values)
{
	NSCAssert([values count] >= 2, @"Missing values");

	int d = [values[0] intValue];
	int m = [values[1] intValue];
	double s = 0.0;

	if ([values count] > 2) {
		s = [values[2] doubleValue];
	}

	return KPCMakeSexagesimalComponents(d, m, s);
}

NSArray *KPCSexagesimalCoordinatesSymbols(KPCCoordinatesUnits units)
{
	NSArray *symbols = nil;
	switch (units) {
		case KPCCoordinatesUnitsDegrees:
			symbols = @[@"º", @"'", @"\""];
			break;
		case KPCCoordinatesUnitsHours:
			symbols = @[@"h", @"m", @"s"];
			break;
		default:
			symbols = @[@"", @"", @""];
			break;
	}
	return symbols;
}

NSString *KPCDecimalCoordinatesSymbol(KPCCoordinatesUnits units)
{
	NSString *symbol = nil;
	switch (units) {
		case KPCCoordinatesUnitsDegrees:
			symbol = @"º";
			break;
		case KPCCoordinatesUnitsHours:
			symbol = @"h";
			break;
		case KPCCoordinatesUnitsRadians:
			symbol = @" rad"; // yes with a white space first
			break;
		default:
			symbol = @"";
			break;
	}
	return symbol;
}

void KPCTransformCoordinatesComponentsUnitsToHoursAndDegrees(KPCCoordinatesComponents *inComponents, KPCCoordinatesComponents *outComponents)
{
	double hours = NOT_A_SCIENTIFIC_NUMBER;
	double degrees = NOT_A_SCIENTIFIC_NUMBER;

	switch ((*inComponents).units) {
		case KPCCoordinatesUnitsHoursAndDegrees:
			hours   = (*inComponents).theta;
			degrees = (*inComponents).phi;
			break;
		case KPCCoordinatesUnitsDegrees:
			hours   = (*inComponents).theta * DEG2HOUR;
			degrees = (*inComponents).phi;
			break;
		case KPCCoordinatesUnitsRadians:
			hours   = (*inComponents).theta * RAD2HOUR;
			degrees = (*inComponents).phi * RAD2DEG;
			break;
		case KPCCoordinatesUnitsHours:
			hours   = (*inComponents).theta;
			degrees = (*inComponents).phi / DEG2HOUR;
			break;
		default:
			break;
	}

	(*outComponents).theta = hours;
	(*outComponents).phi = degrees;
	(*outComponents).units = KPCCoordinatesUnitsHoursAndDegrees;
}

void KPCTransformCoordinatesComponentsUnitsToDegrees(KPCCoordinatesComponents *inComponents, KPCCoordinatesComponents *outComponents)
{
	double degrees1 = NOT_A_SCIENTIFIC_NUMBER;
	double degrees2 = NOT_A_SCIENTIFIC_NUMBER;

	switch ((*inComponents).units) {
		case KPCCoordinatesUnitsHoursAndDegrees:
			degrees1 = (*inComponents).theta / DEG2HOUR;
			degrees2 = (*inComponents).phi;
			break;
		case KPCCoordinatesUnitsDegrees:
			degrees1 = (*inComponents).theta;
			degrees2 = (*inComponents).phi;
			break;
		case KPCCoordinatesUnitsRadians:
			degrees1 = (*inComponents).theta * RAD2DEG;
			degrees2 = (*inComponents).phi * RAD2DEG;
			break;
		case KPCCoordinatesUnitsHours:
			degrees1 = (*inComponents).theta / DEG2HOUR;
			degrees2 = (*inComponents).phi / DEG2HOUR;
			break;
		default:
			break;
	}

	(*outComponents).theta = degrees1;
	(*outComponents).phi = degrees2;
	(*outComponents).units = KPCCoordinatesUnitsDegrees;
}

void KPCTransformCoordinatesComponentsUnitsToRadians(KPCCoordinatesComponents *inComponents, KPCCoordinatesComponents *outComponents)
{
	double rad1 = NOT_A_SCIENTIFIC_NUMBER;
	double rad2 = NOT_A_SCIENTIFIC_NUMBER;

	switch ((*inComponents).units) {
		case KPCCoordinatesUnitsHoursAndDegrees:
			rad1 = (*inComponents).theta * HOUR2RAD;
			rad2 = (*inComponents).phi * DEG2RAD;
			break;
		case KPCCoordinatesUnitsDegrees:
			rad1 = (*inComponents).theta * DEG2RAD;
			rad2 = (*inComponents).phi * DEG2RAD;
			break;
		case KPCCoordinatesUnitsRadians:
			rad1 = (*inComponents).theta;
			rad2 = (*inComponents).phi;
			break;
		case KPCCoordinatesUnitsHours:
			rad1 = (*inComponents).theta * HOUR2RAD;
			rad2 = (*inComponents).phi * HOUR2RAD;
			break;
		default:
			break;
	}

	(*outComponents).theta = rad1;
	(*outComponents).phi = rad2;
	(*outComponents).units = KPCCoordinatesUnitsRadians;
}

void KPCTransformCoordinatesComponentsUnitsToHours(KPCCoordinatesComponents *inComponents, KPCCoordinatesComponents *outComponents)
{
	double hour1 = NOT_A_SCIENTIFIC_NUMBER;
	double hour2 = NOT_A_SCIENTIFIC_NUMBER;

	switch ((*inComponents).units) {
		case KPCCoordinatesUnitsHoursAndDegrees:
			hour1 = (*inComponents).theta;
			hour2 = (*inComponents).phi * DEG2HOUR;
			break;
		case KPCCoordinatesUnitsDegrees:
			hour1 = (*inComponents).theta * DEG2HOUR;
			hour2 = (*inComponents).phi * DEG2HOUR;
			break;
		case KPCCoordinatesUnitsRadians:
			hour1 = (*inComponents).theta * RAD2HOUR;
			hour2 = (*inComponents).phi * RAD2HOUR;
			break;
		case KPCCoordinatesUnitsHours:
			hour1 = (*inComponents).theta;
			hour2 = (*inComponents).phi;
			break;
		default:
			break;
	}

	(*outComponents).theta = hour1;
	(*outComponents).phi = hour2;
	(*outComponents).units = KPCCoordinatesUnitsHours;
}

void KPCTransformCoordinatesComponentsUnits(KPCCoordinatesComponents *inComponents,
											KPCCoordinatesComponents *outComponents,
											KPCCoordinatesUnits outputUnits)
{
	(*outComponents).theta = NOT_A_SCIENTIFIC_NUMBER;
	(*outComponents).phi = NOT_A_SCIENTIFIC_NUMBER;
	(*outComponents).units = KPCCoordinatesUnitsUndefined;

	if ((*inComponents).units == KPCCoordinatesUnitsUndefined || outputUnits == KPCCoordinatesUnitsUndefined) {
		return;
	}

	switch (outputUnits) {
		case KPCCoordinatesUnitsDegrees:
			KPCTransformCoordinatesComponentsUnitsToDegrees(inComponents, outComponents);
			break;
		case KPCCoordinatesUnitsHours:
			KPCTransformCoordinatesComponentsUnitsToHours(inComponents, outComponents);
			break;
		case KPCCoordinatesUnitsRadians:
			KPCTransformCoordinatesComponentsUnitsToRadians(inComponents, outComponents);
			break;
		case KPCCoordinatesUnitsHoursAndDegrees:
			KPCTransformCoordinatesComponentsUnitsToHoursAndDegrees(inComponents, outComponents);
			break;
		default:
			break;
	}
}
