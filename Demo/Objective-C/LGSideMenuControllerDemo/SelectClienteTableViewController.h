//
//  SelectClienteTableViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
@interface SelectClienteTableViewController : UITableViewController <UISearchBarDelegate>
@property (nonatomic,strong) IBOutlet UISearchBar *search;
@property (nonatomic,strong)  NSMutableArray *titulosList;
@property (nonatomic,strong)  NSMutableArray *subtituloList;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynth;
@property (nonatomic, strong) AVSpeechUtterance *utterance;

@end
