* @ValidationCode : MjotMTc0MTA4MTE0NjpDcDEyNTI6MTY4MjMzMTMyMDI4NDpJVFNTOi0xOi0xOjM5NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 396
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CLEAR.MV.CUSTOMER.RELATION(Y.OFS.TRANSACTION.ID, Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.ERROR)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER ;*R22 Auto conversion - END
   $USING EB.TransactionControl
   $USING ST.CompanyCreation

*CLEAR OUTPUTS VARIABLES
    Y.OFS.IN.REQUEST = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.CLEAR.MV.CUSTOMER.PHONE'

    FN.CUSTOMER = 'F.CUSTOMER'
*FN.CUSTOMER<2> = 'NO.FATAL.ERROR'
    F.CUSTOMER = ''

*DEBUG
    Y.ID.COMPANY = "DO0010001"
    IF ID.COMPANY NE Y.ID.COMPANY THEN
*        CALL LOAD.COMPANY(Y.ID.COMPANY)
ST.CompanyCreation.LoadCompany(Y.ID.COMPANY);* R22 UTILITY AUTO CONVERSION
    END

*DEBUG
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,Y.OFS.TRANSACTION.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

*DEBUG
    IF CUSTOMER.ERR EQ "" THEN
        R.CUSTOMER<EB.CUS.RELATION.CODE> = ""
        R.CUSTOMER<EB.CUS.REL.CUSTOMER> = ""
        R.CUSTOMER<EB.CUS.REVERS.REL.CODE> = ""
        R.CUSTOMER<EB.CUS.REL.DELIV.OPT> = ""
        R.CUSTOMER<EB.CUS.ROLE> = ""
        R.CUSTOMER<EB.CUS.ROLE.MORE.INFO> = ""
        R.CUSTOMER<EB.CUS.ROLE.NOTES> = ""

        CALL F.LIVE.WRITE(FN.CUSTOMER, Y.OFS.TRANSACTION.ID, R.CUSTOMER)
*        CALL JOURNAL.UPDATE(Y.OFS.TRANSACTION.ID)
EB.TransactionControl.JournalUpdate(Y.OFS.TRANSACTION.ID);* R22 UTILITY AUTO CONVERSION
    END

RETURN
