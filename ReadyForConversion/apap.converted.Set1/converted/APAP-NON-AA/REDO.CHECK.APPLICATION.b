SUBROUTINE REDO.CHECK.APPLICATION(Y.ITEM.CODE,APPL.NAME,APPL.PATH)
*-----------------------------------------------------------------------------
* Description:
* This routine will be used with the subroutines like REDO.V.INP.SERIES.CHECK, REDO.AUTH.ORDER.RECEPTION etc
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : MARIMUTHU S
* PROGRAM NAME : REDO.CHECK.APPLICATION
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 12.04.2010  MARIMUTHU S     ODR-2009-11-0200  INITIAL CREATION
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.REDO.H.ORDER.DETAILS
    $INSERT I_F.REDO.H.INVENTORY.PARAMETER
*-----------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.H.INVENTORY.PARAMETER = 'F.REDO.H.INVENTORY.PARAMETER'
    F.REDO.H.INVENTORY.PARAMETER = ''
    CALL OPF(FN.REDO.H.INVENTORY.PARAMETER,F.REDO.H.INVENTORY.PARAMETER)
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.H.INVENTORY.PARAMETER,Y.ID,R.REC.PARAMETER,Y.ERR)
    Y.PARAM.ITEM = R.REC.PARAMETER<IN.PR.ITEM.CODE>
    Y.PARAM.ITEM = CHANGE(Y.PARAM.ITEM,@VM,@FM)
    Y.PARAM.ITEM = CHANGE(Y.PARAM.ITEM,@SM,@FM)

    LOCATE Y.ITEM.CODE IN Y.PARAM.ITEM SETTING POS THEN
        Y.APPLN = R.REC.PARAMETER<IN.PR.INV.MAINT.TYPE,POS>
        BEGIN CASE
            CASE Y.APPLN EQ 'ADMIN.CHEQUES'
                APPL.NAME = 'F.REDO.H.ADMIN.CHEQUES'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'BANK.DRAFTS'
                APPL.NAME = 'F.REDO.H.BANK.DRAFTS'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'DEBIT.CARDS'
                APPL.NAME = 'F.REDO.H.DEBIT.CARDS'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'DEPOSIT.RECEIPTS'
                APPL.NAME = 'F.REDO.H.DEPOSIT.RECEIPTS'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'PASSBOOKS'
                APPL.NAME = 'F.REDO.H.PASSBOOK.INVENTORY'
                APPL.PATH = ''

            CASE Y.APPLN EQ 'PIGGY.BANK'
                APPL.NAME = 'F.REDO.H.PIGGY.BANKS'
                APPL.PATH = ''
        END CASE
    END

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
