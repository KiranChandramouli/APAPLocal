*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.REJECT.DATE(REJECT.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :RIYAS
*Program   Name    :REDO.DS.DATE.SUBMIT.TO.SAP
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
* ----------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* DATE            WHO               REFERENCE              DESCRIPTION

*-------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.ORDER.DETAILS

  GOSUB PROCESS
  RETURN
*********
PROCESS:
**********
  TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
  COMI= R.NEW(RE.ORD.REJECT.DATE)<1,1> ; N1=8 ; T1=".D"
  CALL IN2D(N1,T1)
  REJECT.DATE = V$DISPLAY
  COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
