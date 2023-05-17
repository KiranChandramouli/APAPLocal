*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.EMPLOYEE.ACCOUNTS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* COMPANY : APAP
* DEVELOPED BY : RAJA SAKTHIVEL K P
* PROGRAM NAME : REDO.EMPLOYEE.ACCOUNTS
*------------------------------------------------------------------------------
* Description : This is the template definition routine to create the table REDO.EMPLOYEE.ACCOUNTS
*-----------------------------------------------------------------------------

* Input/Output:
*----------------
* IN : NA
* OUT : NA
*----------------

*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*----------------------
* 19/10/07 - EN_10003543
*            New Template changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'REDO.EMPLOYEE.ACCOUNTS' ;* Full application name including product prefix
  Table.title = 'EMPLOYEE ACCOUNTS'     ;* Screen title
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'FIN'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'N' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'REDO.EMP'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
