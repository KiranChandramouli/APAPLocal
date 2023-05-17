SUBROUTINE REDO.V.BA.ORG.FT.REV

*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Edwin Charles D
* Program Name  : REDO.V.BA.REAL.FT.TXN
*-------------------------------------------------------------------------
* Description: This routine is auth routine to process FT from REDO.FT.TT.TRANSACTION
*
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
* DATE         Name              ODR / HD REF              DESCRIPTION
* 14-06-17     Edwin Charles D   R15 Ugrade                Initial creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.DISB.CHAIN

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*****
    FN.USER = 'F.USER'
    F.USER = ''
    CALL OPF(FN.USER,F.USER)

    FN.REDO.DISB.CHAIN = 'F.REDO.DISB.CHAIN'
    F.REDO.DISB.CHAIN = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)

RETURN

PROCESS:
********

    Y.L.INITIAL.ID = R.NEW(FT.TN.L.INITIAL.ID)
    CALL F.READ(FN.REDO.DISB.CHAIN,Y.L.INITIAL.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,DISB.ERR)
    IF R.REDO.DISB.CHAIN THEN
        LOCATE ID.NEW IN R.REDO.DISB.CHAIN<DS.CH.FT.TEMP.REF,1> SETTING POS1 THEN
            IF R.REDO.DISB.CHAIN<DS.CH.TR.STATUS,POS1> EQ 'RNAU' THEN
                Y.FT.ID = R.REDO.DISB.CHAIN<DS.CH.TRANSACTION.ID,POS1>
            END
        END
    END
    IF Y.FT.ID THEN
        OFSVERSION = 'FUNDS.TRANSFER,REDO.DISB.REV'
        GOSUB POST.OFS
    END
RETURN

POST.OFS:
*********
    Y.USR = OPERATOR
    CALL CACHE.READ(FN.USER, Y.USR, R.USR, ERR.US)
    OFS.USERNAME = R.USR<EB.USE.SIGN.ON.NAME>
    OFS.PASSWORD = R.USR<EB.USE.PASSWORD>
    Y.OFS.MSG = ''
    Y.OFS.MSG = OFSVERSION:'/R/PROCESS,':OFS.USERNAME:'/':OFS.PASSWORD:'/':ID.COMPANY:',':Y.FT.ID

    ofsRequest = Y.OFS.MSG
    CALL ofs.addLocalRequest(ofsRequest,'add',error)
    MSG.OUT = ofsRequest
RETURN
END
