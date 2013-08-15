//
//  KPCTwilightConstants.h
//  iObserve
//
//  Created by onekiloparsec on 14/8/13.
//  Copyright (c) 2013 onekiloparsec. All rights reserved.
//

typedef NS_ENUM(NSUInteger, KPCTwilightMode) {
	KPCTwilightModeAstronomical,
	KPCTwilightModeNautical,
	KPCTwilightModeCivilian,
	KPCTwilightModeSunsetSunrise,
};

extern NSUInteger const KPCTwilightModeCount;

extern double const KPCTwilightAstronomicalSunAltitude;
extern double const KPCTwilightNauticalSunAltitude;
extern double const KPCTwilightCivilianSunAltitude;
extern double const KPCTwilightSetRiseSunAltitude;

extern double const KPCTwilightModeAltitudes[4];
