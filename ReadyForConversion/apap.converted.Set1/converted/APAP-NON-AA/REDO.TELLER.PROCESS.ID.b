SUBROUTINE REDO.TELLER.PROCESS.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to check the ID value for the table REDO.TELLER.PROCESS
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.TELLER.PROCESS.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 10.05.2010      SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.LOCKING
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.REDO.TELLER.PROCESS = 'F.REDO.TELLER.PROCESS'
    F.REDO.TELLER.PROCESS = ''
    CALL OPF(FN.REDO.TELLER.PROCESS,F.REDO.TELLER.PROCESS)

    LOCK.FLUSH=''

RETURN
*----------------------------------------------------------------------------
PROCESS:

    LOCK.ID = FN.REDO.TELLER.PROCESS
    IF V$FUNCTION EQ 'I' THEN
        R.LOCKING = ''
        LOCK.ERR = ''
        CALL F.READU(FN.LOCKING,LOCK.ID,R.LOCKING,F.LOCKING,LOCK.ERR,'')
        Y.CONTENT = R.LOCKING<EB.LOK.CONTENT>
        Y.REMARK =R.LOCKING<EB.LOK.REMARK>
        IF Y.CONTENT EQ '' THEN
            Y.SEQ='001'
            ID.NEW='TT':TODAY:Y.SEQ
            R.LOCKING<EB.LOK.CONTENT> = ID.NEW
            R.LOCKING<EB.LOK.REMARK> = TODAY
            CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
        END ELSE
            LOCATE TODAY IN Y.REMARK SETTING POS ELSE
                Y.SEQ='001'
                ID.NEW='TT':TODAY:Y.SEQ
                R.LOCKING<EB.LOK.CONTENT> = ID.NEW
                R.LOCKING<EB.LOK.REMARK> = TODAY
                CALL F.WRITE(FN.LOCKING,LOCK.ID,R.LOCKING)
            END
        END
    END
RETURN
*------------------------------------------------------------------------------
END
