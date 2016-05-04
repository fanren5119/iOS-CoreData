//
//  ViewController.m
//  CoreDataTest
//
//  Created by 王磊 on 16/5/4.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

@interface ViewController ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)respondsToAddButton:(id)sender
{
    NSManagedObject *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    [student setValue:self.nameTextField.text forKey:@"name"];
    [student setValue:@([self.ageTextField.text integerValue]) forKey:@"age"];
    
    
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
        [NSException raise:@"错误" format:@"%@", [error localizedDescription]];
    }
}
- (IBAction)respondsToDeleteButton:(id)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"xiaoming"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSMutableArray *objs = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    for (NSManagedObject *student in objs) {
        [self.managedObjectContext deleteObject:student];
    }
}

- (IBAction)respondsToModifyButton:(id)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *student = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    request.entity = student;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"xiaoming"];
    request.predicate = predicate;
    NSError *error = nil;
    NSMutableArray *objects = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (NSManagedObject *stu in objects) {
        [stu setValue:@(20) forKey:@"age"];
    }
    [self.managedObjectContext save:&error];
}

- (IBAction)respondsToSearchButton:(id)sender
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*xiao*"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    for (NSManagedObject *student in objs) {
        
        NSString *name = [student valueForKey:@"name"];
        NSNumber *age = [student valueForKey:@"age"];
        NSString *string2 = [NSString stringWithFormat:@"name:%@, age:%@", name,age];
        NSLog(@"%@", string2);
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] init];
    
    NSEntityDescription *studentEntity = [[NSEntityDescription alloc] init];
    [studentEntity setName:@"Student"];
    [studentEntity setManagedObjectClassName:@"Student"];
    
    [_managedObjectModel setEntities:@[studentEntity]];
    
    NSAttributeDescription *nameAttribute = [[NSAttributeDescription alloc] init];
    [nameAttribute setName:@"name"];
    [nameAttribute setAttributeType:NSStringAttributeType];
    [nameAttribute setOptional:NO];
    
    NSAttributeDescription *ageAttribute = [[NSAttributeDescription alloc] init];
    [ageAttribute setName:@"age"];
    [ageAttribute setAttributeType:NSInteger16AttributeType];
    [ageAttribute setOptional:NO];
    [ageAttribute setDefaultValue:@(0)];
    
    [studentEntity setProperties:@[nameAttribute, ageAttribute]];
    
    return _managedObjectModel;
}

- (NSURL *)applicationLogDirectory
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSURL *libraryUrl = [fileManager URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    return libraryUrl;
    
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectModel) {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSString *fileName = @"CoreData.sqlite";
    NSURL *url = [[self applicationLogDirectory] URLByAppendingPathComponent:fileName];
    NSError *error = nil;
    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store) {
        NSLog(@"store COnfiguration failure %@", [error localizedDescription]);
    }
    return _persistentStoreCoordinator;
}

@end
