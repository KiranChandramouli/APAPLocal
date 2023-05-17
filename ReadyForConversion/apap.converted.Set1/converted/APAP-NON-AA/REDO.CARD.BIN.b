SUBROUTINE REDO.CARD.BIN
*-----------------------------------------------------------------------------

*DESCRIPTION:
*------------
* This is the template definition to create the REDO.CARD.BIN application
* It contains the table definitions
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*  Date          Who                  Reference              Description
*  19-JULY-2010  SWAMINATHAN.S.R      ODR-2010-03-0400       INITIAL VERSION
*  07.05.2013    lfpazmino                                   VPLus Interfaces
*-----------------------------------------------------------------------------

* <region name= Inserts>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

* </region>

*-----------------------------------------------------------------------------
    Table.name = 'REDO.CARD.BIN'          ;* Full application name including product prefix
    Table.title = 'BIN Credit Cards'      ;* Screen title
    Table.stereotype = 'H'      ;* H, U, L, W or T
    Table.product = 'EB'        ;* Must be on EB.PRODUCT
    Table.subProduct = ''       ;* Must be on EB.SUB.PRODUCT
    Table.classification = 'INT'          ;* As per FILE.CONTROL
    Table.systemClearFile = 'Y' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.CARD.BIN'  ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
