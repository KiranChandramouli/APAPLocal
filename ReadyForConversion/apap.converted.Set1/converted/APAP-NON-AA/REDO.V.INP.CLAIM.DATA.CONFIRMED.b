SUBROUTINE REDO.V.INP.CLAIM.DATA.CONFIRMED
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Input routine is used to check if the CUSTOMER has
* any previous claims in the same PRODUCT & TYPE & TRANSACTIOn.AMOUNT. If the same claim exits
* then OVERRIDE is displayed
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.INP.CLAIM.DATA.CONFIRMED
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
*05-05-2011         PRABHU             HD1100437         Line 48 modified to generate error in case data is not confirmed
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.CLAIMS
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.REDO.ISSUE.CLAIMS  = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS   = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)
*
RETURN

********
PROCESS:
********
*
    IF R.NEW(ISS.CL.STATUS) EQ 'OPEN' THEN
        IF R.NEW(ISS.CL.DATA.CONFIRMED) NE 'YES' THEN
            AF    = ISS.CL.DATA.CONFIRMED
            ETEXT ='EB-REDO.CUSTOMER.DATA.CONFIRMED'
            CALL STORE.END.ERROR
        END
    END
RETURN
END
