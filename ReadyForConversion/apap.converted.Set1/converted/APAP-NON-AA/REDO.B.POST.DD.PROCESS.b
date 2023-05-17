SUBROUTINE REDO.B.POST.DD.PROCESS
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.POST.DD.PROCESS
* Primary Purpose : Clearing all record from the template 'REDO.W.DIRECT.DEBIT'
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.W.DIRECT.DEBIT


    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)

    CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,'TODAY')

    CALL CACHE.READ(FN.REDO.W.DIRECT.DEBIT,'SYSTEM',R.REDO.W.DIRECT.DEBIT,Y.ERR)
    SEL.CMD = ' SELECT ':FN.REDO.W.DIRECT.DEBIT:' WITH @ID LIKE UPDATE-...'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,Y.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POD
    WHILE Y.ID:POD
        Y.ACCOUNT = FIELD(Y.ID,'-',2)
        LOCATE Y.ACCOUNT IN R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,1> SETTING POS ELSE
            R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.ARR.ID,-1> = Y.ACCOUNT
            CALL F.WRITE(FN.REDO.W.DIRECT.DEBIT,'SYSTEM',R.REDO.W.DIRECT.DEBIT)
        END
        CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,Y.ID)
    REPEAT
RETURN
END
