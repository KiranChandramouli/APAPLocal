* @ValidationCode : MjoxOTYxODMwNzg5OkNwMTI1MjoxNjgxMjc2NTQ1NDYzOklUU1M6LTE6LTE6ODc6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 87
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.CLASS.CODE.ID
*-----------------------------------------------------------------------------
*<doc>
* ID Validation is done here
* here
* @stereotype Application
* @package TODO define the product group and product, e.g. infra.eb
* </doc>
*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* 19/10/07 - EN_10003543
*            New Template changes
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* ----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_METHODS.AND.PROPERTIES
    $INSERT I_F.COMPANY

    GOSUB INITALISE
    GOSUB CHECK.ID

RETURN
*------------------------------------------------------------------------------
INITALISE:

    FN.COMPANY = "F.COMPANY"
    F.COMPANY = ""
    CALL OPF(FN.COMPANY,F.COMPANY)
RETURN

*-----------------------------------------------------------------------------
CHECK.ID:

    SELECT.COMP = "SELECT ":FN.COMPANY
    CALL EB.READLIST(SELECT.COMP,SEL.LIST.COMP,'',NO.OF.COMP,SEL.COMP)

    LOCATE ID.NEW IN SEL.LIST.COMP SETTING POS ELSE
        E = 'EB-NOT.VALID.ID'
        CALL ERR
    END
RETURN
*-----------------------------------------------------------------------------
END
