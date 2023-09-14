* @ValidationCode : MjotNTE5NDgyOTI5OkNwMTI1MjoxNjgxMTEwNTAyMTYxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 12:38:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CREDIT.NOSTRO.ACCT(CHQ.DETAILS.ID)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CREDIT.NOSTRO.ACCT
*-------------------------------------------------------------------------

* Description :This is batch routine attached to stage "D990" for Expiration of
* Administration cheque Non Government and Government
* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 10-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.TAX
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.REDO.MANAGER.CHQ.DETAILS
    $INSERT I_REDO.B.CREDIT.NOSTRO.ACCT.COMMON



    GOSUB PROCESS
RETURN
************
PROCESS:
************
    EB.ACCT.ERR.MSG = ''
    R.CHQ.DETAILS=''
    CALL F.READ(FN.REDO.MANAGER.CHQ.DETAILS,CHQ.DETAILS.ID,R.CHQ.DETAILS,F.REDO.MANAGER.CHQ.DETAILS,CHQ.ERR)
    GOSUB ACCT.ENTRIES
RETURN
**************
ACCT.ENTRIES:
**************
*Raising Credit Entry
    Y.ACCOUNT.NO=R.CHQ.DETAILS<MAN.CHQ.DET.ISSUE.ACCOUNT>
    Y.AMOUNT=R.CHQ.DETAILS<MAN.CHQ.DET.AMOUNT>
    Y.ID = CHQ.DETAILS.ID
* Y.ISSUE.ACCOUNT=R.CHQ.DETAILS<MAN.CHQ.DET.ISSUE.ACCOUNT>
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUSTOMER=R.ACCOUNT<AC.CUSTOMER>
    Y.ACCT.OFFICER=R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.CATEGORY=R.ACCOUNT<AC.CATEGORY>
    Y.CURR=R.ACCOUNT<AC.CURRENCY>
    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER> =  Y.ACCOUNT.NO
    R.STMT.ARR<AC.STE.COMPANY.CODE> = ID.COMPANY
    R.STMT.ARR<AC.STE.AMOUNT.LCY> = Y.AMOUNT
    R.STMT.ARR<AC.STE.TRANSACTION.CODE> = 213
    R.STMT.ARR<AC.STE.THEIR.REFERENCE> = CHQ.DETAILS.ID
    R.STMT.ARR<AC.STE.CUSTOMER.ID> = Y.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY> = Y.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ARR<AC.STE.CURRENCY> = Y.CURR
    R.STMT.ARR<AC.STE.OUR.REFERENCE> = CHQ.DETAILS.ID
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>= CHQ.DETAILS.ID
    R.STMT.ARR<AC.STE.SYSTEM.ID> = "CHQ"
    R.STMT.ARR<AC.STE.BOOKING.DATE> = TODAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET> = "1"
    R.STMT.ARR<AC.STE.EXPOSURE.DATE> = TODAY
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>

    MULTI.STMT=''
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    GOSUB RAISE.CATG.ENTRIES


    CALL EB.ACCOUNTING("BM.CRCD.MERCH.UPLOAD","SAO",MULTI.STMT,'')

RETURN
*-------------------------------------------------------------------------
RAISE.CATG.ENTRIES:
*~~~~~~~~~~~~~~~~~~
*Raising CATEG ENTRY



    LOCATE  Y.ACCOUNT.NO IN R.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT,1> SETTING POS THEN
        Y.COMM.TYPE = R.CHQ.PARAM<MAN.CHQ.PRM.TAX.KEY,POS>
        CALL F.READ(FN.FT.COM.TYPE,Y.COMM.TYPE,R.COMM.TYPE,F.FT.COM.TYPE,COMM.ERR)
        Y.TAX = R.COMM.TYPE<FT4.TAX.CODE>
    END

    SEL.TAX = 'SSELECT ':FN.TAX:' WITH @ID LIKE ':Y.TAX:'...'
    CALL EB.READLIST(SEL.TAX,SEL.TAX.LIST,'',NOR,ERR.1)
    Y.TAX.KEY = SEL.TAX.LIST<NOR>

    CALL F.READ(FN.TAX,Y.TAX.KEY,R.TAX,F.TAX,TAX.ERR)
    Y.PL.CATEG=R.TAX<EB.TAX.CATEGORY>
    TAX.TXN.CODE = R.TAX<EB.TAX.TR.CODE.DR>

    R.STMT.ENT = ''
    ACCOUNT.NO = Y.CURR:Y.PL.CATEG:"0001"

    R.STMT.ENT<AC.STE.ACCOUNT.NUMBER> =ACCOUNT.NO
    R.STMT.ENT<AC.STE.COMPANY.CODE>=ID.COMPANY
    R.STMT.ENT<AC.STE.AMOUNT.LCY> = -1 * Y.AMOUNT
    R.STMT.ENT<AC.STE.TRANSACTION.CODE> = TAX.TXN.CODE
    R.STMT.ENT<AC.STE.ACCOUNT.OFFICER> = Y.ACCT.OFFICER
    R.STMT.ENT<AC.STE.CUSTOMER.ID> = Y.CUSTOMER
    R.STMT.ENT<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ENT<AC.STE.PRODUCT.CATEGORY> = Y.CATEGORY
    R.STMT.ENT<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ENT<AC.STE.CURRENCY> = Y.CURR
    R.STMT.ENT<AC.STE.EXCHANGE.RATE> = ''
    R.STMT.ENT<AC.STE.CURRENCY.MARKET> = "1"
    R.STMT.ENT<AC.STE.TRANS.REFERENCE> = CHQ.DETAILS.ID
    R.STMT.ENT<AC.STE.SYSTEM.ID> = "TX.CR"
    R.STMT.ENT<AC.STE.BOOKING.DATE> = TODAY
    R.STMT.ENT<AC.STE.NARRATIVE> ='CR.TAX.COMM'

    MULTI.STMT<-1> = LOWER(R.STMT.ENT)


RETURN
**************************************************************************************************
END
