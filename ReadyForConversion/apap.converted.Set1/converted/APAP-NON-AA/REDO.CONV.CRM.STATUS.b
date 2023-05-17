SUBROUTINE REDO.CONV.CRM.STATUS
*------------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------
* Modification History
* DATE         NAME           ODR.NUMBER       REASON
* 20-09-2011   Sudharsanan   PACS00115270     Initial creation
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    GOSUB PROCESS
RETURN
**********
PROCESS:
*********
    VAR.USER.LANG  =  R.USER<EB.USE.LANGUAGE>
    OUT.DATA = O.DATA
    VAR.VIRTUAL.TABLE = "CM.STATUS"
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
        VAL.DESC = ''
        VAL.DESC = VIRTUAL.TABLE.VALUES<POS,VAR.USER.LANG>
        IF NOT(VAL.DESC) THEN
            O.DATA = VIRTUAL.TABLE.VALUES<POS,1>
        END ELSE
            O.DATA = VAL.DESC
        END
    END
RETURN
*------------------------------------------------------------------------------
END
