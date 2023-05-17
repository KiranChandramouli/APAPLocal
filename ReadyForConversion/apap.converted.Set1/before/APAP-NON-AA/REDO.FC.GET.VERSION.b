*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------

******************************************************************************
  SUBROUTINE REDO.FC.GET.VERSION
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
*-----------------------------------------------------------------------------
* Subroutine Type :  BUILD ROUTINE
* Attached to     :  ENQUIRY > REDO.FC.E.PENDING.AA
* Attached as     :  CONVERSION
* Primary Purpose :  Permite invocar a una version especifica de RCA
*                    de acuerdo al tipo de producto
*
* Incoming        :  NA
* Outgoing        :  NA
*
*-----------------------------------------------------------------------------
* Modification History:
* ====================
* Development by  : lpazminodiaz@temenos.com
* Date            : 09/09/2011
* Purpose         : Initial version
******************************************************************************

******************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.ARRANGEMENT

$INSERT I_F.REDO.FC.ACT.PRES

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

* ========
INITIALISE:
* ========
  FN.REDO.FC.ACT.PRES = 'F.REDO.FC.ACT.PRES'
  F.REDO.FC.ACT.PRES = ''
  R.REDO.FC.ACT.PRES = ''

  Y.ERR = ''

  RETURN

* ========
OPEN.FILES:
* ========
  CALL OPF(FN.REDO.FC.ACT.PRES,F.REDO.FC.ACT.PRES)

  RETURN

* =====
PROCESS:
* =====
  Y.PRODUCT.ID = R.RECORD<AA.ARR.PRODUCT>
  CALL CACHE.READ(FN.REDO.FC.ACT.PRES,Y.PRODUCT.ID,R.REDO.FC.ACT.PRES,Y.ERR)
  Y.VERSION = R.REDO.FC.ACT.PRES<REDO.FC.ACT.DESC.PRODUCT>

  O.DATA = Y.VERSION : ' SEE '

  RETURN

END
