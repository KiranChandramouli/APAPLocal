SUBROUTINE REDO.B.CHQ.UPD.STATUS.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHQ.UPD.STATUS.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : Multi threaded routine used to initialise the variables.

*In  Parameter     :
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 17 OCT 2011        MARIMUTHU S              PACS00146454             Initial Creation
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CHQ.UPD.STATUS.COMMON

    GOSUB OPENFILES

OPENFILES:

    LOC.REF.APPLICATION   = "AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS        = 'L.LOAN.COND'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.COND     =      LOC.REF.POS<1,1>


    FN.REDO.LOAN.CHQ.RETURN = 'F.REDO.LOAN.CHQ.RETURN'
    F.REDO.LOAN.CHQ.RETURN = ''
    CALL OPF(FN.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM, F.REDO.APAP.CLEAR.PARAM)

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

RETURN
END
