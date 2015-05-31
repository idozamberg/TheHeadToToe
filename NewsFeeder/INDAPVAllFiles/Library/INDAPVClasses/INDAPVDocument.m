
/********************************************************************************\
 *
 * File Name       INDAPVDocument.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVDocument.h"
#import "CGPDFDocument.h"
#import <fcntl.h>

@implementation INDAPVDocument

#pragma mark Properties

@synthesize guid = _guid;
@synthesize fileDate = _fileDate;
@synthesize fileSize = _fileSize;
@synthesize pageCount = _pageCount;
@synthesize pageNumber = _pageNumber;
@synthesize bookmarks = _bookmarks;
@synthesize lastOpen = _lastOpen;
@synthesize password = _password;
@dynamic fileName, fileURL;

#pragma mark INDAPVDocument class methods

+ (NSString *)GUID
{
	CFUUIDRef theUUID;
	CFStringRef theString;

	theUUID = CFUUIDCreate(NULL);

	theString = CFUUIDCreateString(NULL, theUUID);

	NSString *unique = [NSString stringWithString:(id)theString];

	CFRelease(theString); CFRelease(theUUID); // Cleanup

	return unique;
}

//YP - (7-10-14) - New Code - Add
+ (NSString *)documentsPath
{
//     NSString *filePath=[[NSBundle mainBundle] resourcePath];
//    return filePath;
    
    NSFileManager *fileManager = [NSFileManager new]; // File manager instance
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    //NSLog(@"documentsPath :%@",[pathURL path]);
    return [pathURL path]; // Path to the application's "~/Documents" directory
}


+ (NSString *)applicationSupportPath
{
    NSFileManager *fileManager = [NSFileManager new]; // File manager instance
    NSURL *pathURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    //NSLog(@"applicationSupportPath :%@",[pathURL path]);
    return [pathURL path]; // Path to the application's "~/Library/Application Support" directory
}


+ (NSString *)relativeFilePath:(NSString *)fullFilePath
{
    assert(fullFilePath != nil); // Ensure that the full file path is not nil
    NSString *documentsPath = [INDAPVDocument documentsPath]; // Get the application path
    NSRange range = [fullFilePath rangeOfString:documentsPath]; // Look for the application path
    assert(range.location != NSNotFound); // Ensure that the application path is in the full file path
    return [fullFilePath stringByReplacingCharactersInRange:range withString:@""]; // Strip it out
}

- (id)initWithFilePath:(NSString *)fullFilePath password:(NSString *)phrase {
    id object = nil; // INDAPVDocument object
    if ([INDAPVDocument isPDF:fullFilePath] == YES) // File must exist
    {
        if ((self = [super init])) // Initialize the superclass object first
        {
            _guid = [[INDAPVDocument GUID] retain]; // Create a document GUID
            _password = [phrase copy]; // Keep a copy of any document password
            _bookmarks = [NSMutableIndexSet new]; // Bookmarked pages index set
            
            
            //_currentPage = @1; // Start page 1
//            _pageNumber = @1; // Start page 1
            _pageNumber = [[NSNumber numberWithInteger:1] retain]; // Start page 1
            
            
            _fileName = [[INDAPVDocument relativeFilePath:fullFilePath] retain];
            CFURLRef docURLRef = (__bridge CFURLRef) [self fileURL]; // CFURLRef from NSURL
            CGPDFDocumentRef thePDFDocRef = CGPDFDocumentCreateX(docURLRef, _password);
            if (thePDFDocRef != NULL) // Get the number of pages in a document
            {
                //New Code - ios 8 //YP - (7-10-14)
                NSInteger pageCount = CGPDFDocumentGetNumberOfPages(thePDFDocRef);
                //_pageCount = @(pageCount);
                
                //Old Code - ios 7 //YP - (7-10-14)
                //NSInteger pageCount = CGPDFDocumentGetNumberOfPages(thePDFDocRef);
                _pageCount = [[NSNumber numberWithInteger:pageCount] retain];
                
                
                CGPDFDocumentRelease(thePDFDocRef); // Cleanup
            }
            else // Cupertino, we have a problem with the document
            {
                NSAssert(NO, @"CGPDFDocumentRef == NULL");
            }
            NSFileManager *fileManager = [NSFileManager new]; // File manager
//            _lastOpen = [NSDate dateWithTimeIntervalSinceReferenceDate:0.0]; // Last opened
            self.lastOpen = [NSDate dateWithTimeIntervalSinceReferenceDate:0.0];
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:NULL];
            
            //Old Code - ios 7 //YP - (7-10-14)
            _fileDate = [[fileAttributes objectForKey:NSFileModificationDate] retain]; // File date
            _fileSize = [[fileAttributes objectForKey:NSFileSize] retain]; // File size (bytes)
            
            //New Code - ios 8 //YP - (7-10-14)
//            _fileDate = fileAttributes[NSFileModificationDate]; // File date
//            _fileSize = fileAttributes[NSFileSize]; // File size (bytes)
            
            
            [self saveReaderDocument]; // Save INDAPVDocument object
            object = self; // Return initialized INDAPVDocument object
        }
    }
    return object;
}

- (NSURL *)fileURL {
    if (_fileURL == nil) // Create and keep the file URL the first time it is requested
    {
        NSString *fullFilePath = [[INDAPVDocument documentsPath] stringByAppendingPathComponent:_fileName];
        _fileURL = [[NSURL alloc] initFileURLWithPath:fullFilePath isDirectory:NO]; // File URL from full file path
    }
    return _fileURL;
}

//YP - (7-10-14) - New Code - Add
+ (NSString *)archiveFilePath:(NSString *)filename
{
    //2
	assert(filename != nil); // Ensure that the archive file name is not nil

	//NSString *archivePath = [INDAPVDocument documentsPath]; // Application's "~/Documents" path

	NSString *archivePath = [INDAPVDocument applicationSupportPath]; // Application's "~/Library/Application Support" path

	NSString *archiveName = [[filename stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];

	return [archivePath stringByAppendingPathComponent:archiveName]; // "{archivePath}/'filename'.plist"
}

+ (INDAPVDocument *)unarchiveFromFileName:(NSString *)filename password:(NSString *)phrase
{
    //1
 	INDAPVDocument *document = nil; // INDAPVDocument object

	NSString *withName = [filename lastPathComponent]; // File name only

	NSString *archiveFilePath = [INDAPVDocument archiveFilePath:withName];

	@try // Unarchive an archived INDAPVDocument object from its property list
	{
        //NSLog(@"archiveFilePath:%@",archiveFilePath);
		document = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveFilePath];

		if ((document != nil) && (phrase != nil)) // Set the document password
		{
			[document setValue:[[phrase copy] autorelease] forKey:@"password"];
		}
	}
	@catch (NSException *exception) // Exception handling (just in case O_o)
	{
		#ifdef DEBUG
			NSLog(@"%s Caught %@: %@", __FUNCTION__, [exception name], [exception reason]);
		#endif
	}

	return document;
}

+ (INDAPVDocument *)withDocumentFilePath:(NSString *)filePath password:(NSString *)phrase;
{
	INDAPVDocument *document = nil; // INDAPVDocument object

	document = [INDAPVDocument unarchiveFromFileName:filePath password:phrase];

	if (document == nil) // Unarchive failed so we create a new INDAPVDocument object
	{
		document = [[[INDAPVDocument alloc] initWithFilePath:filePath password:phrase] autorelease];
	}

	return document;
}

+ (BOOL)isPDF:(NSString *)filePath
{
	BOOL state = NO;

	if (filePath != nil) // Must have a file path
	{
		const char *path = [filePath fileSystemRepresentation];

		int fd = open(path, O_RDONLY); // Open the file

		if (fd > 0) // We have a valid file descriptor
		{
			const unsigned char sig[4]; // File signature

			ssize_t len = read(fd, (void *)&sig, sizeof(sig));

			if (len == 4)
				if (sig[0] == '%')
					if (sig[1] == 'P')
						if (sig[2] == 'D')
							if (sig[3] == 'F')
								state = YES;

			close(fd); // Close the file
		}
	}

	return state;
}

#pragma mark INDAPVDocument instance methods



- (void)dealloc
{
	[_guid release], _guid = nil;

	[_fileURL release], _fileURL = nil;

	[_password release], _password = nil;

	[_fileName release], _fileName = nil;

	[_pageCount release], _pageCount = nil;

	[_pageNumber release], _pageNumber = nil;

	[_bookmarks release], _bookmarks = nil;

	[_fileSize release], _fileSize = nil;

	[_fileDate release], _fileDate = nil;

	[_lastOpen release], _lastOpen = nil;

	[super dealloc];
}

- (NSString *)fileName
{
    //NSLog(@"_fileName 2:%@",_fileName);
	return [_fileName lastPathComponent];
}


- (BOOL)archiveWithFileName:(NSString *)filename
{
	NSString *archiveFilePath = [INDAPVDocument archiveFilePath:filename];

	return [NSKeyedArchiver archiveRootObject:self toFile:archiveFilePath];
}

- (void)saveReaderDocument
{
	[self archiveWithFileName:[self fileName]];
}

- (void)updateProperties
{

}

#pragma mark NSCoding protocol methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_guid forKey:@"FileGUID"];

	[encoder encodeObject:_fileName forKey:@"FileName"];
    
	[encoder encodeObject:_fileDate forKey:@"FileDate"];

	[encoder encodeObject:_pageCount forKey:@"PageCount"];

	[encoder encodeObject:_pageNumber forKey:@"PageNumber"];

	[encoder encodeObject:_bookmarks forKey:@"Bookmarks"];

	[encoder encodeObject:_fileSize forKey:@"FileSize"];

	[encoder encodeObject:_lastOpen forKey:@"LastOpen"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) // Superclass init
	{
		_guid = [[decoder decodeObjectForKey:@"FileGUID"] retain];

		//_fileName = [[decoder decodeObjectForKey:@"FileName"] retain];
        
        _fileName = [[decoder decodeObjectForKey:@"FileName"] retain];
        
		_fileDate = [[decoder decodeObjectForKey:@"FileDate"] retain];

		_pageCount = [[decoder decodeObjectForKey:@"PageCount"] retain];

		_pageNumber = [[decoder decodeObjectForKey:@"PageNumber"] retain];

		_bookmarks = [[decoder decodeObjectForKey:@"Bookmarks"] mutableCopy];

		_fileSize = [[decoder decodeObjectForKey:@"FileSize"] retain];

		_lastOpen = [[decoder decodeObjectForKey:@"LastOpen"] retain];

		if (_bookmarks == nil) _bookmarks = [NSMutableIndexSet new];

		if (_guid == nil) _guid = [[INDAPVDocument GUID] retain];
	}

	return self;
}



//YP - (7-10-14) - New Code - Delete

/*
 + (NSString *)documentsPath
 {
	NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 
	return [documentsPaths objectAtIndex:0]; // Path to the application's "~/Documents" directory
 }
 
 + (NSString *)applicationPath
 {
	NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 
	return [[documentsPaths objectAtIndex:0] stringByDeletingLastPathComponent]; // Strip "Documents" component
 }
 + (NSString *)applicationSupportPath
 {
 NSFileManager *fileManager = [[NSFileManager new] autorelease]; // File manager instance
 
 NSURL *pathURL = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
 
 return [pathURL path]; // Path to the application's "~/Library/Application Support" directory
 }
 
 
 + (NSString *)relativeFilePath:(NSString *)fullFilePath
 {
 assert(fullFilePath != nil); // Ensure that the full file path is not nil
 
 NSString *applicationPath = [INDAPVDocument applicationPath]; // Get the application path
 
 NSRange range = [fullFilePath rangeOfString:applicationPath]; // Look for the application path
 
 //YP - (30-9-14) - Log
 if(range.location==NSNotFound)
 {
 NSLog(@"Range Not Found");
 }
 else
 {
 NSLog(@"Range Found");
 }
 
 assert(range.location != NSNotFound); // Ensure that the application path is in the full file path
 
 return [fullFilePath stringByReplacingCharactersInRange:range withString:@""]; // Strip it out
 }
 
 - (id)initWithFilePath:(NSString *)fullFilePath password:(NSString *)phrase
 {
 id object = nil; // INDAPVDocument object
 
 if ([INDAPVDocument isPDF:fullFilePath] == YES) // File must exist
 {
 if ((self = [super init])) // Initialize the superclass object first
 {
 _guid = [[INDAPVDocument GUID] retain]; // Create a document GUID
 
 _password = [phrase copy]; // Keep a copy of any document password
 
 _bookmarks = [NSMutableIndexSet new]; // Bookmarked pages index set
 
 _pageNumber = [[NSNumber numberWithInteger:1] retain]; // Start page 1
 
 //            //YP - (30-9-14) - New Code - Path
 //            if(isIOS8())
 //            {
 //                //_fileName = [NSString stringWithFormat:@"%@.%@",FileName,FileType];
 //
 //                 //YP - (6-10-14) - New Code - MultiFile
 //                 _fileName = [NSString stringWithFormat:@"%@.%@",appDelObj.strFileName,FileType];
 //            }
 //            else
 //            {
 //                //YP - (30-9-14) - Old Code
 //               _fileName = [[INDAPVDocument relativeFilePath:fullFilePath] retain];
 //            }
 
 _fileName = [[INDAPVDocument relativeFilePath:fullFilePath] retain];
 
 
 CFURLRef docURLRef = (CFURLRef)[self fileURL]; // CFURLRef from NSURL
 
 CGPDFDocumentRef thePDFDocRef = CGPDFDocumentCreateX(docURLRef, _password);
 
 if (thePDFDocRef != NULL) // Get the number of pages in a document
 {
 NSInteger pageCount = CGPDFDocumentGetNumberOfPages(thePDFDocRef);
 
 _pageCount = [[NSNumber numberWithInteger:pageCount] retain];
 
 CGPDFDocumentRelease(thePDFDocRef); // Cleanup
 }
 else // Cupertino, we have a problem with the document
 {
 NSAssert(NO, @"CGPDFDocumentRef == NULL");
 }
 
 NSFileManager *fileManager = [NSFileManager new]; // File manager
 
 _lastOpen = [[NSDate dateWithTimeIntervalSinceReferenceDate:0.0] retain]; // Last opened
 
 NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:NULL];
 
 _fileDate = [[fileAttributes objectForKey:NSFileModificationDate] retain]; // File date
 
 _fileSize = [[fileAttributes objectForKey:NSFileSize] retain]; // File size (bytes)
 
 [fileManager release]; [self saveReaderDocument]; // Save INDAPVDocument object
 
 object = self; // Return initialized INDAPVDocument object
 }
 }
 
 return object;
 }
 
 
 
 - (NSURL *)fileURL
 {
 if (_fileURL == nil) // Create and keep the file URL the first time it is requested
 {
 NSString *fullFilePath = [[INDAPVDocument applicationPath] stringByAppendingPathComponent:_fileName];
 
 _fileURL = [[NSURL alloc] initFileURLWithPath:fullFilePath isDirectory:NO]; // File URL from full file path
 }
 
 return _fileURL;
 }
 */




@end
