* @ValidationCode : Mjo3MjU0MDIyMjA6Q3AxMjUyOjE2OTY1OTUxMDQ4NzU6MzMzc3U6LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Oct 2023 17:55:04
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
$PACKAGE APAP.REDOAPAP
*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.T.ACCTSTAT.BY.DATE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - JAYASURYA H
*  DATE            NAME                  REFERENCE                     DESCRIPTION
* 24 NOV  2022    Edwin Charles D       ACCOUNTING-CR                 Changes applied for Accounting reclassification CR
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*06/10/2023      Conversion tool            R22 Auto Conversion             Nochange
*06/10/2023      Suresh                     R22 Manual Conversion           Nochange
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("TABLE.NAME.ID", T24_Date) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID'
    ID.N = '8'
    ID.T = 'D'
    CALL Table.addFieldDefinition("XX.ACCOUNT","19","N","") ;* Add a new field


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
