  SUBROUTINE REDO.SET.FIELDS1
*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.SET.FIELDS
* Attached as     : ROUTINE
* Primary Purpose : Set default values for multivalues fields. This routine copy from one set of MV to the next
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Santiago - TAM Latin America
* Date            : 29/07/2011
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.APAP.H.INSURANCE.DETAILS


  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END


  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  Y.CONT = DCOUNT(R.NEW(INS.DET.MON.POL.AMT),VM)

  IF Y.CONT GT 1 THEN
    FOR I = 1 TO Y.CONT
      Y.CHARGE = R.NEW(INS.DET.CHARGE)<1,1>
      Y.CHARGE.EXT.AMT = R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,1>
      Y.PAYMENT.TYPE = R.NEW(INS.DET.PAYMENT.TYPE)<1,1>

      R.NEW(INS.DET.CHARGE)<1,I> = Y.CHARGE
      R.NEW(INS.DET.CHARGE.EXTRA.AMT)<1,I> = Y.CHARGE.EXT.AMT
      R.NEW(INS.DET.PAYMENT.TYPE)<1,I> = Y.PAYMENT.TYPE

      R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,I> = R.NEW(INS.DET.MON.POL.AMT)<1,I> + R.NEW(INS.DET.EXTRA.AMT)<1,I>
    NEXT I
  END

  RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
*incializacion de variables

  RETURN

*------------------------
OPEN.FILES:
*=========
*Abrir archivos

  RETURN
*------------
END
