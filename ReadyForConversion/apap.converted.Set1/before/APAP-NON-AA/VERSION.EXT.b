*-------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE VERSION.EXT
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define generic parameter table
*-------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Ivan Roman
*Program   Name    : VERSION.EXT
*-------------------------------------------------------------------------
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
*------------------
*   Date               who           Reference            Description
* 01-19-2012        Ivan Roman       version extension    Initial Creation
* ------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
*-------------------------------------------------------------------------
  Table.name  = 'VERSION.EXT' ;* Full application name including
  Table.title = 'VERSION.EXT' ;* Screen title
  Table.stereotype = 'H'      ;* H, U, L, W or T
  Table.product    = 'EB'     ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification    = 'INT'       ;* As per FILE.CONTROL
  Table.systemClearFile   = 'Y'         ;* As per FILE.CONTROL
  Table.relatedFiles      = ''          ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix      = 'VE.EX'   ;
*-------------------------------------------------------------------------
  Table.idPrefix = ''         ;*  Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked
  Table.trigger = ''          ;* Trigger field used for OPERATION style fi
*-------------------------------------------------------------------------

  RETURN
END
