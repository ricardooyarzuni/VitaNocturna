//
//  vitanocturnaAppDelegate.m
//  vitanocturna
//
//  Created by Ricardo Oyarzun on 11-03-11.
//  Copyright Universidad Tecnica Federico Santa Maria 2011. All rights reserved.
//

#import "vitanocturnaAppDelegate.h"
#import "RootViewController.h"
#import "localClub.h"

@interface vitanocturnaAppDelegate (Private);
- (void)createEditableCopyofDatabaseIfNeeded;
- (void)initializeDatabase;

@end


@implementation vitanocturnaAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize clubRows;

#pragma mark -
#pragma mark Application lifecycle

- (void)createEditableCopyofDatabaseIfNeeded {
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError		  *error;
	NSArray		  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString	  *documentsDirectory = [paths objectAtIndex:0];
	NSString	  *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"vita.sqlite"];
	
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"vita.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0,@"Fallo al crear bd escribible con msg '%@'.",[error localizedDescription]);
	}
}

- (void)initializeDatabase {
    NSMutableArray *Array = [[NSMutableArray alloc] init];
    self.clubRows = Array;
    [Array release];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"vita.sqlite"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT nombre FROM localClub";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int cat = sqlite3_column_int(statement, 0);
                localClub *td = [[localClub alloc] initWithCategoriaClub:cat database:database];
                [clubRows addObject:td];
                [td release];
            }
        }
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
	
	NSLog([[NSString alloc] initWithFormat:@"size:%@",[[clubRows objectAtIndex:3] nombreClub]]);
}


- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    [self createEditableCopyofDatabaseIfNeeded];
	[self initializeDatabase];
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    //return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

