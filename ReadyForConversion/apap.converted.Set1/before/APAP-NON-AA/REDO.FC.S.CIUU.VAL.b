*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.CIUU.VAL

* Subroutine Type : ROUTINE
* Attached to     : REDO.CREATE.ARRANGEMENT validate
* Attached as     : HOT FIELD
* Primary Purpose : If the value from REDO.FC.DEST.LOAN then REDO.FC.CIUU.CATEG has to deleted
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
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo - RTAM
* Date            : 22 Jun 2011
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_GTS.COMMON

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS.MAIN
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============


  R.NEW (REDO.FC.CIUU.CATEG) = ""
  LOOP
  WHILE Y.FIELD.POS GE 1

    IF R.GTS<Y.FIELD.POS,3> EQ Y.FIELD.SEARCH THEN
      DEL R.GTS<Y.FIELD.POS>
      Y.FIELD.POS = -1
    END
    ELSE
      Y.FIELD.POS --
    END

  REPEAT

  RETURN
*------------------------
INITIALISE:
*=========



  PROCESS.GOAHEAD = 1

  CAMPO.ACTUAL = OFS$HOT.FIELD
  NOMBRE.CAMPO = 'DEST.LOAN'
  IF CAMPO.ACTUAL NE NOMBRE.CAMPO THEN
    PROCESS.GOAHEAD = ""
  END


  Y.FIELD.POS = DCOUNT ( R.GTS,FM )

  Y.FIELD.SEARCH = "" : REDO.FC.CIUU.CATEG

  RETURN


*------------------------
OPEN.FILES:
*=========

  RETURN
*------------
END
