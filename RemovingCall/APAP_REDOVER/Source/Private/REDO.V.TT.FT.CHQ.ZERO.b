* @ValidationCode : Mjo0MTcwMTgxMjM6Q3AxMjUyOjE2ODI0MTIzNTUyMDk6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.TT.FT.CHQ.ZERO
*
* Client: APAP
* Description: Routine to remove the leading zero's from the CERT.CHEQUE.NO field.
*----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

    IF COMI NE '' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN

INIT:
*****
    APPL.NAME = "FUNDS.TRANSFER":@FM:"TELLER"
    APPL.FIELD = "CERT.CHEQUE.NO":@FM:"CERT.CHEQUE.NO"
    APPL.LOC = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,APPL.FIELD,APPL.LOC)
    FT.CERT.CHEQUE.NO = APPL.LOC<1,1>
    TT.CERT.CHEQUE.NO = APPL.LOC<2,1>
RETURN

PROCESS:
********
    YCHQ.VAL = ''
    IF APPLICATION EQ 'FUNDS.TRANSFER' AND AV EQ FT.CERT.CHEQUE.NO THEN
        YCHQ.VAL = COMI
        COMI = TRIM(YCHQ.VAL,"0","L")
        R.NEW(FT.LOCAL.REF)<1,FT.CERT.CHEQUE.NO,AS> = COMI
        V$DISPLAY = COMI
    END

    IF APPLICATION EQ 'TELLER' AND AV EQ TT.CERT.CHEQUE.NO THEN
        YCHQ.VAL = COMI
        COMI = TRIM(YCHQ.VAL,"0","L")
        R.NEW(TT.TE.LOCAL.REF)<1,TT.CERT.CHEQUE.NO> = COMI
        V$DISPLAY = COMI
    END
RETURN
END
