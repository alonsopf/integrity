//
//  RevisarViewController.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 31/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScroll.h"
@interface RevisarViewController : UIViewController<UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MyScroll *scroll;
@property (strong, nonatomic) IBOutlet UILabel *clienteLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *loDemasLabel;
@property (nonatomic,strong)  NSMutableDictionary *dataList;


//proposito general
@property int wGlobal;
@property int hGlobal;

@end
