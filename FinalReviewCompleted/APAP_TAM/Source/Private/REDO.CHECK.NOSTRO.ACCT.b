* @ValidationCode : MjotMTAyNTE0NjEwOTpDcDEyNTI6MTY4NDg0MjA4NjQ0MjpJVFNTOi0xOi0xOjE4ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 188
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CHECK.NOSTRO.ACCT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.CHECK.NOSTRO.ACCT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Bank name
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

PROCESS:
*Getting the Description of the Reject Code

    ACCT.ID = R.NEW(FT.CREDIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.CATEG = R.ACCOUNT<AC.CATEGORY>

    IF VAR.CATEG GE 5000 AND VAR.CATEG LE 5999 THEN
        FLAG = 1
    END
    IF FLAG NE 1 THEN
        AF = FT.CREDIT.ACCT.NO
        ETEXT = "EB-INVALID.ACCT"
        CALL STORE.END.ERROR
    END
RETURN
END
