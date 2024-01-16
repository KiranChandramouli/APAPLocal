* @ValidationCode : Mjo4OTQyNDMyODpDcDEyNTI6MTY4MjMzNTk0MzU1NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.USER.SIMULACION
*--------------------------------------------------------------------------------------------------
* Description           : Rutina utilizada para formatear el usuaio INPUTTER
*                         recibe como parametro el usuario y los retorna en formato correcto.
* Developed On          : 16-juan-2019
* Developed By          : Bienvenido Romero
* Development Reference : Para el proceso de monitor req: CI009444
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    Y.USUARIO = COMI
    Y.USUARIO = Y.USUARIO<1,1>
    Y.USUARIO = FIELD(Y.USUARIO, "_",2)
    COMI = Y.USUARIO
RETURN
END
