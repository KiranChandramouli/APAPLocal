$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.EMP.DETAILS

*------------------------------------------------------------------------
* Description : This routine is used to display only the ACCOUNTS of the
*               Current User while launching an Enquiry
*------------------------------------------------------------------------
* Routine type   : Conversion routine
* Input Argument : O.DATA
* Out Argument   : O.DATA
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*    DATE               WHO            REFERENCE           DESCRIPTION
* 08-MAR-2011     L VENKATACHALAM   N.22 - HD1053751      Initial Draft
*                                    (PACS00023964)
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.EMPLOYEE.ACCOUNTS

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*--------------------------------------------------------------------------
INIT:

    FN.CUS.ACT = 'F.CUSTOMER.ACCOUNT'
    F.CUS.ACT = ''

    FN.EMP.DETS = 'F.REDO.EMPLOYEE.ACCOUNTS'
    F.EMP.DETS = ''

    R.CUST.ACCT = ''
    R.CUS.DET = ''
    Y.ACC.LIST = ''

RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:

    CALL OPF(FN.CUS.ACT,F.CUS.ACT)
    CALL OPF(FN.EMP.DETS,F.EMP.DETS)

RETURN
*-----------------------------------------------------------------------------
PROCESS:

    CUST.ID = O.DATA

    CALL F.READ(FN.EMP.DETS,CUST.ID,R.CUS.DET,F.EMP.DETS,EM.ERR)

    Y.USR.ID = R.CUS.DET<REDO.EMP.USER.ID>

    IF R.CUS.DET NE '' THEN

        CALL F.READ(FN.CUS.ACT,CUST.ID,R.CUST.ACCT,F.CUS.ACT,C.ERR)

        IF Y.USR.ID EQ OPERATOR THEN
            Y.ACC.LIST = R.CUST.ACCT
        END

    END

    CHANGE @FM TO @VM IN Y.ACC.LIST

    O.DATA = Y.ACC.LIST

RETURN
*-----------------------------------------------------------------------------
END
