* @ValidationCode : MjotMTA3ODgzODU0MTpDcDEyNTI6MTY4MDYwNzEyOTMzMDpJVFNTOi0xOi0xOi0xNToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.CONDITION.VH
*=============================================================================
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TO COLLATERAL VEHICULOS
*
*
* Incoming: NA
* Outgoing: NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Date            : 01.10.2013
* Development by  : TAM Latin America
*                    Jorge Valarezo - TAM Latin America
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*=============================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.COLLATERAL.CODE
    $INSERT I_F.USER

    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.COLLATERAL.REA
    $INSERT I_F.REDO.MAX.PRESTAR.VS
*****************************************************************************

    GOSUB INITIALISE
    IF OFS$HOT.FIELD MATCHES 'FABR.YEAR.VS...' THEN
        GOSUB PROCESS
    END


RETURN

* =========
INITIALISE:
* =========

    Y.I =  AV
    Y.VALUE.DATE = R.NEW(REDO.FC.SEC.CREATE.DATE.VS)<1,Y.I>
    Y.BLOCK.NO = COMI
RETURN
* ======
PROCESS:
* ======

*** FECHA CREACION GARANTIA
    Y.VALUE.YEAR = LEFT(Y.VALUE.DATE, 4)
    NUM.YEARS = Y.VALUE.YEAR - Y.BLOCK.NO
    IF Y.VALUE.YEAR AND Y.BLOCK.NO AND NUM.YEARS LE 0 THEN
        R.NEW(REDO.FC.SECURED.VS)<1,Y.I> = 'NUEVO'
    END
    IF Y.VALUE.YEAR AND Y.BLOCK.NO AND NUM.YEARS GT 0 THEN
        R.NEW(REDO.FC.SECURED.VS)<1,Y.I> = 'USADO'
    END
RETURN


END
