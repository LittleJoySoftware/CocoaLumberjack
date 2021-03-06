// Copyright 2013 Little Joy Software. All rights reserved.
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

#import "LjsLogging.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int __unused ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int __unused ddLogLevel = LOG_LEVEL_WARN;
#endif


@interface LjsLogging ()

@end

@implementation LjsLogging


#pragma mark Memory Management

- (id) init {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}


+ (void) startLoggingWithASL:(BOOL) aDoASL
             withFileLogging:(BOOL) aDoFileLogging {
  LjsDefaultLogFormatter *ttyFmter = [LjsDefaultLogFormatter new];
  [[DDTTYLogger sharedInstance] setLogFormatter:ttyFmter];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
  if (aDoASL == YES) {
    LjsDefaultLogFormatter *aslFmtet = [LjsDefaultLogFormatter new];
    [[DDASLLogger sharedInstance] setLogFormatter:aslFmtet];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
  }
  
  if (aDoFileLogging == YES) {
    LjsLogFileManager *fileManager = [LjsLogFileManager new];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    LjsDefaultLogFormatter *logFmter = [LjsDefaultLogFormatter new];
    [fileLogger setLogFormatter:logFmter];
    fileLogger.maximumFileSize = 1024 * 1024;
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;
    [DDLog addLogger:fileLogger];
  }
}

@end
