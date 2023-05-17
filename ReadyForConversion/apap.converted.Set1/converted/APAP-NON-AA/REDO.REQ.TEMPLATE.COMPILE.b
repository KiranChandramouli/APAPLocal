PROGRAM REDO.REQ.TEMPLATE.COMPILE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a Auto id routine for REDO.CARD.REQUEST,PRE.EMBOSS version, to default
*               status field to 1 if curr number equal to 1
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 05-4-2011      KAVITHA                PACS00036008            ISSUE FIX
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.LOCKING
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------

    FN.SS = 'F.STANDARD.SELECTION'
    F.SS = ''
    CALL OPF(FN.SS,F.SS)
    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    CALL GET.STANDARD.SELECTION.DETS("REDO.CARD.REQUEST",R.SS)
    Y.FIELDS = R.SS<SSL.SYS.FIELD.NAME>
    USR.FIELD.VALUE = R.SS<SSL.SYS.FIELD.NO>
    Y.COUNT = DCOUNT(Y.FIELDS,@VM)
    CHANGE @VM TO @FM IN Y.FIELDS
    CHANGE @VM TO @FM IN USR.FIELD.VALUE
    LOCATE 'PRIMARY.CARD' IN Y.FIELDS SETTING POS.VAL THEN
        Y.VAL = USR.FIELD.VALUE<POS.VAL>
    END
    LOCATE 'AUDIT.DATE.TIME' IN Y.FIELDS SETTING POS.VAL THEN
        Y.VAL1 = POS.VAL
    END
    SEL.CMD = "SELECT ":FN.REDO.CARD.REQUEST
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',NO.OF.REC.COMP,Y.ERR.LIST)
    LOOP
        REMOVE Y.ID FROM SEL.CMD.LIST SETTING POS
    WHILE Y.ID:POS
        CALL F.READ(FN.REDO.CARD.REQUEST,Y.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,Y.ERR)
        LOOP
        WHILE Y.VAL LE Y.COUNT
            Y.CHANGE.VAL = Y.VAL - 1
            Y.CORRECT.POS = Y.VAL
            Y.VAL1 = R.REDO.CARD.REQUEST<Y.CHANGE.VAL>
            R.REDO.CARD.REQUEST<Y.CORRECT.POS> = R.REDO.CARD.REQUEST<Y.CHANGE.VAL>
            Y.VAL += 1
        REPEAT
        CALL F.WRITE(FN.REDO.CARD.REQUEST,Y.ID,R.REDO.CARD.REQUEST)
    REPEAT
RETURN
*-------------------------------------------------------------------------------------------------------
END
