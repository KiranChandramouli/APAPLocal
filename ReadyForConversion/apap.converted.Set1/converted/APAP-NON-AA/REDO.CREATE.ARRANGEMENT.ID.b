SUBROUTINE REDO.CREATE.ARRANGEMENT.ID
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
* 21/05/2010 -      Naveenkumar N             Initial Creation
* 19/11/2010 -      Arulprakasam P            Done changes for 180A-CR
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LOCKING
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT

    IF V$FUNCTION NE 'I' THEN
        RETURN
    END

    IF ID.NEW THEN
        RETURN
    END
    GOSUB INIT
    IF NOT(RUNNING.UNDER.BATCH) THEN
        IF GTSACTIVE THEN
            IF OFS$OPERATION EQ 'BUILD' THEN
                GOSUB PROCESS
                RETURN
            END
        END ELSE
            GOSUB PROCESS
        END
    END ELSE
        GOSUB PROCESS
    END
RETURN

INIT:
    FN.LOCKING = "F.LOCKING"
    F.LOCKING = ""
    Y.LOCKING.ID = "F.REDO.CREATE.ARRANGEMENT"
    R.LOCKING = ""
    E.LOCKING = ""
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.REDO.CREATE.ARRANGEMENT.NAU = 'F.REDO.CREATE.ARRANGEMENT$NAU'
    F.REDO.CREATE.ARRANGEMENT.NAU  = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT.NAU,F.REDO.CREATE.ARRANGEMENT.NAU)

    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'
    F.REDO.CREATE.ARRANGEMENT.= ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

RETURN

PROCESS:

    GOSUB CHECK.NAU.FILE

    IF R.REDO.CREATE.ARRANGEMENT.NAU THEN
        RETURN
    END

    GOSUB CHECK.LIVE.FILE

    IF R.REDO.CREATE.ARRANGEMENT THEN
        RETURN
    END

    CALL F.READ(FN.LOCKING,Y.LOCKING.ID,R.LOCKING,F.LOCKING,E.LOCKING)
    IF R.LOCKING<EB.LOK.REMARK> EQ TODAY THEN
        ID.NEW="ARR":TODAY:FMT(R.LOCKING<EB.LOK.CONTENT>,'R%3')
        R.LOCKING<EB.LOK.CONTENT>=R.LOCKING<EB.LOK.CONTENT>+1

*    WRITE R.LOCKING TO F.LOCKING,Y.LOCKING.ID ;*Tus Start
        CALL F.WRITE(FN.LOCKING,Y.LOCKING.ID,R.LOCKING);*Tus End
    END ELSE
        R.LOCKING<EB.LOK.REMARK>=TODAY
        R.LOCKING<EB.LOK.CONTENT>=002
        ID.NEW="ARR":TODAY: FMT('1','R%3')

*    WRITE R.LOCKING TO F.LOCKING,Y.LOCKING.ID ;*Tus Start
        CALL F.WRITE(FN.LOCKING,Y.LOCKING.ID,R.LOCKING);*Tus End
    END

RETURN

CHECK.NAU.FILE:

    REDO.CREATE.ARRANGEMENT.ID = COMI
    R.REDO.CREATE.ARRANGEMENT.NAU = ''
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT.NAU,REDO.CREATE.ARRANGEMENT.ID,R.REDO.CREATE.ARRANGEMENT.NAU,F.REDO.CREATE.ARRANGEMENT.NAU,REDO.CREATE.ARRANGEMENT.ER)

RETURN

CHECK.LIVE.FILE:

    REDO.CREATE.ARRANGEMENT.ID = COMI
    R.REDO.CREATE.ARRANGEMENT.NAU = ''
    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,REDO.CREATE.ARRANGEMENT.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ARR.ERR)


RETURN
END
