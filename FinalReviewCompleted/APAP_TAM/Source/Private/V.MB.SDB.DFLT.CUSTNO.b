* @ValidationCode : MjotMTAyNDM3Mzc4MzpDcDEyNTI6MTY4MTg5NDA4MDg1OTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 14:18:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
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
