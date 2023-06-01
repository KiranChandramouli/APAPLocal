* @ValidationCode : MjoxMTIxMjA0NDkxOkNwMTI1MjoxNjgxMTUxNjE4NjQ1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:38
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
SUBROUTINE REDO.VAL.UTIL.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SRIRAMAN.C
*Program   Name    :REDO.VAL.UTIL.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine is No file routine
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
* ----------------------------------------------------------------------------------
* DATE                  WHO        REF                 DESC
* 14-05-2011            PRABHU     ACCOUNT VI-CR013    Error Logic removed
* 11.04.2023       Conversion Tool    R22             Auto Conversion     - No changes
* 11.04.2023       Shanmugapriya M    R22             Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN

*******
PROCESS:
********

    ACCOUNT.ID = ID.NEW

    APL.ARRAY ='ACCOUNT'
    APL.FLD = 'L.AC.TRANS.LIM'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FLD,FLD.POS)

    LOC.L.AC.TRANS.LIM.POS = FLD.POS<1,1>

    Y.TRANS.LIM = R.NEW(AC.LOCAL.REF)<1,LOC.L.AC.TRANS.LIM.POS>

    IF Y.TRANS.LIM GT 0 THEN
        GOSUB TRANS.INT
    END
    ELSE
        COMI='Y'
    END

RETURN

*********
TRANS.INT:
**********

    COMI = 'N'

RETURN
********************************
END

*END OF PROGRAM
**********************************************
