* @ValidationCode : MjoxMzMzNDA2Njk5OkNwMTI1MjoxNjgwNzgxOTU0MjIyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:22:34
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.UPD.ADM.MGR.CHQ
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MARIMUTHU S
* PROGRAM NAME: REDO.INP.UPD.ADM.MGR.CHQ
* ODR NO      : PACS00062902
*----------------------------------------------------------------------
*DESCRIPTION: This routine is input routine attached with FT,CHQ.OTHERS.LOAN.DUM to get the cheque number for admin as well as manager chq

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO              REFERENCE                        DESCRIPTION
*18-07-2011   Marimuthu                                          PACS00062902
*06-04-2023   Conversion Tool    R22 Auto Code conversion          No Changes
*06-04-2023    Samaran T          R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    IF APPLICATION EQ "FUNDS.TRANSFER" THEN

        VAR.CR.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)

        CALL F.READ(FN.ACCOUNT,VAR.CR.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        VAR.CUST = R.ACCOUNT<AC.CUSTOMER>
        IF NOT(VAR.CUST) THEN
            CALL APAP.TAM.REDO.VCR.CHEQUE.NUMBER
        END ELSE
            CALL APAP.TAM.REDO.V.INP.DEFAULT.ACCT
        END
    END

RETURN
*--------------------------------------------------
END
