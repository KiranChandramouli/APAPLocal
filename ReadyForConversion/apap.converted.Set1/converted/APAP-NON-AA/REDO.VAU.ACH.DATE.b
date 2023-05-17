SUBROUTINE REDO.VAU.ACH.DATE
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH
* PROGRAM NAME : REDO.VAU.ACH.DATE
*----------------------------------------------------------


* DESCRIPTION :  Routine responsible for identifying whether
*                it is an ACH transaction, and if that is the cases,
*                assign in the local field L.FT.ACH.DATE, the date
*                when the transaction should be sent to ACH
*                The routine takes into account the value date and
*                cut-off time to determine whether the transaction must
*                be sent the same day or the next working day

*                On the other hand, it must feed the concat file
*                REDO.ACH.DATE with the id of the transaction of T24,
*                for the record which id corresponds to the date of shipment
*                to ACH. Additionally, this routine should consider maintaining
*                the concat file in the event that the transactions are reverseds

*------------------------------------------------------------

*    LINKED WITH :
*    IN PARAMETER:
*    OUT PARAMETER:

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.08.2010      GANESH R               ODR-2009-12-0290   INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_F.REDO.ACH.DATE

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
*********
INIT:
*********
*Initialising
    LOC.APPLICATION = 'FUNDS.TRANSFER'
    LOC.FIELDS = 'L.FT.ACH.DATE'
    LOC.POS = ''
    POS = ''
    DUP.POS = ''
RETURN
*-------------------------------------------------------------
************
OPENFILES:
************
*Opening File
    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'
    F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INT.PARAM = ''
    CALL OPF(FN.REDO.INT.PARAM,F.REDO.INT.PARAM)

    FN.REDO.ACH.DATE = 'F.REDO.ACH.DATE'
    F.REDO.ACH.DATE = ''
    CALL OPF(FN.REDO.ACH.DATE,F.REDO.ACH.DATE)
    R.REDO.ACH.DATE = ''

    FN.REDO.DUP.ACH.DATE = 'F.REDO.DUP.ACH.DATE'
    F.REDO.DUP.ACH.DATE = ''
    CALL OPF(FN.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE)
    R.REDO.DUP.ACH.DATE = ''

RETURN
*------------------------------------------------------------------------------------------------------------
*********
PROCESS:
**********
*Getting the Local Reference position
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    LOC.ACH.DATE.POS = LOC.POS<1,1>

*Getting the Transaction Type and check for the entry in ACH Param table
    VAR.FT.TXN.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,ERR.ACH.PARAM)
    IF R.REDO.ACH.PARAM THEN
        PARAM.TXN.TYPE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.TYPE>
    END

    CHANGE @VM TO @FM IN PARAM.TXN.TYPE
    LOCATE VAR.FT.TXN.TYPE IN PARAM.TXN.TYPE SETTING FT.POS THEN

*Getting the Record Status and checking for reverse transaction or not

        VAR.REC.STATUS = R.NEW(FT.RECORD.STATUS)
        IF VAR.REC.STATUS EQ 'RNAU' OR  V$FUNCTION EQ 'R' THEN
            GOSUB REVERSE.TXN
        END ELSE
            GOSUB NORMAL.TXN
        END

    END

