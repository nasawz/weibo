#import "DBConnection.h"
#import "Statement.h"
#import "CarWeiboAppDelegate.h"

static sqlite3*             theDatabase = nil;

#define MAIN_DATABASE_NAME @"db1.3.sql"

//#define TEST_DELETE_TWEET

#ifdef TEST_DELETE_TWEET
const char *delete_tweets = 
"BEGIN;"
//"DELETE FROM statuses;"
//"DELETE FROM direct_messages;"
//"DELETE FROM images;"
//"DELETE FROM statuses WHERE type = 0 and id > (SELECT id FROM statuses WHERE type = 0 ORDER BY id DESC LIMIT 1 OFFSET 1);"
//"DELETE FROM statuses WHERE type = 1 and id > (SELECT id FROM statuses WHERE type = 1 ORDER BY id DESC LIMIT 1 OFFSET 1);"
//"DELETE FROM direct_messages WHERE id > (SELECT id FROM direct_messages ORDER BY id DESC LIMIT 1 OFFSET 10);"
"COMMIT";
#endif

@implementation DBConnection

+ (sqlite3*)openDatabase:(NSString*)dbFilename
{
    sqlite3* instance;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dbFilename];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &instance) != SQLITE_OK) {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(instance);
        NSLog(@"Failed to open database. (%s)", sqlite3_errmsg(instance));
        return nil;
    }        
    return instance;
}

+ (sqlite3*)getSharedDatabase
{
    if (theDatabase == nil) {
        theDatabase = [self openDatabase:MAIN_DATABASE_NAME];
        if (theDatabase == nil) {
            [DBConnection createEditableCopyOfDatabaseIfNeeded:true];
            [[CarWeiboAppDelegate getAppDelegate] alert:@"Local cache error" 
                                                  message:@"Local cache database has been corrupted. Re-created new database."];
        }
        
#ifdef TEST_DELETE_TWEET
        char *errmsg;
        if (sqlite3_exec(theDatabase, delete_tweets, NULL, NULL, &errmsg) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to cleanup chache (%s)", errmsg);
        }
#endif
    }
    return theDatabase;
}

//
// delete caches
//
const char *delete_message_cache_sql = 
"BEGIN;"
"DELETE FROM statuses;"
"DELETE FROM direct_messages;"
"DELETE FROM users;"
"DELETE FROM followees;"
"COMMIT;"
"VACUUM;";

+ (void)deleteMessageCache
{
    char *errmsg;
    [self getSharedDatabase];
    
    if (sqlite3_exec(theDatabase, delete_message_cache_sql, NULL, NULL, &errmsg) != SQLITE_OK) {
        // ignore error
        NSLog(@"Error: failed to cleanup chache (%s)", errmsg);
    }
}

+ (void)deleteImageCache
{
    char *errmsg;
    [self getSharedDatabase];
    
    if (sqlite3_exec(theDatabase, "DELETE FROM images; VACUUM;", NULL, NULL, &errmsg) != SQLITE_OK) {
        // ignore error
        NSLog(@"Error: failed to cleanup chache (%s)", errmsg);
    }
}

//
// cleanup and optimize
//
const char *cleanup_sql =
"BEGIN;"
"DELETE FROM images WHERE updated_at <= (SELECT updated_at FROM images order by updated_at LIMIT 1 OFFSET 5000);"
"DELETE FROM statuses WHERE type = 0 and id <= (SELECT id FROM statuses WHERE type = 0 ORDER BY id DESC LIMIT 1 OFFSET 4000);"
"DELETE FROM statuses WHERE type = 1 and id <= (SELECT id FROM statuses WHERE type = 1 ORDER BY id DESC LIMIT 1 OFFSET 1000);"
"COMMIT";


const char *optimize_sql = "VACUUM; ANALYZE";

+ (void)closeDatabase
{
    char *errmsg;
    if (theDatabase) {
        if (sqlite3_exec(theDatabase, cleanup_sql, NULL, NULL, &errmsg) != SQLITE_OK) {
            // ignore error
            NSLog(@"Error: failed to cleanup chache (%s)", errmsg);
        }
        
      	int launchCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchCount"];
        NSLog(@"launchCount %d", launchCount);
        if (launchCount-- <= 0) {
            NSLog(@"Optimize database...");
            if (sqlite3_exec(theDatabase, optimize_sql, NULL, NULL, &errmsg) != SQLITE_OK) {
                NSLog(@"Error: failed to cleanup chache (%s)", errmsg);
            }
            launchCount = 50;
        }
        [[NSUserDefaults standardUserDefaults] setInteger:launchCount forKey:@"launchCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];        
        sqlite3_close(theDatabase);
    }
}

// Creates a writable copy of the bundled default database in the application Documents directory.
+ (void)createEditableCopyOfDatabaseIfNeeded:(BOOL)force
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:MAIN_DATABASE_NAME];
    
    //
    // migration
    //
    // Update from version 1.2.*
    //
    NSString *oldDBPath = [documentsDirectory stringByAppendingPathComponent:@"db1.2.sql"];
    success = [fileManager fileExistsAtPath:oldDBPath];
    if (success) {
        sqlite3 *db12 = [DBConnection openDatabase:@"db1.2.sql"];
        char *errmsg;
        NSString *migrateSQL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"update_v12_to_v13.sql"];
        NSData *sqldata = [fileManager contentsAtPath:migrateSQL];
        NSString *sql = [[[NSString alloc] initWithData:sqldata encoding:NSUTF8StringEncoding] autorelease];
        if (sqlite3_exec(db12, [sql UTF8String], NULL, NULL, &errmsg) == SQLITE_OK) {
            // succeeded to update.
            [fileManager moveItemAtPath:oldDBPath toPath:writableDBPath error:&error];
            NSLog(@"Updated database from version 1.2 to 1.3.");
            return;
        }
        NSLog(@"Failed to update database (Reason: %s). Discard version 1.2 data...", errmsg);
        [fileManager removeItemAtPath:oldDBPath error:&error];
    }
    
    if (force) {
        [fileManager removeItemAtPath:writableDBPath error:&error];
    }
    
    // No exists any database file. Create new one.
    //
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MAIN_DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (void)beginTransaction
{
    char *errmsg;     
    sqlite3_exec(theDatabase, "BEGIN", NULL, NULL, &errmsg);     
}

+ (void)commitTransaction
{
    char *errmsg;     
    sqlite3_exec(theDatabase, "COMMIT", NULL, NULL, &errmsg);     
}

+ (Statement*)statementWithQuery:(const char *)sql
{
    Statement* stmt = [Statement statementWithDB:theDatabase query:sql];
    return stmt;
}

+ (void)alert
{
    NSString *sqlite3err = [NSString stringWithUTF8String:sqlite3_errmsg(theDatabase)];
    [[CarWeiboAppDelegate getAppDelegate] alert:@"Local cache db error" message:sqlite3err];
}

@end
