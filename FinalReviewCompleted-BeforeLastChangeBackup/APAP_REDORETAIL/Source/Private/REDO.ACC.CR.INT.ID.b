* @ValidationCode : MjoxOTYyNTExNzI2OkNwMTI1MjoxNjgxMjc2NTU1ODAwOklUU1M6LTE6LTE6NjI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 62
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.ACC.CR.INT.ID
*-----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM , FM TO @FM,
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEGORY

    GOSUB INIT
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------
INIT:

    FN.CATEGORY='F.CATEGORY'
    F.CATEGORY=''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

RETURN
*----------------------------------------------------------------------------
PROCESS:
    ACC.CR.ID=ID.NEW
    Y.CATEGORY= FIELD(ACC.CR.ID,'.',1)
    Y.STATUS= FIELD(ACC.CR.ID,'.',2)
    R.CATEGORY=''
    ERR.CATEGORY=''
    CALL CACHE.READ(FN.CATEGORY, Y.CATEGORY, R.CATEGORY, ERR.CATEGORY) ;*AUTO R22 CODE CONVERSION
    IF R.CATEGORY EQ '' THEN
        E = 'NOT A VALID CATEGORY'
    END
*PACS00024017 - S
    VAR.VIRTUAL.TABLE2 = 'L.AC.STATUS2'
    VAR.VIRTUAL.TABLE1 = 'L.AC.STATUS1'
    GOSUB CHECK.EB.LOOKUP1
    GOSUB CHECK.EB.LOOKUP2
    LOCATE Y.STATUS IN VIRTUAL.TABLE.IDS1 SETTING STAT.POS1 ELSE
        LOCATE Y.STATUS IN VIRTUAL.TABLE.IDS2 SETTING STAT.POS1 ELSE
            E = 'NOT A VALID STATUS'
        END
    END
*PACS00024017 - E
RETURN
*-------------------------------------------------------------------------
CHECK.EB.LOOKUP1:
*-------------------------------------------------------------------------
*This para is used to find the EB.LOOKUP values
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE1)
    CNT.VTABLE1= DCOUNT(VAR.VIRTUAL.TABLE1,@FM)
    VIRTUAL.TABLE.IDS1 = VAR.VIRTUAL.TABLE1<2>      ;*2nd Part of @ID
    VIRTUAL.TABLE.VALUES1 = VAR.VIRTUAL.TABLE1<CNT.VTABLE1>   ;*Description field values
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES1
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS1
RETURN
*---------------------------------------------------------------------------
CHECK.EB.LOOKUP2:
*----------------------------------------------------------------------------
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE2)
    CNT.VTABLE2= DCOUNT(VAR.VIRTUAL.TABLE2,@FM)
    VIRTUAL.TABLE.IDS2 = VAR.VIRTUAL.TABLE2<2>      ;*2nd Part of @ID
    VIRTUAL.TABLE.VALUES2 = VAR.VIRTUAL.TABLE2<CNT.VTABLE2>   ;*Description field values
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES2
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS2
RETURN
*----------------------------------------------------------------------------
END
