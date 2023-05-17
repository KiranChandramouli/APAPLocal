SUBROUTINE REDO.H.REASSIGNMENT.VALIDATE
*-----------------------------------------------------------------------------
* Description:
* This is a .VALIDATE  routine for the template REDO.H.REASSIGNMENT
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.H.REASSIGNMENT.VALIDATE
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.H.PASSBOOK.INVENTORY
    $INSERT I_F.REDO.H.REASSIGNMENT
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB CHECK.DEPOSIT

    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.H.INV.PARAM = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INV.PARAM = ''
    CALL OPF(FN.REDO.H.INV.PARAM,F.REDO.H.INV.PARAM)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    ACC.ID = R.NEW(RE.ASS.ACCOUNT.NUMBER)

    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)

    CALL MULTI.GET.LOC.REF('ACCOUNT','L.AC.STATUS1':@VM:'L.AC.STATUS2',GET.POS)

    STATUS1.VAL = GET.POS<1,1>
    STATUS2.VAL = GET.POS<1,2>
    CHECK1.ST = R.ACC<AC.LOCAL.REF,STATUS1.VAL>
    CHECK2.ST = R.ACC<AC.LOCAL.REF,STATUS2.VAL>
    Y.FLAG = ''
    Y.FLAG1 = ''
    IF CHECK1.ST EQ 'ABANDONED' AND CHECK2.ST EQ 'DECEASED' THEN
        Y.FLAG1 = '1'
    END


    IF CHECK1.ST EQ 'ABANDONED' AND CHECK2.ST EQ 'DECEASED' THEN
        Y.FLAG = '1'
    END
    IF Y.FLAG AND Y.FLAG1 THEN
        TEXT = 'STATUS.BLOCKED'
        CNT.CURR.NO = DCOUNT(R.NEW(RE.ASS.OVERRIDE),@VM)
        CALL STORE.OVERRIDE(CNT.CURR.NO+1)
    END

RETURN

CHECK.DEPOSIT:

    Y.ITEM.CODE = R.NEW(RE.ASS.ITEM.CODE)

    CALL CACHE.READ(FN.REDO.H.INV.PARAM,'SYSTEM',R.REC.PARAMETER,PARAM.ERR)
    Y.PARAM.ITEM = R.REC.PARAMETER<IN.PR.ITEM.CODE>
    Y.PARAM.ITEM = CHANGE(Y.PARAM.ITEM,@VM,@FM)
    Y.PARAM.ITEM = CHANGE(Y.PARAM.ITEM,@SM,@FM)

    LOCATE Y.ITEM.CODE IN Y.PARAM.ITEM SETTING POS THEN
        Y.APPLN = R.REC.PARAMETER<IN.PR.INV.MAINT.TYPE,POS>
        IF Y.APPLN EQ 'DEPOSIT.RECEIPTS' THEN
            AF = RE.ASS.ITEM.CODE
            ETEXT = 'EB-CANT.REASSIGN.DEPOSIT'
            CALL STORE.END.ERROR
            GOSUB PROGRAM.END
        END
    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

END
