SUBROUTINE REDO.AUT.DEL.ID.TEMP
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.AUT.DEL.ID.TEMP
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is auth routine will be attached to the version FT,CHQ.TAX
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 19-01-2011      MARIMUTHU S        HD1052244       Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS
*-------------------------------------------------------------------------------
MAIN:
*-------------------------------------------------------------------------------
    GOSUB OPENFILES
    Y.TEMP.ID = APPLICATION:PGM.VERSION
    CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.TEMP.ID,R.REC.TEMP,F.REDO.TEMP.VERSION.IDS,ERR.TEMP)
    IF R.REC.TEMP THEN
        Y.TRANS.IDS = R.REC.TEMP<REDO.TEM.TXN.ID>
        LOCATE ID.NEW IN Y.TRANS.IDS<1,1> SETTING POS THEN
            DEL Y.TRANS.IDS<1,POS>
            R.REC.TEMP<REDO.TEM.TXN.ID> = Y.TRANS.IDS
            Y.AUT.TRANS.IDS = R.REC.TEMP<REDO.TEM.AUT.TXN.ID>
            Y.CNT = DCOUNT(Y.AUT.TRANS.IDS,@VM)
            R.REC.TEMP<REDO.TEM.AUT.TXN.ID,Y.CNT+1> = ID.NEW
            R.REC.TEMP<REDO.TEM.PROCESS.DATE,Y.CNT+1> = TODAY
            CALL F.WRITE(FN.REDO.TEMP.VERSION.IDS,Y.TEMP.ID,R.REC.TEMP)
        END
    END
    GOSUB PROGRAM.END
*-------------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------------
    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

RETURN
*-------------------------------------------------------------------------------
PROGRAM.END:

END
