* @ValidationCode : MjotMTAyNDM3Mzc4MzpDcDEyNTI6MTY4NDg0MjE1NjczNTpJVFNTOi0xOi0xOjMwMDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE V.MB.SDB.DFLT.CUSTNO
*---------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MB.SDB.POST

    FN.CUST = 'F.CUSTOMER'
    F.CUST = ''
    CALL OPF(FN.CUST,F.CUST)

    MEMBR.NO = R.NEW(SDB.POST.CUSTOMER.NO)
    IF R.NEW(SDB.POST.HOLDER.NAME) EQ '' THEN
        FN.CUST = 'F.CUSTOMER' ; F.CUST = ''
        CALL OPF(FN.CUST,F.CUST)

        R.CUST = '' ; CUSTERR = ''
        CALL F.READ(FN.CUST,MEMBR.NO,R.CUST,F.CUST,CUSTERR)
        R.NEW(SDB.POST.HOLDER.NAME) = R.CUST<EB.CUS.SHORT.NAME>
    END

RETURN

END
