//
//  localClub.h
//  vitanocturna
//
//  Created by Ricardo Oyarzun on 11-03-11.
//  Copyright 2011 Universidad Tecnica Federico Santa Maria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface localClub : NSObject {
	NSString  *nombreClub;
	NSInteger categoriaClub;
	NSString  *direccionClub;
	NSString  *descripcionClub;
	
	sqlite3	  *database;
}

@property (assign,nonatomic,readonly) NSInteger categoriaClub;
@property (nonatomic,retain) NSString *nombreClub;
@property (nonatomic,retain) NSString *direccionClub;
@property (nonatomic,retain) NSString *descripcionClub;

- (id)initWithCategoriaClub: (NSInteger)cat database:(sqlite3 *)db;

@end
