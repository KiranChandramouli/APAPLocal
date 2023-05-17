*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.CO.STATUS (COLL.ID)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :Service Routine
* Attached to     :REDO.FC.S.UNLINK.COL.AA
* Attached as     :From auth routine invocation
* Primary Purpose :Changes current CO status to ACTIVE whenever it is not belonging to any active AA.
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Nava V. - TAM Latin America
* Date            : Aug 21 2013
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL

*
* -------------------------------------------------------------------------------

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

*
  RETURN

*
* ======
PROCESS:
* ======
*
  IF Y.CO.ID NE "" THEN
    GOSUB CHANGE.STATUS
  END
*
  RETURN
*

* ============
CHANGE.STATUS:
* ============
*
  R.COLLATERAL = '' ; Y.CO.ERR.MSJ = ''
  CALL F.READ(FN.COLLATERAL,Y.CO.ID,R.COLLATERAL,F.COLLATERAL,Y.CO.ERR.MSJ)
*
  Y.STATUS = R.COLLATERAL<COLL.LOCAL.REF,WPOESTA>
*
  IF Y.STATUS NE Y.STATUS2 THEN
    R.COLLATERAL<COLL.LOCAL.REF,WPOESTA> = Y.STATUS2
    CALL F.WRITE(FN.COLLATERAL,Y.CO.ID,R.COLLATERAL)
  END
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.COLLATERAL,F.COLLATERAL)
  RETURN
*
* =========
INITIALISE:
* =========
*
  Y.CO.ID = COLL.ID
*
  Y.STATUS = ''
  Y.STATUS2 = "IN-FORCE"
*
  FN.COLLATERAL = 'F.COLLATERAL'
  F.COLLATERAL  = ''
  R.COLLATERAL  = ''

*   Set the local field for read
  WCAMPO     = "L.COL.SEC.STA"

  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0

*Get the position for field(s)
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)

  WPOESTA  = YPOS<1,1>
*
  RETURN
*
END
