/*
 Copyright (c) 2013, Init LLC
 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

/**
 The INTShapeDatabase class offers an Objective-C interface for opening .dbf 
 files using the shapelib library. Once a .dbf file is open the fields in the 
 database can be accessed using the fields property and records are available
 using the records property.
 */
@interface INTShapeDatabase : NSObject

/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */

/** Number of fields in database file.*/
@property (readonly) NSUInteger fieldCount;

/** Array of field names as NSStrings.*/
@property (readonly) NSArray *fields;

/** Number of records in the database file.*/
@property (readonly) NSUInteger recordsCount;

/** Array of NSDictionary objects containing key names from
 fields and values for each record in the database file.*/
@property (readonly) NSArray *records;



/**-----------------------------------------------------------------------------
 * @name Opening Files
 * -----------------------------------------------------------------------------
 */

/** Open a .dbf file.

 @param url File NSURL containing path to .dbf file to open.

 @return Instance of INTShapeDatabase.
 */
+ (instancetype)openDatabaseAtURL:(NSURL *)url;


@end
