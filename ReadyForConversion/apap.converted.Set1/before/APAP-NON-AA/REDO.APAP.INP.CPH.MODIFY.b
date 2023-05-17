*-----------------------------------------------------------------------------
* <Rating>-140</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.APAP.INP.CPH.MODIFY
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.INP.CPH.MODIFY
* ODR NO : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.INP.CPH.MODIFY is an input routine for the version
* AZ.ACCOUNT, MODIFY.CPH which updates the changes made in CPH to table
* REDO.APAP.MORTGAGE.DETAILS




*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: AZ.ACCOUNT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*05.08.2010 H GANESH ODR-2009-10-0346 INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
$INSERT I_F.REDO.APAP.CPH.PARAMETER



GOSUB OPENFILES
GOSUB MULTI.LOC.REF
GOSUB PROCESS

RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
F.REDO.APAP.MORTGAGES.DETAIL=''
CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

FN.ACCOUNT='F.ACCOUNT'
F.ACCOUNT=''
CALL OPF(FN.ACCOUNT,F.ACCOUNT)

FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'

RETURN
*----------------------------------------------------------------------
MULTI.LOC.REF:
*----------------------------------------------------------------------

LOC.REF.APPLICATION="AZ.ACCOUNT"
LOC.REF.FIELDS='L.MG.ACT.NO'
LOC.REF.POS=''
CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
POS.L.MG.ACT.NO=LOC.REF.POS<1,1>
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

Y.OLD.ACCTS=R.OLD(AZ.LOCAL.REF)<1,POS.L.MG.ACT.NO>
Y.NEW.ACCTS=R.NEW(AZ.LOCAL.REF)<1,POS.L.MG.ACT.NO>

CHANGE SM TO FM IN Y.OLD.ACCTS
CHANGE SM TO FM IN Y.NEW.ACCTS
Y.Y.OLD.ACCTS.CNT=DCOUNT(Y.OLD.ACCTS,FM)
Y.MG.IDS=Y.NEW.ACCTS
IF NOT(Y.MG.IDS) THEN
RETURN
END
GOSUB INPUT.FUNCTION
GOSUB DELETE.OR.REVERSE.FUNCTION
RETURN

*----------------------------------------------------------------------
INPUT.FUNCTION:
*----------------------------------------------------------------------

IF V$FUNCTION EQ 'I' THEN
VAR1=1
LOOP
WHILE VAR1 LE Y.Y.OLD.ACCTS.CNT
Y.OLD.ACT = Y.OLD.ACCTS<VAR1>
GOSUB FIND.DELINKED.MGS
VAR1++
REPEAT

GOSUB FIND.LINKED.MGS
END
RETURN

*----------------------------------------------------------------------
DELETE.OR.REVERSE.FUNCTION:
*----------------------------------------------------------------------

IF V$FUNCTION EQ 'D' OR V$FUNCTION EQ 'R' THEN
Y.MG.IDS.CNT=DCOUNT(Y.MG.IDS,FM)
VAR4=1
LOOP
WHILE VAR4 LE Y.MG.IDS.CNT
MG.DET.ID=Y.MG.IDS<VAR4>
GOSUB READ.MORTGAGES.DET
GOSUB CLEAR.DELINKED.MGS
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.LIEN.AMT,POS3>='0.00'
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.BAL.PRINCIPAL>=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.OUTS.PRINCIPLE>
GOSUB WRITE.MORTGAGES.DET
VAR4++
REPEAT
END
RETURN

*----------------------------------------------------------------------
FIND.DELINKED.MGS:
*----------------------------------------------------------------------
LOCATE Y.OLD.ACT IN Y.NEW.ACCTS SETTING POS1 THEN
DEL Y.NEW.ACCTS<POS1>
END ELSE
MG.DET.ID=Y.OLD.ACT
GOSUB READ.MORTGAGES.DET
GOSUB CLEAR.DELINKED.MGS
GOSUB UPD.LIEN.AMT.AND.BAL.PRIN
GOSUB WRITE.MORTGAGES.DET
END
RETURN

