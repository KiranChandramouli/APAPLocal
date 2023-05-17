SUBROUTINE REDO.V.AUTH.DIS.PROCESS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is an authorisation routine attached to below versions,
*TELLER,COLLECT.AA.REPAY

* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-11-2010        JEEVA T        ODR-2010-08-0017    Baselined after few logic changes
*------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
*   $INSERT I_F.TELLER
    $INSERT I_F.REDO.MTS.DISBURSE


    GOSUB INIT
    GOSUB PROCESS
RETURN

******
INIT:
******
*Initialize all the variables

    FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'
    F.REDO.MTS.DISBURSE = ''
    CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)

RETURN
*********
PROCESS:
*********
* Removal of Transaction ID from the local table

    IF APPLICATION EQ 'FUNDS.TRANSFER' AND PGM.VERSION EQ ",REDO.AA.CUS.PAY" THEN
        VAR.FT.PROCESS.ID=R.NEW(FT.CREDIT.THEIR.REF)
        CALL F.DELETE(FN.REDO.MTS.DISBURSE,VAR.FT.PROCESS.ID)
    END
    IF APPLICATION EQ 'TELLER' AND PGM.VERSION EQ ",REDO.AA.CUS.PAY" THEN
        VAR.FT.PROCESS.ID=R.NEW(TT.TE.NARRATIVE.1)
        CALL F.DELETE(FN.REDO.MTS.DISBURSE,VAR.FT.PROCESS.ID)
    END
RETURN
*******************************************************************************************
END
