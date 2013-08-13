//
//  KPCCoordinatesElements.m
//
//  Created by onekiloparsec on 13/3/10.
//  https://github.com/onekiloparsec/AstroCocoaPackage
//  Released under licence GPL v2
//

#import "KPCCoordinatesElements.h"

KPCCoordinatesElements KPCMakeCoordinatesElementsFromString(id input)
{
	KPCCoordinatesElements elements;

	NSArray *components = ([input isKindOfClass:[NSString class]]) ? [input componentsSeparatedByString:@" "] : input;

	if ([components count] == 2) {
		elements.theta = [[components objectAtIndex:0] doubleValue];
		elements.phi = [[components objectAtIndex:1] doubleValue];
		elements.units = KPCCoordinatesUnitsDegrees; // Assumption!
	}
	else if ([components count] == 6) {

		// Look for minus sign in dec components
        __block double sign = 1.0;
        [[components subarrayWithRange:NSMakeRange(3, 3)] enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
            if ([component containsSubstring:@"-"]) {
                sign = -1.0;
            }
        }];

		double raHour = [[components objectAtIndex:0] doubleValue];
		double raMinute = [[components objectAtIndex:1] doubleValue];
		double raSecond = [[components objectAtIndex:2] doubleValue];
		elements.theta = raHour + raMinute/60.0 + raSecond/3600.0;

		double decDegrees = [[components objectAtIndex:3] doubleValue];
		double decMinute = [[components objectAtIndex:4] doubleValue];
		double decSecond = [[components objectAtIndex:5] doubleValue];
		elements.phi = sign * (fabs(decDegrees) + fabs(decMinute/60.0) + fabs(decSecond/3600.0));

		elements.units = KPCCoordinatesUnitsHoursAndDegrees;
	}

	return elements;
}

KPCCoordinatesElements KPCMakeCoordinatesElementsFromData(NSData *input)
{
	KPCCoordinatesElements elements;

	NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:input];
	elements.theta = [[dic objectForKey:@"theta"] doubleValue];
	elements.phi = [[dic objectForKey:@"phi"] doubleValue];
	elements.units = [[dic objectForKey:@"units"] unsignedIntegerValue];

	return elements;
}