RETURN
*------------------------------------------------------------------------------------------------------------
****************
NORMAL.TXN:
****************
*Getting the Debit value date and comparing with the Today
    VAR.DEBIT.VALUE.DATE = R.NEW(FT.DEBIT.VALUE.DATE)
    IF VAR.DEBIT.VALUE.DATE GT TODAY THEN
        R.NEW(FT.LOCAL.REF)<1,LOC.ACH.DATE.POS> = VAR.DEBIT.VALUE.DATE
    END

    IF VAR.DEBIT.VALUE.DATE LT TODAY THEN
        R.NEW(FT.LOCAL.REF)<1,LOC.ACH.DATE.POS> = TODAY
    END

    IF VAR.DEBIT.VALUE.DATE EQ TODAY THEN
        GOSUB CHECK.CUT.OFF.TIME
    END

    VAR.TXN.ID = R.NEW(FT.LOCAL.REF)<1,LOC.ACH.DATE.POS>
    CALL F.READU(FN.REDO.ACH.DATE,VAR.TXN.ID,R.REDO.ACH.DATE,F.REDO.ACH.DATE,Y.ERR.ACH.DATE,'')
    LOCATE ID.NEW IN R.REDO.ACH.DATE SETTING POS ELSE
        R.REDO.ACH.DATE<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.ACH.DATE,VAL.ACH.DATE,R.REDO.ACH.DATE)
    END

    CALL F.READU(FN.REDO.DUP.ACH.DATE,VAR.TXN.ID,R.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE,REDO.DUP.ACH.DATE.ERR,'')
    LOCATE ID.NEW IN R.REDO.DUP.ACH.DATE SETTING DUP.POS ELSE
        R.REDO.DUP.ACH.DATE<-1> = ID.NEW
        CALL F.WRITE(FN.REDO.DUP.ACH.DATE,VAR.TXN.ID,R.REDO.DUP.ACH.DATE)
    END

RETURN
*------------------------------------------------------------------------------------------------------------
*********************
CHECK.CUT.OFF.TIME:
*********************
*Get the cut-off time, this is in the field REP.TIME.RANGE of table REDO.ACH.PARAM, record 'ACH001'
    ACH.PARAM.ID = 'ACH001'
    VAR.NEXT.WORK.DAY=R.DATES(EB.DAT.NEXT.WORKING.DAY)
    CALL CACHE.READ(FN.REDO.INT.PARAM,ACH.PARAM.ID,R.REDO.INT.PARAM,ACH.PARAM.ERR)
    VAR.CUT.OFF.TIME = R.REDO.INT.PARAM<REDO.INT.PARAM.REP.TIME.RANGE>
    VAR.CUT.HR = VAR.CUT.OFF.TIME[1,2]
    VAR.CUT.MIN = VAR.CUT.OFF.TIME[3,2]
    LOC.TIME = TIMEDATE()
    LOC.HR = LOC.TIME[1,2]
    LOC.MIN = LOC.TIME[4,2]
    VAR.CUT.TOT.MIN = (VAR.CUT.HR*60) + VAR.CUT.MIN
    VAR.LOC.TOT.MIN = (LOC.HR * 60) + LOC.MIN
    IF VAR.LOC.TOT.MIN LE VAR.CUT.TOT.MIN THEN
        R.NEW(FT.LOCAL.REF)<1,LOC.ACH.DATE.POS> = TODAY
    END
    IF VAR.LOC.TOT.MIN GT VAR.CUT.TOT.MIN THEN
        R.NEW(FT.LOCAL.REF)<1,LOC.ACH.DATE.POS> = VAR.NEXT.WORK.DAY
    END
RETURN
*------------------------------------------------------------------------------------------------------------
REVERSE.TXN:

    VAL.ACH.DATE = R.NEW(FT.LOCAL.REF)<1,LOC.ACH.DATE.POS>

    CALL F.READU(FN.REDO.ACH.DATE,VAL.ACH.DATE,R.REDO.ACH.DATE,F.REDO.ACH.DATE,DAT.ERR,'')
    IF R.REDO.ACH.DATE THEN
        LOCATE ID.NEW IN R.REDO.ACH.DATE SETTING LOC.POS THEN
            DEL R.REDO.ACH.DATE<LOC.POS>
        END
        CALL F.WRITE(FN.REDO.ACH.DATE,VAL.ACH.DATE,R.REDO.ACH.DATE)
    END

    CALL F.READU(FN.REDO.DUP.ACH.DATE,VAL.ACH.DATE,R.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE,REDO.DUP.ACH.DATE.ERR,'')
    IF R.REDO.DUP.ACH.DATE THEN
        LOCATE ID.NEW IN R.REDO.DUP.ACH.DATE SETTING LOC.POS THEN
            DEL R.REDO.DUP.ACH.DATE<LOC.POS>
        END
        CALL F.WRITE(FN.REDO.DUP.ACH.DATE,VAL.ACH.DATE,R.REDO.DUP.ACH.DATE)
    END

RETURN

END
