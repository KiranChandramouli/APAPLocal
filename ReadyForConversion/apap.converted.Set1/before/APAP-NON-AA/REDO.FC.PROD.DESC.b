*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------

******************************************************************************
  SUBROUTINE REDO.FC.PROD.DESC
******************************************************************************
* Company Name:   Asociacion Popular de Ahorro y Prestamo (APAP)
* Developed By:   Reginal Temenos Application Management
*-----------------------------------------------------------------------------
* Subroutine Type :  BUILD ROUTINE
* Attached to     :  ENQUIRY > REDO.FC.E.CUST.AA
* Attached as     :  CONVERSION
* Primary Purpose :  Obtiene la descripcion de un producto AA
*
* Incoming        :  NA
* Outgoing        :  NA
*
*-----------------------------------------------------------------------------
* Modification History:
* ====================
* Development by  : lpazminodiaz@temenos.com
* Date            : 23/08/2011
* Purpose         : Initial version
******************************************************************************

******************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.PRODUCT

$INSERT I_F.REDO.CREATE.ARRANGEMENT

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

* ========
INITIALISE:
* ========
  FN.AA.PRODUCT = 'F.AA.PRODUCT'
  F.AA.PRODUCT = ''
  R.AA.PRODUCT = ''

  Y.ERR = ''

  RETURN

* ========
OPEN.FILES:
* ========
  CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)

  RETURN

* =====
PROCESS:
* =====
  Y.PRODUCT.ID = R.RECORD<REDO.FC.PRODUCT>
  CALL CACHE.READ(FN.AA.PRODUCT,Y.PRODUCT.ID,R.AA.PRODUCT,Y.ERR)

  Y.PRODUCT.DESCRIPTION = FIELD(R.AA.PRODUCT<AA.PDT.DESCRIPTION>,VM,2)
  IF Y.PRODUCT.DESCRIPTION EQ '' THEN
    Y.PRODUCT.DESCRIPTION = FIELD(R.AA.PRODUCT<AA.PDT.DESCRIPTION>,VM,1)
  END

  O.DATA = Y.PRODUCT.DESCRIPTION

  RETURN

END
