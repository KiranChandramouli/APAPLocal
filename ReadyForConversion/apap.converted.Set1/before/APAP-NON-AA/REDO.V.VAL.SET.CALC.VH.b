*-----------------------------------------------------------------------------
* <Rating>-29</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.SET.CALC.VH
*
* ====================================================================================
*
* - Set information for two "VALOR NOMINAL" AND "VALOR DE EJECUCION"
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : Set computed values for collateral VH
*
* Incoming:
* ---------
*
*
* Outgoing:
*
* ---------
*
*
*----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Pablo Castillo De La Rosa RTam
* Date            : 08/FEB/2012
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL
$INSERT I_GTS.COMMON

*************************************************************************

  GOSUB INITIALISE

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

* =========
PROCESS:
* =========
*EXCECUTE ONLY IF PRESS HOT FIELD
  VAR.HOT = OFS$HOT.FIELD
  IF LEN(VAR.HOT) EQ 0 THEN
    RETURN
  END

  Y.NOMINAL.VALUE = COMI

  IF R.NEW(COLL.EXECUTION.VALUE) EQ '' THEN
    R.NEW(COLL.EXECUTION.VALUE) = Y.NOMINAL.VALUE ;*** VALOR DE EJECUCION
  END

  R.NEW(COLL.GEN.LEDGER.VALUE) = Y.NOMINAL.VALUE  ;*** VALOR LIBRO MAYOR
  R.NEW(COLL.MAXIMUM.VALUE) = Y.NOMINAL.VALUE     ;*** VALOR MAXIMO CORE

*Verify if the % is Grate 0 for calculate el maximun value
  R.NEW(COLL.LOCAL.REF)<1,WPOSVALOR>= Y.NOMINAL.VALUE
  VAR.PORC =  R.NEW(COLL.LOCAL.REF)<1,WPOSPORC>

  IF VAR.PORC GT 0 THEN
    VAR.MAXIMO = (Y.NOMINAL.VALUE * VAR.PORC)/100
    VAR.MAXIMO = DROUND(VAR.MAXIMO,2)   ;* PACS00307565 - S/E
    R.NEW(COLL.LOCAL.REF)<1,WPOSMAX> = VAR.MAXIMO
    R.NEW(COLL.MAXIMUM.VALUE) = Y.NOMINAL.VALUE
  END

*IF THE INFORMATION IS NOT SET, THEN SET NOMINAL.VALUE, AND EXECUTION.VALUE

*     IF  LEN(R.NEW(COLL.EXECUTION.VALUE)) EQ 0 THEN
  R.NEW(COLL.EXECUTION.VALUE) = Y.NOMINAL.VALUE
*     END

*     IF  LEN(R.NEW(COLL.NOMINAL.VALUE)) EQ 0 THEN
  R.NEW(COLL.NOMINAL.VALUE) = Y.NOMINAL.VALUE
*     END

*CALC THE REA VALUE FOR NEW VALUE
  CALL REDO.V.VAL.REA.COLLATERAL

  RETURN

* =========
INITIALISE:
* =========

  PROCESS.GOAHEAD = 1

  WCAMPO = "L.COL.VAL.AVA"
  WCAMPO<2> = "L.COL.LN.MX.PER"
  WCAMPO<3> = "L.COL.LN.MX.VAL"

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
  WPOSVALOR  = YPOS<1,1>
  WPOSPORC   = YPOS<1,2>
  WPOSMAX    = YPOS<1,3>
  RETURN

END
