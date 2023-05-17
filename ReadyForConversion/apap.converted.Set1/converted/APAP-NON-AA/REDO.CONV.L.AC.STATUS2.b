SUBROUTINE REDO.CONV.L.AC.STATUS2
*---------------------------------------------------
* Description: This routine is a conversion routine for the enquiry
* to display the L.AC.STATUS2.
*---------------------------------------------------
* Modification History
* DATE         NAME          Reference                   REASON
* 10-02-2012  H Ganesh      PACS00194856 - CR.22      Initial creation
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    OUT.DATA =  O.DATA
    IF OUT.DATA ELSE
        RETURN
    END

    VAR.USER.LANG  =  R.USER<EB.USE.LANGUAGE>
    VAR.VIRTUAL.TABLE = "L.AC.STATUS2"
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
        O.DATA = VIRTUAL.TABLE.VALUES<POS,VAR.USER.LANG>
        IF O.DATA ELSE
            O.DATA =  VIRTUAL.TABLE.VALUES<POS,1>
        END
    END

RETURN
END
