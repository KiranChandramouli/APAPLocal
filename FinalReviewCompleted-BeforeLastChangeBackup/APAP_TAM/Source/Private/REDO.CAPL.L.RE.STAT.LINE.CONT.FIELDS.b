* @ValidationCode : MjotMTcwNTU1NDU0MzpDcDEyNTI6MTY4MDYxNzUwNDg0OTpJVFNTOi0xOi0xOjA6MTp0cnVlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 19:41:44
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
SUBROUTINE REDO.CAPL.L.RE.STAT.LINE.CONT.FIELDS
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
*-----------------------
*HD1012870 - New template FIELDS to store the backup of RE.STAT.LIN.CONT
*
* Date           Who                 Ref                  Modification
* 04.04.2023    Conversion Tool      R22                 Auto Conversion     - No changes
* 04.04.2023    Shanmugapriya M      R22                 Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("CAPL.LINE.CONT.ID", T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------
    CALL Table.addField('XX<ASST.CONSOL.KEY','65','A','')     ;* Add a new fields
    CALL Table.addField('XX-XX<ASSET.TYPE','12','A','')       ;* Add a new fields
    CALL Table.addField('XX>XX>MAT.RANGE','4','A','')         ;* Add a new fields
    CALL Table.addField('XX<PRFT.CONSOL.KEY','65','A','')     ;* Add a new fields
    CALL Table.addField('XX-XX<PROFIT.CCY','3','A','')        ;* Add a new fields
    CALL Table.addField('XX>XX>PROFIT.SIGN','6','A','')       ;* Add a new fields
    CALL Table.addField('DATE.UPDATED','8','D','')  ;* Add a new fields
    CALL Table.addField('RESERVED.4','25','A','')   ;* Add a new fields
    CALL Table.addField('RESERVED.3','25','A','')   ;* Add a new fields
    CALL Table.addField('RESERVED.2','25','A','')   ;* Add a new fields
    CALL Table.addField('RESERVED.1','25','A','')   ;* Add a new fields

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
