*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.T.MSG.DET
*------------
*DESCRIPTION:
*------------
*This Template creates local table REDO.T.MSG.DET .This table holds the value of
*EB.SECURE.MESSAGE.ID with customer id as @ID

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-FEB-2010        Prabhu.N       ODR-2009-12-0279    Initial Creation
* ----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.T.MSG.DET'         ;* Full application name including product prefix
  Table.title = 'REDO.T.MSG.DET'        ;* Screen title
  Table.stereotype = 'T'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'CUS'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'MD'   ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
