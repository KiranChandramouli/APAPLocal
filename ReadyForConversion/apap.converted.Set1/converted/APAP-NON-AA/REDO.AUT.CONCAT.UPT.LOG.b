SUBROUTINE REDO.AUT.CONCAT.UPT.LOG
*----------------------------------------------------------------------------
* Description:
* This routine will be attached to the version REDO.ORDER.DETAIL,ORDER.DELEVIRY as
* a input routine
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.V.INP.SERIES.CHECK
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CR.CONTACT.LOG

    GOSUB OPENFILES
    GOSUB PROCESS

OPENFILES:
*-----------------------------------------------------------------------------------------

    FN.CR.CONTACT.LOG  = 'F.CR.CONTACT.LOG'
    F.CR.CONTACT.LOG  = ''
    CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)
    FN.REDO.W.CONTACT.LOG = 'F.REDO.W.CONTACT.LOG'
    F.REDO.W.CONTACT.LOG =''
    CALL OPF(FN.REDO.W.CONTACT.LOG,F.REDO.W.CONTACT.LOG)

RETURN
*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------
    VAR.CONT.CLIENT = R.NEW(CR.CONT.LOG.CONTACT.CLIENT)
    Y.ID = 'CRM-CONCATE':'*':VAR.CONT.CLIENT
    Y.DESCRIPTION = R.NEW(CR.CONT.LOG.CONTACT.TYPE)
    Y.VAL.LIST = 'RECLAMACION':@FM:'SOLICITUD':@FM:'QUEJAS'
    LOCATE Y.DESCRIPTION IN Y.VAL.LIST SETTING POS THEN
        CALL F.READ(FN.REDO.W.CONTACT.LOG,Y.ID,R.REDO.W.CONTACT.LOG,F.REDO.W.CONTACT.LOG,Y.ERR)
        Y.COUNT = DCOUNT(R.REDO.W.CONTACT.LOG,@FM)
        IF Y.COUNT LT 20 THEN
            Y.CNT = Y.COUNT + 1
            R.REDO.W.CONTACT.LOG<Y.CNT> = ID.NEW
            CALL F.WRITE (FN.REDO.W.CONTACT.LOG,Y.ID,R.REDO.W.CONTACT.LOG)
        END
        IF Y.COUNT EQ 20 THEN
            DEL R.REDO.W.CONTACT.LOG<1>
            R.REDO.W.CONTACT.LOG<Y.COUNT> = ID.NEW
            CALL F.WRITE (FN.REDO.W.CONTACT.LOG,Y.ID,R.REDO.W.CONTACT.LOG)
        END
    END
RETURN

END
