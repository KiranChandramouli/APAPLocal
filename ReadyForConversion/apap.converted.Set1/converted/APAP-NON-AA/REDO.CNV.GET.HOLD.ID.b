SUBROUTINE REDO.CNV.GET.HOLD.ID
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
***Input argument extract first 6 charcter from date.time field

    FN.DEP.REPRINT = 'F.REDO.DEP.REPRINT.DETAILS'
    F.DEP.REPRINT = ''
    CALL OPF(FN.DEP.REPRINT,F.DEP.REPRINT)

    AZ.ID = O.DATA

    CALL F.READ(FN.DEP.REPRINT,AZ.ID,R.HOLD.ID,F.DEP.REPRINT,DEP.ERR)

    O.DATA = R.HOLD.ID

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
