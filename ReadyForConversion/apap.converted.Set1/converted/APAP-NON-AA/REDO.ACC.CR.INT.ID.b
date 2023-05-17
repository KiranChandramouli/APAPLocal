SUBROUTINE REDO.ACC.CR.INT.ID
*-----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
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
    CALL CACHE.READ(FN.CATEGORY, Y.CATEGORY, R.CATEGORY, ERR.CATEGORY)
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
