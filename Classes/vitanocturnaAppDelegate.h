//
//  vitanocturnaAppDelegate.h
//  vitanocturna
//
//  Created by Ricardo Oyarzun on 11-03-11.
//  Copyright Universidad Tecnica Federico Santa Maria 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface vitanocturnaAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	NSMutableArray *clubRows;
	sqlite3 *database;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *clubRows;

@end

