// Copyright (c) 2010, Little Joy Software
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsDefaultLogFormatter.h"
#import "LjsLog.h"


static NSString *const kFormatString_dated = @"%@ %@ %@: %s %i - %@";
static NSString *const kDateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";


static NSString * const k_ljs_error_log = @"ERROR";
static NSString * const k_ljs_fatal_log = @"FATAL";
static NSString * const k_ljs_warn_log  = @" WARN";
static NSString * const k_ljs_note_log  = @" NOTE";
static NSString * const k_ljs_info_log  = @" INFO";
static NSString * const k_ljs_debug_log = @"DEBUG";
static NSString * const k_ljs_some_log  = @"  LOG";



@interface LjsDefaultLogFormatter ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


/**
 A verbose formatter for use with CocoaLumberjackLogging framework.
 
 Implements the DDLogFormatter protocol.
 
 See LjsLog.h for details about log level.
 */
@implementation LjsDefaultLogFormatter

@synthesize dateFormatter = _dateFormatter;


// strange, but using this seems to occassionally create
// dates that are not formated correctly
// opting using a string literal
//static NSString * const DATE_FORMAT = @"yyyy-MM-dd HH:mm:ss.SSS";


/** @name Initialization */
/**
 assigns the dateFormatter and formatString properties
 @return an initialized receiver
 */
- (id) init {
	self = [super init];
	if (self != nil) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:kDateFormat];
  }
	return self;
}

/** @name Format Log Message */
/**
 implements the DDLogFormatter protocol.
 @return a formatted log message
 @param logMessage the log message to format
 */
- (NSString *) formatLogMessage:(DDLogMessage *)logMessage {
	
  NSString *level;
	switch (logMessage->logFlag) {
    case LOG_FLAG_FATAL:
      level = k_ljs_fatal_log;
      break;
    case LOG_FLAG_ERROR:
			level = k_ljs_error_log;
			break;
		case LOG_FLAG_WARN:
			level = k_ljs_warn_log;
			break;
		case LOG_FLAG_NOTICE:
			level = k_ljs_note_log;
			break;
    case LOG_FLAG_INFO:
			level = k_ljs_info_log;
			break;
    case LOG_FLAG_DEBUG:
			level = k_ljs_debug_log;
			break;
		default:
			level = k_ljs_some_log;
			break;
	}
  
  NSString *dateStr = [_dateFormatter stringFromDate:(logMessage->timestamp)];
    return [NSString stringWithFormat:kFormatString_dated,
            dateStr,
            level, [logMessage fileName], logMessage->function,
            logMessage->lineNumber, logMessage->logMsg];
  
  
  /*
  ancient - hopefully will never need this again
  NSString *dateStr =
  // fixes a problem where by dates are sometimes incorrectly formated
  if ([dateStr length] != 23) {
    //NSDate *thedate = logMessage->timestamp;
    //NSString *oldDateStr = dateStr;
    dateStr = [self.dateFormatter stringFromDate:(logMessage->timestamp)];
    //NSLog(@"CORRECTED: %@ ==> %@ for %@", oldDateStr, dateStr, thedate);
  }
   */
 
}


@end
