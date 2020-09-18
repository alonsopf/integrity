//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//

#import "LeftViewController.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "ViewController.h"
#import "OtherViewController.h"
#import "NuevoClienteViewController.h"
#import "SelectClienteTableViewController.h"
#import "ListaClientesTableViewController.h"
#import "TalonarioTableViewController.h"
#import "FirmaAsociadoViewController.h"
#import "CambiarContrasenaViewController.h"
#import "NavigationController.h"
#import "AppDelegate.h"
@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController
/*
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.titlesArray = @[[defaults valueForKey:@"name"],
                         @"",
                         [defaults valueForKey:@"email"],
                         @"",
                         @"Clientes",
                         @"Nuevo Cliente",
                         @"Pedidos",
                         @"Nuevo Pedido",
                         @"Music"];
    
    [self.tableView reloadData];
}
 */
-(void)reloadMenu {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.titlesArray = @[[defaults valueForKey:@"name"],
                         @"SINCRONIZAR CON INTERNET",
                         [defaults valueForKey:@"email"],
                         @"",
                         @"Clientes",
                         @"Nuevo Cliente",
                         @"Pedidos",
                         @"Nuevo Pedido",
                         @"Firma ejecutivo",
                         @"Cambiar contraseña",
                         @"Cerrar sesión"] ;
    [self.tableView reloadData];
}
- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
      
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.titlesArray = @[[defaults valueForKey:@"name"],
                             @"SINCRONIZAR CON INTERNET",
                             [defaults valueForKey:@"email"],
                             @"",
                             @"Clientes",
                             @"Nuevo Cliente",
                             @"Pedidos",
                             @"Nuevo Pedido",
                             @"Firma ejecutivo",
                             @"Cambiar contraseña",
                             @"Cerrar sesión"] ;

        self.view.backgroundColor = [UIColor clearColor];

        [self.tableView registerClass:[LeftViewCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
if(indexPath.row==1)
{
//    cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"refresh.png"]];

}
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.separatorView.hidden = (indexPath.row <= 3 || indexPath.row == self.titlesArray.count-1);
    cell.userInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3);

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0;
}
-(BOOL)tieneSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int idGema = [[defaults valueForKey:@"idGema"] intValue];
    if(idGema<0)
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Integrity"
                                     message:@"¡Debes de iniciar sesión primero!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    if (indexPath.row == 2) {//
        if([self tieneSession])
        {
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if(app.hasInternet)
            {
                [app trySincronizarTodo];
                [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
            }
        }
        return;
    }
    if (indexPath.row == 4) {//lista de cliente
        if([self tieneSession])
        {
            ListaClientesTableViewController *viewController = [[ListaClientesTableViewController alloc] initWithNibName:@"ListaClientesTableViewController" bundle:[NSBundle mainBundle]];
            
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        return;
    }
    if (indexPath.row == 5) {//nuevo cliente
        if([self tieneSession])
        {
            NuevoClienteViewController *viewController = [[NuevoClienteViewController alloc] initWithNibName:@"NuevoClienteViewController" bundle:[NSBundle mainBundle]];
            viewController.modo=1;//1 es nuevo cliente!
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        return;
    }
    if (indexPath.row == 6) {//lista de pedidos (talonario)
        if([self tieneSession])
        {
            TalonarioTableViewController *viewController = [[TalonarioTableViewController alloc] initWithNibName:@"TalonarioTableViewController" bundle:[NSBundle mainBundle]];
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        return;
    }
    if (indexPath.row == 7) {//nuevo cliente
        if([self tieneSession])
        {
            SelectClienteTableViewController *viewController = [[SelectClienteTableViewController alloc] initWithNibName:@"SelectClienteTableViewController" bundle:[NSBundle mainBundle]];
            
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        return;
    }
    if (indexPath.row == 8) {//firma ejecutivo
        if([self tieneSession])
        {
            FirmaAsociadoViewController *viewController = [[FirmaAsociadoViewController alloc] initWithNibName:@"FirmaAsociadoViewController" bundle:[NSBundle mainBundle]];
            
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        return;
    }
    if (indexPath.row == 9) {//cambia contraseña
        if([self tieneSession])
        {
            CambiarContrasenaViewController *viewController = [[CambiarContrasenaViewController alloc] initWithNibName:@"CambiarContrasenaViewController" bundle:[NSBundle mainBundle]];
            
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            [navigationController pushViewController:viewController animated:YES];
            
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        return;
    }

    if (indexPath.row == 10) {//cerrar sesión
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"AlreadyRan"];
        [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"idGema"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"desabilita"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"email"];
        NavigationController *navigationController  = (NavigationController*)mainViewController.rootViewController;
        ViewController *viewController = (ViewController*)navigationController.topViewController;
        [viewController  checarSesion];
        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        
        return;
    }
}

@end
