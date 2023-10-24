* @ValidationCode : MjoxMDYxOTk0NDMzOkNwMTI1MjoxNjgwNzE4ODA2MjM4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:50:06
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
SUBROUTINE REDO.GET.CHRG.AMT(Y.CCY,Y.FT.CHRG.TYPE,Y.AMT)
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :H GANESH
*  Program   Name    :REDO.GET.CHRG.AMT
***********************************************************************************
*Description: This routine is to calculate the charge amount from FT type



*****************************************************************************
*linked with: NA
*In parameter: Y.CCY ,Y.FT.CHRG.TYPE
*Out parameter: Y.AMT
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   H GANESH       ODR-2010-08-0469  INITIAL CREATION
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - F TO CACHE
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CURRENCY
    $INSERT I_F.FT.CHARGE.TYPE




    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------
INIT:
*---------------------------------------------------

    FN.FT.CHARGE.TYPE='F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE=''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)


RETURN

*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    CALL CACHE.READ(FN.FT.CHARGE.TYPE, Y.FT.CHRG.TYPE, R.FT.CHARGE.TYPE, FT.ERR)      ;** R22 Auto conversion - F TO CACHE
    LOCATE Y.CCY IN R.FT.CHARGE.TYPE<FT5.CURRENCY,1> SETTING POS.CHG THEN
        Y.AMT=R.FT.CHARGE.TYPE<FT5.FLAT.AMT,POS.CHG>
    END
RETURN

END
