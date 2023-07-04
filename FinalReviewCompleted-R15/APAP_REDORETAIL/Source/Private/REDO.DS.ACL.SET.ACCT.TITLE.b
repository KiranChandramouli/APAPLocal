* @ValidationCode : MjozNDQyNzY4OTg6Q3AxMjUyOjE2ODE4MjkwOTEyNTU6SVRTUzotMTotMToxOTI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 192
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.ACL.SET.ACCT.TITLE(ACCT.TITLE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.ACL.SET.ACCT.TITLE
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the account title value.
* ----------------------------------------------------------------------------------
* MODIFICATION HISTORY:
* DATE            WHO               REFERENCE              DESCRIPTION
* 07 MAY 2012     Sudharsanan S     CR.20         This program is used to get the account title value.
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.ACCOUNT

    GOSUB PROCESS
RETURN
*********
PROCESS:
**********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    VAR.ID = R.NEW(AC.ACL.SETTLEMENT.ACCT)

    CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    ACCT.TITLE = R.ACCOUNT<AC.ACCOUNT.TITLE.1>

RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
