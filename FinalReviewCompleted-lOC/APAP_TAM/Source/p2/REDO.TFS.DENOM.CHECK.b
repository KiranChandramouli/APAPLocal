* @ValidationCode : MjotOTgyNjc2NTMxOkNwMTI1MjoxNjgyNjgxOTE5NzAxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 17:08:39
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

*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.TFS.DENOM.CHECK
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.TFS.DENOM.CHECK
*--------------------------------------------------------------------------------
* Description: This Validation routine is to check whether the entered denomination is same as
* Entered transaction amount for TFS
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE          WHO                 REFERENCE        DESCRIPTION
* 08-Apr-2011   H GANESH            PACS00032977     INITIAL CREATION
* 22/05/2013    Vignesh Kumaar R    PACS00289417     DENOMINATION DIFF AMOUNT THOUSAND SEPERATOR
* 28.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 28.04.2023       Shanmugapriya M       R22            Manual Conversion   - FM TO @FM, SM TO @SM
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_T24.FS.COMMON

    IF AF EQ TFS.CR.DEN.UNIT THEN         ;* This part is Credit Side
        GOSUB CHECK.CR.DENOM
    END
    IF AF EQ TFS.DR.DEN.UNIT THEN         ;* This part is Debit Side
        GOSUB CHECK.DR.DENOM
    END
RETURN
*-----------------------------------------------------------------------------
CHECK.CR.DENOM:
*-----------------------------------------------------------------------------
* This part checks whether the Credit denomination entered is correct

    Y.CR.UNIT=R.NEW(TFS.CR.DEN.UNIT)
    Y.CR.DENOM=R.NEW(TFS.CR.DENOM)

    Y.CR.UNIT.LAST=R.NEW(TFS.CR.DEN.UNIT)<1,AV>
    Y.CR.UNIT.CNT.SUB=DCOUNT(Y.CR.UNIT.LAST,@SM)
    IF Y.CR.UNIT.CNT.SUB NE AS THEN       ;* If it triggers for last sub-value set then routine continues
        RETURN
    END
    IF Y.CR.UNIT.LAST AND SUM(Y.CR.UNIT.LAST) ELSE
        RETURN
    END
    LOCATE R.NEW(TFS.CURRENCY)<1,AV> IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS THEN
        CCY.DENOM = TFS$TT.DENOM(CCY.POS)
    END
    Y.FLAG = ''
    TOTAL.UNIT.VALUE=0
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.CR.UNIT.CNT.SUB
        GOSUB CHECK.CR.DENOM1
        Y.VAR1++
    REPEAT

    Y.TRANSACTION.AMOUNT= R.NEW(TFS.AMOUNT)<1,AV>
    CHANGE ',' TO '' IN Y.TRANSACTION.AMOUNT
    IF Y.TRANSACTION.AMOUNT NE TOTAL.UNIT.VALUE THEN
        AF=TFS.CR.DEN.UNIT
        AS=Y.VAR1-1

