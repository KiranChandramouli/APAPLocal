SUBROUTINE REDO.DS.CLIENT.TYPE.DISC(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT,
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.DS.CLIENT.TYPE.DISC
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 29-Mar-2011      Pradeep S          PACS00056285                Initial Creation
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER

    GOSUB PROCESS

RETURN

********
PROCESS:
********
*Check with the EB.LOOKUP table to display the description values

    Y.CLIENT.TYPE = IN.OUT.PARA

    VAR.VIRTUAL.TABLE = 'L.TT.CLNT.TYPE'
    CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
    CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,@FM)
    VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part of @ID
    VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>      ;*Description field values
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.VALUES
    CHANGE '_' TO @FM IN VIRTUAL.TABLE.IDS

    LOCATE Y.CLIENT.TYPE IN VIRTUAL.TABLE.IDS SETTING POS THEN
        IN.OUT.PARA  = VIRTUAL.TABLE.VALUES<POS>
    END

RETURN

END
