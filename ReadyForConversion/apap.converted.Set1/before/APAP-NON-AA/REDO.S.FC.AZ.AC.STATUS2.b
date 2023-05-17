*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.AZ.AC.STATUS2(AC.ID, AC.REC)
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
  CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
  Y.REV.RT.TYPE.POS = LOC.REF.POS<1,1>

  IF Y.REV.RT.TYPE.POS GT 0 THEN
    Y.AC.STATUS2 = AC.REC<AC.LOCAL.REF,Y.REV.RT.TYPE.POS>   ;* This hold the Value in the local field
    AC.REC = Y.AC.STATUS2
  END
  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  LOC.REF.APPL="ACCOUNT"
  LOC.REF.FIELDS="L.AC.STATUS2"
  LOC.REF.POS=" "
  AC.REC = 'NULO'
  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
