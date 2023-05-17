* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
* <Rating>-48</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
*-----------------------------------------------------------------------------
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose :
*                   Validate of Mandatory field according COLLATERAL.CODE
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
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 08 Junio 2011
* Modify by       : JP
* Date Modify     : 05 Agosto 2011
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT


  GOSUB INITIALISE
  GOSUB PROCESS.MESSAGE

  RETURN


*-----------------------------------------------------------------------------
INITIALISE:
***
  Y.ERROR.MESSAGE = ''

  RETURN
*-----------------------------------------------------------------------------
PROCESS.MESSAGE:

  BEGIN CASE
  CASE MESSAGE EQ ''          ;* Only during commit
    BEGIN CASE
    CASE V$FUNCTION EQ 'D'
*GOSUB VALIDATE.DELETE
    CASE V$FUNCTION EQ 'R'
      GOSUB VALIDATE.REVERSE
    CASE OTHERWISE  ;* The real VALIDATE
      GOSUB VALIDATE
    END CASE
  CASE MESSAGE EQ 'AUT'       ;* During authorisation and verification
* Si no funciona las validaciones del validate
    IF V$FUNCTION EQ 'R' THEN
*GOSUB VALIDATE.REVERSE
    END

  END CASE

*
  RETURN
*-----------------------------------------------------------------------------
VALIDATE:
*---------------------------------------------------------------------------
* LANZA VALIDACIONES DINAMICAS DE COLLATERALS SEGUN PARAMETRIZACION PARA LA VERSION
*

  CALL REDO.FC.S.VALID.COLL

  RETURN
*-----------------------------------------------------------------------------
VALIDATE.REVERSE:
*---------------------------------------------------------------------------
* Proceso de validacion antes de reversar los registros creados en:
* Polizas, Coll.right, Coll y Limit
*

  IF R.NEW(REDO.FC.STATUS.TEMPLATE) EQ "INPROGRESS" THEN
* ----> Aqui la llamada a la rutina de validacion llamada REDO.FC.S.VALREV

    CALL REDO.FC.REV.VAL

  END ELSE

    ETEXT = "EB-REVERSAL.NOT.ALLOWED"
    CALL STORE.END.ERROR
  END
  RETURN

*-----------------------------------------------------------------------------
END
