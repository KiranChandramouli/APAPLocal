*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.HOST.DETAILS.TRACE
*-----------------------------------------------------------------------------
*<doc>
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : TAM.HOST.DETAILS.TRACE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a T24 routine which retrieves the information from the
*                    local table TAM.HOST.DETAILS.TRACE and stores it in the INPUTTER field of the transaction
*                     Attach this Routine in the AUTH.RTN field of VERSION.CONTROL file with SYSTEM as id
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE           WHO           REFERENCE         DESCRIPTION
* 03-OCT-2010    Mudassir V   ODR-2010-08-0465   INITIAL CREATION
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
  Table.name = 'TAM.HOST.DETAILS.TRACE' ;* Full application name including product prefix
  Table.title = 'TAM.HOST.DETAILS.TRACE'          ;* Screen title
  Table.stereotype = 'L'      ;* H, U, L, W or T
  Table.product = 'EB'        ;* Must be on EB.PRODUCT
  Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
  Table.classification = 'INT'          ;* As per FILE.CONTROL
  Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
  Table.relatedFiles = ''     ;* As per FILE.CONTROL
  Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
  Table.equatePrefix = 'HOST.DET'       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
  Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
  Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
  Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

  RETURN
END