* Fix for PACS00289417 [DENOMINATION DIFF AMOUNT THOUSAND SEPERATOR #1]

        GET.DENOM.DIFF = TOTAL.UNIT.VALUE - Y.TRANSACTION.AMOUNT
        ETEXT='EB-REDO.DENOM.MISMATCH':@FM:FMT(GET.DENOM.DIFF,'R,2')
        CALL STORE.END.ERROR
        ETEXT=''

* End of Fix

    END ELSE

        OFS$ENRI<TFS.CR.DEN.UNIT,AV,1>    = "TOTAL CAPTURADO " : TRIM(FMT(TOTAL.UNIT.VALUE,'R2,$#19'),' ','B')
    END

RETURN
*------------------------------------------------------------------------
CHECK.CR.DENOM1:
*------------------------------------------------------------------------
* Splitted

    Y.UNIT=Y.CR.UNIT.LAST<1,1,Y.VAR1>
    Y.DENOM=R.NEW(TFS.CR.DENOM)<1,AV,Y.VAR1>
    LOCATE Y.DENOM IN CCY.DENOM<1,1> SETTING CCY.DENOM.POS THEN
        DENOM.VALUE = CCY.DENOM<2,CCY.DENOM.POS>
        TOTAL.UNIT.VALUE+=Y.UNIT * DENOM.VALUE
        Y.VALUE = Y.UNIT * DENOM.VALUE
        IF Y.VALUE THEN

            IF Y.FLAG ELSE
                Y.FLAG = 'YES'
                Y.DEN.POS = Y.VAR1
            END

            OFS$ENRI<TFS.CR.DEN.UNIT> = ''
            OFS$ENRI<TFS.CR.DEN.UNIT,AV,Y.DEN.POS>    = "TOTAL CAPTURADO " : TRIM(FMT(TOTAL.UNIT.VALUE,'R2,$#19'),' ','B')
        END
    END
RETURN
*------------------------------------------------------------------------
CHECK.DR.DENOM:
*------------------------------------------------------------------------
* This part checks whether the Debit denomination entered is correct

    Y.DR.UNIT=R.NEW(TFS.DR.DEN.UNIT)
    Y.DR.DENOM=R.NEW(TFS.DR.DENOM)

    Y.DR.UNIT.LAST=R.NEW(TFS.DR.DEN.UNIT)<1,AV>
    Y.DR.UNIT.CNT.SUB=DCOUNT(Y.DR.UNIT.LAST,@SM)
    IF Y.DR.UNIT.CNT.SUB NE AS THEN       ;* If it triggers for last sub-value set then routine continues
        RETURN
    END

    IF Y.DR.UNIT.LAST AND SUM(Y.DR.UNIT.LAST) ELSE
        RETURN
    END

    LOCATE R.NEW(TFS.CURRENCY)<1,AV> IN TFS$TT.DENOM.CCY<1> SETTING CCY.POS THEN
        CCY.DENOM = TFS$TT.DENOM(CCY.POS)
    END
    Y.FLAG = ''
    TOTAL.UNIT.VALUE=0
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.DR.UNIT.CNT.SUB
        GOSUB CHECK.DR.DENOM1
        Y.VAR1++
    REPEAT

    Y.TRANSACTION.AMOUNT= R.NEW(TFS.AMOUNT)<1,AV>
    CHANGE ',' TO '' IN Y.TRANSACTION.AMOUNT

    IF Y.TRANSACTION.AMOUNT NE TOTAL.UNIT.VALUE THEN
        AF=TFS.DR.DEN.UNIT
        AS=Y.VAR1-1
* Fix for PACS00289417 [DENOMINATION DIFF AMOUNT THOUSAND SEPERATOR #2]

        GET.DENOM.DIFF = TOTAL.UNIT.VALUE - Y.TRANSACTION.AMOUNT
        ETEXT='EB-REDO.DENOM.MISMATCH':@FM:FMT(GET.DENOM.DIFF,'R,2')
        CALL STORE.END.ERROR
        ETEXT=''

* End of Fix

    END ELSE
        OFS$ENRI<TFS.DR.DEN.UNIT,AV,1>    = "TOTAL CAPTURADO " : TRIM(FMT(TOTAL.UNIT.VALUE,'R2,$#19'),' ','B')
    END

RETURN
*-------------------------------------------------
CHECK.DR.DENOM1:
*-------------------------------------------------
* Splitted
    Y.UNIT=Y.DR.UNIT.LAST<1,1,Y.VAR1>
    Y.DENOM=R.NEW(TFS.DR.DENOM)<1,AV,Y.VAR1>

    LOCATE Y.DENOM IN CCY.DENOM<1,1> SETTING CCY.DENOM.POS THEN

        DENOM.VALUE = CCY.DENOM<2,CCY.DENOM.POS>
        TOTAL.UNIT.VALUE += Y.UNIT * DENOM.VALUE
        Y.VALUE = Y.UNIT * DENOM.VALUE
        IF Y.VALUE THEN
            IF Y.FLAG ELSE
                Y.FLAG = 'YES'
                Y.DEN.POS = Y.VAR1
            END
            OFS$ENRI<TFS.DR.DEN.UNIT> = ''
            OFS$ENRI<TFS.DR.DEN.UNIT,AV,Y.DEN.POS>    = "TOTAL CAPTURADO " : TRIM(FMT(TOTAL.UNIT.VALUE,'R2,$#19'),' ','B')
        END
    END

RETURN
END
