* @ValidationCode : MjoxODYwNTg0MDg1OkNwMTI1MjoxNjgzODkyNjE2MjIwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:26:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FT.LAUNCH.SUPPORTING.ENQ
*----------------------------------------------------------------------------------------------------------------------
* Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By      : Temenos Application Management
* Program   Name    : REDO.FT.LAUNCH.SUPPORTING.ENQ
*----------------------------------------------------------------------------------------------------------------------
* Description       : Routine to refresh all the enquiries displayed in CASHOFF.REDO.COS cos screen
* Linked With       : VERSION.CONTROL FT
* In  Parameter     : N/A
* Out Parameter     : N/A
* Files  Used       : FUNDS.TRANSFER
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference      Description
* ------       -----                ------------   -------------
* 21-06-2013   Vignesh Kumaar M R   PACS00269527   Refresh all the enquiries of CASHOFF.REDO.COS COS Screen
* 22-07-2013   Vignesh Kumaar M R   PACS00306799   REDO.CUST.ACCT.FULL.CASH NOT TO BE TRIGGERED FOR COS CASHIER.NV.COS
* 31-07-2013   Vignesh Kumaar M R   PACS00305984   CASHIER DEAL SLIP PRINT OPTION
* 10/04/2014   Vignesh Kumaar M R   PACS00349444   Shouldn't allow user to amend the record [updated]
** 06-04-2023 R22 Auto Conversion 
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_S.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_BROWSER.TAGS
    $INSERT I_F.FUNDS.TRANSFER
*
    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN
*
*-------
PROCESS:
*-------
*
    CALL F.READ(FN.FUNDS.TRANSFER.NAU,ID.NEW,R.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU,FT.ERR)

    IF R.FUNDS.TRANSFER.NAU AND V$FUNCTION EQ 'I' AND OFS$SOURCE.ID NE 'FASTPATH' THEN
        E = 'EB-CANNOT.AMEND.EXISTING.RECORD'         ;* Fix for PACS00349444
        CALL ERR
    END

    GET.FT.CRD.ACCT = R.NEW(FT.CREDIT.ACCT.NO)

* Fix for PACS00305984 [CASHIER DEAL SLIP PRINT OPTION]

    Y.GET.AUTHORISOR = R.NEW(FT.AUTHORISER)
    Y.GET.RECORD.STATUS = R.NEW(FT.RECORD.STATUS)

*    IF V$FUNCTION NE "I" OR V$FUNCTION NE "A" OR (V$FUNCTION EQ 'A' AND Y.GET.AUTHORISOR NE '' AND Y.GET.RECORD.STATUS EQ 'INAO') THEN
*        RETURN
*    END

    IF Y.COS.NAME[1,4] EQ Y.CASHIER.COS OR Y.COS.NAME[1,11] EQ Y.SUPER.COS OR Y.COS.NAME[1,11] EQ Y.BUSS.COS ELSE
        RETURN
    END

* End of Fix

    IF ALPHA(GET.FT.CRD.ACCT[1,3]) THEN
        GET.FT.CRD.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
        IF ALPHA(GET.FT.CRD.ACCT[1,3]) THEN
            RETURN
        END
    END

*
    GET.ENQ.LIST = 'ENQ REDO.ACCT.JHOLDER @ID EQ ':GET.FT.CRD.ACCT
    GET.ENQ.LIST<-1> = 'ENQ REDO.ENQ.RBHP.PADRONE ACCOUNT.NO EQ ':GET.FT.CRD.ACCT
    GET.ENQ.LIST<-1> = 'ENQ REDO.IM.CONSULTA.FIRMAS IMAGE.REFERENCE EQ ':GET.FT.CRD.ACCT

* Fix for PACS00306799 [REDO.CUST.ACCT.FULL.CASH NOT TO BE TRIGGERED FOR COS CASHIER.NV.COS]

    IF Y.COS.NAME[1,11] EQ Y.SUPER.COS THEN
        GET.ENQ.LIST<-1> = 'ENQ REDO.CUST.ACCT.FULL.CASH @ID EQ ':GET.FT.CRD.ACCT
    END

* End of Fix

    I.VAR = 1 ; Y.ENQ.CNT = DCOUNT(GET.ENQ.LIST,@FM) ; ;* R22 Auto conversion
    LOOP
    WHILE I.VAR LE Y.ENQ.CNT ;* R22 Auto conversion
        Y.NEXT.TASK = ''
        Y.NEXT.TASK = GET.ENQ.LIST<I.VAR> ;* R22 Auto conversion
        CALL EB.SET.NEW.TASK(Y.NEXT.TASK)
        I.VAR += 1 ;* R22 Auto conversion
    REPEAT

RETURN
*
* ---------
INITIALISE:
* ---------
*
    Y.COS.NAME = OFS$WINDOW.NAME

    Y.CASHIER.COS = 'TXNS'
    Y.SUPER.COS = 'OFFICERTXNS'
    Y.BUSS.COS = 'BUSINESSTXN'
*
    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''
    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)
*
RETURN
*
END
