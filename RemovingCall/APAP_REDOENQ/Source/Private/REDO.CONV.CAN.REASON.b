$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CAN.REASON
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - FM to @FM 
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------
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
    VAR.VIRTUAL.TABLE = "L.AC.CAN.REASON"
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
        VAL.LIST.REST = ''
        VAL.LIST.REST = VIRTUAL.TABLE.VALUES<POS,VAR.USER.LANG>
        IF NOT(VAL.LIST.REST) THEN
            O.DATA = VIRTUAL.TABLE.VALUES<POS,1>
        END ELSE
            O.DATA = VAL.LIST.REST
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
END
