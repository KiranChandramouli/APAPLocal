* @ValidationCode : Mjo5Nzk1ODE2NTY6Q3AxMjUyOjE2ODA2MDY1NTYxNjE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:39:16
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
SUBROUTINE  REDO.ENQ.CHG.REV(Y.ID.LIST)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ENQ.CHG.REV
*Date              : 13.12.2010
*-------------------------------------------------------------------------
*Description:
*------------
*This is routine is used to REVERSE charge for the balance enquiry.
*This will be attached to field ENQ.CHG.RTN.
*---------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*13/12/2010      saktharrasool@temenos.com    ODR-2010-08-0469          Initial Version
*04-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*04-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*------------------------------------------------------------------------------------
*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE GLOBUS.BP I_F.ACCOUNT
*    $INCLUDE ATM.BP I_AT.ISO.COMMON
*    $INCLUDE TAM.BP I_F.REDO.APAP.H.PARAMETER
*    $INCLUDE GLOBUS.BP I_F.FT.CHARGE.TYPE
*    $INCLUDE ATM.BP I_ATM.BAL.ENQ.COMMON
*    $INCLUDE ATM.BP I_F.ATM.REVERSAL
*    $INCLUDE GLOBUS.BP I_GTS.COMMON
*    $INCLUDE GLOBUS.BP I_F.STMT.ENTRY
*    $INCLUDE GLOBUS.BP I_F.CATEG.ENTRY
*    $INCLUDE GLOBUS.BP I_ENQUIRY.COMMON


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_ATM.BAL.ENQ.COMMON
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_GTS.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_ENQUIRY.COMMON        ;*/ TUS END
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN


*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------
    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER=''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE = ''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    ENQ.ERROR.COM=''
    Y.INC.ISO=AT$INCOMING.ISO.REQ(38)
    Y.CARD.NO=AT$INCOMING.ISO.REQ(2)

    Y.ATM.REV.ID = Y.CARD.NO:'.':Y.INC.ISO
    CALL F.READ(FN.ATM.REVERSAL,Y.ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,Y.ATM.REV.ERR)
    IF R.ATM.REVERSAL NE '' THEN
        GOSUB AC.PROCESS
    END
RETURN

*------------------------------------------------------------------------------------
AC.PROCESS:
*------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,"SYSTEM",R.REDO.APAP.H.PARAMETER,APAP.ERR)
    Y.ENQ.NAME=R.REDO.APAP.H.PARAMETER<PARAM.ENQ.NAME>
    Y.CHR.TYPE=R.REDO.APAP.H.PARAMETER<PARAM.FT.CHARGE.TYPE>
    Y.ATM.ENQ.NAME=R.ATM.REVERSAL<AT.REV.TXN.REF>

    LOCATE Y.ATM.ENQ.NAME IN Y.ENQ.NAME<1,1> SETTING POS.ENQ THEN
        Y.CHR.TYPE = Y.CHR.TYPE<1,POS.ENQ>
        CALL CACHE.READ(FN.FT.CHARGE.TYPE,Y.CHR.TYPE,R.CHARGE.TYPE,CHRG.ERR)
        Y.CHRG.AMT = R.CHARGE.TYPE<FT5.FLAT.AMT>
        GOSUB RAISE.ENTRY
    END

RETURN
*----------------------------------------------------------------------
RAISE.ENTRY:
*----------------------------------------------------------------------

    Y.TXN.CODE.DR       = R.CHARGE.TYPE<FT5.TXN.CODE.DR>
    Y.TXN.CODE.CR       = R.CHARGE.TYPE<FT5.TXN.CODE.CR>
    Y.PL.CATEG          = R.CHARGE.TYPE<FT5.CATEGORY.ACCOUNT>
    Y.ACCT.NO           = AT$INCOMING.ISO.REQ(102)
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCT,F.ACCOUNT,ACC.ERR)

    Y.COM.CODE          = R.ACCT<AC.CO.CODE>
    Y.CUSTOMER          = R.ACCT<AC.CUSTOMER>
    Y.ACCT.OFFICER      = R.ACCT<AC.ACCOUNT.OFFICER>
    Y.PRODUCT.CATEGORY  = R.ACCT<AC.CATEGORY>
    Y.ACC.CUR           = R.ACCT<AC.CURRENCY>
    Y.POS.TYPE          = R.ACCT<AC.POSITION.TYPE>
    Y.CCY.MARKET        = R.ACCT<AC.CURRENCY.MARKET>
    Y.DEPT.CODE         = R.ACCT<AC.DEPT.CODE>

    ID.NEW =  Y.ACCT.NO
    GOSUB RAISE.STMT.ENTRIES

