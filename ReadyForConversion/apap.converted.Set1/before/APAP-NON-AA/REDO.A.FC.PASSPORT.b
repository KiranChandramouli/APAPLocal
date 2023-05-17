*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.A.FC.PASSPORT
*
* Subroutine Type : ROUTINE
* Attached to     : CUSTOMER module
* Attached as     : ROUTINE
* Primary Purpose : concatenate LEGAL.ID + NATIONALITY
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
* Date            :
* Fix by          : JP - This fix solve the HD1053754 issue
* Date fix        : 07 / 02 / 2011
* Date modify fix : 01 April 2011
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
  RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*=======
  Y.FIELD.NAME = 'L.CU.PASS.NAT'
  Y.FIELD.NO = 0
  CALL GET.LOC.REF ('CUSTOMER',Y.FIELD.NAME,Y.FIELD.NO)
  IF R.NEW(EB.CUS.LEGAL.ID) THEN
    R.NEW(EB.CUS.LOCAL.REF)<1,Y.FIELD.NO> = R.NEW(EB.CUS.LEGAL.ID):"-":R.NEW(EB.CUS.NATIONALITY)
  END ELSE
    R.NEW(EB.CUS.LOCAL.REF)<1,Y.FIELD.NO> = ""
  END
  RETURN

*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1

  RETURN

*------------------------
OPEN.FILES:
*=========

  RETURN
*-----------------------
END
