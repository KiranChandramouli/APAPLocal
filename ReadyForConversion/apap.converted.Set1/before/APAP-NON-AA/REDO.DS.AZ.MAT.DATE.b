*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.AZ.MAT.DATE(MAT.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.AZ.MAT.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
* ----------------------------------------------------------------------------------
*MODIFICATION HISTORY:
* DATE            WHO               REFERENCE              DESCRIPTION
* 26 JUN 2011     Sudharsanan S     CR.18         This code is used to get the date format based on user language  (01 JAN 2011 OR 01 ENE 2011)
*-------------------------------------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT

  GOSUB PROCESS
  RETURN
*********
PROCESS:
**********
  TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
  COMI= R.NEW(AZ.MATURITY.DATE) ; N1=8 ; T1=".D"
  CALL IN2D(N1,T1)
  MAT.DATE = V$DISPLAY
  COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1

  RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
