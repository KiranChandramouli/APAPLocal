*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.DELEVIRY.DATE(DELEVIRY.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :RIYAS
*Program   Name    :REDO.DS.DELEVIRY.DATE
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
  COMI= R.NEW(RE.ORD.DELEVIRY.DATE)<1,1> ; N1=8 ; T1=".D"
  CALL IN2D(N1,T1)
  DELEVIRY.DATE = V$DISPLAY
  COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
