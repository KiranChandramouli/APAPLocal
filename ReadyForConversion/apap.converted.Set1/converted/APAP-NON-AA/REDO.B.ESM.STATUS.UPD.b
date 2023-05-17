SUBROUTINE REDO.B.ESM.STATUS.UPD(Y.REDO.T.MSG.ID)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.ESM.STATUS.UPD
*--------------------------------------------------------------------------------
* Linked with   : None
* In Parameter  : None
* Out Parameter : None
*--------------------------------------------------------------------------------
*Modification History:
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 09 AUG 2011    Prabhu N      PACS00100804      routine for the updating secure message status to UNREAD
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_REDO.B.ESM.STATUS.UPD.COMMON

    GOSUB INIT
RETURN
*------
INIT:
*------
    R.REDO.T.MSG=''
    CALL F.READ(FN.REDO.T.MSG.DET,Y.REDO.T.MSG.ID,R.REDO.T.MSG,F.REDO.T.MSG.DET,ERR)
    Y.ESM.LIST=R.REDO.T.MSG
    Y.ESM.TOT.CNT=DCOUNT(Y.ESM.LIST,@FM)
    Y.ESM.ST.CNT=1
    LOOP
    WHILE Y.ESM.ST.CNT LE Y.ESM.TOT.CNT
        Y.ESM.ID=Y.ESM.LIST<Y.ESM.ST.CNT>
        Y.ESM.ST.CNT += 1
        CALL F.READ(FN.EB.SECURE.MESSAGE,Y.ESM.ID,R.ESM.REC,F.EB.SECURE.MESSAGE,ERR)
        IF NOT(ERR) THEN
            R.ESM.REC<EB.SM.TO.STATUS>='UNREAD'
            CALL F.WRITE(FN.EB.SECURE.MESSAGE,Y.ESM.ID,R.ESM.REC)
        END
    REPEAT
RETURN
END
