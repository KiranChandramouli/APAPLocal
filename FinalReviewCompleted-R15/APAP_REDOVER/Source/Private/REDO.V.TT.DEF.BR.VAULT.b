* @ValidationCode : MjotMTY0MzM4ODI0ODpDcDEyNTI6MTY4MjQxMjM1NTE0NjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TT.DEF.BR.VAULT
*----------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      F.READ TO CACHE.READ
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.TRANSACTION

    GOSUB INIT
    GOSUB PROCESS

RETURN


*******
INIT:
*******
*
    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER  = ''
    CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION, F.TELLER.TRANSACTION)

    R.TELLER.PARAMETER = ''
    TP.ERR = ''

RETURN

*********
PROCESS:
*********
*
    ID.TRANSACTION = R.NEW(TT.TE.TRANSACTION.CODE)
    Y.AC.L         = R.NEW(TT.TE.ACCOUNT.1)[1,8]
    Y.AC.R         = R.NEW(TT.TE.ACCOUNT.1)[13,4]

    CALL CACHE.READ(FN.TELLER.TRANSACTION, ID.TRANSACTION, R.TELLER.TRANSACTION, TP.ERR)    ;*R22 AUTO CODE CONVERSION


    CALL CACHE.READ(FN.TELLER.PARAMETER, ID.COMPANY, R.TELLER.PARAMETER, TP.ERR)      ;*R22 AUTO CODE CONVERSION

    IF TP.ERR ELSE
        GOSUB POPULATE.TELLER.FIELD
    END

RETURN
*
POPULATE.TELLER.FIELD:
*
    WCAT1         = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.1>
    WCAT2         = R.TELLER.TRANSACTION<TT.TR.CAT.DEPT.CODE.2>
    WVAULTS       = RAISE(R.TELLER.PARAMETER<TT.PAR.TRAN.CATEGORY>)
    WVAULT.BRANCH = R.TELLER.PARAMETER<TT.PAR.VAULT.ID><1,1>

    IF WCAT1 THEN
        GOSUB ANALYZE.CAT.FIELDS
    END ELSE
        IF WCAT2 THEN
*            LOCATE WCAT2 IN WVAULTS<1> SETTING WVAULT.POS THEN
            IF WCAT2 EQ "10011" THEN
                R.NEW(TT.TE.TELLER.ID.2) = WVAULT.BRANCH
*                R.NEW(TT.TE.ACCOUNT.2) = Y.AC.L : WVAULT.BRANCH : Y.AC.R
            END
        END

    END
*
RETURN
*
ANALYZE.CAT.FIELDS:
*
*   LOCATE WCAT1 IN WVAULTS<1> SETTING WVAULT.POS THEN
    IF WCAT1 EQ "10011" THEN
        R.NEW(TT.TE.TELLER.ID.1) = WVAULT.BRANCH
*        R.NEW(TT.TE.ACCOUNT.1) = Y.AC.L : WVAULT.BRANCH : Y.AC.R
    END ELSE
        IF WCAT2 THEN
*            LOCATE WCAT2 IN WVAULTS<1> SETTING WVAULT.POS THEN
            IF WCAT2 EQ "10011" THEN
                R.NEW(TT.TE.TELLER.ID.2) = WVAULT.BRANCH
*                R.NEW(TT.TE.ACCOUNT.2) = Y.AC.L : WVAULT.BRANCH : Y.AC.R
            END
        END
    END
*
RETURN
*
END
