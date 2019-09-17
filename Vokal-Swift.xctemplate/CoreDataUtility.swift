//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation
import Vokoder

/**
 A helper for setting up Core Data with Vokoder. This should usually be
 set up to run as early as possible, in your app delegate's willFinishLaunching:
 withOptions: method.
 
 NOTE: If you're using a Testing App Delegate, you should also have this helper
 run `setupCoreDataForTesting` in that file as well.
 */
struct CoreDataUtility {
    // MARK: - Setup consolidation methods
    
    /**
     Performs initial setup of the core data stack to use an in-memory store
     for testing.
     */
    static func setupCoreDataForTesting() {
        setupInMemoryDatabase()
    }
    
    /**
     Performs initial setup of the core data stack to use a sqlite file with
     the given file name.
     */
    static func setupCoreData() {
        setupDatabase(named: "___PACKAGENAMEASIDENTIFIER___.sqlite")
    }
    
    /**
     Wipes the current core data stack out and sets it back up for production use.
     */
    static func nukeAndResetCoreData() {
        nukeCoreData()
        setupCoreData()
    }
    
    /**
     Wipes the current core data stack out and sets it back up for testing.
     */
    static func nukeAndResetCoreDataForTesting() {
        nukeCoreData()
        setupCoreDataForTesting()
    }
    
    // MARK: - Private helper methods
    
    private static func nukeCoreData() {
        VOKCoreDataManager.sharedInstance().resetCoreData()
    }
    
    private static func setupInMemoryDatabase() {
        setupDatabase(named: nil)
    }
    
    private static func setupDatabase(named databaseName: String?) {
        //Setup the actual stack
        let manager = VOKCoreDataManager.sharedInstance()
        //TODO: make sure it's OK to wipe the data base on migration failure
        manager.migrationFailureOptions = .wipeRecovery
        manager.setResource("___PACKAGENAMEASIDENTIFIER___", database: databaseName)
        
        //Fire off the object mappers
        setupObjectMappers()
    }
    
    private static func setupObjectMappers() {
        //TODO: Add mapper method firing here
    }
}
