SUBROUTINE REDO.REINV.FT.REVERSE
*----------------------------------------------------------------
* Description: This routine is to auto default the values for reversal.



*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE           DESCRIPTION
* 14-Jul-2011     H Ganesh    PACS00072695 - N.11   Initial Draft.


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TEMP.VERSION.IDS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------


    Y.ID = APPLICATION:PGM.VERSION
    CALL CACHE.READ(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION,TEMP.ERR)

    IF R.REC.TEMP.VERSION EQ '' THEN
        R.REC.TEMP<REDO.TEM.AUT.TXN.ID> = ID.NEW
        R.REC.TEMP<REDO.TEM.PROCESS.DATE> = TODAY
        CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP)
    END ELSE
        LOCATE ID.NEW IN R.REC.TEMP.VERSION<REDO.TEM.AUT.TXN.ID,1> SETTING POS.ID ELSE
            Y.TXN.ID = R.REC.TEMP.VERSION<REDO.TEM.AUT.TXN.ID>
            Y.CNT = DCOUNT(Y.TXN.ID,@VM)
            R.REC.TEMP.VERSION<REDO.TEM.AUT.TXN.ID,Y.CNT+1> = ID.NEW
            R.REC.TEMP.VERSION<REDO.TEM.PROCESS.DATE,Y.CNT+1> = TODAY
            CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.ID,R.REC.TEMP.VERSION)
        END
    END

RETURN
END
