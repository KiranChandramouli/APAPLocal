*-----------------------------------------------------------------------------
* <Rating>-73</Rating>
*-----------------------------------------------------------------------------
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
CHANGE SM TO FM IN Y.L.MG.ACT.NO
IF NOT(Y.L.MG.ACT.NO) THEN
RETURN
END
Y.L.MG.ACT.NO.CNT=DCOUNT(Y.L.MG.ACT.NO,FM)

VAR1=1
LOOP
WHILE VAR1 LE Y.L.MG.ACT.NO.CNT
Y.MSG.DET.ID= Y.L.MG.ACT.NO<VAR1>
GOSUB MORT.DETAIL
Y.OUT.AMT=''

CALL REDO.APAP.GET.OUTSTANDING.AMT(Y.MAT.DATE,ARR.ID,Y.OUT.AMT)
Y.SUM+=Y.OUT.AMT
VAR1++
REPEAT

GOSUB VAL.EXCESS.PERC

RETURN
*----------------------------------------------------------------------
VAL.EXCESS.PERC:
*----------------------------------------------------------------------
* This part to throw the error



GOSUB READ.CPH.PARAMETER
Y.MAT.AMT=''
CALL REDO.APAP.GET.MATURITY.AMT(ID.NEW,Y.MAT.AMT)
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
