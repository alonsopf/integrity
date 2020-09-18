//
//  Clientes+CoreDataProperties.m
//  Integrity
//
//  Created by Fernando Alonso Pecina on 13/06/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "Clientes+CoreDataProperties.h"

@implementation Clientes (CoreDataProperties)

+ (NSFetchRequest<Clientes *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Clientes"];
}

@dynamic calle;
@dynamic ciudad;
@dynamic colonia;
@dynamic correo;
@dynamic cp;
@dynamic estado;
@dynamic idCliente;
@dynamic nombre;
@dynamic sincronizado;
@dynamic telefono;
@dynamic rfc;

@end
