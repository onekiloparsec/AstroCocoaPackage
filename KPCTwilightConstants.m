//
//  KPCTwilightConstants.c
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import "KPCTwilightConstants.h"

double const KPCTwilightAstronomicalSunAltitude	= -18.0;
double const KPCTwilightNauticalSunAltitude		= -12.0;
double const KPCTwilightCivilianSunAltitude		=  -6.0;
double const KPCTwilightSetRiseSunAltitude		=  -0.5833333333333;
// See also http://www.sunearthtools.com/dp/tools/pos_sun.php for the last value

NSUInteger const KPCTwilightModeCount = 4;

double const KPCTwilightModeAltitudes[4] = {
	KPCTwilightAstronomicalSunAltitude,
	KPCTwilightNauticalSunAltitude,
	KPCTwilightCivilianSunAltitude,
	KPCTwilightSetRiseSunAltitude
};
