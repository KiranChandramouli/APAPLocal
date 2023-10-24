* @ValidationCode : MjoxMjI4MDIxMDI0OkNwMTI1MjoxNjk3MDI5MzA5MjY3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Oct 2023 18:31:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.ATM

SUBROUTINE  REDO.ENQ.CHG(R.ACCT)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ENQ.CHG
*Date              : 13.12.2010
*-------------------------------------------------------------------------
*Description:
*------------
*This is routine is used to raise charge for the balance enquiry.
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
*13/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version

* 13-APR-2023     Conversion tool    R22 Auto conversion       F.READ to CACHE.READ
* 13-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_ATM.BAL.ENQ.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.POSTING.RESTRICT
    $USING APAP.TAM

    GOSUB OPEN.FILES
    GOSUB LOCAL.REF.FIELDS
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

    FN.FT.CHARGE.TYPE='F.FT.CHARGE.TYPE'

RETURN

*------------------------------------------------------------------------------------
LOCAL.REF.FIELDS:
*------------------------------------------------------------------------------------

    LREF.APP = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.AV.BAL'
    LOCAL.REF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)
    L.AC.AV.BAL.POS = LOCAL.REF.POS<1,1>

RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    Y.SYS.ID='SYSTEM'
    ENQ.ERROR.COM=''
* CALL REDO.INIT.CARD.VAL
*  CALL REDO.INIT.ACCT.VAL
    APAP.ATM.redoInitCardVal() ;*Manual R22 conversion
    APAP.ATM.redoInitAcctVal();*Manual R22 conversion

    Y.INC.ISO=AT$INCOMING.ISO.REQ(32)
    Y.INC.ISO = Y.INC.ISO * 1
    IF Y.INC.ISO NE '1' AND ENQ.ERROR.COM EQ '' THEN
        GOSUB AC.PROCESS
    END
RETURN

*------------------------------------------------------------------------------------
AC.PROCESS:
*------------------------------------------------------------------------------------

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,Y.SYS.ID,R.REDO.APAP.H.PARAMETER,APAP.ERR)
    Y.ENQ.NAME=R.REDO.APAP.H.PARAMETER<PARAM.ENQ.NAME>
    Y.CHR.TYPE=R.REDO.APAP.H.PARAMETER<PARAM.FT.CHARGE.TYPE>
    LOCATE ENQ.NAME IN Y.ENQ.NAME<1,1> SETTING POS.ENQ THEN

        Y.CHR.TYPE=Y.CHR.TYPE<1,POS.ENQ>
        CALL CACHE.READ(FN.FT.CHARGE.TYPE,Y.CHR.TYPE,R.CHARGE.TYPE,CHRG.ERR)

* FT5.CURRENCY            FT5.FLAT.AMT
*
        Y.AV.BAL              = R.ACCT<AC.LOCAL.REF,L.AC.AV.BAL.POS>
        Y.CHRG.AMT            = R.CHARGE.TYPE<FT5.FLAT.AMT>
        ENQ.Y.CHRG.AMT=Y.CHRG.AMT
        IF Y.CHRG.AMT GT Y.AV.BAL THEN
            ENQ.ERROR.COM='NO AVAIL BALANCE'
            ISO.RESP='51'
        END ELSE
            GOSUB RAISE.ENTRY
        END
    END
RETURN

*----------------------------------------------------------------------
RAISE.ENTRY:
*----------------------------------------------------------------------



*
    FN.POSTING.RESTRICT = 'F.POSTING.RESTRICT'
    CALL OPF(FN.POSTING.RESTRICT,F.POSTING.RESTRICT)
