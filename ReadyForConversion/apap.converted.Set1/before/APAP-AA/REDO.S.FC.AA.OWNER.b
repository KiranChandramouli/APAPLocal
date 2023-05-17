*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.AA.OWNER(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.CUSTOMER>OWNER  FIELD
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
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.CUSTOMER

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
  AA.ARR = INT.COND<AA.CUS.OWNER>       ;* This hold the Value in the core field
  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  Y.ARRG.ID = AA.ID
  PROPERTY.CLASS = 'CUSTOMER'
  AA.ARR = 'NULO'
  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
