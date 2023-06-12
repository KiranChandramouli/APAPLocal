$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.GET.PRD
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , SM to @SM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_ENQUIRY.COMMON

    Y.AA.IDS = O.DATA

    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    CALL OPF(FN.AA,F.AA)

    Y.AA.IDS = CHANGE(Y.AA.IDS,@SM,@VM)
    Y.CNT = DCOUNT(Y.AA.IDS,@VM)
    FLG = '' ; Y.PRD.LIST = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.ID = Y.AA.IDS<1,FLG>
        CALL F.READ(FN.AA,Y.ID,R.AA,F.AA,AA.ERR)
        Y.PRD = R.AA<AA.ARR.PRODUCT>
        Y.PRD.LIST<1,-1>  = Y.PRD
        Y.CNT -= 1
    REPEAT

    O.DATA = Y.PRD.LIST

RETURN

END
