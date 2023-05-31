* @ValidationCode : MjotMjAyNzU2NzU2MTpDcDEyNTI6MTY4NDg1MTk2MDAzMjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 19:56:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.AC.BAL.RTN
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : E.AC.BAL.RTN
*--------------------------------------------------------------------------------------------------------
*Description  : E.AC.BAL.RTN. is a conversion routine
*               This routine is used to fetch the closing balance of the account on a particular date
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ------------------------    ----------------        ----------------
* 30 DEC 2010    PRASHANTH RAI J             ODR-2010-08-0181        Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------

*
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY


    ACCT.ID = FIELD(O.DATA,'*',2,1)
    P.DATE = FIELD(O.DATA,'*',1,1)
    Y.REGION = ''
    IF P.DATE NE '' THEN
        CALL CDT(Y.REGION,P.DATE,'-1W')
    END
    DB.MVM=""
    OPEN.BAL=""
    R.ACCT=""
    ACCT.BAL=""
    CR.MVT=""
    CALL EB.GET.ACCT.BALANCE(ACCT.ID,R.ACCT,'BOOKING',P.DATE,'',ACCT.BAL,CR.MVM,DB.MVM,ERR.MSG)
    O.DATA = TRIM(ACCT.BAL)
RETURN
END
