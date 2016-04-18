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

//Method used for initializing some settings
- (id)init {
    
    if (self = [super init]) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        self.context = [appDelegate managedObjectContext];
        
    }
    
    return self;
    
}

//Method used for creating only single one initialized instance of PersistenceController
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

//Method invoked when user buys attempts
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

//Method used for updating user on NSUserDefaults after buying attempts
- (void)updateDefaultUser:(NSNumber *)numberOfAttempts {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:numberOfAttempts forKey:@"attempts"];
    [defaults synchronize];
    
}

//Method used for updating user's details
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
        
        [self updateDefaultUser:username
                          email:email
                    phoneNumber:phone
                      carNumber:car];
        
        return YES;
        
    }
    
    return NO;
}

//Method used for updating user's details on NSUserDefaults
- (void)updateDefaultUser:(NSString *)username email:(NSString *)email phoneNumber:(NSString *)phoneNumber carNumber:(NSString *)carNumber {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:username      forKey:@"username"];
    [defaults setObject:email        forKey:@"email"];
    [defaults setObject:phoneNumber  forKey:@"phone"];
    [defaults setObject:carNumber    forKey:@"car"];
    
    [defaults synchronize];
    
}

//Method used when a new incident has occured
-(void)sendPhotoToDatabase:(UIImage *)image withCoordinates:(CLLocationCoordinate2D)coordinate {
    
    NSNumber *latitude = [[NSNumber alloc] initWithFloat:coordinate.latitude];
    NSNumber *longitude = [[NSNumber alloc] initWithFloat:coordinate.longitude];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Photo"
                                                         inManagedObjectContext:self.context];
    
    NSManagedObject *newPhoto =[[NSManagedObject alloc] initWithEntity:entityDescription
                                        insertIntoManagedObjectContext:self.context];
    
    NSData *dataWithImage = UIImageJPEGRepresentation(image, 1.0);
    
    [newPhoto setValue:dataWithImage forKey:@"photo"];
    [newPhoto setValue:[NSDate date] forKey:@"date"];
    [newPhoto setValue:latitude forKey:@"latitude"];
    [newPhoto setValue:longitude forKey:@"longitude"];
    
    NSError *error;
    [self.context save:&error];
    
}

//Method used for getting all incidents
- (NSArray *)getAllIncidents {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.context]];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    return results;
    
}

//Method used for getting incident's image based on coordinates
- (UIImage *)incidentImage:(CLLocationCoordinate2D)incidentCoordinates {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo"
                                   inManagedObjectContext:self.context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude == %lf and longitude == %lf", [[[NSNumber alloc] initWithDouble:incidentCoordinates.latitude] floatValue], [[[NSNumber alloc] initWithDouble:incidentCoordinates.longitude] floatValue]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request
                                                   error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    UIImage *incidentImage = [UIImage imageWithData:[obj valueForKey:@"photo"]];
    
    return incidentImage;
    
}

//Method used for getting incident's date based on coordinates
- (NSString *)incidentDate:(CLLocationCoordinate2D)incidentCoordinates {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Photo"
                                   inManagedObjectContext:self.context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude == %lf and longitude == %lf", [[[NSNumber alloc] initWithDouble:incidentCoordinates.latitude] floatValue], [[[NSNumber alloc] initWithDouble:incidentCoordinates.longitude] floatValue]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:request
                                                   error:&error];
    
    NSManagedObject* obj = [results objectAtIndex:0];
    NSDate *incidentDate = [obj valueForKey:@"date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSString *stringFromDate = [formatter stringFromDate:incidentDate];
    
    return stringFromDate;
    
}

@end
