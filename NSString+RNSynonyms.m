//
//  NSString+RNSynonyms.m
//  Readability-Mock
//
//  Created by Ryan Nystrom on 5/31/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import "NSString+RNSynonyms.h"

#error "Get an API key here http://words.bighugelabs.com/api.php"
static NSString * const kBigHugeLabAPIKey = @"";

static NSString * const kBigHugeLabAPIURLFormat = @"http://words.bighugelabs.com/api/%i/%@/%@/json";

@implementation NSString (RNSynonyms)

- (void)findSynonymsWithUsage:(NSString *)context completion:(void (^)(NSArray*,NSError*))completion {
    NSString *cleanString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *split = [cleanString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert([split count] == 1, @"Synonyms cannot be found for more than one word. Attempted finding synonym for %@",self);
    
    NSString *url = [NSString stringWithFormat:kBigHugeLabAPIURLFormat,2,kBigHugeLabAPIKey,cleanString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSMutableArray *words = nil;
        if (data && [data length] > 0) {
            NSError *parseError = nil;
            id results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            if (parseError) {
                error = parseError;
                NSLog(@"%@",parseError.localizedDescription);
            }
            
            if ([results isKindOfClass:[NSDictionary class]]) {                
                if (context) {
                    NSDictionary *options = results[context];
                    if (options) {
                        words = options[context];
                    }
                }
                
                if (! words) {
                    words = [NSMutableArray array];
                    NSArray *keys = [results allKeys];
                    for (NSString *key in keys) {
                        [words addObjectsFromArray:results[key][@"syn"]];
                    }
                }
            }
        }
        
        if (completion) {
            completion(words, error);
        }
    }];
}

- (void)findSynonymsWithCompletion:(void (^)(NSArray*,NSError*))completion {
    [self findSynonymsWithUsage:nil completion:completion];
}

- (void)findSynonymsInContextSentence:(NSString *)sentence completion:(void (^)(NSArray*,NSError*))completion {
    static NSDictionary *linguisticsMap = nil;
    
    if (! linguisticsMap) {
        linguisticsMap = @{
                           @"Noun": @"noun",
                           @"Pronoun": @"noun",
                           @"Determiner": @"noun",
                           @"Verb": @"verb",
                           @"Adjective": @"adjective",
                           @"Adverb": @"adverb"
                           };
    }
    
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLexicalClass] options:~NSLinguisticTaggerOmitWords];
    [tagger setString:sentence];
    NSRange range = [sentence rangeOfString:self];
    __block NSString *usage = nil;
    [tagger enumerateTagsInRange:range
                          scheme:NSLinguisticTagSchemeLexicalClass
                         options:~NSLinguisticTaggerOmitWords
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                          usage = linguisticsMap[tag];
                      }];
    
    [self findSynonymsWithUsage:usage completion:completion];
}

@end
