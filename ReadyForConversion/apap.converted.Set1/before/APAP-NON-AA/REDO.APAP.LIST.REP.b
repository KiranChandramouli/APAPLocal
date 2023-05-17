*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.LIST.REP
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME    ODR.NUMBER       REASON
* 08-06-2011   MANJU   PACS00074021     Initial creation
*---------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.USER
$INSERT I_F.REDO.RESTRICTIVE.LIST
  GOSUB PROCESS
  RETURN
**********
PROCESS:
*********
  VAR.USER.LANG  =  R.USER<EB.USE.LANGUAGE>
  OUT.DATA = O.DATA
  VAR.VIRTUAL.TABLE = "LIST"
  CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
  CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,FM)
  VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
  VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
  CHANGE '_' TO FM IN VIRTUAL.TABLE.VALUES
  CHANGE '_' TO FM IN VIRTUAL.TABLE.IDS
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
