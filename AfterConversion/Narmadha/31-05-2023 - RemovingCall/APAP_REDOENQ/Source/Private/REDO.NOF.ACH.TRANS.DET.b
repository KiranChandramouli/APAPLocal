$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.ACH.TRANS.DET(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.ACH.TRANS.DET
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is No-file Enquiry routine. It will fetch the field details required for enquiry
*
* In parameter  :
* out parameter : Y.FIN.ARR
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 12-01-2011      MARIMUTHU s      ODR-2009-10-0795  Initial Creation
*----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACH.TRANSFER.DETAILS
*----------------------------------------------------------------------------------------------------
MAIN:
*----------------------------------------------------------------------------------------------------
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END
*----------------------------------------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------------------------------------
    FN.REDO.ACH.TRANSFER.DETAILS = 'F.REDO.ACH.TRANSFER.DETAILS'
    F.REDO.ACH.TRANSFER.DETAILS = ''
    CALL OPF(FN.REDO.ACH.TRANSFER.DETAILS,F.REDO.ACH.TRANSFER.DETAILS)

RETURN
*----------------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------------
    SEL.CMD = 'SELECT ':FN.REDO.ACH.TRANSFER.DETAILS:' WITH TRANS.ACH EQ "NO" BY BENEFICIARY BY BENEFICIARY.ACC BY BEN.BNK.CODE'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,CHEQ.ERR)
    LOOP
        REMOVE Y.ACH.ID FROM SEL.LIST SETTING POS
    WHILE Y.ACH.ID:POS
        FLG.CK += 1
        CALL F.READ(FN.REDO.ACH.TRANSFER.DETAILS,Y.ACH.ID,R.REDO.ACH.DET,F.REDO.ACH.TRANSFER.DETAILS,ACH.ERR)
        Y.BENEFIC.NAME = R.REDO.ACH.DET<REDO.ACH.BENEFICIARY>
        Y.BEN.ACC = R.REDO.ACH.DET<REDO.ACH.BENEFICIARY.ACC>
        Y.BEN.BNK.CODE = R.REDO.ACH.DET<REDO.ACH.BEN.BNK.CODE>
        FLAG += 1
        IF Y.BENE.NAME NE Y.BENEFIC.NAME OR Y.DUP.BEN.AC NE Y.BEN.ACC OR Y.DUP.BNK.CODE NE Y.BEN.BNK.CODE THEN
            IF FLAG GT 1 THEN
                Y.FIN.ARR<-1> = Y.BENE.NAME:'*':Y.DUP.BEN.AC:'*':Y.DUP.BNK.CODE:'*':Y.CUSTOMER.NAME:'*':Y.AGENCY:'*':Y.PAY.DATE:'*':Y.DEP.NO:'*':Y.INT.VALUE:'*':Y.TOT.INT.VAL
                Y.CUSTOMER.NAME = ''; Y.AGENCY = ''; Y.PAY.DATE = ''; Y.DEP.NO = ''; Y.INT.RATE = ''; Y.INT.VALUE = ''
                FLAG = 1
            END
            GOSUB GET.VALUES.DIFF.CUS
            Y.BENE.NAME = Y.BENEFIC.NAME
            Y.DUP.BEN.AC = Y.BEN.ACC
            Y.DUP.BNK.CODE = Y.BEN.BNK.CODE
        END ELSE
            GOSUB GET.VALUES.SAME.CUS
            Y.BENE.NAME = Y.BENEFIC.NAME
            Y.DUP.BEN.AC = Y.BEN.ACC
            Y.DUP.BNK.CODE = Y.BEN.BNK.CODE
        END
        IF FLG.CK EQ NO.OF.RECS THEN
            Y.FIN.ARR<-1> = Y.BENE.NAME:'*':Y.DUP.BEN.AC:'*':Y.DUP.BNK.CODE:'*':Y.CUSTOMER.NAME:'*':Y.AGENCY:'*':Y.PAY.DATE:'*':Y.DEP.NO:'*':Y.INT.VALUE:'*':Y.TOT.INT.VAL
        END

    REPEAT

RETURN
*----------------------------------------------------------------------------------------------------
GET.VALUES.DIFF.CUS:
*----------------------------------------------------------------------------------------------------
    Y.AGENCY = R.REDO.ACH.DET<REDO.ACH.AGENCY>
    Y.PAY.DATE = R.REDO.ACH.DET<REDO.ACH.PAYMENT.DATE>
    Y.PAY.DATE = ICONV(Y.PAY.DATE,'D')
    Y.PAY.DATE = OCONV(Y.PAY.DATE,'D')
    Y.DEP.NO = R.REDO.ACH.DET<REDO.ACH.DEPOSIT.NO>
    Y.INT.VALUE = R.REDO.ACH.DET<REDO.ACH.INT.PAYMNT.AMT>
    Y.CUSTOMER.NAME = R.REDO.ACH.DET<REDO.ACH.CLIENT.ID>
    Y.TOT.INT.VAL = Y.INT.VALUE

RETURN
*----------------------------------------------------------------------------------------------------
GET.VALUES.SAME.CUS:
*----------------------------------------------------------------------------------------------------
    Y.AGENCY := @VM:R.REDO.ACH.DET<REDO.ACH.AGENCY>
    Y.CH.PAY.DATE = R.REDO.ACH.DET<REDO.ACH.PAYMENT.DATE>
    Y.CH.PAY.DATE = ICONV(Y.CH.PAY.DATE,'D')
    Y.CH.PAY.DATE = OCONV(Y.CH.PAY.DATE,'D')
    Y.PAY.DATE := @VM:Y.CH.PAY.DATE
    Y.DEP.NO := @VM:R.REDO.ACH.DET<REDO.ACH.DEPOSIT.NO>
    Y.INT.VALUE := @VM:R.REDO.ACH.DET<REDO.ACH.INT.PAYMNT.AMT>
* Y.CUSTOMER.NAME := VM:R.REDO.ADMIN.CHEQ<REDO.AD.CHQ.CLIENT.NAME>
    Y.TOT.INT.VAL += R.REDO.ACH.DET<REDO.ACH.INT.PAYMNT.AMT>

RETURN
*----------------------------------------------------------------------------------------------------
PROGRAM.END:

END
