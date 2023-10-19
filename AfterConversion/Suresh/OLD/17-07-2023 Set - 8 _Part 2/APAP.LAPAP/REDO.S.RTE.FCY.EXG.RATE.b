* @ValidationCode : MjotMTIzMDU2NzEzMjpDcDEyNTI6MTY4OTM0MDUxNTUyOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:45:15
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
$PACKAGE APAP.LAPAP

SUBROUTINE REDO.S.RTE.FCY.EXG.RATE(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :APAP
*Program   Name    :REDO.S.RTE.FCY.EXG.RATE
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the Exchange Rate for RTE form
*
* Date           ref            who                description
* 16-08-2011     New RTE Form   APAP               New RTE Form
*13/07/2023      Conversion tool            R22 Auto Conversion            INCLUDE TO INSERT, BP removed in INSERT file, VM TO @VM, ++ TO +=, F.READ TO CACHE.READ
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

    FN.TFS.TRANSACTION = 'F.TFS.TRANSACTION'
    F.TFS.TRANSACTION  = ''
    CALL OPF(FN.TFS.TRANSACTION,F.TFS.TRANSACTION)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    LRF.APP = "CURRENCY"
    LRF.FIELD = "L.CU.AMLBUY.RT"
    LRF.POS=''
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    L.CU.AMLBUY.RT.POS = LRF.POS<1,1>

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
                    Y.RTE.TXN.CCY = R.TFS.REC<TFS.CURRENCY><1,Y.VAR1>
                    Y.VAR1 += Y.TRANSACTION.CNT
                END
                Y.VAR1 += 1
            REPEAT

    END CASE
    IF Y.RTE.TXN.CCY NE 'DOP' THEN
        R.CURRENCY = ''
        CCY.ERR = ''
        CALL CACHE.READ(FN.CURRENCY, Y.RTE.TXN.CCY, R.CURRENCY, CCY.ERR) ;*R22 Auto Conversion
        IF R.CURRENCY THEN
            Y.OUT = R.CURRENCY<EB.CUR.LOCAL.REF,L.CU.AMLBUY.RT.POS>
        END ELSE
            Y.OUT = ''
        END
    END ELSE
        Y.OUT = ''
    END

RETURN
*------------------------------------------------------------------------------------
END
