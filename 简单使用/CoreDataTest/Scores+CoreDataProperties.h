//
//  Scores+CoreDataProperties.h
//  CoreDataTest
//
//  Created by 王磊 on 16/4/25.
//  Copyright © 2016年 wanglei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Scores.h"

NS_ASSUME_NONNULL_BEGIN

@interface Scores (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *english;
@property (nullable, nonatomic, retain) NSNumber *math;
@property (nullable, nonatomic, retain) NSNumber *chinese;

@end

NS_ASSUME_NONNULL_END
