SUBROUTINE REDO.E.NOF.REV.AUT.FT(Y.FIN.ARR)
*-------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.E.NOF.REV.AUT.FT
* ODR NUMBER    : HD1052244
*-------------------------------------------------------------------------------
* Description   : This is nofile routine will be attached to the enquiry REDO.DIS.REV.AUT.FT.ENQ
* In parameter  : none
* out parameter : Y.FIN.ARR
*-------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 20-01-2011      MARIMUTHU S        HD1052244       Initial Creation
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TEMP.VERSION.IDS
*-------------------------------------------------------------------------------
MAIN:
*-------------------------------------------------------------------------------
    FN.REDO.TEMP.VERSION.IDS = 'F.REDO.TEMP.VERSION.IDS'
    F.REDO.TEMP.VERSION.IDS = ''
    CALL OPF(FN.REDO.TEMP.VERSION.IDS,F.REDO.TEMP.VERSION.IDS)

    SEL.CMD = 'SELECT ':FN.REDO.TEMP.VERSION.IDS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING POS
    WHILE Y.TEMP.ID:POS
        CALL F.READ(FN.REDO.TEMP.VERSION.IDS,Y.TEMP.ID,R.REC.TEMP,F.REDO.TEMP.VERSION.IDS,TEMP.ERR)
        Y.REV.ID = R.REC.TEMP<REDO.TEM.REV.TXN.ID>
        Y.REV.DATE = R.REC.TEMP<REDO.TEM.REV.TXN.DATE>
        Y.CNT = DCOUNT(Y.REV.DATE,@VM)
        LOOP
        WHILE Y.CNT GT 0 DO
            FLG += 1
            IF Y.REV.DATE<1,FLG> EQ TODAY THEN
                Y.FIN.ARR<-1> = Y.REV.ID<1,FLG>
            END
            Y.CNT -= 1
        REPEAT
    REPEAT

RETURN
*-------------------------------------------------------------------------------
END
