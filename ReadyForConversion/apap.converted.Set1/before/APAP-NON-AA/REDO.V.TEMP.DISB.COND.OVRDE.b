*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.TEMP.DISB.COND.OVRDE
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
* 05-Jun-2017   Edwin Charles D     R15 Upgrade           Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION


MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    Y.STATUS = R.NEW(FT.TN.L.LOAN.STATUS.1)
    Y.COND = R.NEW(FT.TN.L.LOAN.COND)

    IF Y.STATUS MATCHES 'JudicialCollection' OR Y.STATUS MATCHES 'Write-off' THEN
        AF = FT.TN.L.LOAN.STATUS.1
        CURR.NO = DCOUNT(R.NEW(FT.TN.OVERRIDE),VM) + 1
        TEXT = 'REDO.LOAN.BLOCK.ST'
        CALL STORE.OVERRIDE(CURR.NO)
    END
    IF Y.COND MATCHES 'Legal' THEN
        AF = FT.TN.L.LOAN.COND
        CURR.NO = DCOUNT(R.NEW(FT.TN.OVERRIDE),VM) + 1
        TEXT = 'REDO.LOAN.BLOCK.ST'
        CALL STORE.OVERRIDE(CURR.NO)
    END


    RETURN


PGM.END:

END
