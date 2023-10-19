* @ValidationCode : MjotODIwNTAxMTEwOkNwMTI1MjoxNjg5MjQyMTEyNTEzOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:25:12
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
$PACKAGE APAP.REDOAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion             VM TO @VM
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.INP.BILL.PAYMENT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.BILL.PAYMENT
*--------------------------------------------------------------------------------------------------------
*Description       : This is an INPUT routine, the routine checks if the transaction type is
*                    related to BILL PAYMENTS then validates if the user has entered the company name,
*                    bill.cond, bill type, bill contract no., name, bill amount
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                 Description
*   ------            -----               -------------              -------------
* 22 Dec 2010     Shiva Prasad Y       ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    Y.FLAG = 0
    GOSUB FIND.MULTI.LOCAL.REF
    LOCATE 'BILLPAYMENTCASH' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        GOSUB CHECK.FIELDS
    END

    LOCATE 'BILLPAYMENTCHQ' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        GOSUB CHECK.FIELDS
    END

    LOCATE 'CREDCARDPAYMENT' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        GOSUB CHECK.CC.FIELDS
    END

    LOCATE 'ADMCHQGOVWITTAX' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB CHECK.ADMIN.FIELDS
    END

    LOCATE 'ADMCHQGOVWOTAX' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB CHECK.ADMIN.FIELDS
    END

    LOCATE 'ADMCHQOTHERS' IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        Y.FLAG += 1
        GOSUB CHECK.ADMIN.FIELDS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************
CHECK.FIELDS:
*************

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.CMPNY.ID.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.CMPNY.ID.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.CMPNY.NAME.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.CMPNY.NAME.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BILL.COND.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.BILL.COND.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BILL.TYPE.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.BILL.TYPE.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.BILL.NUM.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.BILL.NUM.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.PARTY.NAME.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.PARTY.NAME.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.BILL.AMT.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TFS.BILL.AMT.POS
        ETEXT = 'EB-INP.MAND.BILLPAYMENT'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.CC.FIELDS:
****************
    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TT.CR.CARD.NO.POS>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TT.CR.CARD.NO.POS
        ETEXT = 'EB-CCARD.INP.MAND'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.ADMIN.FIELDS:
*******************
    IF NOT(R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ADMIN.CHQ.POS,Y.FLAG>) THEN
        AF = TFS.LOCAL.REF
        AV = LOC.L.TFS.ADMIN.CHQ.POS
        AS = Y.FLAG
        ETEXT = 'EB-DRAFT.NO.MAND'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
FIND.MULTI.LOCAL.REF:
********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY = 'L.TT.CMPNY.ID':@VM:'L.TT.CMPNY.NAME':@VM:'L.TT.BILL.COND':@VM:'L.TT.BILL.TYPE':@VM:'L.TT.BILL.NUM':@VM:'L.TT.PARTY.NAME':@VM:'L.TFS.BILL.AMT':@VM:'L.TT.CR.CARD.NO':@VM:'L.TFS.ADMIN.CHQ'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.CMPNY.ID.POS   = FLD.POS<1,1>
    LOC.L.TT.CMPNY.NAME.POS = FLD.POS<1,2>
    LOC.L.TT.BILL.COND.POS  = FLD.POS<1,3>
    LOC.L.TT.BILL.TYPE.POS  = FLD.POS<1,4>
    LOC.L.TT.BILL.NUM.POS   = FLD.POS<1,5>
    LOC.L.TT.PARTY.NAME.POS = FLD.POS<1,6>
    LOC.L.TFS.BILL.AMT.POS  = FLD.POS<1,7>
    LOC.L.TT.CR.CARD.NO.POS = FLD.POS<1,8>
    LOC.L.TFS.ADMIN.CHQ.POS = FLD.POS<1,9>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
