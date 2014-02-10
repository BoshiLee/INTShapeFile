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

#import "INTShapeDatabase.h"
#import "shapefil.h"

NSString * const INTShapeDatabaseRecordIndexKey = @"INTShapeDatabaseRecordIndexKey";

@interface INTShapeDatabase ()

@property DBFHandle handle;

@end

@implementation INTShapeDatabase

@synthesize fields = _fields;
@synthesize records = _records;

+ (instancetype)openDatabaseAtURL:(NSURL *)url
{
    INTShapeDatabase *db = [[INTShapeDatabase alloc] initWithURL:url];
    return db;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (!url) {
        return nil;
    }
    _handle = DBFOpen([url.path cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (_handle == NULL) {
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [self close];
}

- (NSUInteger)fieldCount
{
    if (_handle == NULL) {
        return 0;
    }
    return DBFGetFieldCount(_handle);
}

- (NSArray *)fields
{
    if (_handle == NULL) {
        return nil;
    }
    if (_fields) {
        return _fields;
    }
    NSMutableArray *mutableFieldsArray = [NSMutableArray array];
    char field_title[12];
    int field_width, field_decimals;
    for(int i = 0; i < DBFGetFieldCount(_handle); i++){
        DBFGetFieldInfo( _handle, i, field_title, &field_width, &field_decimals );
        [mutableFieldsArray addObject:[NSString stringWithUTF8String:field_title]];
    }
    _fields = [NSArray arrayWithArray:mutableFieldsArray];
    return _fields;
}

- (NSUInteger)recordsCount
{
    if (_handle == NULL) {
        return 0;
    }
    return DBFGetRecordCount(_handle);
}

- (NSArray *)records
{
    if (_handle == NULL) {
        return nil;
    }
    if (_records) {
        return _records;
    }
    NSMutableArray *mutableRecordsArray = [NSMutableArray array];
    char field_title[12];
    int field_width, field_decimals;
    for (int record_count = 0; record_count < self.recordsCount; record_count++) {
        NSMutableDictionary *recordDictionary = [NSMutableDictionary dictionary];
        [recordDictionary setObject:[NSNumber numberWithInt:record_count] forKey:INTShapeDatabaseRecordIndexKey];
        for (int field_count = 0; field_count < self.fieldCount; field_count++){
            DBFFieldType field_type = DBFGetFieldInfo( _handle, field_count, field_title, &field_width, &field_decimals );
            NSString *fieldTitle = [NSString stringWithUTF8String:field_title];
            if (DBFIsAttributeNULL( _handle, record_count, field_count )) {
                [recordDictionary setObject:[NSNull null] forKey:fieldTitle];
            }else{
                switch (field_type) {
                    case FTString:
                    {
                        NSString *s = [NSString stringWithUTF8String:DBFReadStringAttribute(_handle, record_count, field_count)];
                        [recordDictionary setObject:s forKey:fieldTitle];
                    }
                        break;
                    case FTInteger:
                    {
                        int int_value = DBFReadIntegerAttribute(_handle, record_count, field_count);
                        [recordDictionary setObject:[NSNumber numberWithInt:int_value] forKey:fieldTitle];
                    }
                        break;
                    case FTDouble:
                    {
                        double dbl_value = DBFReadDoubleAttribute(_handle, record_count, field_count);
                        [recordDictionary setObject:[NSNumber numberWithDouble:dbl_value] forKey:fieldTitle];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        [mutableRecordsArray addObject:recordDictionary];
    }
    _records = [NSArray arrayWithArray:mutableRecordsArray];
    return _records;
}

- (void)close
{
    DBFClose(_handle);
    _handle = NULL;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Field Count: %ld\nFields: %@\nRecords Count: %ld", (unsigned long)self.fieldCount, self.fields, (unsigned long)self.recordsCount];
}

@end