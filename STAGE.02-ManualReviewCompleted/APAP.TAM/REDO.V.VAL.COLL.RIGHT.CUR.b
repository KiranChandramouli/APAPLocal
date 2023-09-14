$PACKAGE APAP.TAM
* @ValidationCode : MjoxMDMzNjk2MDAwOkNwMTI1MjoxNjgxODA1NTA3MjA2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 13:41:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

SUBROUTINE REDO.V.VAL.COLL.RIGHT.CUR
 

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.COLL.RIGHT
* Attached as     : ROUTINE
* Primary Purpose : ASSING CURRENCY TO VARIABLE FROM
*                   COLLATERAL
* Incoming:
* ---------


* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : JP Armas - Temenos
* Date            :
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         INCLUDE TO INSERT
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_System

    Y.COLL.CUR = COMI
    CALL System.setVariable("CURRENT.COL.CUR",Y.COLL.CUR)

RETURN
END
