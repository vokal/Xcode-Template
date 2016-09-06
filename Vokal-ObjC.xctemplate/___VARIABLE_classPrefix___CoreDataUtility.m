//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___VARIABLE_classPrefix___CoreDataUtility.h"

#import "VOKCoreDataManager.h"

@implementation ___VARIABLE_classPrefix___CoreDataUtility

+ (void)setupCoreDataForTesting
{
    [self setupCoreDataWithDatabaseName:nil];
}

+ (void)setupCoreData
{
    [self setupCoreDataWithDatabaseName:@"___PACKAGENAMEASIDENTIFIER___.sqlite"];
}

+ (void)nukeAndResetCoreData
{
    [[VOKCoreDataManager sharedInstance] resetCoreData];
    [self setupCoreData];
}

+ (void)nukeAndResetCoreDataForTesting
{
    [[VOKCoreDataManager sharedInstance] resetCoreData];
    [self setupCoreDataForTesting];
}

+ (void)setupCoreDataWithDatabaseName:(NSString *)databaseName
{
    //Setup Core Data Stack
    VOKCoreDataManager *manager = VOKCoreDataManager.sharedInstance;
    //TODO: make sure it's OK to wipe the data base on migration failure
    manager.migrationFailureOptions = VOKMigrationFailureOptionWipeRecovery;
    [manager setResource:@"___PACKAGENAMEASIDENTIFIER___" database:databaseName];

    //Setup Object Mappers
    [self setupObjectMappers];
}

#pragma mark - Mappers

+ (void)setupObjectMappers
{
    //TODO:Fire Off Your Mapper Methods Here
}

@end
