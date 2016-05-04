//
//  Student+CoreDataProperties.h
//  CoreDataTest
//
//  Created by 王磊 on 16/4/25.
//  Copyright © 2016年 wanglei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) Scores *scores;

@end

NS_ASSUME_NONNULL_END
