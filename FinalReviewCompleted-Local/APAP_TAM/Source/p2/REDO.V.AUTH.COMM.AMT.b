* @ValidationCode : MjoxNjg1OTgwMjg3OkNwMTI1MjoxNjg0NDkxMDQzNTk0OklUU1M6LTE6LTE6MTA1OToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1059
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     F.READ TO CACHE.READ
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.AUTH.COMM.AMT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at Auth Level for the Following versions of
* CERTIFIED.CHEQUE.DETAILS,STOP.PAYMENT.This Routine is used
* to calculate the charge amount and also raise the proper accounting entries
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
* Linked : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.AUTH.COMM.AMT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 26.03.2010      SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.CURRENCY
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.TAX='F.TAX'
    F.TAX=''
    CALL OPF(FN.TAX,F.TAX)
    FN.STMT.ENTRY='F.STMT.ENTRY'
    F.STMT.ENTRY=''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    FN.CATEG.ENTRY='F.CATEG.ENTRY'
    F.CATEG.ENTRY=''
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.USER='F.USER'
    F.USER=''
    CALL OPF(FN.USER,F.USER)
    FN.CURRENCY='F.CURRENCY'
    F.CURRENCY=''
    CALL OPF(FN.CURRENCY,F.CURRENCY)
    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    FN.CERTIFIED.CHEQUE.PARAMETER='F.CERTIFIED.CHEQUE.PARAMETER'
    F.CERTIFIED.CHEQUE.PARAMETER=''
    CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)
    FN.CERTIFIED.CHEQUE.DETAILS='F.CERTIFIED.CHEQUE.DETAILS'
    F.CERTIFIED.CHEQUE.DETAILS=''
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
    DIM R.NEW(500)
    FN.CERTIFIED.CHEQUE.DETAILS.NAU='F.CERTIFIED.CHEQUE.DETAILS$NAU'
    F.CERTIFIED.CHEQUE.DETAILS.NAU=''
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS.NAU,F.CERTIFIED.CHEQUE.DETAILS.NAU)
    CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,ID.COMPANY,R.CERT.CHEQ.PARAM,CERT.ERR)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
*Generate Statement and Categ Entries
    Y.WAIVE.STOP.PMT=R.NEW(CERT.DET.WAIVE.STOP.PMT)
    Y.DEBIT.ACCOUNT.NO = R.NEW(CERT.DET.ISSUE.ACCOUNT)
    IF Y.WAIVE.STOP.PMT EQ 'NO' OR Y.WAIVE.STOP.PMT EQ '' THEN
        Y.CHARGE.ID=R.CERT.CHEQ.PARAM<CERT.CHEQ.STOP.PAY.CHARGE>
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE.ID, R.FT.COMMISSION.TYPE, FT.ERR) ;*R22 AUTO CONVERSION
        Y.PL.CATEGORY=R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
        Y.DR.TXN.CODE=R.FT.COMMISSION.TYPE<FT4.TXN.CODE.DR>
        Y.CR.TXN.CODE=R.FT.COMMISSION.TYPE<FT4.TXN.CODE.CR>
* Y.CERT.CHEQ.NO = ID.NEW
        GOSUB DEFAULT.AMOUNT
        GOSUB GENERATE.STMT.ENTRIES
    END
RETURN
*------------------------------------------------------------------------------------
GENERATE.STMT.ENTRIES:
*------------------------------------------------------------------------
*Raise the accounting entries
    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> = Y.DEBIT.ACCOUNT.NO
    R.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    R.STMT.ARR<AC.STE.AMOUNT.LCY> = -1*Y.AMOUNT
    R.STMT.ARR<AC.STE.TRANSACTION.CODE> =Y.DR.TXN.CODE
    R.STMT.ARR<AC.STE.THEIR.REFERENCE>= ID.NEW
    R.STMT.ARR<AC.STE.CUSTOMER.ID> =Y.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = Y.PRODUCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ARR<AC.STE.CURRENCY> = Y.CURR
    R.STMT.ARR<AC.STE.POSITION.TYPE> = 'TR'
    R.STMT.ARR<AC.STE.AMOUNT.FCY> = ''
    R.STMT.ARR<AC.STE.EXCHANGE.RATE>=''
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>='1'
    R.STMT.ARR<AC.STE.OUR.REFERENCE> = ID.NEW
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>= ID.NEW
    R.STMT.ARR<AC.STE.SYSTEM.ID> = "CHQ"
    R.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
    MULTI.STMT=''
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    GOSUB RAISE.CATEG.ENTRIES
    V = CERT.DET.AUDIT.DATE.TIME
    CALL EB.ACCOUNTING("CHQ","SAO",MULTI.STMT,'')
RETURN
*---------------------------------------------------------------------
RAISE.CATEG.ENTRIES:
*---------------------------------------------------------------------
*Raise the catg.entries
    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.ACCOUNT.NUMBER> = ''
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>=ID.COMPANY
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY> = Y.AMOUNT
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE> = Y.CR.TXN.CODE
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER> = Y.ACCT.OFFICER
    R.CATEG.ENT<AC.CAT.PL.CATEGORY> = Y.PL.CATEGORY
    R.CATEG.ENT<AC.CAT.VALUE.DATE> = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY> = LCCY
    R.CATEG.ENT<AC.CAT.POSITION.TYPE> = 'TR'
    R.CATEG.ENT<AC.CAT.EXCHANGE.RATE> = ''
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET> = "1"
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE> = ID.NEW
    R.CATEG.ENT<AC.CAT.SYSTEM.ID> = "CHQ"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE> = TODAY
    MULTI.STMT<-1> = LOWER(R.CATEG.ENT)
RETURN
*----------------------------------------------------------------------------
DEFAULT.AMOUNT:
*------------------------------------------------------------------------------
*Calculate flat amount
    Y.DEFAULT.CCY=R.FT.COMMISSION.TYPE<FT4.DEFAULT.CCY>
    IF Y.DEFAULT.CCY NE '' THEN
        Y.CURRENCY=R.FT.COMMISSION.TYPE<FT4.CURRENCY>
        LOCATE Y.DEFAULT.CCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
            Y.AMOUNT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
        END
    END ELSE
        LOCATE LCCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
            Y.AMOUNT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
        END
    END
    CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCOUNT.NO,R.ACCT,F.ACCOUNT,ACC.ERR)
    Y.CURR = R.ACCT<AC.CURRENCY>
    Y.ACCT.OFFICER = R.ACCT<AC.ACCOUNT.OFFICER>
    Y.PRODUCT.CATEGORY=R.ACCT<AC.CATEGORY>
    Y.CUSTOMER = R.ACCT<AC.CUSTOMER>
RETURN
*-----------------------------------------------------------------------------------
END
