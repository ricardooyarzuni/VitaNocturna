//
//  localClub.m
//  vitanocturna
//
//  Created by Ricardo Oyarzun on 11-03-11.
//  Copyright 2011 Universidad Tecnica Federico Santa Maria. All rights reserved.
//

#import "localClub.h"
#import <sqlite3.h>

static sqlite3_stmt *init_statement = nil;

@implementation localClub
@synthesize nombreClub, descripcionClub,categoriaClub,direccionClub;

-(id)initWithCategoriaClub: (NSInteger)cat database:(sqlite3 *)db {
	if (self = [super init]) {
        categoriaClub = cat;
        database = db;
        // Compile the query for retrieving book data. See insertNewBookIntoDatabase: for more detail.
        if (init_statement == nil) {
            // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
            // This is a great way to optimize because frequently used queries can be compiled once, then with each
            // use new variable values can be bound to placeholders.
            const char *sql = "SELECT nombre FROM localClub WHERE categoria=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // For this query, we bind the primary key to the first (and only) placeholder in the statement.
        // Note that the parameters are numbered from 1, not from 0.
        sqlite3_bind_int(init_statement, 1, cat);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.nombreClub = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
        } else {
            self.nombreClub = @"Nothing";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
    }
    return self;
	
}

@end
