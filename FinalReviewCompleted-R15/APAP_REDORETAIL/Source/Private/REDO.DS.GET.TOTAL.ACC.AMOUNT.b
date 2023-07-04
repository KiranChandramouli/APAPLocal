* @ValidationCode : MjotMzc5ODU5MjI3OkNwMTI1MjoxNjgxOTA1Njc5OTk0OklUU1M6LTE6LTE6LTg6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.GET.TOTAL.ACC.AMOUNT(VAR.TOT.AMOUNT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.TOTAL.ACC.AMOUNT
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the AMOUNT VALUE
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB PROCESS

RETURN
*********
PROCESS:
**********

    Y.AMOUNT = R.NEW(AC.ACL.TOTAL.ACC.AMT)
    Y.CURR = R.NEW(AC.ACL.CURRENCY)


    Y.AMOUNT = TRIM(FMT(Y.AMOUNT,"L2,#19")," ",'B')

    VAR.TOT.AMOUNT = Y.CURR:" ":Y.AMOUNT

RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
