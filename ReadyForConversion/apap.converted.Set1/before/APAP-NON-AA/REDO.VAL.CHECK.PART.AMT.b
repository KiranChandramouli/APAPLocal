*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.CHECK.PART.AMT
*-----------------------------------------------------------------------------
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : TAM
* Program Name : REDO.VAL.CHECK.PART.AMT
*---------------------------------------------------------
* Description : This subroutine is attached input routine in REDO.AA.PART.DISBURSE.FC,PART.DISB
*
*----------------------------------------------------------
* Linked TO :
*----------------------------------------------------------
* Modification History:
* 28-11-2012          MARIMUTHU S            PACS00236823
*----------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.AA.PART.DISBURSE.FC

  Y.AMT = COMI

  IF Y.AMT GT R.NEW(REDO.PDIS.PARTIAL.OS.AMT) THEN
    AF = REDO.PDIS.DIS.AMT.TOT
    ETEXT = 'EB-AMT.EXCEEDED'
    CALL STORE.END.ERROR
  END

  RETURN

END
