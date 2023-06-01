$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.OS.AMT
*-----------------------------------------------------------------------------
* Marimuthus
* MANTIS  4798
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_ENQUIRY.COMMON



MAIN:

    FN.AA.BILL = 'F.AA.BILL.DETAILS'
    F.AA.BILL = ''
    CALL OPF(FN.AA.BILL,F.AA.BILL)

    Y.ID = O.DATA

    CALL F.READ(FN.AA.BILL,Y.ID,R.AA.BILL,F.AA.BILL,AA.BL.ERR)
    Y.OS.AMT = SUM(R.AA.BILL<AA.BD.OS.PROP.AMOUNT>)

    O.DATA = Y.OS.AMT

RETURN

END
