* @ValidationCode : MjotNjYzOTgxMTkzOkNwMTI1MjoxNjgxMDk3NzM0MDA3OklUU1M6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 09:05:34
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
SUBROUTINE REDO.T.MSG.DET.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine defines field for REDO.T.MSG.DET

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-FEB-2010       Prabhu.N       ODR-2009-12-0279    Initial Creation
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*---------------------------------------------------------------------------------
***<region>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>

*------------------------------------------------------------------------------------
    ID.F="@ID"
    ID.N="10"
    ID.T="A"
*-----------------------------------------------------------------------------------
    fieldName="SECURE.ID"
    fieldLength="15"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
