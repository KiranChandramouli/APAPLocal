*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.AZ.AC.WKN.BAL(AC.ID, AC.REC)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  Y.AC.WKN.BAL = AC.REC<AC.WORKING.BALANCE>       ;* This hold the Value in the local field
  AC.REC = Y.AC.WKN.BAL
  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  AC.REC = 'NULO'
  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
