* @ValidationCode : MjotMjk4NDExOTYxOkNwMTI1MjoxNjgzMDgxNzAyNDI2OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 May 2023 08:11:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
