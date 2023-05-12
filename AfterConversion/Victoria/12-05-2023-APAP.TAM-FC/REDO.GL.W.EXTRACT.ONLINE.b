$PACKAGE APAP.TAM
SUBROUTINE REDO.GL.W.EXTRACT.ONLINE
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.GL.W.EXTRACT.ONLINE
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a template routine. This template is used for extraction of EXTRACTS
*                    and REPORTS online
*</doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 22 Oct 2010    Shiva Prasad Y      ODR-2009-12-0294 C.12      Initial Creation

** 11-04-2023 R22 Auto Conversion no changes
** 11-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.GL.W.EXTRACT.ONLINE'         ;* Full application name including product prefix
    Table.title = 'SAP Extraction - Online'         ;* Screen title
    Table.stereotype = 'W'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'SAP.GL.EO'      ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
RETURN
END
