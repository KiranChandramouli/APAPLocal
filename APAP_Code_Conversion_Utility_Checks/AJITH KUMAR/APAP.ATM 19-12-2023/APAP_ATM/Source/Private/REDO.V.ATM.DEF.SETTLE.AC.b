* @ValidationCode : MjoxNTczMDIyOTM2OkNwMTI1MjoxNzAyNDcyNzk2MzEyOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Dec 2023 18:36:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.ATM

SUBROUTINE REDO.V.ATM.DEF.SETTLE.AC
*-----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          F.READ TO CACHE.READ
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION


***********
INITIALISE:
***********
*
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION, F.TELLER.TRANSACTION)

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER = ''
*CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)

    R.TT.TR   = ''
    TT.TR.ID  = ''
    TT.TR.ERR = ''

    R.TT.TP   = ''
    TT.TR.ID  = ''
    TT.TR.ERR = ''

********
PROCESS:
********
*

*CALL F.READ(FN.TELLER.PARAMETER, ID.COMPANY, R.TT.TP, F.TELLER.TRANSACTION, TT.TP.ERR)
*  Tus Start
    CALL CACHE.READ(FN.TELLER.PARAMETER, ID.COMPANY, R.TT.TP,TT.TP.ERR) ; * Tus End


    TT.TR.ID = R.NEW(TT.TE.TRANSACTION.CODE)
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TT.TR.ID, R.TT.TR, TT.TR.ERR)   ;*R22 AUTO CODE CONVERSION

    CAT.DEPT.CODE.1 = R.TT.TR<TT.TR.CAT.DEPT.CODE.1>
    CAT.DEPT.CODE.2 = R.TT.TR<TT.TR.CAT.DEPT.CODE.2>

    YAC.CCY = COMI[1,3]
    YTILL.ID = COMI[9,4]
    YBRAN.ID = COMI[13,4]

    IF AF EQ TT.TE.ACCOUNT.1 THEN
        LOCATE CAT.DEPT.CODE.1 IN R.TT.TP<TT.PAR.TRAN.CATEGORY,1> SETTING YPOS THEN
            R.NEW(TT.TE.ACCOUNT.2) = YAC.CCY : R.TT.TR<TT.TR.CAT.DEPT.CODE.2> : YTILL.ID : YBRAN.ID
            R.NEW(TT.TE.ACCOUNT.1) = COMI
        END
    END
    IF AF EQ TT.TE.ACCOUNT.2 THEN
        LOCATE CAT.DEPT.CODE.2 IN R.TT.TP<TT.PAR.TRAN.CATEGORY,1> SETTING YPOS THEN
            R.NEW(TT.TE.ACCOUNT.1) = YAC.CCY : R.TT.TR<TT.TR.CAT.DEPT.CODE.1> : YTILL.ID : YBRAN.ID
            R.NEW(TT.TE.ACCOUNT.2) = COMI
        END
    END

    IF MESSAGE EQ "VAL" AND R.NEW(TT.TE.RECORD.STATUS) EQ "IHLD" THEN
        GOSUB ANALISE.HOLD.PROCESS
    END
    IF R.NEW(TT.TE.RECORD.STATUS) EQ "IHLD" AND MESSAGE NE "VAL" THEN
        R.NEW.LAST(TT.TE.ACCOUNT.1) = R.NEW(TT.TE.ACCOUNT.1)
        R.NEW.LAST(TT.TE.ACCOUNT.2) = R.NEW(TT.TE.ACCOUNT.2)
    END
RETURN
*
* ===================
ANALISE.HOLD.PROCESS:
* ===================
*

    IF AF EQ TT.TE.ACCOUNT.1 THEN
        WCAJERO = R.NEW(TT.TE.ACCOUNT.1)[9,4]
        IF WCAJERO EQ R.NEW(TT.TE.TELLER.ID.1) THEN
            R.NEW(TT.TE.ACCOUNT.1) = R.NEW.LAST(TT.TE.ACCOUNT.1)
            R.NEW(TT.TE.ACCOUNT.2) = R.NEW.LAST(TT.TE.ACCOUNT.2)
        END
    END
*
    IF AF EQ TT.TE.ACCOUNT.2 THEN
        WCAJERO = R.NEW(TT.TE.ACCOUNT.2)[9,4]
        IF WCAJERO EQ R.NEW(TT.TE.TELLER.ID.2) THEN
            R.NEW(TT.TE.ACCOUNT.1) = R.NEW.LAST(TT.TE.ACCOUNT.1)
            R.NEW(TT.TE.ACCOUNT.2) = R.NEW.LAST(TT.TE.ACCOUNT.2)
        END
    END
*
RETURN
*
END
