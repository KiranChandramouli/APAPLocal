*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CNV.STATUS
* This routine is used to populate the descrptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME           Reference       REASON
* 02-07-2011   Sudharsanan   PACS00024006     Initial creation
*
*---------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.USER

*-------------------------------------------------------------------------------------------------------------
  GOSUB PROCESS
  RETURN
*-------------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------------
  ENQ.VALUE = O.DATA
  VAR.VIRTUAL.TABLE = "CM.STATUS"
  CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
  CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,FM)
  VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
  VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
  CHANGE '_' TO FM IN VIRTUAL.TABLE.VALUES
  CHANGE '_' TO FM IN VIRTUAL.TABLE.IDS
  LOCATE ENQ.VALUE IN VIRTUAL.TABLE.IDS SETTING POS1 THEN
    VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>       ;* Get the values based on user language
    Y.OUT = VIRTUAL.TABLE.VALUES<POS1,VAR.USER.LANG>
    IF NOT(Y.OUT) THEN
      Y.OUT = VIRTUAL.TABLE.VALUES<POS1,1>
    END
    O.DATA = Y.OUT
  END
  RETURN
*-------------------------------------------------------------------------------------------------------------------
END
