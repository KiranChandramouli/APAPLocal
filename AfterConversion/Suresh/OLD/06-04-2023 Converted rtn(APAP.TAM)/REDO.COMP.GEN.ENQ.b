* @ValidationCode : MjotNTQ4NjQwMTg1OkNwMTI1MjoxNjgwNzY3ODI5Mzg2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 13:27:09
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
SUBROUTINE REDO.COMP.GEN.ENQ

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.BRANCH.STATUS

*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.RTE.DENOM.EXCESS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.COMP.GEN.ENQ is a Input routine to generate Withdraw,Deposit and Denomination
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
* 30 May 2011       Shiva Prasad Y              ODR-2011-03-0150 35         Initial Creation
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*********************************************************************************************************

    Y.GET.STATUS = R.NEW(BR.ST.OPERATION.STATUS)
    IF Y.GET.STATUS EQ 'CLOSED' THEN


        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.WIT AGENCY EQ "':ID.NEW:'"'
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.DEP AGENCY EQ "':ID.NEW:'"'
        CALL EB.SET.NEW.TASK(Y.INP)

        Y.INP = 'ENQ REDO.APAP.ENQ.CASH.WINDOW.DENOM AGENCY EQ "':ID.NEW:'"'
        CALL EB.SET.NEW.TASK(Y.INP)

    END
RETURN
END