*

    ID.POST.RESTRICT = R.ACCT<AC.POSTING.RESTRICT>
    CALL CACHE.READ(FN.POSTING.RESTRICT, ID.POST.RESTRICT, R.POSTING.RESTRICT, ER.POSTING.RESTRICT) ;*R22 Auto conversion


    IF R.POSTING.RESTRICT<AC.POS.RESTRICTION.TYPE> EQ 'DEBIT' OR R.POSTING.RESTRICT<AC.POS.RESTRICTION.TYPE> EQ 'ALL' THEN

        BLK.MARK.ACCT = 'TRUE'
    END ELSE
        BLK.MARK.ACCT = 'FALSE'

    END

    IF BLK.MARK.ACCT EQ 'TRUE' THEN

        ENQ.ERROR.COM="EB-POSTING.RESTRICT"
        ISO.RESP=05
        RETURN
    END


    Y.TXN.CODE.DR         = R.CHARGE.TYPE<FT5.TXN.CODE.DR>
    Y.TXN.CODE.CR         = R.CHARGE.TYPE<FT5.TXN.CODE.CR>
    Y.PL.CATEG            = R.CHARGE.TYPE<FT5.CATEGORY.ACCOUNT>

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
    R.STMT.ARR<AC.STE.AMOUNT.LCY>             = Y.CHRG.AMT * '-1'
    R.STMT.ARR<AC.STE.TRANSACTION.CODE>       = Y.TXN.CODE.DR
    R.STMT.ARR<AC.STE.CUSTOMER.ID>            = Y.CUSTOMER
    R.STMT.ARR<AC.STE.ACCOUNT.OFFICER>        = Y.ACCT.OFFICER
    R.STMT.ARR<AC.STE.PRODUCT.CATEGORY>       = Y.PRODUCT.CATEGORY
    R.STMT.ARR<AC.STE.VALUE.DATE>             = TODAY
    R.STMT.ARR<AC.STE.CURRENCY>               = Y.ACC.CUR
    R.STMT.ARR<AC.STE.OUR.REFERENCE>          = Y.ACCT.NO     ;* need to be created
    R.STMT.ARR<AC.STE.EXPOSURE.DATE>          = TODAY
    R.STMT.ARR<AC.STE.CURRENCY.MARKET>        = Y.CCY.MARKET
    R.STMT.ARR<AC.STE.DEPARTMENT.CODE>        = Y.DEPT.CODE
    R.STMT.ARR<AC.STE.TRANS.REFERENCE>        = Y.ACCT.NO     ;*need to be created
    R.STMT.ARR<AC.STE.SYSTEM.ID>              = "AC"          ;*PACS00820160
    R.STMT.ARR<AC.STE.BOOKING.DATE>           = TODAY

    GOSUB RAISE.CATG.ENTRIES
    GOSUB ACCT.ENTRIES

RETURN
*----------------------------------------------------------------------
RAISE.CATG.ENTRIES:
*----------------------------------------------------------------------

    R.CATEG.ENT = ''
    R.CATEG.ENT<AC.CAT.PL.CATEGORY>          = Y.PL.CATEG
    R.CATEG.ENT<AC.CAT.COMPANY.CODE>         = ID.COMPANY
    R.CATEG.ENT<AC.CAT.AMOUNT.LCY>           = Y.CHRG.AMT
    R.CATEG.ENT<AC.CAT.TRANSACTION.CODE>     = Y.TXN.CODE.CR
    R.CATEG.ENT<AC.CAT.CUSTOMER.ID>          = Y.CUSTOMER
    R.CATEG.ENT<AC.CAT.ACCOUNT.OFFICER>      = Y.ACCT.OFFICER
    R.CATEG.ENT<AC.CAT.PRODUCT.CATEGORY>     = Y.PRODUCT.CATEGORY
    R.CATEG.ENT<AC.CAT.VALUE.DATE>           = TODAY
    R.CATEG.ENT<AC.CAT.CURRENCY>             = Y.ACC.CUR
    R.CATEG.ENT<AC.CAT.OUR.REFERENCE>        = Y.ACCT.NO      ;*needs to be created
    R.CATEG.ENT<AC.CAT.CURRENCY.MARKET>      = Y.CCY.MARKET
    R.CATEG.ENT<AC.CAT.TRANS.REFERENCE>      = Y.ACCT.NO      ;*needs to be created
    R.CATEG.ENT<AC.CAT.SYSTEM.ID>            = "AC"           ;*PACS00820160
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
    CALL EB.ACCOUNTING('ICGC','SAO',MULTI.STMT,ACCOUNTING.TYPE)
RETURN
*----------------------------------------------------------------------
END
