//
//  NSString+RNSynonyms.h
//  Readability-Mock
//
//  Created by Ryan Nystrom on 5/31/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

// Returns an array of words if available as well as any request or parsing error
typedef void (^RNSynonymsCompletion)(NSArray*,NSError*);

@interface NSString (RNSynonyms)

// Find all available synonyms for a word
- (void)findSynonymsWithCompletion:(RNSynonymsCompletion)completion;

// Find synonyms for a word with specific use.
// Available uses from API are: "noun", "verb", "adjective", "adverb"
// Returns all findings if results for usage do not exist
- (void)findSynonymsWithUsage:(NSString *)context completion:(RNSynonymsCompletion)completion;

// Find synonyms for a word when used in context of a sentence. Attempts to find usage.
// Returns all findings if results for usage do not exist
- (void)findSynonymsInContextSentence:(NSString *)sentence completion:(RNSynonymsCompletion)completion;

@end
