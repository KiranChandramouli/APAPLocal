* @ValidationCode : MjoyNTE0ODE4NDM6Q3AxMjUyOjE3MDM1NjcyNjgxOTM6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Dec 2023 10:37:48
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.UPD.WORK.FILE

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AUTH.UPD.WORK.FILE
*--------------------------------------------------------------------------------
* Description: This routine is for updating local template for the COB preformanace issue
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                  REFERENCE                  DESCRIPTION
* 02-12-2011      Jeeva T           For COB Performance
*05-04-2023    Conversion Tool      R22 Auto Code conversion      FM TO @FM, VM TO @VM, Y.COUNT + 1 TO +=1
*05-04-2023       Samaran T         Manual R22 Code Conversion         No Changes

* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.AZ.ACCOUNT

    GOSUB OPEN.FILE

    BEGIN CASE
        CASE APPLICATION EQ 'ACCOUNT'
            GOSUB PROCESS.FILE
            GOSUB INT.CALC.UPD
        CASE APPLICATION EQ 'AZ.ACCOUNT'
            GOSUB REVIEW.DATE
        CASE APPLICATION EQ 'ACCOUNT.CREDIT.INT'
            GOSUB PROCESS.ACI
        CASE APPLICATION EQ 'GROUP.CREDIT.INT'
            GOSUB PROCESS.GCI
    END CASE

RETURN

*---------------------------------------------------------------------------------
OPEN.FILE:
*---------------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.W.ACCOUNT.UPDATE = 'F.REDO.W.ACCOUNT.UPDATE'
    F.REDO.W.ACCOUNT.UPDATE = ''
    CALL OPF(FN.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE)
    R.REDO.W.ACCOUNT.UPDATE = '' ; Y.FUNCTION = ''

    FN.REDO.W.UPD.REVIEW.ACCT = 'F.REDO.W.UPD.REVIEW.ACCT'
    F.REDO.W.UPD.REVIEW.ACCT = ''
    CALL OPF(FN.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT)

    FN.ACCOUNT.PARAMETER = 'F.ACCOUNT.PARAMETER'
    F.ACCOUNT.PARAMETER = ''
    CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)
    ID.VAR = 'SYSTEM' ;*R22 MANUAL CODE CONVERSION
    CALL CACHE.READ(FN.ACCOUNT.PARAMETER,ID.VAR,R.ACCOUNT.PARAMETER,Y.ERR.AP)
    Y.CAT.DES = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.DESC>
    Y.CAT.ST = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.STR>
    Y.CAT.END = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.END>

    Y.COUNT = 1
    LOOP
    WHILE Y.COUNT LE DCOUNT(Y.CAT.DES,@VM)
        Y.DES.CAT = Y.CAT.DES<1,Y.COUNT>
        Y.STORED = UPCASE(Y.DES.CAT)
        FINDSTR 'SAVING' IN Y.STORED SETTING POS.FM,POS.VM THEN
            Y.CATEGORY.VAL.ST = Y.CAT.ST<1,Y.COUNT>
            Y.CATEGORY.VAL.END = Y.CAT.END<1,Y.COUNT>
        END

        FINDSTR 'CURRENT' IN Y.STORED SETTING POS.FM,POS.VM THEN
            Y.CUR.CATEG.VAL.ST = Y.CAT.ST<1,Y.COUNT>
            Y.CUR.CATEG.VAL.END = Y.CAT.END<1,Y.COUNT>
        END
        Y.COUNT += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT

    LF.APP = 'ACCOUNT':@FM:'AZ.ACCOUNT'
    LF.FLD = 'L.AC.TRANS.INT':@VM:'L.EB.REVIEW':@FM:'L.EB.REVIEW'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    L.AC.TRANS.INT.POS = LF.POS<1,1>
    L.EB.REVIEW.POS = LF.POS<1,2>
    L.EB.REVIEW.POS.1 = LF.POS<2,1>
RETURN
*---------------------------------------------------------------------------------
PROCESS.FILE:
*---------------------------------------------------------------------------------

    Y.CURR = R.NEW(AC.CURR.NO)
    Y.CATEGORY = ''
    Y.OLD.CURRENCY  = R.OLD(AC.CURRENCY)
    Y.CATEGORY = R.NEW(AC.CATEGORY)
    IF (Y.CATEGORY GE Y.CATEGORY.VAL.ST AND Y.CATEGORY LE Y.CATEGORY.VAL.END) OR (Y.CATEGORY GE Y.CUR.CATEG.VAL.ST AND Y.CATEGORY LE Y.CUR.CATEG.VAL.END) THEN
        IF R.OLD(AC.CURRENCY) EQ '' OR R.NEW(AC.CURR.NO) EQ '1' THEN
* CALL F.READ(FN.REDO.W.ACCOUNT.UPDATE,TODAY,R.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE,Y.ERR)
            CALL F.READU(FN.REDO.W.ACCOUNT.UPDATE,TODAY,R.REDO.W.ACCOUNT.UPDATE,F.REDO.W.ACCOUNT.UPDATE,Y.ERR,'');*R22 MANUAL CODE CONVERSION
            LOCATE ID.NEW IN R.REDO.W.ACCOUNT.UPDATE SETTING POS.YR ELSE
                R.REDO.W.ACCOUNT.UPDATE<-1> = ID.NEW
                CALL F.WRITE(FN.REDO.W.ACCOUNT.UPDATE,TODAY,R.REDO.W.ACCOUNT.UPDATE)
            END
        END

        Y.TRANS.ID = APPLICATION
        IF R.NEW(AC.LOCAL.REF)<1,L.EB.REVIEW.POS> EQ 'YES' THEN
            GOSUB INSERT.CONCAT.TABLE
        END
        IF NOT(R.NEW(AC.LOCAL.REF)<1,L.EB.REVIEW.POS>) OR R.NEW(AC.LOCAL.REF)<1,L.EB.REVIEW.POS> EQ 'NO' THEN
            GOSUB DELETE.CONCAT.TABLE
        END
    END
