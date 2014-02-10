##Description

Use INTShapeFile to open .shp files using the [shapelib](http://http://shapelib.maptools.org) library and access shapes as either MKPolygon or MKPolyline objects suitable for display using MapKit on Mac OS X and iOS.

####Features
* load shapes in .shp files as either MKPolygon or MKPolyline objects
* access fields and records in .dbf files

####Limitations
* only polygon, polyline (arc), and point shapes are supported
* cannot modify or create .shp or .dbf files

####Requirements
* [shapelib](http://http://shapelib.maptools.org)

####Use
Download [shapelib](http://http://shapelib.maptools.org) and copy the following files into ```INTShapeFile/shapelib```

* dbfopen.c
* safileio.c
* shapefil.h
* shopen.c
* shptree.c

Add the ```INTShapeFile``` directory to your Xcode project. Import ```INTShapeFile.h``` and ```INTShapeDatabase.h``` files where necessary.

Make sure the ```Enable Modules (C and Objective-C)``` build setting is **YES**.

####Display Shapes on MKMapView
```
// Open the shape file.
NSURL *url = [NSURL fileURLWithPath:@"/path/to/shapes.shp"];
INTShapeFile *shapeFile = [INTShapeFile openShapeFileAtURL:url];

// Get overlays for a shape and add them to a map.
// mapView is an instance of MKMapView.
NSArray *overlays = [shapeFile overlaysForIndex:0];
[mapView addOverlays:overlays]

// Implement mapView:rendererForOverlay: delegate method to display the added overlays on the map.
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]]){
        MKPolygonRenderer *r = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
#if TARGET_OS_IPHONE
        r.strokeColor = [UIColor blueColor];
#else
        r.strokeColor = [NSColor blueColor];
#endif
        r.lineWidth = 1.5;
        return r;
    }else if([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineRenderer *r = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
#if TARGET_OS_IPHONE
        r.strokeColor = [UIColor redColor];
#else
        r.strokeColor = [NSColor redColor];
#endif
        r.lineWidth = 1.5;
        return r;
    }
    return nil;
}
```

####Load Shape Database
```
// Open the database file.
NSURL *url = [NSURL fileURLWithPath:@"/path/to/shapes.shp"];
INTShapeDatabase *shapeDatabase = [INTShapeDatabase openDatabaseFileAtURL:url];

// Get array of field names
NSArray *fields = shapeDatabase.fields;

// Get array of NSDictionary objects that represent the records in the database.
// The keys of each dictionary are defined by the values in the fields property.
NSArray *records = shapeDatabase.records;

```

####License
```
Copyright (c) 2014, Init LLC
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
```