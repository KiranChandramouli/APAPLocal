* @ValidationCode : MjotMjk4NDExOTYxOkNwMTI1MjoxNjgxMjk0MTY2NTkzOjMzM3N1Oi0xOi0xOjA6MDp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 15:39:26
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
$PACKAGE APAP.TAM
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*12/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*12/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
SUBROUTINE REDO.NV.DUP.VERSION.FIELDS


*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------
    ID.F = '@ID'
    ID.CHECKFILE = 'VERSION'
    ID.N = '50'
    ID.T = 'A'
*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("AUTH.VERSION", "50", "A", "")        ;* Add a new fields
    CALL Field.setCheckFile("VERSION")    ;* Use DEFAULT.ENRICH from SS or just field 1

    CALL Table.setAuditPosition

RETURN

END
