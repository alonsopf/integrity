//
//  SelectArticulosTableViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 29/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import "CatalagoTableViewController.h"
@interface SelectArticulosTableViewController : UITableViewController <CatalagoTableViewControllerDelegate>
@property (nonatomic,strong)  NSMutableArray *titulosList;
@property (nonatomic,strong)  NSMutableArray *subtituloList;
@property (nonatomic,strong)  NSMutableDictionary *dataList;
@property (nonatomic, strong) AVSpeechSynthesizer *speechSynth;
@property (nonatomic, strong) AVSpeechUtterance *utterance;
@property float total;
@end
