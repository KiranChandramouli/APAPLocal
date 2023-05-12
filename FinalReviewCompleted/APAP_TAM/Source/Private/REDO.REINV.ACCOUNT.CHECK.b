* @ValidationCode : MjotMjg4MTA0MDA0OkNwMTI1MjoxNjgyNTI4NDcxOTU1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:11
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.REINV.ACCOUNT.CHECK
*-------------------------------------------------------
* Description: This routine is to restrict the Reinvested
* Interest Liq account from doing the transactions.
*-------------------------------------------------------

* In  Arg : N/A
* Out Arg : N/A

*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO                REFERENCE         DESCRIPTION
* 10 Sep 2011     H Ganesh        PACS00102785 - N.11  INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
RETURN

*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

    Y.ACC.ID = COMI
    IF COMI EQ '' THEN
        RETURN
    END
    GOSUB OPEN.FILES

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>

    IF Y.CATEGORY GE 6011 AND Y.CATEGORY LE 6020 THEN
        ETEXT = 'EB-REDO.REINV.ACC.CHECK'
        CALL STORE.END.ERROR
    END


RETURN
*-------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
END
