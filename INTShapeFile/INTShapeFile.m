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

#import "INTShapeFile.h"
@import MapKit;

@interface INTShapeFile ()

@property SHPHandle handle;

- (SHPObject)shapeObjectForIndex:(NSUInteger)index;

@end

@implementation INTShapeFile

+ (instancetype)openShapeFileAtURL:(NSURL *)url
{
    INTShapeFile *shape = [[INTShapeFile alloc] initWithURL:url];
    return shape;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (!url) {
        return nil;
    }
    _handle = SHPOpen([url.path cStringUsingEncoding:NSUTF8StringEncoding], "rb");

    if (_handle == NULL) {
        return nil;
    }

    double 	minBound[4], maxBound[4];
    int shpcnt = 0;
    SHPGetInfo( _handle, &shpcnt, &_shapeType, minBound, maxBound );
    _shapeCount = (NSUInteger)shpcnt;

    return self;
}

- (void)dealloc
{
    [self close];
}

- (void)close
{
    SHPClose(_handle);
    _handle = NULL;
    _shapeCount = 0;
    _shapeType = 0;
}

- (NSString *)shapeName
{
    if (_handle == NULL) {
        return nil;
    }
    return [NSString stringWithUTF8String:SHPTypeName(self.shapeType)];
}

- (SHPObject)shapeObjectForIndex:(NSUInteger)index
{
    if (index >= self.shapeCount) {
        NSAssert(NO, @"Shape index %ld out of bounds (0 - %lu)", (unsigned long)index, (unsigned long)self.shapeCount);
        SHPObject shp;
        return shp;
    }
    if (_handle == NULL) {
        SHPObject shp;
        return shp;
    }
    return *SHPReadObject(_handle, (int)index);
}

- (NSArray *)overlaysForIndex:(NSUInteger)index
{
    if (index >= self.shapeCount) {
        NSAssert(NO, @"Shape index %ld out of bounds (0 - %lu)", (unsigned long)index, (unsigned long)self.shapeCount);
        return nil;
    }
    SHPObject shapeObject = [self shapeObjectForIndex:index];
    if (shapeObject.nSHPType != SHPT_POLYGON &&
        shapeObject.nSHPType != SHPT_ARC) {
        NSAssert(NO, @"Shape Type %d (%@) not supported by %s",shapeObject.nSHPType, self.shapeName,  __PRETTY_FUNCTION__);
        return nil;
    }

    NSMutableArray *polyParts = [NSMutableArray array];
    int j = 0;
    if (shapeObject.nParts > 1) {
        int part = 1;
        for( int i = 0; i < shapeObject.nVertices - 1; i++ )
        {
            if( part < shapeObject.nParts && shapeObject.panPartStart[part] == i )
            {
                part++;
                NSRange range = NSMakeRange(j, i - j);
                id overlay = [self overlayForShape:shapeObject forRange:range];
                [polyParts addObject:overlay];
                j = i;
            }
        }
    }
    NSRange range = NSMakeRange(j, shapeObject.nVertices - j);
    id overlay = [self overlayForShape:shapeObject forRange:range];
    [polyParts addObject:overlay];

    return polyParts;
}

- (id)overlayForShape:(SHPObject)shapeObject forRange:(NSRange)range
{
    id overlay = nil;
    CLLocationCoordinate2D cl_coordinates[range.length];
    NSUInteger ci = 0;
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(shapeObject.padfY[i], shapeObject.padfX[i]);
        cl_coordinates[ci] = coordinate;
        ci++;
    }
    switch (shapeObject.nSHPType) {
        case SHPT_ARC:
        {
            overlay = [MKPolyline polylineWithCoordinates:cl_coordinates count:range.length];
        }
            break;
        case SHPT_POLYGON:
        {
            overlay = [MKPolygon polygonWithCoordinates:cl_coordinates count:range.length];
        }
            break;
        default:
            break;
    }
    return overlay;
}

- (NSArray *)coordinatesForIndex:(NSUInteger)index
{
    if (index >= self.shapeCount) {
        NSAssert(NO, @"Shape index %ld out of bounds (0 - %lu)", (unsigned long)index, (unsigned long)self.shapeCount);
        return nil;
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    SHPObject shapeObject = [self shapeObjectForIndex:index];
    int numCoordinates = shapeObject.nVertices;
    for (int i = 0; i < numCoordinates; i++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(shapeObject.padfY[i], shapeObject.padfX[i]);
        [mutableArray addObject:[NSValue valueWithMKCoordinate:coordinate]];
    }
    return [NSArray arrayWithArray:mutableArray];
}

@end