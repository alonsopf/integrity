//
//  CatalagoTableViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
@class CatalagoTableViewController;             //define class, so protocol can see MyClass
@protocol CatalagoTableViewControllerDelegate <NSObject>   //define delegate protocol
- (void) selectProducto: (NSString *) producto contadoOCredito:(int)cc precio:(float)p   clave:(NSString*)clave;
@end //end protocol


@interface CatalagoTableViewController : UITableViewController <UISearchBarDelegate>
@property (nonatomic, weak) id <CatalagoTableViewControllerDelegate> delegate;
@property (nonatomic,strong) IBOutlet UISearchBar *search;
@property (nonatomic,strong)  NSMutableDictionary *dataList;
@property (nonatomic,strong)  NSMutableArray *cuantosTipos;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynth;
@property (nonatomic, strong) AVSpeechUtterance *utterance;
@property int cuantosTiposInt;

@end
