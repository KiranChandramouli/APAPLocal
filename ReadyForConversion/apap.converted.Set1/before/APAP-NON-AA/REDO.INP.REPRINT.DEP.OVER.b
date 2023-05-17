*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.REPRINT.DEP.OVER
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Temenos Development
*  Program   Name    :REDO.INP.REPRINT.DEP.OVER
***********************************************************************************
*Description:    This is an input routine attached to the Enquiry used
*                to PRINT a deal slip when the User clicks on PRINT option
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.APAP.H.REPRINT.DEP

  GOSUB INIT

  RETURN
*--------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------
  VAR.REPRINT.FLAG = R.NEW(REDO.REP.DEP.REPRINT.FLAG)
  VAR.ID = FIELD(ID.NEW,"-",1)
  CURR.NO = 0
  CALL STORE.OVERRIDE(CURR.NO)
  IF OFS$OPERATION EQ 'PROCESS' AND VAR.REPRINT.FLAG EQ 'YES' THEN
    TEXT = "REDO.DEP.REPRINT.OVR":FM:VAR.ID
    CALL STORE.OVERRIDE(CURR.NO)
  END
  RETURN
END
