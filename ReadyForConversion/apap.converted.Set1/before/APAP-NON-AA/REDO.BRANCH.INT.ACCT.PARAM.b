*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BRANCH.INT.ACCT.PARAM
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This template is used to update the internal Account details for a company.
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*-----------------------------------------------------------------------------
*   Date               who             Reference            Description
* 02-05-2011          Bharath G       ODR-2010-08-0017      Initial Creation
*-----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.BRANCH.INT.ACCT.PARAM'       ;* Full application name including product prefix
  Table.title = 'Branch Internal Account Details' ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'BR.INT.ACCT'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
