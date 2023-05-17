*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.CLIENT.TYPE (TYPE)
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
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
* Development by  : pgarzongavilanes
* Date            : 2011-06-09
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.EB.LOOKUP
$INSERT I_F.TELLER
$INSERT I_F.USER
*
*************************************************************************
*


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

*
  RETURN
*
* ======
PROCESS:
* ======
  CALL F.READ(FN.EB.LOOKUP, Y.EB.LOOKUP.ID, R.EB.LOOKUP, F.EB.LOOKUP, Y.ERR.EB.LOOKUP)

  Y.LANG = R.USER<EB.USE.LANGUAGE>

  TYPE = R.EB.LOOKUP<EB.LU.DESCRIPTION,Y.LANG>


  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)
  RETURN

*
* =========
INITIALISE:
* =========
*
  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP = ''
  R.EB.LOOKUP = ''
  Y.EB.LOOKUP.ID = ''
  Y.ERR.EB.LOOKUP = ''

  WCAMPO = "L.TT.CLNT.TYPE"

  YPOS = ""

  CALL MULTI.GET.LOC.REF("TELLER",WCAMPO,YPOS)
  WPOS.TT.CLNT.TYPE = YPOS<1,1>


  Y.CLNT.TYPE = R.NEW(TT.TE.LOCAL.REF)<1,WPOS.TT.CLNT.TYPE>
  Y.EB.LOOKUP.ID = "L.TT.CLNT.TYPE" : "*" : Y.CLNT.TYPE


  RETURN


END
