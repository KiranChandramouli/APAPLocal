* @ValidationCode : Mjo5NTAzMzQ0MTQ6Q3AxMjUyOjE2ODE3MjM2ODI2Mzg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 14:58:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.TELLER.GEN.ENQ

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.BRANCH.STATUS

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TELLER.GEN.ENQ
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.TELLER.GEN.ENQ is a Input routine to generate Withdraw,Deposit and Denomination
*                    enquiry
*Linked With       :

*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 30 May 2011       Shiva Prasad Y              ODR-2011-04-0007 32         Initial Creation
* 20 Jul 2018       Gopala Krishnan R           PACS00676434                Issue Fix
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*********************************************************************************************************
    Y.GET.STATUS = R.NEW(TT.TID.STATUS)

    IF Y.GET.STATUS EQ 'CLOSE' THEN
        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.WIT.R32 TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.DEP.R32 TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASHIER.DENOM TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.TELLER.CASHIER.REPORT TELLER.ID EQ ':ID.NEW:''
        CALL EB.SET.NEW.TASK(Y.INP)
    END
RETURN
END
