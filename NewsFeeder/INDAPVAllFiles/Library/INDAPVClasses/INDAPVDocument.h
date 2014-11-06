
/********************************************************************************\
 *
 * File Name       INDAPVDocument.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <Foundation/Foundation.h>

@interface INDAPVDocument : NSObject <NSCoding>
{
@private // Instance variables

	NSString *_guid;

	NSDate *_fileDate;

	NSDate *_lastOpen;

	NSNumber *_fileSize;

	NSNumber *_pageCount;

	NSNumber *_pageNumber;

	NSMutableIndexSet *_bookmarks;

	NSString *_fileName;

	NSString *_password;

	NSURL *_fileURL;
}

@property (nonatomic, retain, readonly) NSString *guid;
@property (nonatomic, retain, readonly) NSDate *fileDate;
@property (nonatomic, retain, readwrite) NSDate *lastOpen;
@property (nonatomic, retain, readonly) NSNumber *fileSize;
@property (nonatomic, retain, readonly) NSNumber *pageCount;
@property (nonatomic, retain, readwrite) NSNumber *pageNumber;
@property (nonatomic, retain, readonly) NSMutableIndexSet *bookmarks;
@property (nonatomic, retain, readonly) NSString *fileName;
@property (nonatomic, retain, readonly) NSString *password;
@property (nonatomic, retain, readonly) NSURL *fileURL;



//YP - (7-10-14) - New Code - Add
+ (NSString *)documentsPath;


+ (INDAPVDocument *)withDocumentFilePath:(NSString *)filename password:(NSString *)phrase;

+ (INDAPVDocument *)unarchiveFromFileName:(NSString *)filename password:(NSString *)phrase;

- (id)initWithFilePath:(NSString *)fullFilePath password:(NSString *)phrase;

- (void)saveReaderDocument;

- (void)updateProperties;



@end
