SUBROUTINE REDO.V.INP.DISB.COND.OVRDE
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: INPUT routine
*------------
*DESCRIPTION:
*------------
* This routine is used to raise the override if loan status and condition having block
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*-----------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 23-sep-2011   MARIMUTHU S        PACS00136030          Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    LR.APP = 'FUNDS.TRANSFER'
    LR.FLDS = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LR.POS = ''
    CALL MULTI.GET.LOC.REF(LR.APP,LR.FLDS,LR.POS)
    POS.L.LOAN.ST = LR.POS<1,1>
    POS.L.LOAN.CON = LR.POS<1,2>

    Y.STATUS = R.NEW(FT.LOCAL.REF)<1,POS.L.LOAN.ST>
    Y.COND = R.NEW(FT.LOCAL.REF)<1,POS.L.LOAN.CON>

    IF Y.STATUS MATCHES 'JudicialCollection' OR Y.STATUS MATCHES 'Write-off' THEN
        AF = FT.LOCAL.REF
        AV = POS.L.LOAN.ST
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = 'REDO.LOAN.BLOCK.ST'
        CALL STORE.OVERRIDE(CURR.NO)
    END
    IF Y.COND MATCHES 'Legal' THEN
        AF = FT.LOCAL.REF
        AV = POS.L.LOAN.CON
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = 'REDO.LOAN.BLOCK.ST'
        CALL STORE.OVERRIDE(CURR.NO)
    END


RETURN


PGM.END:


END
