* @ValidationCode : MjoxNDkwNTU4NjYwOkNwMTI1MjoxNjgxMTUxNjE4NTUzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE REDO.VAL.RETURN.AMOUNT.INITIAL
*-------------------------------------------------------
*Description: This routine validates the total return amount
*             entered for each cheque.
*-------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, ++ TO += 1
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LOAN.FT.TT.TXN

    GOSUB PROCESS
RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

    Y.FLAG = ''
    Y.OLD.ACCOUNT = R.OLD(LN.FT.TT.DRAWDOWN.ACC)
    Y.NEW.ACCOUNT = R.NEW(LN.FT.TT.DRAWDOWN.ACC)
    Y.VAR1 = 1
    Y.NEW.ACCOUNT.COUNT = DCOUNT(Y.NEW.ACCOUNT,@VM)
    LOOP
    WHILE Y.VAR1 LE Y.NEW.ACCOUNT.COUNT

        IF Y.OLD.ACCOUNT<1,Y.VAR1> NE Y.NEW.ACCOUNT<1,Y.VAR1> THEN
            Y.FLAG = 'YES'
        END

        Y.VAR1 += 1           ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    IF Y.FLAG EQ '' THEN
        AF = LN.FT.TT.DRAWDOWN.ACC
        ETEXT = 'EB-REDO.NO.CHANGE'
        CALL STORE.END.ERROR
    END


RETURN
END
