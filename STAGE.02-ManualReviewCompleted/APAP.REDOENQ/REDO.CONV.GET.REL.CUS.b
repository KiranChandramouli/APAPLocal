$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.GET.REL.CUS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.GET.REL.CUS
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the related customer for dposit number
*Linked With       : Enquiry REDO.DEP.ACC.BAL
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who                       Reference                                 Description
*     ------         -----                    -------------                             -------------
* 11 NOV 2011     Sudharsanan s                    CR.18                                Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    GOSUB INIT
RETURN
******
INIT:
******

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    GOSUB PROCESS.PARA

RETURN
*************
PROCESS.PARA:
*************

    VAR.ACT.ID = O.DATA

    CALL F.READ(FN.ACCOUNT,VAR.ACT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    VAR.CUS.ID = R.ACCOUNT<AC.CUSTOMER>
    VAR.REL.ID = R.ACCOUNT<AC.JOINT.HOLDER>

    IF VAR.REL.ID THEN
        VAR.OUTPUT = VAR.CUS.ID:@VM:VAR.REL.ID
        CHANGE @VM TO " -" IN VAR.OUTPUT
    END ELSE
        VAR.OUTPUT = VAR.CUS.ID
    END

    O.DATA = VAR.OUTPUT

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
*---------------------------------------------------------------------------------------------------------
