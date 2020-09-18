//
//  Catalogo+CoreDataProperties.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 23/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "Catalogo+CoreDataProperties.h"

@implementation Catalogo (CoreDataProperties)

+ (NSFetchRequest<Catalogo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Catalogo"];
}

@dynamic clave;
@dynamic nombre;
@dynamic tipo;
@dynamic listaColportor;
@dynamic contadoColportor;
@dynamic contadoPublico;
@dynamic creditoPublico;
@dynamic agotado;

@end
