* @ValidationCode : MjotMzY3ODQ1NDkwOkNwMTI1MjoxNjgxMzgyMzMxNjM1OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:08:51
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
SUBROUTINE REDO.V.VAL.DEB.ACC.MAN
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SHANKAR RAJU
*Program   Name    :REDO.V.VAL.DEB.ACC.MAN
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a validation routine to check if the account is a of Savings/Current account category
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference                    Description
* 17-MAY-2011       SHANKAR RAJU  ODR-2010-01-0081(PACS Issues)   Check if the account is Savings/Current
* 02-SEP-2011       Marimuthu S   PACS000112741
*-------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.ACCOUNT.PARAMETER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ARRANGEMENT


    GOSUB INIT
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------
INIT:
*~~~~
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    R.ACCOUNT.CLASS = ''

    FN.ACCOUNT.PARAMETER = 'F.ACCOUNT.PARAMETER'
    F.ACCOUNT.PARAMETER  = ''
    CALL OPF(FN.ACCOUNT.PARAMETER,F.ACCOUNT.PARAMETER)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*~~~~~~~
**PACS000112741 -S
    Y.COMI = COMI
    IF Y.COMI[1,2] EQ 'AA' THEN
        CALL F.READ(FN.AA.ARRANGEMENT,Y.COMI,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)
        COMI = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    END
**PACS000112741 -E

    CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ERR)
    CATEG.AC = R.ACCOUNT<AC.CATEGORY>

    CALL CACHE.READ(FN.ACCOUNT.PARAMETER,'SYSTEM',R.ACCOUNT.PARAMETER,ERR.AP)
    ALL.CAT.DESC = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.DESC>
    LOCATE 'Current Account Range' IN ALL.CAT.DESC<1,1> SETTING POS.AP THEN
        ST.CAT = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.STR,POS.AP>
        EN.CAT = R.ACCOUNT.PARAMETER<AC.PAR.ACCT.CATEG.END,POS.AP>
        IF CATEG.AC GE ST.CAT AND CATEG.AC LE EN.CAT THEN
            IF R.NEW(FT.CHEQUE.NUMBER) EQ '' THEN
                ETEXT="EB-CHEQUE.NO.MAND"
                CALL STORE.END.ERROR
            END
        END
    END

RETURN
END
