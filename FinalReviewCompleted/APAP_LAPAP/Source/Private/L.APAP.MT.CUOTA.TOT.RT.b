$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.MT.CUOTA.TOT.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.BILL.DETAILS

    Y.ARR = O.DATA
    Y.TOT.CUOTA = 0

    IF Y.ARR NE '' THEN
        GOSUB INIT
        GOSUB SET.MONTO.CUOTA
    END

    O.DATA = Y.TOT.CUOTA

RETURN

*----------
INIT:
*----------

    FN.BILL  = "F.AA.BILL.DETAILS"
    FV.BILL  = ""
    R.BILL  = ""
    BILL.ERR = ""
    CALL OPF(FN.BILL,FV.BILL)

    SEL.LIST = ""
    NO.OF.RECS = ""
    SEL.ERR = ""

RETURN

*--------------
SET.MONTO.CUOTA:
*--------------
    SEL.CMD = "SELECT " : FN.BILL : " WITH ARRANGEMENT.ID EQ ": Y.ARR :" AND SETTLE.STATUS EQ 'UNPAID' AND OS.TOTAL.AMOUNT GT 0"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)

    LOOP REMOVE Y.BILL.DET FROM SEL.LIST SETTING CR.POS
    WHILE Y.BILL.DET DO
        CALL F.READ(FN.BILL, Y.BILL.DET, R.BILL, FV.BILL, BILL.ERR)

        Y.TOT.CUOTA = Y.TOT.CUOTA + SUM(R.BILL<AA.BD.OS.PROP.AMOUNT>)

    REPEAT

RETURN

END
