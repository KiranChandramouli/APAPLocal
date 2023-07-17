* @ValidationCode : MjoxOTcwMzk1ODQwOkNwMTI1MjoxNjgzMDEwNzE2OTMxOklUU1M6LTE6LTE6MTkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 12:28:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.UPD.ADM.MGR.TABLES
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MARIMUTHU S
* PROGRAM NAME: REDO.AUT.UPD.ADM.MGR.TABLES
* ODR NO      : PACS00062902
*----------------------------------------------------------------------
*DESCRIPTION: This routine is AUTH routine attached with FT,CHQ.OTHERS.LOAN.DUM to update admin as well as manager chq tables

*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE               WHO                        REFERENCE                 DESCRIPTION
*18-07-2011       Marimuthu                                              PACS00062902
*04-04-2023       Conversion Tool          R22 Auto Code conversion      No Changes
*04-04-2023            Samaran T           Manual R22 Code Conversion    No Changes
* 25-APR-2023      Harishvikram C             Manual R22 conversion     CALL routine format modified
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
            CALL APAP.REDOVER.redoVAutUpdTables();*Manual R22 Code Conversion
        END ELSE
            CALL APAP.REDOVER.redoVAutUpdMgrtables();*Manual R22 Code Conversion
        END
    END

RETURN
*--------------------------------------------------
END
