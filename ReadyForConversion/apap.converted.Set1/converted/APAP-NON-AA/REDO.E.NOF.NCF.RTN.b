SUBROUTINE REDO.E.NOF.NCF.RTN(TXN.ARRAY)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is a no file enquiry routine for the enquiry REDO.E.NCF.ISSUED
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : TXN.ARRAY
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*08.02.2010      PRABHU N         ODR-2009-10-0321         INITIAL CREATION
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.L.NCF.CANCELLED

    GOSUB INIT
    GOSUB PROCESS
RETURN


INIT:
******

    FN.REDO.NCF.ISSUED='F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED=''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

    FN.REDO.L.NCF.CANCELLED='F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED=''
    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)
    Y.TXN.DATE=''
RETURN

PROCESS:
*********

    LOCATE "TXN.ID" IN D.FIELDS<1> SETTING POS THEN
        Y.TXN.ID=D.RANGE.AND.VALUE<POS>
    END
    SEL.NCF.CMD='SELECT ':FN.REDO.NCF.ISSUED:' WITH TXN.ID LIKE ':Y.TXN.ID:'...'
    CALL EB.READLIST(SEL.NCF.CMD,SEL.NCF.LIST,'',NCF.COUNT,NCF.ERR)
    LOOP
        REMOVE Y.NCF.ID FROM SEL.NCF.LIST SETTING NCF.POS
    WHILE Y.NCF.ID:NCF.POS
        CALL F.READ(FN.REDO.NCF.ISSUED,Y.NCF.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ERR.NCF)
        TRANSACTION.ID=R.REDO.NCF.ISSUED<ST.IS.TXN.ID>
        NCF=R.REDO.NCF.ISSUED<ST.IS.NCF>
        CHARGE.AMOUNT=R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
        TAX=R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>
        Y.DATE=R.REDO.NCF.ISSUED<ST.IS.DATE>
        TXN.ARRAY<-1>=TRANSACTION.ID:'*':NCF:'*':CHARGE.AMOUNT:'*':TAX:'*':Y.DATE
    REPEAT

    SEL.NCF.CMD='SELECT ':FN.REDO.L.NCF.CANCELLED:' WITH TXN.ID LIKE ':Y.TXN.ID:'...'
    CALL EB.READLIST(SEL.NCF.CMD,SEL.NCF.LIST,'',CAN.COUNT,CAN.ERR)
    LOOP
        REMOVE Y.NCF.CANCEL.ID FROM SEL.NCF.LIST SETTING NCF.CAN.POS
    WHILE Y.NCF.CANCEL.ID:NCF.CAN.POS
        CALL F.READ(FN.REDO.L.NCF.CANCELLED,Y.NCF.CANCEL.ID,R.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED,ERR.NCF.CANCEL)
        TRANSACTION.ID=R.REDO.L.NCF.CANCELLED<NCF.CAN.TXN.ID>
        NCF=R.REDO.L.NCF.CANCELLED<NCF.CAN.NCF>
        CHARGE.AMOUNT=R.REDO.L.NCF.CANCELLED<NCF.CAN.CHARGE.AMOUNT>
        TAX=R.REDO.L.NCF.CANCELLED<NCF.CAN.TAX.AMOUNT>
        Y.DATE=R.REDO.L.NCF.CANCELLED<NCF.CAN.DATE>
        TXN.ARRAY<-1>=TRANSACTION.ID:'*':NCF:'*':CHARGE.AMOUNT:'*':TAX:'*':Y.DATE
    REPEAT

RETURN

END
