*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TC35.IN.STLMT.RTN(STLMT.LINES)
*----------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.TC35.IN.STLMT.RTN
*****************************************************************
*Description:
*----------------
*TC 35,36,37 represents the reversal of chargeback raised by us in the case of duplicate
*Start the routine with one incoming parameter STLMT.LINES
*-----------------------------------------------------------------------------------------------------
*In Parameter : None
*Out Parameter : None
************************************************************************
*Modification History:
***********************
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   2-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*--------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.VISA.STLMT.05TO37
$INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON



  GOSUB PROCESS

  RETURN

********
PROCESS:
*********

  CALL REDO.TC.IN.FRAME.ARR(STLMT.LINES)
  CALL REDO.TC35.IN.VERIFY.RTN
  R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> = 'SETTLED'
  R.REDO.STLMT.LINE<VISA.SETTLE.FILE.DATE>=Y.FILE.DATE
  CALL LOAD.COMPANY(ID.COMPANY)
  FULL.FNAME = 'F.REDO.VISA.STLMT.05TO37'
  ID.T  = 'A'
  ID.N ='15'
  ID.CONCATFILE = ''
  COMI = ''
  PGM.TYPE = '.IDA'
  ID.NEW = ''
  V$FUNCTION = 'I'
  ID.NEW.LAST = ''
  CALL GET.NEXT.ID(ID.NEW.LAST,'F')
  Y.ID = COMI
  CALL REDO.VISA.SETTLE.WRITE(Y.ID,R.REDO.STLMT.LINE)

  RETURN


END
