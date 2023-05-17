SUBROUTINE REDO.ISSUE.CLAIMS.RECORD
*-----------------------------------------------------------------------------
* @author tcoleman@temenos.com
*-----------------------------------------------------------------------------
* Modification History :
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_System
    $INSERT I_F.REDO.CLAIM.STATUS.MAP

    FN.REDO.CLAIM.STATUS.MAP = 'F.REDO.CLAIM.STATUS.MAP'
    F.REDO.CLAIM.STATUS.MAP  = ''
    CALL OPF(FN.REDO.CLAIM.STATUS.MAP,F.REDO.CLAIM.STATUS.MAP)
    GOSUB PROCESS

RETURN
*********
PROCESS:
*********

    table = 'CL.CLOSING.STATUS'
    CALL EB.LOOKUP.LIST(table)
    Y.FINAL.TABLE = table<2>
    CHANGE '_' TO @FM IN Y.FINAL.TABLE

    Y.PGM.VERSION = System.getVariable('CURRENT.PGM.VER')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.PGM.VERSION = ""
    END
    Y.APPLICATION = System.getVariable('CURRENT.APPLICATION')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.APPLICATION = ""
    END
    Y.VERSION.ID = Y.APPLICATION:Y.PGM.VERSION
    CALL F.READ(FN.REDO.CLAIM.STATUS.MAP,Y.VERSION.ID,R.REDO.CLAIM.STATUS.MAP,F.REDO.CLAIM.STATUS.MAP,REDO.CLAIM.STATUS.MAP.ERR)
    IF R.REDO.CLAIM.STATUS.MAP THEN
        Y.CLOSED.STATUS = R.REDO.CLAIM.STATUS.MAP<CR.ST.CLOSED.STATUS>

        CHANGE @VM TO @FM IN Y.CLOSED.STATUS
        Y.CNT.TABLE = DCOUNT(Y.FINAL.TABLE,@FM)
        Y.INT = 1
        LOOP
        WHILE Y.INT LE Y.CNT.TABLE
            Y.STATUS = Y.FINAL.TABLE<Y.INT>
            LOCATE Y.STATUS IN Y.CLOSED.STATUS SETTING Y.POS THEN
            END ELSE
                DEL Y.FINAL.TABLE<Y.INT>
                Y.TEMP.ARR = ''
                INS Y.TEMP.ARR BEFORE Y.FINAL.TABLE<Y.INT>
            END

            Y.INT + = 1
        REPEAT
        CHANGE @FM TO '_' IN Y.FINAL.TABLE
        T(ISS.CL.CLOSING.STATUS)<2> = Y.FINAL.TABLE
    END ELSE
        CHANGE @FM TO '_' IN Y.FINAL.TABLE
        T(ISS.CL.CLOSING.STATUS)<2> = Y.FINAL.TABLE
    END
RETURN
*-----------------------------------------------------------------------------
END
