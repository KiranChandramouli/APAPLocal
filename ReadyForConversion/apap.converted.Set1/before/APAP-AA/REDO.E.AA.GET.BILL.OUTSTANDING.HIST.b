*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.E.AA.GET.BILL.OUTSTANDING.HIST
*****************************************
* This is a conversion routine
* This routine accepts Bill Id(with or without Sim Ref)
* and returns OS.TOTAL.AMOUNT from the sum of all OS.PROP.AMOUNT
*
*****************************************
*MODIFICATION HISTORY
*
* 05/01/09 - BG_100021512
* Arguments changed for SIM.READ.
*
*****************************************
*
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_ENQUIRY.COMMON
    $INCLUDE T24.BP I_F.AA.BILL.DETAILS
*****************************************
*
    BILL.ID = O.DATA['%',1,1]
    SIM.REF = O.DATA['%',2,1]
    R.AA.BILLS = ''
    IF SIM.REF THEN
        CALL SIM.READ(SIM.REF, "F.AA.BILL.DETAILS.HIST", BILL.ID, R.AA.BILLS, "", "", RET.ERR)
    END ELSE
        CALL F.READ("F.AA.BILL.DETAILS.HIST", BILL.ID, R.AA.BILLS, F.AA.BILLS, RET.ERR)
    END
*
    IF R.AA.BILLS THEN
        O.DATA = SUM(R.AA.BILLS<AA.BD.OS.PROP.AMOUNT>)
    END
*
    RETURN
