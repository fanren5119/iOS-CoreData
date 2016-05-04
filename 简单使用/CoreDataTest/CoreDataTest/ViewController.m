//
//  ViewController.m
//  CoreDataTest
//
//  Created by 王磊 on 16/4/25.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "Student+CoreDataProperties.h"
#import "Scores+CoreDataProperties.h"
#import "AppDelegate.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UISwitch    *sexSwitch;
@property (weak, nonatomic) IBOutlet UITextField *chineseTextField;
@property (weak, nonatomic) IBOutlet UITextField *mathTextField;
@property (weak, nonatomic) IBOutlet UITextField *englishTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)respondsToInputData:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:appDelegate.managedObjectContext];
    student.name = self.nameTextField.text;
    student.age = @([self.ageTextField.text integerValue]);
    student.sex = @(self.sexSwitch.isOn);
    
    Scores *score = [NSEntityDescription insertNewObjectForEntityForName:@"Scores" inManagedObjectContext:appDelegate.managedObjectContext];
    score.chinese = @([self.chineseTextField.text floatValue]);
    score.math = @([self.mathTextField.text floatValue]);
    score.english = @([self.englishTextField.text floatValue]);
    
    student.scores = score;
    
    NSError *error = nil;
    BOOL success = [appDelegate.managedObjectContext save:&error];
    if (!success) {
        [NSException raise:@"错误" format:@"%@", [error localizedDescription]];
    }
}

- (IBAction)respondsToInquireData:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appDelegate.managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*xiao*"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    for (Student *student in objs) {
        
        NSString *string = [NSString stringWithFormat:@"chinese:%@, math:%@ english:%@", student.scores.chinese, student.scores.math, student.scores.english];
        NSString *string2 = [NSString stringWithFormat:@"name:%@, age:%@, sex:%@ scores:%@", student.name,student.age, student.sex, string];
        NSLog(@"%@", string2);
    }
}

- (IBAction)respondsToDeleteData:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appDelegate.managedObjectContext];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = @[sort];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"xiaoming"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSMutableArray *objs = [[appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    for (Student *student in objs) {
        [appDelegate.managedObjectContext deleteObject:student];
    }
}

- (IBAction)repondsToUpdateData:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *student = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:appDelegate.managedObjectContext];
    request.entity = student;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"xiaoming"];
    request.predicate = predicate;
    NSError *error = nil;
    NSMutableArray *objects = [[appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (Student *stu in objects) {
        stu.age = @(20);
    }
    [appDelegate.managedObjectContext save:&error];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
