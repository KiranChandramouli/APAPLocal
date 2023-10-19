$PACKAGE APAP.REDOSRTN
* @ValidationCode : MjoyMDUwNjc3OTgzOkNwMTI1MjoxNjg3Nzc2NDEyNjg2OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2023 16:16:52
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



*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.S.GET.TFS.TOT.AMT(Y.TOTAL.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.GET.TFS.TOT.AMT
*---------------------------------------------------------------------------------
 
*DESCRIPTION       :This routine is to get the total amount for TFS transaction
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*26/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             NOCHANGE
*26/06/2023      SURESH                     MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*  $INSERT I_F.T24.FUND.SERVICES    ;*R22 MANUAL CODE CONVERSION


    Y.INIT.TXN = 1
    Y.TXN.AMT = 0
    Y.TOTAL.AMT = 0
    TXN.LIST = R.NEW(TFS.TRANSACTION)
    Y.TXN.COUNT = DCOUNT(TXN.LIST,@VM)

    LOOP
        REMOVE Y.TXN.ID FROM TXN.LIST SETTING Y.TXN.POS
    WHILE Y.INIT.TXN LE Y.TXN.COUNT
        IF Y.TXN.ID NE 'NET.ENTRY' THEN
            Y.TXN.AMT = R.NEW(TFS.AMOUNT)<1,Y.INIT.TXN>
            Y.TOTAL.AMT += Y.TXN.AMT
        END
        Y.INIT.TXN++
    REPEAT

RETURN
END
