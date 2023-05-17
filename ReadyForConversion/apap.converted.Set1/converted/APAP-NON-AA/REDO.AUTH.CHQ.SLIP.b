SUBROUTINE REDO.AUTH.CHQ.SLIP
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Temenos Development
*  Program   Name    :REDO.AUTH.CHQ.SLIP
***********************************************************************************
*Description:    This is an AUTHORISATION routine attached to the Enquiry used
*                to PRINT a deal slip when the User clicks on PRINT option
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*15-10-2011       JEEVA T                   B.34             Initial Creation
****************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.ADMIN.CHEQUE.DETAILS
    $INSERT I_F.REDO.APAP.H.REPRINT.CHQ

    GOSUB INIT
    GOSUB PROCESS
RETURN

****
INIT:
*****
    FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
    F.REDO.ADMIN.CHEQUE.DETAILS = ''

    CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)

    R.REDO.ADMIN.CHEQUE.DETAILS =''

    CALL F.READ(FN.REDO.ADMIN.CHEQUE.DETAILS,ID.NEW,R.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS,CHEQ.ERR)

RETURN

*----------
PROCESS:
*----------
    VAR.REPRINT.FLAG = R.NEW(REDO.REP.CHQ.REPRINT.FLAG)
    IF VAR.REPRINT.FLAG EQ 'YES' THEN
        R.REDO.ADMIN.CHEQUE.DETAILS<REDO.AD.CHQ.APPROVAL> = VAR.REPRINT.FLAG
        CALL F.WRITE(FN.REDO.ADMIN.CHEQUE.DETAILS,ID.NEW,R.REDO.ADMIN.CHEQUE.DETAILS)
    END
RETURN
*------------------------------------------------------------------------------------
END
