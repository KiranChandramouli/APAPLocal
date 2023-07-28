* @ValidationCode : Mjo3ODU5ODU3MzI6Q3AxMjUyOjE2ODI1MTg4ODA3NzA6SVRTUzotMTotMTo1Njk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 19:51:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 569
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.INP.GARNISHMENT.MAINT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Description:
*    This is an input routine for the version AC.LOCKED.EVENTS,INPUT
*---------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
* HD REFERENCE  : HD1016159
*Linked With    :AC.LOCKED.EVENTS,INPUT version as input routine
*---------------------------------------------------------------
* In parameter : NONE
*Out Parameter:none
*-----------------------------------------------------------------------
*MODIFICATION:
*   DATE           ODR
*18.1.2010     ODR-2009-10-0531
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,SM TO @SM, VAR.COUNT = VAR.COUNT - 1 TO VAR.COUNT -= 1
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*----------------------------
INIT:
    POS=''
    POS1=''
    ACCOUNT.LOCAL.NO=''
    STATUS1=''
    FLAG='0'
    D.COUNT='1'
    VAR.LOC.AMT = 0
RETURN
*------------------------------
OPENFILE:

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    R.ACCOUNT=''
    ACCOUNT.NUMBER=''
    ERR.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT=''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    LOCAL.FIELD='L.AC.GAR.AMT':@VM:'L.AC.AVAIL.BAL':@VM:'L.AC.CUSTOMER':@VM:'L.AC.ACCT.LOCK':@VM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.LOCKE.TYPE':@FM:'L.AC.STATUS1':'L.AC.STATUS2':'L.AC.AV.BAL' ;*R22 AUTO CONVERSION

    APPLICATION='AC.LOCKED.EVENTS':@FM:'ACCOUNT' ;*R22 AUTO CONVERSION

    CALL MULTI.GET.LOC.REF(APPLICATION,LOCAL.FIELD,AC.LOCK.POS)
RETURN
*----------------------------
PROCESS:
    AC.LOCKED.EVENTS.ID=ID.NEW
    POS=AC.LOCK.POS<1,1>
    GARNISHMENT.AMT=R.NEW(AC.LCK.LOCAL.REF)<1,POS>
    POS=AC.LOCK.POS<1,2>
    AVAILABLE.BAL=R.NEW(AC.LCK.LOCAL.REF)<1,POS>
    POS=AC.LOCK.POS<1,3>
    CUSTOMER=R.NEW(AC.LCK.LOCAL.REF)<1,POS>
    POS=AC.LOCK.POS<1,4>
    ACCTS.LOCKED=R.NEW(AC.LCK.LOCAL.REF)<1,POS>

    ACCOUNT.NUMBER=R.NEW(AC.LCK.ACCOUNT.NUMBER)
***********************************************************
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUST.ERR)

    LOOP
        REMOVE ACC.ID FROM R.CUSTOMER.ACCOUNT SETTING POS1
    WHILE ACC.ID:POS1
        CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        VAR.LOCKED.AMT=R.ACCOUNT<AC.LOCKED.AMOUNT>
        VAR.COUNT=DCOUNT(VAR.LOCKED.AMT,@VM) ;*R22 AUTO CONVERSION
        LOOP
        WHILE VAR.COUNT NE 0
            VAR.LOC.AMT = VAR.LOC.AMT + VAR.LOCKED.AMT<VAR.COUNT>
            VAR.COUNT -= 1 ;*R22 AUTO CONVERSION
        REPEAT
    REPEAT
    VAR.GARNISH.AMT = GARNISHMENT.AMT - VAR.LOC.AMT
**************************************************************
    VAR.ACK.NO=R.NEW(AC.LCK.ACCOUNT.NUMBER)
    CALL F.READ(FN.ACCOUNT,VAR.ACK.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.BAL.POS=AC.LOCK.POS<2,3>
    ACCT.AVAIL.BAL=R.ACCOUNT<AC.LOCAL.REF><1,Y.BAL.POS>

    LOCKED.AMOUNT=R.NEW(AC.LCK.LOCKED.AMOUNT)
    IF LOCKED.AMOUNT GT VAR.GARNISH.AMT THEN
        LOCKED.AMOUNT = VAR.GARNISH.AMT
    END
    IF LOCKED.AMOUNT GT ACCT.AVAIL.BAL THEN
        LOCKED.AMOUNT = ACCT.AVAIL.BAL
    END
    IF AVAILABLE.BAL GT '0' THEN
    END
    ELSE
    END

*HD1040884-Value removed from updating the lock type

RETURN
*----------------------------
*CHECK.FIRST.ACCOUT:
************************

ACCOUNT.LOCAL.NO=FIELD(ACCTS.LOCKED,@SM,1) ;*R22 AUTO CONVERSION
IF ACCOUNT.LOCAL.NO EQ ACCOUNT.NUMBER THEN

    CALL F.READ(FN.ACCOUNT,ACCOUNT.NUMBER,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)

    POS=AC.LOCK.POS<2,1>
    STATUS1=R.ACCOUNT<AC.LOCAL.REF,POS>

    POS=AC.LOCK.POS<1,5>
    R.NEW(AC.LCK.LOCAL.REF)<1,POS>=STATUS1
    POS.STATUS2=AC.LOCK.POS<2,2>
    Y.STATUS2=R.ACCOUNT<AC.LOCAL.REF,POS.STATUS2>
    POS=AC.LOCK.POS<1,6>
    R.NEW(AC.LCK.LOCAL.REF)<1,POS>=Y.STATUS2
END ELSE

END
IF LOCKED.AMOUNT NE VAR.GARNISH.AMT THEN
    AF=AC.LCK.LOCKED.AMOUNT
    TEXT='GARNISH.AMT.NOT.EQUAL'
    CURR.NO=DCOUNT(R.NEW(AC.LCK.OVERRIDE),@VM) + 1 ;*R22 AUTO CONVERSION
    CALL STORE.OVERRIDE(CURR.NO)
END
RETURN
*-----------------------------
END
