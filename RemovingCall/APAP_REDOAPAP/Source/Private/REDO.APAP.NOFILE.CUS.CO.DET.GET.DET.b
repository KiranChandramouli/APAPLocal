* @ValidationCode : MjotMTkzMjk5NDk5ODpDcDEyNTI6MTY4NDgzNjA1MDU3MDpJVFNTOi0xOi0xOjU4NDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 584
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOFILE.CUS.CO.DET.GET.DET(Y.LOAN.ID,Y.ALT.ID,Y.LOAN.STATUS,Y.AMOUNT,Y.LIMIT.ID,Y.LIMIT.AMT,Y.OFFICER,Y.PDT.TYPE,Y.LOAN.NAME,Y.POL.TYPE,Y.CUS.ID,Y.PORTF.NO)
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
*Company Name : APAP Bank
*Developed By : Temenos Application Management
*Program Name : REDO.APAP.NOFILE.CUS.CO.DET.GET.DET
*Date : 23.06.2010
*-----------------------------------------------------------------------------------------------------------------
* Description : This routine is called from REDO.APAP.NOFILE.CUS.CO.DET nofile routine
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In : --N/A--
* Out : Y.ARRAY
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date Name Reference Version
* ------- ---- ---------- --------
* 23/06/2010 Rashmitha M ODR-2009-10-0310 Initial Version
*Modification
* Date                  who                   Reference
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION VM TO @VM AND ! TO *
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.LIMIT
    $INSERT I_F.REDO.CUS.PORTFOLIO.DET
    $INSERT I_F.AA.OFFICERS
*   $INSERT I_F.AA.ARRANGEMENT ;*R22 AUTO CONVERSTION
    $INSERT I_F.AA.CHARGE
    $USING APAP.TAM
*-------------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*-------------------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.CUS.PORTFOLIO.DET ='F.REDO.CUS.PORTFOLIO.DET'
    F.REDO.CUS.PORTFOLIO.DET=''
    CALL OPF(FN.REDO.CUS.PORTFOLIO.DET,F.REDO.CUS.PORTFOLIO.DET)

    FN.LIMIT='F.LIMIT'
    F.LIMIT=''
    CALL OPF(FN.LIMIT,F.LIMIT)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARR.CHARGE='F.AA.ARR.CHARGE'
    F.AA.ARR.CHARGE=''
    CALL OPF(FN.AA.ARR.CHARGE, F.AA.ARR.CHARGE)

RETURN
*-------------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB GET.ALT.ID
    GOSUB GET.LOAN.STATUS
    GOSUB GET.AMOUNT
    GOSUB GET.LIMIT.ID
    GOSUB GET.PRIM.OFFICER
    GOSUB GET.PRODUCT.TYPE
    GOSUB GET.POLICY.TYPE
    GOSUB GET.PORTFOLIO.NO

