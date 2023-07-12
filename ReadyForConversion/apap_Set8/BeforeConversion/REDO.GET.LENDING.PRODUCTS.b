*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.LENDING.PRODUCTS

*----------------------------------------------------------------------
*Company Name: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program Name: REDO.GET.LENDING.PRODUCTS
*------------------------------------------------------------------------------------------------------------------------------------------
*Description:
*           This is a AUTH routine which will update the Product group and Product ID in a Concat file which is
* used to retrieve only the LENDING product group and the LENDING products
*----------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------------------------------------------------
*
*    DATE                  WHO                       REFERENCE                         DESCRIPTION
*
* 25-02-20011                                                                            Creation
*
*----------------------------------------------------------------------------------------------------------------------------------------------
*<desc> File Inserts and Commons used in the routine </desc>

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.PRODUCT.GROUP
$INSERT I_F.AA.PRODUCT.DESIGNER

*----------------------------------------------------------------------------------------------------------------------------------------------
*<desc> This GOSUB holds the logic flow of this program </desc>

MAIN.ROUTINE:

* This is checked coz, this is attached to VERSION>CONTROL with id as SYSTEM
* which will be triggered across all Applications available

  IF APPLICATION EQ 'AA.PRODUCT.DESIGNER' THEN

    GOSUB INITIALISE

    GOSUB GET.PRODUCT.GROUP   ;* Update the Product group ID in the Concat file maintained for Product Group

  END

  RETURN

*----------------------------------------------------------------------------------------------------------------------------------------------
*<desc> This initialises the required variables, OPENS the required files which are to be used in the routine </desc>

INITIALISE:

  PRODUCT.GROUP.ID = ''
  R.PRODUCT.GROUP = ''
  PGRP.ERR = ''
  PRODUCT.ID = ''
  R.PRD.GRP= ''
  R.PROD = ''

*Open the required files

  FN.AA.PRODUCT.GROUP = 'F.AA.PRODUCT.GROUP'
  F.AA.PRODUCT.GROUP = ''
  CALL OPF (FN.AA.PRODUCT.GROUP, F.AA.PRODUCT.GROUP)

  FN.AA.PRODUCT.DESIGNER = 'F.AA.PRODUCT.DESIGNER'
  F.AA.PRODUCT.DESIGNER = ''
  CALL OPF (FN.AA.PRODUCT.DESIGNER, F.AA.PRODUCT.DESIGNER)

  FN.REDO.PRODUCT.GROUP = 'F.REDO.PRODUCT.GROUP'
  F.REDO.PRODUCT.GROUP = ''
  CALL OPF (FN.REDO.PRODUCT.GROUP, F.REDO.PRODUCT.GROUP)

  FN.REDO.PRODUCT = 'F.REDO.PRODUCT'
  F.REDO.PRODUCT = ''
  CALL OPF (FN.REDO.PRODUCT, F.REDO.PRODUCT)

  RETURN

*----------------------------------------------------------------------------------------------------------------------------------------------
*<desc> This GOSUB updates the PRODUCT.GROUP ID in the concat file maintained for Product group </desc>

GET.PRODUCT.GROUP:

  PRODUCT.GROUP.ID = R.NEW(AA.PRD.PRODUCT.GROUP)


  CALL F.READ(FN.AA.PRODUCT.GROUP, PRODUCT.GROUP.ID, R.PRODUCT.GROUP, F.PRODUCT.GROUP, PGRP.ERR)    ;*Read the Product group record

  IF (R.PRODUCT.GROUP<AA.PG.PRODUCT.LINE> EQ 'LENDING') THEN          ;*Update the CONCAT file only if the product group is LENDING

*    R.PRD.GRP<1> = R.PRODUCT.GROUP<AA.PG.DESCRIPTION>
* Tus Start
R.PRD.GRP<REDO.PRD.GRP.DESCRIPTION> = R.PRODUCT.GROUP<AA.PG.DESCRIPTION>
* Tus End

    CALL F.WRITE(FN.REDO.PRODUCT.GROUP, PRODUCT.GROUP.ID, R.PRD.GRP)

    GOSUB GET.PRODUCT         ;*Update the LENDING product in the PRODUCT concat table

  END

  RETURN

*----------------------------------------------------------------------------------------------------------------------------------------------
*<desc> This GOSUB updates the PRODUCT.ID in the concat file maintained for Product </desc>

GET.PRODUCT:

  PRODUCT.ID = FIELD(ID.NEW,'-',1)      ;* Get the Product ID from the Product Designer ID. Truncate the Date Part in it :)

  IF (R.NEW(AA.PRD.INHERITANCE.ONLY) NE 'YES') THEN         ;*Write only the Children properties...coz they are only the saleable products

*    R.PROD<1> = R.NEW(AA.PRD.DESCRIPTION)
* Tus Start
 R.PROD<REDO.PROD.DESCRIPTION> = R.NEW(AA.PRD.DESCRIPTION) ; * Tus End

    CALL F.WRITE(FN.REDO.PRODUCT, PRODUCT.ID, R.PROD)

  END

  RETURN

*----------------------------------------------------------------------------------------------------------------------------------------------

END