RETURN
*---------------------------------------------------------------------------------
INT.CALC.UPD:
*---------------------------------------------------------------------------------
    Y.TRANS.ID = 'SYSTEM'
    Y.LOCL.REF = R.NEW(AC.LOCAL.REF)<1,L.AC.TRANS.INT.POS>
    IF R.NEW(AC.LOCAL.REF)<1,L.AC.TRANS.INT.POS> THEN
        CALL CACHE.READ(FN.REDO.W.ACCOUNT.UPDATE,Y.TRANS.ID,R.REDO.W.ACCOUNT.UPDATE,Y.ERR)
        LOCATE ID.NEW IN R.REDO.W.ACCOUNT.UPDATE SETTING POS.YR ELSE
            R.REDO.W.ACCOUNT.UPDATE<-1> = ID.NEW
            CALL F.WRITE(FN.REDO.W.ACCOUNT.UPDATE,Y.TRANS.ID,R.REDO.W.ACCOUNT.UPDATE)
        END
    END

RETURN
*---------------------------------------------------------------------------------
REVIEW.DATE:
*---------------------------------------------------------------------------------
    Y.TRANS.ID = APPLICATION
    IF R.NEW(AZ.LOCAL.REF)<1,L.EB.REVIEW.POS.1> EQ 'YES' THEN
        GOSUB INSERT.CONCAT.TABLE
    END
    IF NOT(R.NEW(AZ.LOCAL.REF)<1,L.EB.REVIEW.POS.1>) OR R.NEW(AZ.LOCAL.REF)<1,L.EB.REVIEW.POS.1> EQ 'NO' THEN
        GOSUB DELETE.CONCAT.TABLE
    END
RETURN
*---------------------------------------------------------------------------------
PROCESS.ACI:
*---------------------------------------------------------------------------------
    Y.ACI.ID = ID.NEW

    Y.DATE = FIELD(Y.ACI.ID,"-",2)
    Y.ACCT = FIELD(Y.ACI.ID,"-",1)

    CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    Y.TRANS.ID = "ACI-":Y.DATE

    IF R.ACCOUNT<AC.LOCAL.REF,L.EB.REVIEW.POS> EQ 'YES' THEN
        GOSUB INSERT.CONCAT.TABLE
    END

RETURN
*---------------------------------------------------------------------------------
PROCESS.GCI:
*-----------------------------------------------------------------------------

    Y.GCI.ID = ID.NEW
    Y.GCI.LEN = LEN(Y.GCI.ID)

    Y.START.DTE = Y.GCI.LEN-7
    Y.START.CCY = Y.GCI.LEN-10

    Y.DATE = Y.GCI.ID[Y.START.DTE,8]
    Y.CCY = Y.GCI.ID[Y.START.CCY,3]

    Y.TRANS.ID = "GCI-":Y.CCY:"-":Y.DATE

    GOSUB INSERT.CONCAT.TABLE

****Note: The delete functionality for ACI /GCI was handled in REDO.B.UPDATE.POOL.RATE.POST

RETURN
*----------------------
INSERT.CONCAT.TABLE:
*----------------------
*This concat table updation is used to update the pool rate and eb.profitloss values in REDO.B.UPDATE.POOL.RATE batch
    R.REDO.W.UPD.REVIEW.ACCT = ''
* CALL F.READ(FN.REDO.W.UPD.REVIEW.ACCT,Y.TRANS.ID,R.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT,Y.ERR)
    CALL F.READU(FN.REDO.W.UPD.REVIEW.ACCT,Y.TRANS.ID,R.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT,Y.ERR,'');*R22 MANUAL CODE CONVERSION
    LOCATE ID.NEW IN R.REDO.W.UPD.REVIEW.ACCT SETTING POS.ACCT ELSE
        R.REDO.W.UPD.REVIEW.ACCT<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.W.UPD.REVIEW.ACCT,Y.TRANS.ID,R.REDO.W.UPD.REVIEW.ACCT)
    END
RETURN
*----------------------
DELETE.CONCAT.TABLE:
*----------------------
    R.REDO.W.UPD.REVIEW.ACCT = ''
* CALL F.READ(FN.REDO.W.UPD.REVIEW.ACCT,Y.TRANS.ID,R.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT,Y.ERR)
    CALL F.READU(FN.REDO.W.UPD.REVIEW.ACCT,Y.TRANS.ID,R.REDO.W.UPD.REVIEW.ACCT,F.REDO.W.UPD.REVIEW.ACCT,Y.ERR,'');*R22 MANUAL CODE CONVERSION
    LOCATE ID.NEW IN R.REDO.W.UPD.REVIEW.ACCT SETTING PO THEN
        DEL R.REDO.W.UPD.REVIEW.ACCT<PO>
        CALL F.WRITE(FN.REDO.W.UPD.REVIEW.ACCT,Y.TRANS.ID,R.REDO.W.UPD.REVIEW.ACCT)
    END
RETURN
*----------------------
END
