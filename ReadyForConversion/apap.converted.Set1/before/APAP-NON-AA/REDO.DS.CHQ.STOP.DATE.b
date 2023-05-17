*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.CHQ.STOP.DATE(MAT.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :RIYAS
*Program   Name    :REDO.DS.CHQ.STOP.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
* ----------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* DATE            WHO               REFERENCE              DESCRIPTION

*-------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT

  GOSUB PROCESS
  RETURN
*********
PROCESS:
**********
  TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
  COMI= R.NEW(REDO.PS.ACCT.STOP.DATE)<1,1> ; N1=8 ; T1=".D"
  CALL IN2D(N1,T1)
  MAT.DATE = V$DISPLAY
  COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
