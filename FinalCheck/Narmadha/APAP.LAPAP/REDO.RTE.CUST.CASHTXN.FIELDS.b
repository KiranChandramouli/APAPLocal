* @ValidationCode : MjotMjA2NDgxMjY5MzpDcDEyNTI6MTY4MjA3MTIxMjE3NjozMzNzdTotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 15:30:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.RTE.CUST.CASHTXN.FIELDS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_Table

    ID.F='@ID'
    ID.N='50'
    ID.T='A'

    CALL Table.addFieldDefinition("XX<TXN.ID", 16, 'A', "") ;* Add a new field
    CALL Table.addFieldDefinition("XX-INITIAL.ID", 16, 'A', "")       ;* Add a new field
    CALL Table.addFieldDefinition("XX-TRANS.DATE", 25, 'A', "")       ;* Add a new field
    CALL Table.addField("XX-BRANCH.CODE", 'A', "", "")      ;* Add a new fields
    CALL Field.setCheckFile("COMPANY")  ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.addFieldDefinition("XX-CASH.AMOUNT", 19, 'AMT', "")    ;* Add a new field

    CALL Table.addFieldDefinition("XX-ACTUAL.VERSION", 65, 'A', "")   ;* Add a new field
    CALL Table.addFieldDefinition("XX-FUNCTION", 3, 'A', "")          ;* Add a new field
    CALL Table.addFieldDefinition("XX>RTE.RESET.FLAG", 10, 'A', "")          ;* Add a new field

    V = Table.currentFieldPosition

RETURN

END
