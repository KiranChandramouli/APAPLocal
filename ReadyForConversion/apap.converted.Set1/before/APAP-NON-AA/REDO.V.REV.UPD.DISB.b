*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.REV.UPD.DISB
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an Auth routine attached to below version,
* REDO.FT.TT.TRANSACTION,REDO.DISB.REV
*
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference          Description
* 01-07-2017        Edwin Charles D  R15 Upgrade      Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.DISB.CHAIN
    $INSERT I_F.REDO.AA.DISB.REVERSE
    $INSERT I_F.REDO.FT.TT.TRANSACTION

    GOSUB INIT
    GOSUB PROCESS

    RETURN
******
INIT:
******
*Initialize all the variables

    FN.REDO.DISB.CHAIN = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN = ''
    CALL OPF(FN.REDO.DISB.CHAIN, F.REDO.DISB.CHAIN)

    FN.REDO.AA.DISB.REVERSE = 'F.REDO.AA.DISB.REVERSE'
    F.REDO.AA.DISB.REVERSE = ''
    CALL OPF(FN.REDO.AA.DISB.REVERSE, F.REDO.AA.DISB.REVERSE)

    RETURN

PROCESS:
********
    Y.INITIAL.ID = R.NEW(FT.TN.L.INITIAL.ID)
    Y.AA.ID      = R.NEW(FT.TN.DEBIT.ACCT.NO)

    IF NUM(Y.AA.ID[1,2]) THEN
        IN.ARR.ID = ''
        CALL REDO.CONVERT.ACCOUNT(Y.AA.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
        ARR.ID   = OUT.ID
        Y.ACC.ID = Y.AA.ID
    END ELSE
        IN.ACC.ID = ''
        CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.AA.ID,OUT.ID,ERR.TEXT)
        ARR.ID   = Y.AA.ID
        Y.ACC.ID = OUT.ID
    END
    R.REDO.AA.DISB.REVERSE = ''; DISB.REV.ERR = ''
    CALL F.READ(FN.REDO.AA.DISB.REVERSE,ARR.ID,R.REDO.AA.DISB.REVERSE,F.REDO.AA.DISB.REVERSE,DISB.REV.ERR)

    IF V$FUNCTION EQ 'R' THEN
        GOSUB UPDATE.REVERSE.FT
        GOSUB UPDATE.DISB.CHAIN
    END
    IF V$FUNCTION EQ 'A' THEN
        GOSUB PROCESS.FT.DEL
    END

    RETURN

UPDATE.REVERSE.FT:
******************
    IF R.REDO.AA.DISB.REVERSE THEN
        LOCATE Y.INITIAL.ID IN R.REDO.AA.DISB.REVERSE<AA.RE.DESB.REF,1> SETTING POS1 THEN
            FT.POS = DCOUNT(R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,POS1>, SM)
            R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,POS1,FT.POS+1> = ID.NEW
        END ELSE
            R.REDO.AA.DISB.REVERSE<AA.RE.DESB.REF,POS1+1> = Y.INITIAL.ID
            R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,POS1+1,1> = ID.NEW
        END
        CALL F.WRITE(FN.REDO.AA.DISB.REVERSE,ARR.ID,R.REDO.AA.DISB.REVERSE)
    END ELSE
        R.REDO.AA.DISB.REVERSE<AA.RE.DESB.REF,1,1>    = Y.INITIAL.ID
        R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,1,1> = ID.NEW
        CALL F.WRITE(FN.REDO.AA.DISB.REVERSE,ARR.ID,R.REDO.AA.DISB.REVERSE)
    END
    RETURN

UPDATE.DISB.CHAIN:
******************
    CALL F.READ(FN.REDO.DISB.CHAIN,Y.INITIAL.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,DISB.ERR)

    LOCATE ID.NEW IN R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,1> SETTING TEMP.POS THEN
        R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,TEMP.POS> = 'RNAU'
        CALL F.WRITE(FN.REDO.DISB.CHAIN,Y.INITIAL.ID,R.REDO.DISB.CHAIN)
    END

    RETURN

PROCESS.FT.DEL:
***************
    LOCATE Y.INITIAL.ID IN R.REDO.AA.DISB.REVERSE<AA.RE.DESB.REF,1> SETTING POS1 THEN
        LOCATE ID.NEW IN R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,POS1,1> SETTING FT.POS THEN
            DEL R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,POS1,FT.POS>
            IF R.REDO.AA.DISB.REVERSE<AA.RE.FT.TEMP.REF,POS1,1> EQ '' THEN
                DEL R.REDO.AA.DISB.REVERSE<AA.RE.DESB.REF,POS1>
                CALL F.DELETE(FN.REDO.AA.DISB.REVERSE,ARR.ID)
            END ELSE
                Y.FADR = ''
                CALL LOG.WRITE(FN.REDO.AA.DISB.REVERSE,ARR.ID,R.REDO.AA.DISB.REVERSE,Y.FADR)
            END
        END
    END
    RETURN
END