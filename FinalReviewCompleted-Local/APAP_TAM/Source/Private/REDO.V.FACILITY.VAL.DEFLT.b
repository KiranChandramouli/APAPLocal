* @ValidationCode : MjoyMDczMDc1NDY0OkNwMTI1MjoxNjgxMTIxMjU0MzkzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 15:37:34
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
SUBROUTINE REDO.V.FACILITY.VAL.DEFLT
*
* Description: Routine to update the L.INV.FACILITY field value from the CATEGORY for the AZ record.
* DEV By: V.P.Ashokkumar
*
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, F TO CACHE
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON                  ;** R22 Auto conversion
    $INSERT I_EQUATE                ;** R22 Auto conversion
    $INSERT I_F.CATEGORY          ;** R22 Auto conversion
    $INSERT I_F.AZ.ACCOUNT             ;** R22 Auto conversion


    GOSUB INIT
    GOSUB PROCESS
RETURN


INIT:
*****
    YTP.CATEG = ''; YTPL.INV.FACILITY = ''; YINV.VAL = ''; LVAL.POSN = ''
    FN.CATEGORY = 'F.CATEGORY'; F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    YFILE.NME = "CATEGORY":@FM:"AZ.ACCOUNT"
    YFIELD.NME = "L.CU.AGE":@FM:"L.INV.FACILITY"
    CALL MULTI.GET.LOC.REF(YFILE.NME,YFIELD.NME,LVAL.POSN)
    L.CU.AGE.POS = LVAL.POSN<1,1>
    L.INV.FACILITY.POS = LVAL.POSN<2,1>
RETURN

PROCESS:
********
    YTP.CATEG = R.NEW(AZ.CATEGORY)
    YTPL.INV.FACILITY = R.NEW(AZ.LOCAL.REF)<1,L.INV.FACILITY.POS>

    ERR.CATEGORY = ''; R.CATEGORY = ''
    CALL CACHE.READ(FN.CATEGORY, YTP.CATEG, R.CATEGORY, ERR.CATEGORY)           ;** R22 Auto conversion - F TO CACHE
    YINV.VAL = R.CATEGORY<EB.CAT.LOCAL.REF,L.CU.AGE.POS>
    IF NOT(YTPL.INV.FACILITY) THEN
        R.NEW(AZ.LOCAL.REF)<1,L.INV.FACILITY.POS> = YINV.VAL
    END
RETURN

END
