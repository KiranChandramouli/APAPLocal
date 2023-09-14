* @ValidationCode : MjoxMDMzNjk2MDAwOkNwMTI1MjoxNjgzMDI0MzM0OTgxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
