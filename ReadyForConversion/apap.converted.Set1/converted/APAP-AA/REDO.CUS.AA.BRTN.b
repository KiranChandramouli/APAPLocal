SUBROUTINE REDO.CUS.AA.BRTN(ENQ.DATA)
*
*
*--------------------------------------------------------------------------
* This routine fetches the Collateral IDs for the arrangement Specified
*
*---------------------------------------------------------------------------------------------------------
*
* Modification History
*
*
*---------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_B02.COMMON

*---------------------------------------------------------------------------------------------------------
MAIN.LOGIC:
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------------------------------------
INITIALISE:
    COMM.CUS = ""

RETURN
*---------------------------------------------------------------------------------------------------------
PROCESS:

    COMM.CUS = R.NEW(INS.DET.CUSTOMER)


RETURN
*---------------------------------------------------------------------------------------------------------
END
