SUBROUTINE REDO.APAP.B.UPD.OUTS.PRINC(MG.ACC.NO)
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.B.UPD.OUTS.PRINC

*--------------------------------------------------------

*DESCRIPTION: REDO.APAP.B.UPD.OUTS.PRINC is a COB routine attached to a
* BATCH BNK/APAP.UPD.OUTS.PRINC. This routine will update the current
* outstanding principal, status of mortgages loan and Balance principal
* on a daily basis in table REDO.APAP.MORTGAGES.DETAILS. It also updates
* current loan status and outstanding principal in REDO.APAP.CPH.DETAIL

*IN PARAMETER: MG.ACC.NO
*OUT PARAMETER: NONE
*LINKED WITH: REDO.APAP.B.UPD.OUTS.PRINC

* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*06.08.2010   H GANESH                ODR-2009-10-0346   INITIAL CREATION

*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_REDO.APAP.B.UPD.OUTS.PRINC.COMMON
    $INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
    $INSERT I_F.REDO.APAP.CPH.DETAIL

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    REDO.APAP.MORTGAGES.DETAILS.ID=MG.ACC.NO
    CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,REDO.APAP.MORTGAGES.DETAILS.ID,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,MRTG.ERR)
    ARR.ID=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.ARR.ID>
    Y.AMT=''
    CALL REDO.APAP.GET.OUTSTANDING.AMT(TODAY,ARR.ID,Y.AMT)
    Y.AMT=ABS(Y.AMT)
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.OUTS.PRINCIPLE>=Y.AMT
    GOSUB GET.CONDITIONS
    Y.STATUS=OVERDUE.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>
    CHANGE @SM TO @FM IN Y.STATUS
    Y.STATUS.CNT=DCOUNT(Y.STATUS,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.STATUS.CNT
        R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.STATUS,VAR1>=Y.STATUS<VAR1>
        VAR1 += 1
    REPEAT
    Y.LIEN.AMT=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.LIEN.AMT>
    Y.BAL=Y.AMT-Y.LIEN.AMT
    R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.BAL.PRINCIPAL>=Y.BAL
    CALL F.WRITE(FN.REDO.APAP.MORTGAGES.DETAIL,REDO.APAP.MORTGAGES.DETAILS.ID,R.REDO.APAP.MORTGAGES.DETAIL)

    GOSUB UPDATE.CPH

RETURN
*-----------------------------------------------------------------------------
GET.CONDITIONS:
*-----------------------------------------------------------------------------


    AA.ID = ARR.ID
    PROP.CLASS='OVERDUE'
    EFF.DATE = ''
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.REC,ERR.MSG)
    OVERDUE.CONDITION=R.REC

RETURN
*-----------------------------------------------------------------------------
UPDATE.CPH:
*-----------------------------------------------------------------------------
    Y.DEP.ACT.NOS=R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.DEP.ACT.NO>
    CHANGE @VM TO @FM IN Y.DEP.ACT.NOS
    CHANGE @FM TO @SM IN Y.STATUS
    Y.DEP.COUNT=DCOUNT(Y.DEP.ACT.NOS,@FM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.DEP.COUNT

        Y.DEP.ID=Y.DEP.ACT.NOS<VAR2>
        GOSUB READ.CPH.DETAIL
        Y.LOAN.ACT.NO=R.REDO.APAP.CPH.DETAIL<CPH.DET.LOAN.ACT.NO>
        CHANGE @VM TO @FM IN Y.LOAN.ACT.NO
        LOCATE MG.ACC.NO IN Y.LOAN.ACT.NO SETTING POS2 THEN

            R.REDO.APAP.CPH.DETAIL<CPH.DET.STATUS,POS2>=Y.STATUS
            R.REDO.APAP.CPH.DETAIL<CPH.DET.OUTS.PRINCIPAL,POS2>=Y.AMT
            CALL F.WRITE(FN.REDO.APAP.CPH.DETAIL,Y.DEP.ID,R.REDO.APAP.CPH.DETAIL)
        END
        VAR2 += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
READ.CPH.DETAIL:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.REDO.APAP.CPH.DETAIL,Y.DEP.ID,R.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL,CPH.ERR)
RETURN

END
