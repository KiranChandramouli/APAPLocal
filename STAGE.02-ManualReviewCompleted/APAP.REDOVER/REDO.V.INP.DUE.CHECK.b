* @ValidationCode : MjoxNTkwMjYwOTU5OkNwMTI1MjoxNjgxMjE0OTI2NTUxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:38:46
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
SUBROUTINE REDO.V.INP.DUE.CHECK
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sakthi Sellappillai
*Program   Name    :REDO.V.INP.DUE.CHECK
*Developed for     :ODR-2010-08-0031
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a validation routine attached to advance payment check for no due version of FT
*LINKED WITH       :
*----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date            who                       Reference                                 Description
*=========          ==========                ==============                             ============
* 11-10-2010        Sakthi Sellappillai       ODR-2010-08-0031                       Initial Creation
*11-04-2023           Conversion Tool          R22 Auto Code conversion             FM TO @FM,VM TO @VM,SM TO @SM
*11-04-2023           Samaran T                R22 Manual Code conversion               No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    VAR.AC.ID=R.NEW(FT.CREDIT.ACCT.NO)
    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------
    CALL F.READ(FN.ACCOUNT,VAR.AC.ID,R.ACCOUNT,F.ACCOUNT,ERR)
    VAR.AA.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL F.READ(FN.AA.ARRANGEMENT,VAR.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ERR)
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS ,F.AA.ACCOUNT.DETAILS ,ERR)
    VAR.SET.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @VM TO @FM IN  VAR.SET.LIST
    CHANGE @SM TO @FM IN  VAR.SET.LIST
    LOCATE 'UNPAID' IN  VAR.SET.LIST SETTING POS THEN
        ETEXT = 'EB-NO.DUE.NOT.ALLOWED'
        AF=FT.CREDIT.ACCT.NO
        CALL STORE.END.ERROR
    END
RETURN
END
