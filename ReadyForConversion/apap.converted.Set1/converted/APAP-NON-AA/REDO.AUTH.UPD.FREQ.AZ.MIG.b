SUBROUTINE REDO.AUTH.UPD.FREQ.AZ.MIG
*--------------------------------------------------------------------------------------
*Description: This routine is used to update the month end freq. for migrated deposits.
* Also it is attached in the version of AZ.ACCOUNT,MB.DM.LOAD
*Reference: PACS00269507
****---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    GOSUB PROCESS
    GOSUB PGM.END
RETURN
*-----------
PROCESS:
*----------
    Y.DATE = R.NEW(AZ.VALUE.DATE)
*    Y.YEAR.MONTH = Y.DATE[1,6]
*    Y.MONTH = Y.DATE[5,2]
*
*    BEGIN CASE
*
*    CASE (Y.MONTH EQ 01) OR (Y.MONTH EQ 03) OR (Y.MONTH EQ 05) OR (Y.MONTH EQ 07) OR (Y.MONTH EQ 08) OR (Y.MONTH EQ 10) OR (Y.MONTH EQ 12)
*        YLAST.DAY = "31"
*
*    CASE (Y.MONTH EQ 02)
*        IF MOD(Y.DATE[1,4],4) EQ 0 THEN
*            YLAST.DAY = "29"
*        END ELSE
*            YLAST.DAY = "28"
*        END
*
*    CASE (Y.MONTH EQ 04) OR (Y.MONTH EQ 06) OR (Y.MONTH EQ 09) OR (Y.MONTH EQ 11)
*        YLAST.DAY = "30"
*
*    CASE OTHERWISE
*        YLAST.DAY = "31"
*
*    END CASE
*
*    Y.FREQ = Y.YEAR.MONTH:YLAST.DAY:"M0131"

    Y.MONTH.FREQ = "M0130"
    TEMP.COMI = COMI
    COMI = Y.DATE:Y.MONTH.FREQ
    CALL CFQ
    Y.FREQ = COMI
    COMI = TEMP.COMI

    VAR.TYPE.OF.SCHDLE   = R.NEW(AZ.TYPE.OF.SCHDLE)<1,1>

    IF VAR.TYPE.OF.SCHDLE EQ "I" THEN
        R.NEW(AZ.FREQUENCY) = Y.FREQ
    END

RETURN
*----------
PGM.END:
*---------
END
