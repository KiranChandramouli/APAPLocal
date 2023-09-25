* @ValidationCode : MjotNDg2OTM0NTg0OkNwMTI1MjoxNjg5NzQ0NTcwMzU4OklUU1M6LTE6LTE6MTM4NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Jul 2023 10:59:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1384
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.S.RTE.CCY.GBP(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.USD.AMT
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the CURRENCY for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
*13/07/2023      Conversion tool            R22 Auto Conversion            VM TO @VM, ++ TO +=, INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.TFS.TRANSACTION
    $INSERT I_REDO.DEAL.SLIP.COMMON

    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_F.REDO.RTE.CUST.CASHTXN ;*R22 Auto Conversion - End

    GOSUB INIT

    GOSUB PROCESS
RETURN
*********
INIT:
*********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY  = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.TFS = 'F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.REDO.PAY.TYPE = 'F.REDO.PAY.TYPE'
    F.REDO.PAY.TYPE = ''
    CALL OPF(FN.REDO.PAY.TYPE,F.REDO.PAY.TYPE)

    FN.REDO.RTE.CATEG.POS = 'F.REDO.RTE.CATEG.POSITION'
    F.REDO.RTE.CATEG.POS = ''
    CALL OPF(FN.REDO.RTE.CATEG.POS,F.REDO.RTE.CATEG.POS)

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.FTTC = 'F.FT.TXN.TYPE.CONDITION'
    F.FTTC  = ''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')


RETURN

**************
PROCESS:
*************

    BEGIN CASE

        CASE ID.NEW[1,2] EQ 'TT'
            CALL F.READ(FN.TELLER,ID.NEW,R.TELLER.REC,F.TELLER,TELLER.ERR)
            Y.RTE.TXN.CCY = R.TELLER.REC<TT.TE.CURRENCY.1>

        CASE ID.NEW[1,2] EQ 'FT'
            CALL F.READ(FN.FT,ID.NEW,R.FT.REC,F.FT,FT.ERR)
            Y.RTE.TXN.CCY = R.FT.REC<FT.CREDIT.CURRENCY>

        CASE ID.NEW[1,5] EQ 'T24FS'
            CALL F.READ(FN.TFS,ID.NEW,R.TFS.REC,F.TFS,TFS.ERR)
            Y.TRANSACTION.CODE = R.TFS.REC<TFS.TRANSACTION>

            Y.TRANSACTION.CNT = DCOUNT(Y.TRANSACTION.CODE,@VM)
            Y.VAR1=1
            LOOP
            WHILE Y.VAR1 LE Y.TRANSACTION.CNT
                Y.TRANS = Y.TRANSACTION.CODE<1,Y.VAR1>
                IF Y.TRANS EQ 'CASHDEP' OR Y.TRANS EQ 'FCASHDEP' OR Y.TRANS EQ 'CASHDEPD' THEN
                    Y.RTE.TXN.CCY = R.NEW(TFS.CURRENCY)<1,Y.VAR1>
                    Y.VAR1 += Y.TRANSACTION.CNT
                END
                Y.VAR1 += 1 ;*R22 Auto Conversion
            REPEAT

    END CASE
    IF Y.RTE.TXN.CCY EQ 'GBP' THEN
        Y.OUT = 'SI'
    END ELSE
        Y.OUT = ''
    END

RETURN
*------------------------------------------------------------------------------------
END
