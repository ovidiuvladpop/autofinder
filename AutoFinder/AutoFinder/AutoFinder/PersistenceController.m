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

@end
