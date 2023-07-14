* @ValidationCode : MjozNDYxNjMxNDA6Q3AxMjUyOjE2ODMwMjQzMzQyOTI6SVRTUzotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:34
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

SUBROUTINE REDO.UPDT.FXSN.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.UPDT.FXSN *
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-01-0213
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 01/02/10 - EN_10003543
*            New Template changes
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '10'
    ID.T = ''
*------------------------------------------------------------------------------
    fieldName = 'SPECIFY.NO.REC'
    fieldLength = '10'
    fieldType = 'A'
*    fieldType = "":FM:"Available_Issued_Cancelled"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
