* @ValidationCode : MjotMjEwNzQ5Njk2NzpDcDEyNTI6MTY4NDg1NDQwNDMxOTpJVFNTOi0xOi0xOi0zOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BRAN.EDU.DETS.FIELDS

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.BRAN.EDU.DETS.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.BRAN.EDU.DETS
*LINKED WITH    :REDO.BRAN.EDU.DETS
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*MODIFICATION DETAILS:
*     03NOV09 ODR-2009-10-0526
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    ID.F=''
    ID.N='4'
    ID.T=''

*-------------------------------------------------------------------------
    fieldName="XX.LL.DESCRIPTION"
    fieldLength=35.1
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.LL.SHORT.DESC"
    fieldLength=20.1
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.setAuditPosition
*-------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------
END
