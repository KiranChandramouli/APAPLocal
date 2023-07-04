* @ValidationCode : MjotMzU4NzUzNjM3OkNwMTI1MjoxNjgzMDMwNjg4NTM3OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 18:01:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.CAP.COVER
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.INP.CAP.COVER
* ODR NO : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.INP.CAP.COVER is an input routine for the versions AZ.ACCOUNT,
* OPEN.CPH and AZ.ACCOUNT,MODIFY.CPH which checks if there is inadequate capital cover



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: AZ.ACCOUNT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*27.07.2010 H GANESH ODR-2009-10-0346 INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , SM to @SM, ++ to +=
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL ROUTINE FORMAT CAN BE MODIFIED
*----------------------------------------------------------------------------------------


*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_EB.TRANS.COMMON

    IF cTxn_CommitRequests NE '1' THEN
        RETURN
    END

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB MULTI.GET.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    Y.SUM=''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'
    F.REDO.APAP.CPH.PARAMETER = ''
    CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)

    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL=''
    CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)


RETURN
*----------------------------------------------------------------------
MULTI.GET.REF:
*----------------------------------------------------------------------
* This part gets the local field position in LRT

    LOC.REF.APPLICATION="AZ.ACCOUNT"
    LOC.REF.FIELDS='L.MG.ACT.NO'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.MG.ACT.NO=LOC.REF.POS<1,1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.L.MG.ACT.NO=R.NEW(AZ.LOCAL.REF)<1,POS.L.MG.ACT.NO>
    Y.MAT.DATE=R.NEW(AZ.MATURITY.DATE)
    CHANGE @SM TO @FM IN Y.L.MG.ACT.NO
    IF NOT(Y.L.MG.ACT.NO) THEN
        RETURN
    END
    Y.L.MG.ACT.NO.CNT=DCOUNT(Y.L.MG.ACT.NO,@FM)

    VAR1=1
    LOOP
    WHILE VAR1 LE Y.L.MG.ACT.NO.CNT
        Y.MSG.DET.ID= Y.L.MG.ACT.NO<VAR1>
        GOSUB MORT.DETAIL
        Y.OUT.AMT=''

        CALL APAP.REDOAPAP.redoApapGetOutstandingAmt(Y.MAT.DATE,ARR.ID,Y.OUT.AMT) ;*R22 MANUAL CODE CONVERSION
        Y.SUM+=Y.OUT.AMT
        VAR1 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    GOSUB VAL.EXCESS.PERC

RETURN
*----------------------------------------------------------------------
VAL.EXCESS.PERC:
*----------------------------------------------------------------------
* This part to throw the error



    GOSUB READ.CPH.PARAMETER
    Y.MAT.AMT=''
*CALL APAP.REDOAPAP.REDO.APAP.GET.MATURITY.AMT(ID.NEW,Y.MAT.AMT)  ;*R22 MANUAL CODE CONVERSION
    CALL APAP.REDOAPAP.redoApapGetMaturityAmt(ID.NEW,Y.MAT.AMT)
    Y.DIFF.PER=(Y.SUM-Y.MAT.AMT)*100/Y.MAT.AMT
    IF Y.DIFF.PER LT Y.EXCESS.PERC THEN
        AF=AZ.PRINCIPAL
        ETEXT='EB-REDO.DEP.NOT.COVERED'
        CALL STORE.END.ERROR
    END
RETURN

*----------------------------------------------------------------------
READ.CPH.PARAMETER:
*----------------------------------------------------------------------
* This part to read the PARAMETER Table
    Y.PARA.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
    Y.EXCESS.PERC=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.EXCESS.PERCENTAGE>
RETURN
*----------------------------------------------------------------------
MORT.DETAIL:
*----------------------------------------------------------------------
    CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,Y.MSG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,MRTG.ERR)

    IF R.REDO.APAP.MORTGAGES.DETAIL THEN
        ARR.ID=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.ARR.ID>
    END
RETURN


END
