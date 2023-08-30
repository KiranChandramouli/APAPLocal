* @ValidationCode : MjoxNTY2MDg4MjA1OkNwMTI1MjoxNjgwNjAyOTUzNTA5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:39:13
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUT.UPD.MORTGAGE.DET
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.AUT.UPD.MORTGAGE.DET
* ODR NO : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.AUT.UPD.MORTGAGE.DET is an POST routine
* for the TERM.AMOUNT PROPERTY which is used to update
* the table MORTGAGES.DET. This table is updated whenever a mortgage loan
* which has category code defined in CPH.PARAMETER is opened




*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: AA

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*01.08.2010 H GANESH ODR-2009-10-0346 INITIAL CREATION
* Date                   who                   Reference              
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND SM TO @SM AND VAR1++ TO VAR1 += 1
* 04-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.APAP.MORTGAGES.DETAIL


    IF V$FUNCTION EQ 'A' THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB MULTI.GET.REF
        GOSUB PROCESS
    END

RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    R.MORTGAGES.DET=''
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL=''
    CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*----------------------------------------------------------------------
MULTI.GET.REF:
*----------------------------------------------------------------------

    LOC.REF.APPLICATION="AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS='L.LOAN.STATUS.1'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.STATUS.1=LOC.REF.POS<1,1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.RECORD.STATUS= R.NEW(AA.OD.RECORD.STATUS)
    IF Y.RECORD.STATUS EQ 'INAU' THEN
        GOSUB READ.CPH.PARAMTER
        GOSUB CHECK.CATEGORY
    END
    IF Y.RECORD.STATUS EQ 'RNAU' THEN
        ARR.ID=c_aalocArrId
        PROP.CLASS = 'ACCOUNT'
        GOSUB GET.CONDITIONS
        Y.ACCT.NO=R.REC<AA.AC.ACCOUNT.REFERENCE>
        CALL F.DELETE(FN.REDO.APAP.MORTGAGES.DETAIL,Y.ACCT.NO)

    END

RETURN

*----------------------------------------------------------------------
READ.CPH.PARAMTER:
*----------------------------------------------------------------------

    Y.PARA.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
    Y.MG.CATEGORIES=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.MG.CATEGORY>
    CHANGE @VM TO @FM IN Y.MG.CATEGORIES
RETURN

*----------------------------------------------------------------------
CHECK.CATEGORY:
*----------------------------------------------------------------------

    ARR.ID=c_aalocArrId
    PROP.CLASS = 'ACCOUNT'
    GOSUB GET.CONDITIONS
    Y.AA.CATEGORY=R.REC<AA.AC.CATEGORY>
    Y.ACCT.NO=R.REC<AA.AC.ACCOUNT.REFERENCE>
    LOCATE Y.AA.CATEGORY IN Y.MG.CATEGORIES SETTING POS1 THEN
        GOSUB GET.MORTGAGES.DET
        GOSUB UPD.MORTGAGES.DET
    END
RETURN

*----------------------------------------------------------------------
GET.CONDITIONS:
*----------------------------------------------------------------------

    AA.ID = ARR.ID
    EFF.DATE = ''
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.REC,ERR.MSG)
RETURN

*----------------------------------------------------------------------
GET.MORTGAGES.DET:
*----------------------------------------------------------------------

    GOSUB READ.ACCOUNT
    GOSUB READ.AA.ARRANGEMENT
RETURN

*----------------------------------------------------------------------
READ.ACCOUNT:
*----------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.ACT.NAME = R.ACCOUNT<AC.SHORT.TITLE>
RETURN

*----------------------------------------------------------------------
READ.AA.ARRANGEMENT:
*----------------------------------------------------------------------


    PROP.CLASS = 'TERM.AMOUNT'
    GOSUB GET.CONDITIONS
    Y.TERM.AMOUNT.RECORD=R.REC
    Y.STATUS=R.NEW(AA.OD.LOCAL.REF)<1,POS.L.LOAN.STATUS.1>
    Y.MAT.DATE=Y.TERM.AMOUNT.RECORD<AA.AMT.MATURITY.DATE>
    CHANGE @SM TO @FM IN Y.STATUS
    Y.AMT=Y.TERM.AMOUNT.RECORD<AA.AMT.AMOUNT>
RETURN

*----------------------------------------------------------------------
UPD.MORTGAGES.DET:
*----------------------------------------------------------------------

    R.MORTGAGES.DET<MG.DET.LOAN.ACCT.NO>=Y.ACCT.NO
    R.MORTGAGES.DET<MG.DET.ARR.ID>=ARR.ID
    R.MORTGAGES.DET<MG.DET.ACCT.NAME>=Y.ACT.NAME
    Y.STATUS.COUNT=DCOUNT(Y.STATUS,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.STATUS.COUNT
        R.MORTGAGES.DET<MG.DET.STATUS,-1>=Y.STATUS<VAR1>
        VAR1 += 1  ;*R22 AUTO CONVERSTION VAR1++ TO VAR1 += 1
    REPEAT
    R.MORTGAGES.DET<MG.DET.MATURITY.DATE>=Y.MAT.DATE
    R.MORTGAGES.DET<MG.DET.OUTS.PRINCIPLE>=Y.AMT
    R.MORTGAGES.DET<MG.DET.LIEN.AMT>=0
    R.MORTGAGES.DET<MG.DET.BAL.PRINCIPAL>=Y.AMT
    CALL F.WRITE(FN.REDO.APAP.MORTGAGES.DETAIL,Y.ACCT.NO,R.MORTGAGES.DET)
RETURN

END
