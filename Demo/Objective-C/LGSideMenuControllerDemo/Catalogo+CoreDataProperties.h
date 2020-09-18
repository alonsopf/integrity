//
//  Catalogo+CoreDataProperties.h
//  Integrity
//
//  Created by Fernando Alonso Pecina on 23/05/17.
//  Copyright © 2017 Grigory Lutkov. All rights reserved.
//

#import "Catalogo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Catalogo (CoreDataProperties)

+ (NSFetchRequest<Catalogo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *clave;
@property (nullable, nonatomic, copy) NSString *nombre;
@property (nonatomic) int16_t tipo;
@property (nonatomic) float listaColportor;
@property (nonatomic) float contadoColportor;
@property (nonatomic) float contadoPublico;
@property (nonatomic) float creditoPublico;
@property (nonatomic) int16_t agotado;

@end

NS_ASSUME_NONNULL_END
