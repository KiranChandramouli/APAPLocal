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
