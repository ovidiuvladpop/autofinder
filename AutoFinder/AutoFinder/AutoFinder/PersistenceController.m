//
//  PersistenceController.m
//  AutoFinder
//
//  Created by admin on 16/04/16.
//  Copyright © 2016 Basic. All rights reserved.
//

#import "PersistenceController.h"
#define kNumberOfAttempts 3

@interface PersistenceController() {}

@property (nonatomic, weak) NSManagedObjectContext *context;


@end

@implementation PersistenceController

- (id)init {
    if (self = [super init]) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = [appDelegate managedObjectContext];
        
    }
    return self;
}

+ (id)sharedInstance {
    static PersistenceController *sharedPersistence = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPersistence = [[self alloc] init];
    });
    return sharedPersistence;
}

//Method used for creating a new account
-(BOOL)createAccountWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email phone:(NSString *)phone car:(NSString *)car {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User"
                                                         inManagedObjectContext:self.context];
    NSManagedObject *newUser =[[NSManagedObject alloc] initWithEntity:entityDescription
                                       insertIntoManagedObjectContext:self.context];
    
    [newUser setValue:username
               forKey:@"username"];
    [newUser setValue:password
               forKey:@"password"];
    [newUser setValue:email
               forKey:@"email"];
    [newUser setValue:phone
               forKey:@"phone"];
    [newUser setValue:car
               forKey:@"car"];
    [newUser setValue:[NSNumber numberWithInt:kNumberOfAttempts]
               forKey:@"attempts"];
    
    NSError *error;
    BOOL isSaved = [self.context save:&error];
    
    if (isSaved) {
        
        return YES;
        
    }
    
    return NO;
}

//Method used for login the user in application.
- (BOOL)loginUser:(NSString*)username andPassword:(NSString*)password {
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"User"
                                                  inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entitydesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username like %@ and password like %@", username, password];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matchingData=[self.context executeFetchRequest:request
                                                      error:&error];
    
    if(matchingData.count <= 0){
        return NO;
    } else {
        NSString *username;
        NSString *password;
        NSString *email;
        NSString *phone;
        NSString *car;
        NSNumber *attempts;
        
        for(NSManagedObjectContext *obj in matchingData) {
            username = [obj valueForKey:@"username"];
            password = [obj valueForKey:@"password"];
            email    = [obj valueForKey:@"email"];
            phone    = [obj valueForKey:@"phone"];
            car      = [obj valueForKey:@"car"];
            attempts = [obj valueForKey:@"attempts"];
        }
        
        [self saveUser:username withPassword:password email:email phoneNumber:phone carNumber:car andAttempts:attempts];
        
        return YES;
    }
}

//Method used for saving user on NSUserDefaults.
- (void)saveUser:(NSString *)username withPassword:(NSString *)password email:(NSString *)email phoneNumber:(NSString *)phone carNumber:(NSString *)car andAttempts:(NSNumber *)attempts {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:username
                 forKey:@"username"];
    [defaults setObject:password
                 forKey:@"password"];
    [defaults setObject:email
                 forKey:@"email"];
    [defaults setObject:phone
                 forKey:@"phone"];
    [defaults setObject:car
                 forKey:@"car"];
    [defaults setObject:attempts
                 forKey:@"attempts"];
    
    [defaults synchronize];
    
}

- (void)buyAttempts {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    NSNumber *numberOfAttempts = [NSNumber numberWithInt:([[obj valueForKey:@"attempts"] intValue] + kNumberOfAttempts)];
    
    [obj setValue:numberOfAttempts forKey:@"attempts"];
    [self.context save:&error];
    
    [self updateDefaultUser:numberOfAttempts];
}

- (void)updateDefaultUser:(NSNumber *)numberOfAttempts {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:numberOfAttempts forKey:@"attempts"];
    [defaults synchronize];
}

- (BOOL)updateUser:(NSString *)username email:(NSString *)email phone:(NSString *)phone andCar:(NSString *)car {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email == %@", [defaults objectForKey:@"email"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    [obj setValue:username forKey:@"username"];
    [obj setValue:email forKey:@"email"];
    [obj setValue:phone forKey:@"phone"];
    [obj setValue:car forKey:@"car"];
    
    if ([self.context save:&error]) {
        return YES;
    }
    
    return NO;
}


@end
