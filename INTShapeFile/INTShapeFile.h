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
#import "shapefil.h"

/**
 The INTShapeFile class offers an Objective-C interface for opening .shp files 
 using the shapelib library. Once a .shp file is open shapes can be accessed 
 using the overlaysForIndex: method. Coordinates for a shape can be accessed
 using the coordinatesForIndex: method. Only polygon, line, and point shapes are 
 supported at this time.
 */
@interface INTShapeFile : NSObject

/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */

/** Integer that identifies the shape type represented by the file.*/
@property (nonatomic, readonly) int shapeType;

/** Name of the shape represented by the file.*/
@property (nonatomic, readonly) NSString *shapeName;

/** Number of shapes contained in the shape file.*/
@property (nonatomic, readonly) NSUInteger shapeCount;



/**-----------------------------------------------------------------------------
 * @name Opening Files
 * -----------------------------------------------------------------------------
 */

/** Open a .shp file.

 @param url File NSURL containing path to .shp file to open.

 @return Instance of INTShapeFile.
 */
+ (instancetype)openShapeFileAtURL:(NSURL *)url;



/**-----------------------------------------------------------------------------
 * @name Instance Methods
 * -----------------------------------------------------------------------------
 */

/** Returns array of either MKPolygon or MKPolyline objects that contain
 the coordinates for the shape at the provided index. The index value is an index 
 representing one of the records from an INTShapeDatabase instance.

 @param index Index of a record from an INTShapeDatabase.

 @return NSArray of MKPolygon or MKPolyline objects.
 */
- (NSArray *)overlaysForIndex:(NSUInteger)index;


/** Returns array of NSValue objects containing CLLocationCoordinate2D values
 for the shape object at the provided index. The index value is an index
 representing one of the records from an INTShapeDatabase instance.
 
 Example:

 CLLocationCoordinate2d coordinate;
 
 [[array objectAtIndex:index] getValue:&coordinate];

 @param index Index of a record from an INTShapeDatabase.

 @return NSArray of NSValues representing CLLocationCoordinate2D.
 */
- (NSArray *)coordinatesForIndex:(NSUInteger)index;

@end
