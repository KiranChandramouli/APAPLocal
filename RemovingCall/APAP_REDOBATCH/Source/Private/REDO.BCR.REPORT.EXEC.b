* @ValidationCode : MjoyNDEyODU4Mzk6Q3AxMjUyOjE2ODA2OTA0NjE2NTU6SVRTUzotMTotMTotMTU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -15
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BCR.REPORT.EXEC
*-----------------------------------------------------------------------------
*<doc>
*
* APAP: C.21 Buro de Credito
*
* Este es un WorkFile que permite al usuario sobrescribir las definiciones realizadas
* en REDO.INTERFACE.PARAM para poder generar o enviar el archivo relacionado a la interface de forma manual
* @hpasquel@temenos.com
* @stereotype Application
* @package REDO.BCR
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 29/09/10 - C.21 APAP
*            New Template changes
* DATE              WHO                REFERENCE                 DESCRIPTION
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* ----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
* </region>
*-----------------------------------------------------------------------------
    Table.name = 'REDO.BCR.REPORT.EXEC'   ;* Full application name including product prefix
    Table.title = 'Buro de Credito - Interface'     ;* Screen title
    Table.stereotype = 'W'      ;* H, U, L, W or T
    Table.product         = 'ST'          ;* Must be on EB.PRODUCT
    Table.subProduct      = 'CUSTOMER'    ;* Must be on EB.SUB.PRODUCT
    Table.classification  = 'INT'         ;* As per FILE.CONTROL
    Table.systemClearFile = 'N' ;* As per FILE.CONTROL
    Table.relatedFiles = ''     ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''          ;* As per FILE.CONTROL
    Table.equatePrefix = 'REDO.BCR.REP.EXE'         ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix = ''         ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions = '' ;* Space delimeted list of blocked functions
    Table.trigger = ''          ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------

RETURN
END
