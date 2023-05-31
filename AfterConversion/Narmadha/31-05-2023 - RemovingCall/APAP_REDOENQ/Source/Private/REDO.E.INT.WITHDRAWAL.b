$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.INT.WITHDRAWAL
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.INT.WITHDRAWAL
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
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
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
* Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus End
*-------------------------------------------------------------------------------------------------------

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*--------------------------------------------------------------------------------------------------------
OPENFILES:
*--------------------------------------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT =''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    Y.APPL = 'ACCOUNT'
    Y.FIELDS = 'L.AC.REINVESTED'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELDS,Y.POS)
    Y.L.AC.REINVESTED.POS = Y.POS<1,1>
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

    Y.AMT = ''
    Y.ID = O.DATA
    O.DATA=''
    CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,F.ERR)
    Y.REINVEST.STATUS = R.ACCOUNT<AC.LOCAL.REF><1,Y.L.AC.REINVESTED.POS>
    IF Y.REINVEST.STATUS EQ 'YES' THEN
        Y.INT.LIQ.ACCT = R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
        CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACCT,R.ACC,F.ACCOUNT,ERR)
* Tus Start
        R.ECB = '' ; ECB.ERR = '' ;
        CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.INT.LIQ.ACCT,R.ECB,ECB.ERR)
        LOCATE 'CUST-DR' IN R.ECB<ECB.INITIATOR.TYPE,1> SETTING CUST.DR.POS THEN
            Y.AMT = R.ECB<ECB.AMNT.LAST,CUST.DR.POS>
*    Y.AMT = R.ACC<AC.AMNT.LAST.DR.CUST>
* Tus End
        END
        IF Y.AMT NE '' THEN
            O.DATA = Y.AMT
        END
        RETURN
    END