RETURN
*----------------------------------------------------------------------------------------------------------------------
***********
GET.ALT.ID:
***********

    AA.ID = Y.LOAN.ID
    EFF.DATE = ''
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''

    PROP.CLASS = 'ACCOUNT'
    CALL APAP.TAM.redoCrrGetConditions(AA.ID,EFF.DATE,PROP.CLASS, PROPERTY, R.REC, ERR.MSG)

    IF Y.ALT.ID EQ '@' THEN
        Y.ALT.ID = R.REC<AA.AC.ALT.ID.TYPE>
    END ELSE
        Y.ALT.ID := @VM: R.REC<AA.AC.ALT.ID.TYPE>
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------------
****************
GET.LOAN.STATUS:
****************
    PROP.CLASS = 'OVERDUE'
    CALL APAP.TAM.redoCrrGetConditions(AA.ID,EFF.DATE,PROP.CLASS, PROPERTY, R.REC, ERR.MSG)
    POS.FLD = ''
    CALL MULTI.GET.LOC.REF('AA.PRD.DES.OVERDUE','L.LOAN.STATUS.1':@VM:'L.LOAN.COND',POS.FLD)
    POS.LN.STATUS = POS.FLD<1,1>
    POS.LN.COND = POS.FLD<1,2>

    Y.LN.STATUS = R.REC<AA.OD.LOCAL.REF,POS.LN.STATUS>
    Y.LN.CONDITION = R.REC<AA.OD.LOCAL.REF,POS.LN.COND>

    IF Y.LN.STATUS NE '' AND Y.LN.CONDITION NE '' AND Y.LOAN.STATUS EQ '@' THEN
        Y.LOAN.STATUS=Y.LN.STATUS:',':Y.LN.CONDITION
        RETURN
    END
    IF Y.LN.STATUS NE '' AND Y.LN.CONDITION NE '' AND Y.LOAN.STATUS NE '@' THEN
        Y.LN.STATUS=R.REC<AA.OD.LOCAL.REF,POS.LN.STATUS>
        Y.LN.CONDITION=R.REC<AA.OD.LOCAL.REF,POS.LN.COND>
        Y.LOAN.STATUS:=@VM:Y.LN.STATUS:',':Y.LN.CONDITION
        RETURN
    END
    IF Y.LN.STATUS EQ '' AND Y.LN.CONDITION EQ '' AND Y.LOAN.STATUS EQ '@' THEN
        Y.LOAN.STATUS=''
        RETURN
    END
    IF Y.LN.STATUS EQ '' AND Y.LN.CONDITION EQ '' AND Y.LOAN.STATUS NE '@' THEN
        Y.LOAN.STATUS:=@VM:''
        RETURN
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
***********
GET.AMOUNT:
***********
    PROP.CLASS = 'TERM.AMOUNT'
    CALL APAP.TAM.redoCrrGetConditions(AA.ID,EFF.DATE,PROP.CLASS, PROPERTY, R.REC, ERR.MSG)

    IF Y.AMOUNT EQ '@' THEN
        Y.AMT.FMT = R.REC<AA.AMT.AMOUNT>
        Y.AMOUNT = FMT(Y.AMT.FMT,"R2,#15")
    END ELSE
        Y.AMT.FMT = R.REC<AA.AMT.AMOUNT>
        Y.AMOUNT := @VM: FMT(Y.AMT.FMT,"R2,#15")
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
*************
GET.LIMIT.ID:
*************
    PROP.CLASS = 'LIMIT'
    CALL APAP.TAM.redoCrrGetConditions(AA.ID,EFF.DATE,PROP.CLASS, PROPERTY, R.REC, ERR.MSG)

    IF Y.LIMIT.ID EQ '@' THEN
        Y.LMT.ID = R.REC<AA.LIM.LIMIT.REFERENCE>
        Y.LIMIT.ID = Y.LMT.ID
        GOSUB GET.LIMIT.AMT
    END ELSE
        Y.LMT.ID = R.REC<AA.LIM.LIMIT.REFERENCE>
        Y.LIMIT.ID := @VM: Y.LMT.ID
        GOSUB GET.LIMIT.AMT
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------
**************
GET.LIMIT.AMT:
**************
* Get limit amount
    FN.FILE.NAME=FN.LIMIT
    F.FILE.NAME=F.LIMIT
* Limit amount is null when limit id is null:
    IF NOT(Y.LMT.ID) AND Y.LIMIT.AMT EQ '@' THEN
        Y.LIMIT.AMT=''
        RETURN
    END
    IF NOT(Y.LMT.ID) AND Y.LIMIT.AMT NE '@' THEN
        Y.LIMIT.AMT:=@VM:''
        RETURN
    END
* When limit id is not null:
    SEL.CMD3='SELECT ':FN.LIMIT:' WITH @ID LIKE ':Y.CUS.ID:'...':Y.LMT.ID:'...'
    GOSUB SELECT.CODE

RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
*****************
GET.PRIM.OFFICER:
*****************
    PROP.CLASS = 'OFFICERS'
    CALL APAP.TAM.redoCrrGetConditions(AA.ID,EFF.DATE,PROP.CLASS, PROPERTY, R.REC, ERR.MSG)

    IF Y.OFFICER EQ '@' THEN
        Y.OFFICER = R.REC<AA.OFF.PRIMARY.OFFICER>
    END ELSE
        Y.OFFICER := @VM: R.REC<AA.OFF.PRIMARY.OFFICER>
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------
*****************
GET.PRODUCT.TYPE:
*****************
    CALL F.READ(FN.AA.ARRANGEMENT,Y.LOAN.ID,R.REC,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ER)

    IF Y.PDT.TYPE EQ '@' AND Y.LOAN.NAME EQ '@' THEN
        Y.PDT.TYPE = R.REC<AA.ARR.PRODUCT.GROUP>
        Y.LOAN.NAME = R.REC<AA.ARR.PRODUCT>
    END ELSE
        Y.PDT.TYPE := @VM:R.REC<AA.ARR.PRODUCT.GROUP>
        Y.LOAN.NAME := @VM:R.REC<AA.ARR.PRODUCT>
    END
    R.REC = ''
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------
****************
GET.POLICY.TYPE:
****************
    SEL.CMD3='SSELECT ':FN.AA.ARR.CHARGE:' WITH ID.COMP.1 EQ ':Y.LOAN.ID
    SEL.LIST3=''
    NO.OF.RECS3=''
    Y.SEL.ERR3=''
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NO.OF.RECS3,Y.SEL.ERR3)
    AA.ARR.CHARGE.ID=SEL.LIST3<NO.OF.RECS3>
    ERR.AA.ARR.CHARGE=''
    R.REC=''
    CALL F.READ(FN.AA.ARR.CHARGE,AA.ARR.CHARGE.ID,R.REC,F.AA.ARR.CHARGE,ERR.AA.ARR.CHARGE)
    POS.POL.TYPE = ''
    CALL GET.LOC.REF('AA.PRD.DES.CHARGE','INS.POLICY.TYPE',POS.POL.TYPE)
    IF Y.POL.TYPE EQ '@' THEN
        Y.POL.TYPE=R.REC<AA.CHG.LOCAL.REF,POS.POL.TYPE>
    END ELSE
        Y.POL.TYPE:=@VM:R.REC<AA.CHG.LOCAL.REF,POS.POL.TYPE>
    END

RETURN
*------------------------------------------------------------------------------------------------------------------------------------------
*****************
GET.PORTFOLIO.NO:
*****************
* Get portfolio number
    FN.FILE.NAME=FN.REDO.CUS.PORTFOLIO.DET
    F.FILE.NAME=F.REDO.CUS.PORTFOLIO.DET
    SEL.CMD3='SELECT ':FN.REDO.CUS.PORTFOLIO.DET:' WITH @ID LIKE ':Y.CUS.ID:'...'
    GOSUB SELECT.CODE

RETURN
*------------------------------------------------------------------------------------------------------------------------------------------
************
SELECT.CODE:
************
    SEL.LIST3=''
    NO.OF.RECS3=''
    Y.SEL.ERR3=''
    R.REC=''
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NO.OF.RECS3,Y.SEL.ERR3)
    Y.REC.ID=SEL.LIST3
    CALL F.READ(FN.FILE.NAME,Y.REC.ID,R.REC,F.FILE.NAME,Y.ERR)
    GOSUB GET.FIELD.VAL

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------
**************
GET.FIELD.VAL:
**************
    BEGIN CASE
        CASE FN.FILE.NAME EQ FN.LIMIT ;*--------------------------------------- Get limit amount
            IF Y.LIMIT.AMT EQ '@' THEN
                Y.LIMIT.FMT = R.REC<LI.INTERNAL.AMOUNT>
                Y.LIMIT.AMT= FMT(Y.LIMIT.FMT,"R2,#15")
            END ELSE
                Y.LIMIT.FMT = R.REC<LI.INTERNAL.AMOUNT>
                Y.LIMIT.AMT:=@VM:FMT(Y.LIMIT.FMT,"R2,#15")
            END

        CASE FN.FILE.NAME EQ FN.REDO.CUS.PORTFOLIO.DET ;*--------------------------------------- Get potfolio number
            IF R.REC THEN
                Y.PORTF.NO=R.REC<CUS.PORT.PORTFOLIO.NO>
            END
    END CASE

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------
END
