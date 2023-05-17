*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RISK.GROUP.ID
*-----------------------------------------------------------------------------

*COMPANY NAME   :APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.RISK.GROUP.ID
*DESCRIPTION    :TEMPLATE FOR THE ID OF REDO.RISK.GROUP
*LINKED WITH    :REDO.RISK.GROUP
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
  $INSERT I_COMMON
  $INSERT I_EQUATE
*-----------------------------------------------------------------------------
  IF LEN(ID.NEW) < 10 THEN
    ID.NEW = STR("0",(10-LEN(ID.NEW))):ID.NEW
  END
END
