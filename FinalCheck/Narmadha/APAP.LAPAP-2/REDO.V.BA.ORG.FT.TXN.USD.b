* @ValidationCode : MjotODU1MTA0MjEzOkNwMTI1MjoxNjgyNDMwMDQ0MDIxOklUU1M6LTE6LTE6MjkzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 19:10:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 293
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.BA.ORG.FT.TXN.USD

*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Juan Garcia
* Program Name  : REDO.V.BA.ORG.FT.TXN.USD
*-------------------------------------------------------------------------
* Description: Esta rutina es una copia de REDO.V.BA.ORG.FT.TXN creada para
* trabajar solos desembolsos en Dolares
*
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED, F.READ TO CACHE.READ
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER ;*R22 AUTO CONVERSION END

    GOSUB INIT
    GOSUB PROCESS

RETURN

*====
INIT:
*====
    Y.VERSION.NAME = APPLICATION:PGM.VERSION
    Y.APPLICATION = APPLICATION
    Y.OFS.BDY     = ''
RETURN

*=======
PROCESS:
*=======
    IF APPLICATION EQ 'REDO.FT.TT.TRANSACTION' THEN

        OFSVERSION = ''
        Y.TRANSACTION.TYPE      = R.NEW(FT.TN.TRANSACTION.TYPE)
        Y.DEBIT.ACCT.NO         = R.NEW(FT.TN.DEBIT.ACCT.NO)
        Y.DEBIT.CURRENCY        = R.NEW(FT.TN.DEBIT.CURRENCY)
        Y.DEBIT.VALUE.DATE      = R.NEW(FT.TN.DEBIT.VALUE.DATE)
        Y.DEBIT.THEIR.REF       = R.NEW(FT.TN.DEBIT.THEIR.REF)
        Y.CREDIT.ACCT.NO        = R.NEW(FT.TN.CREDIT.ACCT.NO)
        Y.CREDIT.AMOUNT         = R.NEW(FT.TN.CREDIT.AMOUNT)
        Y.DEBIT.AMOUNT          = R.NEW(FT.TN.DEBIT.AMOUNT)
        Y.CREDIT.CURRENCY       = R.NEW(FT.TN.CREDIT.CURRENCY)
        Y.CREDIT.VALUE.DATE     = R.NEW(FT.TN.CREDIT.VALUE.DATE)
        Y.L.LOAN.COND           = R.NEW(FT.TN.L.LOAN.COND)
        Y.L.LOAN.STATUS.1       = R.NEW(FT.TN.L.LOAN.STATUS.1)
        Y.L.INITIAL.ID          = R.NEW(FT.TN.L.INITIAL.ID)
        Y.CREDIT.THEIR.REF      = ID.NEW

        Y.ACTUAL.VERSION = '' ; Y.NEXT.VERSION = ''; Y.VERSION = '' ; Y.N.VERSION = ''
        Y.ACTUAL.VERSION = R.NEW(FT.TN.L.ACTUAL.VERSIO)
        Y.VERSION = FIELD(Y.ACTUAL.VERSION,',',2)
        Y.NEXT.VERSION   = R.NEW(FT.TN.L.NEXT.VERSION)
        Y.N.VERSION   = FIELD(Y.NEXT.VERSION,',',2)
        REP.CHAR = '?'
        IF Y.VERSION THEN
            Y.L.ACTUAL.VERSIO = 'FUNDS.TRANSFER':REP.CHAR:Y.VERSION
        END
        IF Y.N.VERSION THEN
            Y.L.NEXT.VERSION  = 'FUNDS.TRANSFER':REP.CHAR:Y.N.VERSION
        END

        Y.OFS.BDY = 'TRANSACTION.TYPE::=':Y.TRANSACTION.TYPE:',DEBIT.ACCT.NO::=':Y.DEBIT.ACCT.NO:',DEBIT.AMOUNT::=':Y.DEBIT.AMOUNT:',DEBIT.CURRENCY::=':Y.DEBIT.CURRENCY:',DEBIT.VALUE.DATE::=':Y.DEBIT.VALUE.DATE:',DEBIT.THEIR.REF::=':Y.DEBIT.THEIR.REF:',CREDIT.ACCT.NO::=':Y.CREDIT.ACCT.NO:',CREDIT.AMOUNT::=':Y.CREDIT.AMOUNT:',CREDIT.CURRENCY::=':Y.CREDIT.CURRENCY:',CREDIT.VALUE.DATE::=':Y.CREDIT.VALUE.DATE:',CREDIT.THEIR.REF::=':Y.CREDIT.THEIR.REF
        Y.OFS.BDY :=',L.ACTUAL.VERSIO::=':Y.L.ACTUAL.VERSIO:',L.NEXT.VERSION::=':Y.L.NEXT.VERSION:',L.LOAN.COND::=':Y.L.LOAN.COND:',L.LOAN.STATUS.1::=':Y.L.LOAN.STATUS.1:',L.INITIAL.ID::=':Y.L.INITIAL.ID

        BEGIN CASE
            CASE Y.VERSION.NAME EQ 'REDO.FT.TT.TRANSACTION,L.APAP.TRANS.DOLARES' OR Y.VERSION.NAME EQ 'REDO.FT.TT.TRANSACTION,L.APAP.PART.TRANS.ACH.DOLARES'
                Y.L.FT.COMPANY        = R.NEW(FT.TN.L.FT.COMPANY)
                OFSVERSION = "FUNDS.TRANSFER,":Y.VERSION
                Y.OFS.BDY :=',L.FT.COMPANY::=':Y.L.FT.COMPANY
            CASE 1

        END CASE

        IF OFSVERSION THEN
            GOSUB POST.FT.TXN
        END
    END

RETURN
*===========
POST.FT.TXN:
*===========
    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    Y.USR = OPERATOR
    CALL CACHE.READ(FN.USER, Y.USR, R.USR, ERR.US) ;*R22 AUTO CONVERSION
    OFS.USERNAME = R.USR<EB.USE.SIGN.ON.NAME>
    OFS.PASSWORD = R.USR<EB.USE.PASSWORD>
    Y.OFS.MSG = ''
    Y.OFS.MSG = OFSVERSION:'/I/PROCESS,':OFS.USERNAME:'/':OFS.PASSWORD:'/':ID.COMPANY:',,':Y.OFS.BDY

    ofsRequest = Y.OFS.MSG
    CALL ofs.addLocalRequest(ofsRequest,'add',error)
    MSG.OUT = ofsRequest

RETURN

END