*----------------------------------------------------------------------
FIND.LINKED.MGS:
*----------------------------------------------------------------------
Y.Y.NEW.ACCTS.CNT=DCOUNT(Y.NEW.ACCTS,FM)
VAR3=1
LOOP
WHILE VAR3 LE Y.Y.NEW.ACCTS.CNT
MG.DET.ID=Y.NEW.ACCTS<VAR3>
GOSUB READ.MORTGAGES.DET
GOSUB UPD.NEW.MORTGAGE.DET
GOSUB UPD.LIEN.AMT.AND.BAL.PRIN
GOSUB WRITE.MORTGAGES.DET
VAR3++
REPEAT
RETURN

*----------------------------------------------------------------------
READ.MORTGAGES.DET:
*----------------------------------------------------------------------

CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,MG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,MRTG.ERR)
RETURN
*----------------------------------------------------------------------
CLEAR.DELINKED.MGS:
*----------------------------------------------------------------------
Y.DEP.AC.NOS=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO>
CHANGE VM TO FM IN Y.DEP.AC.NOS
LOCATE ID.NEW IN Y.DEP.AC.NOS SETTING POS3 THEN
DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO,POS3>
DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NAME,POS3>
DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.START.DATE,POS3>
DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.END.DATE,POS3>
DEL R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT,POS3>
END
RETURN

*----------------------------------------------------------------------
UPD.NEW.MORTGAGE.DET:
*----------------------------------------------------------------------

Y.DEP.AC.NOS=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO>
CHANGE VM TO FM IN Y.DEP.AC.NOS
LOCATE ID.NEW IN Y.DEP.AC.NOS SETTING POS2 THEN
Y.FLD.VALUE=POS2
END ELSE
Y.FLD.VALUE=DCOUNT(Y.DEP.AC.NOS,FM)+1
END
GOSUB ASSIGN.VALUES
RETURN
*----------------------------------------------------------------------
UPD.LIEN.AMT.AND.BAL.PRIN:
*----------------------------------------------------------------------

Y.PARA.ID='SYSTEM'
CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
Y.EXCESS.PERC=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.EXCESS.PERCENTAGE>
Y.MAT.AMOUNTS=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT>
Y.TOT.MAT=SUM(Y.MAT.AMOUNTS)
Y.LIEN.AMT=Y.TOT.MAT+(Y.TOT.MAT*Y.EXCESS.PERC/100)
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.LIEN.AMT>=Y.LIEN.AMT
Y.BAL.PRINC=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.OUTS.PRINCIPLE>-Y.LIEN.AMT
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.BAL.PRINCIPAL>=Y.BAL.PRINC

RETURN

*----------------------------------------------------------------------
ASSIGN.VALUES:
*----------------------------------------------------------------------
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO,Y.FLD.VALUE>=ID.NEW
GOSUB READ.ACCOUNT
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NAME,Y.FLD.VALUE>=Y.ACT.NAME
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.START.DATE,Y.FLD.VALUE>=R.NEW(AZ.VALUE.DATE)
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.END.DATE,Y.FLD.VALUE>=R.NEW(AZ.MATURITY.DATE)
CALL REDO.APAP.GET.MATURITY.AMT(ID.NEW,Y.MAT.AMT)
R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.MATURITY.AMT,Y.FLD.VALUE>=Y.MAT.AMT

RETURN
*----------------------------------------------------------------------
READ.ACCOUNT:
*----------------------------------------------------------------------
CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
Y.ACT.NAME=R.ACCOUNT<AC.SHORT.TITLE>
RETURN
*----------------------------------------------------------------------
WRITE.MORTGAGES.DET:
*----------------------------------------------------------------------
CALL F.WRITE(FN.REDO.APAP.MORTGAGES.DETAIL,MG.DET.ID,R.REDO.APAP.MORTGAGES.DETAIL)
RETURN
END