RETURN
*********************
RAISE.STMT.ENTRIES:
*********************
    R.STMT.ARR = ''
    R.STMT.ARR<AC.STE.ACCOUNT.NUMBER>         = Y.ACCT.NO
    R.STMT.ARR<AC.STE.COMPANY.CODE>           = Y.COM.CODE
    R.STMT.ARR<AC.STE.AMOUNT.LCY>             = Y.CHRG.AMT
    R.STMT.ARR<AC.STE.TRANSACTION.CODE>       = Y.TXN.CODE.DR
    R.STMT.ARR<AC.STE.CUSTOMER.ID>            = Y.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER>        = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY>       = Y.PRODUCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE>             = TODAY
    R.STMT.ARR<AC.STE.CURRENCY>               = Y.ACC.CUR
    R.STMT.ARR<AC.STE.OUR.REFERENCE>          = Y.ACCT.NO
    R.STMT.ARR<AC.STE.EXPOSURE.DATE>          = TODAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>        = Y.CCY.MARKET
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>        = Y.DEPT.CODE
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>        = Y.ACCT.NO
    R.STMT.ARR<AC.STE.SYSTEM.ID>              = "ICGC"
    R.STMT.ARR<AC.STE.BOOKING.DATE>           = TODAY

    GOSUB RAISE.CATG.ENTRIES
    GOSUB ACCT.ENTRIES
    GOSUB REVERSE.PROC
RETURN
*----------------------------------------------------------------------
RAISE.CATG.ENTRIES:
*----------------------------------------------------------------------

    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.PL.CATEGORY>          = Y.PL.CATEG
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>         = Y.COM.CODE
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY>           = Y.CHRG.AMT * '-1'
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE>     = Y.TXN.CODE.CR
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID>          = Y.CUSTOMER
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER>      = Y.ACCT.OFFICER
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY>     = Y.PRODUCT.CATEGORY
    R.CATEG.ENT<AC.CAT.VALUE.DATE>           = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY>             = Y.ACC.CUR
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE>        = Y.ACCT.NO
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET>      = Y.CCY.MARKET
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE>      = Y.ACCT.NO
    R.CATEG.ENT<AC.CAT.SYSTEM.ID>            = "ICGC"
    R.CATEG.ENT<AC.CAT.BOOKING.DATE>         = TODAY
    R.CATEG.ENT<AC.CAT.DEPARTMENT.CODE>      = Y.DEPT.CODE
    R.CATEG.ENT<AC.CAT.EXPOSURE.DATE>        = TODAY

RETURN
*----------------------------------------------------------------------
ACCT.ENTRIES:
**************

    MULTI.STMT=''
    MULTI.STMT<-1> = LOWER(R.STMT.ARR)
    MULTI.STMT<-1> = LOWER(R.CATEG.ENT)


    V = 11
    ACCOUNTING.TYPE = ''
    CALL EB.ACCOUNTING.WRAPPER('ICGC','SAO',MULTI.STMT,ACCOUNTING.TYPE,Y.ERR)

RETURN
*----------------------------------------------------------------------
REVERSE.PROC:
**************
    Y.UNIQUE.ID = Y.INC.ISO
    CALL V.FT.UPD.ENQ.ATM.KEY.ID
RETURN          ;*From GET.UNIQUE.ID

END
