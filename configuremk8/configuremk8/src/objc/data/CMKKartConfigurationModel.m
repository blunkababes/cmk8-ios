//
//  CMKKartConfiguration.m
//  configuremk8
//
//  Created by Anthony Robledo on 8/17/14.
//  Copyright (c) 2014 Blunka. All rights reserved.
//

#import "CMKConstants.h"
#import "CMKKartConfigurationModel.h"
#import "CMKPartGroupModel.h"
#import "CMKStatsModel.h"
#import "CMKPartData.h"
#import "CMKStarredKartConfigurationUtils.h"

#define _TAG (NSStringFromClass([CMKKartConfigurationModel class]))

@interface CMKKartConfigurationModel ()

- (float)attributeSum:(NSString *)key;

@end

@implementation CMKKartConfigurationModel

- (instancetype)initWithCharacterGroup:(CMKPartGroupModel *)characterGroup
                      withVehicleGroup:(CMKPartGroupModel *)vehicleGroup
                         withTireGroup:(CMKPartGroupModel *)tireGroup
                       withGliderGroup:(CMKPartGroupModel *)gliderGroup {
  self.characterGroup = characterGroup;
  self.vehicleGroup = vehicleGroup;
  self.tireGroup = tireGroup;
  self.gliderGroup = gliderGroup;

  return self;
}

- (instancetype)initWithUserDefaultsKey:(NSString *)key {
  if (key) {
    NSArray *keyComponents = [key componentsSeparatedByString:KEY_SEPERATOR];
      
      CMKPartData *sharedPartDataStore = [CMKPartData sharedPartModelDataStore];
      NSDictionary *partTypeNamesDictionary = sharedPartDataStore.partTypeNames;
      
      
      self.characterGroup = sharedPartDataStore .characterGroups[0];
      self.vehicleGroup = sharedPartDataStore.vehicleGroups[0];
      self.tireGroup = sharedPartDataStore.tireGroups[0];
      self.gliderGroup = sharedPartDataStore.tireGroups[0];
      
//      CMKPartGroupModel *cGroup = [CMKPartData partGroupForType:[keyComponents[0] lowercaseString]];
//      CMKPartGroupModel *vGroup = [CMKPartData partGroupForType:[keyComponents]]
      
      NSString *characterGroupString = [keyComponents[0] lowercaseString];
      NSString *vehicleGroupString = [[VEHICLE_STRING lowercaseString] stringByAppendingString:keyComponents[1]];
      NSString *tireGroupString = [[TIRE_STRING lowercaseString] stringByAppendingString:keyComponents[2]];
      NSString *gliderGroupString = [[GLIDER_STRING lowercaseString] stringByAppendingString:keyComponents[3]];


//    self.characterGroup = [CMKPartData valueForKey:[keyComponents[0] lowercaseString]];
//    self.vehicleGroup =
//        [CMKPartData valueForKey:[[VEHICLE_STRING lowercaseString] stringByAppendingString:keyComponents[1]]];
//    self.tireGroup = [CMKPartData valueForKey:[[TIRE_STRING lowercaseString] stringByAppendingString:keyComponents[2]]];
//    self.gliderGroup =
//        [CMKPartData valueForKey:[[GLIDER_STRING lowercaseString] stringByAppendingString:keyComponents[3]]];
    return self;
  } else {
    return nil;
  }
}

- (CMKStatsModel *)kartStats {
  CMKStatsModel *kartStats = [CMKStatsModel alloc];

  for (NSString *key in [CMKStatsModel attributeKeys]) {
    [kartStats setValue:[NSNumber numberWithFloat:[self attributeSum:key]] forKey:key];
  }

  return kartStats;
}

- (NSArray *)partGroups {
  return @[ self.characterGroup, self.vehicleGroup, self.tireGroup, self.gliderGroup ];
}

- (float)attributeSum:(NSString *)key {
  return [[self.characterGroup.stats valueForKey:key] floatValue] +
         [[self.vehicleGroup.stats valueForKey:key] floatValue] + [[self.tireGroup.stats valueForKey:key] floatValue] +
         [[self.gliderGroup.stats valueForKey:key] floatValue];
}

- (NSComparisonResult)compare:(CMKKartConfigurationModel *)otherObject {
  NSComparisonResult characterResult = [self.characterGroup compare:otherObject.characterGroup];

  if (characterResult == NSOrderedSame) {
    NSComparisonResult vehicleResult = [self.vehicleGroup compare:otherObject.vehicleGroup];

    if (vehicleResult == NSOrderedSame) {
      NSComparisonResult tireResult = [self.tireGroup compare:otherObject.tireGroup];

      if (tireResult == NSOrderedSame) {
        return [self.gliderGroup compare:otherObject.gliderGroup];
      }

      return tireResult;
    }

    return vehicleResult;
  }

  return characterResult;
}

- (NSString *)keyForUserDefaults {
  return [@[ self.characterGroup.name, self.vehicleGroup.name, self.tireGroup.name, self.gliderGroup.name ]
      componentsJoinedByString:KEY_SEPERATOR];
}

- (NSString *)name {
  return [@[ self.characterGroup.displayName, self.vehicleGroup.name, self.tireGroup.name, self.gliderGroup.name ]
      componentsJoinedByString:NAME_SEPERATOR];
}

#pragma mark - CMKSpinneritem

- (NSString *)displayText {
  return [self name];
}

@end
