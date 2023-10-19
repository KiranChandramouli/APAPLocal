$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.DIFF.DATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.DIFF.DATE
*--------------------------------------------------------------------------------------------------------
*Description       : This build routine is used to find out difference between from and to date
*
*Linked With       : Enquiry REDO.INVESTMENT.REINVESTMENT.R94
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 13 August 2010      Jeyachandran S       ODR-2010-03-0094 103         Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN

*-------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
RETURN

*--------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------

    Y.DIFF = ''
    Y.ID = O.DATA
    CALL F.READ(FN.AZ.ACCOUNT,Y.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,F.ERR)
    Y.VAL.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.MAT.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    IF Y.MAT.DATE NE '' AND Y.VAL.DATE NE '' THEN
        Y.DAYS = 'C'
        CALL CDD(Y.DIFF,Y.VAL.DATE,Y.MAT.DATE,Y.DAYS)
        O.DATA = Y.DAYS
    END
RETURN
*---------------------------------------------------------------------
GOEND:
RETURN
*---------------------------------------------------------------------
END
