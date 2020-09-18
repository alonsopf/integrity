//
//  ListaClientesTableViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 01/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListaClientesTableViewController : UITableViewController<UISearchBarDelegate>

@property (nonatomic,strong) IBOutlet UISearchBar *search;
@property (nonatomic,strong)  NSMutableArray *titulosList;
@property (nonatomic,strong)  NSMutableArray *subtituloList;

@end
