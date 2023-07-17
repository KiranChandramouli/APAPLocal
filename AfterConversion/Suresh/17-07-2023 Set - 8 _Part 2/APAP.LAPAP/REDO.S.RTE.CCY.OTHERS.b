$PACKAGE APAP.LAPAP
* @ValidationCode : MjoxMzI1OTY0NzQ1OkNwMTI1MjoxNjg5MzQwNDIzMzk2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:43:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.



SUBROUTINE REDO.S.RTE.CCY.OTHERS(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.USD.AMT
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the currency for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           INCLUDE TO INSERT, BP removed in INSERT file, VM TO @VM, ++ TO +=
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
    $INSERT I_F.REDO.RTE.CUST.CASHTXN ;*R22 Auto Conversion - Start

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
    IF Y.RTE.TXN.CCY NE 'DOP' AND Y.RTE.TXN.CCY NE 'USD' AND Y.RTE.TXN.CCY NE 'EUR' AND Y.RTE.TXN.CCY NE 'GBP' THEN
        Y.OUT = 'SI'
    END ELSE
        Y.OUT = ''
    END

RETURN
*------------------------------------------------------------------------------------
END
