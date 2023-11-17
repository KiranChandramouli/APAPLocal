$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CRM.OPEN.CHAN
*------------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------
* Modification History
* DATE         NAME           ODR.NUMBER       REASON
* 20-09-2011   Sudharsanan   PACS00115270     Initial creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - FM to @FM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
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
    OUT.DATA = O.DATA
    VAR.VIRTUAL.TABLE = "OPENING.CHANNEL"
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
        VAL.DESC = ''
        VAL.DESC = VIRTUAL.TABLE.VALUES<POS,LNGG>     ;*LNGG - Language code from USER Record
        IF NOT(VAL.DESC) THEN
            O.DATA = VIRTUAL.TABLE.VALUES<POS,1>
        END ELSE
            O.DATA = VAL.DESC
        END
    END
RETURN
*------------------------------------------------------------------------------
END
