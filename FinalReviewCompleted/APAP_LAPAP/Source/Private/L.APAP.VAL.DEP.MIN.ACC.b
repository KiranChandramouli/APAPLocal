* @ValidationCode : MjoxMTg3Mjc0MDI4OkNwMTI1MjoxNjkwMTY3NTM3NjY2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Subrutina: L.APAP.VAL.DEP.MIN.ACC
*  Creación: 02/10/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.DEP.MIN.ACC
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.ST.CONTROL.CUENTA.AHORRO

    GOSUB INIT
    GOSUB PROCCESS

RETURN
INIT:
****

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CONTROL.CUENTA.AHORRO ='F.ST.CONTROL.CUENTA.AHORRO'
    F.CONTROL.CUENTA.AHORRO=''
    CALL OPF(FN.CONTROL.CUENTA.AHORRO,F.CONTROL.CUENTA.AHORRO)

RETURN

PROCCESS:
********
    Y.VAR.ACCOUNT =  R.NEW(TT.TE.ACCOUNT.2)
    Y.VAR.MONTO.DEP = R.NEW(TT.TE.AMOUNT.LOCAL.1)

    IF Y.VAR.ACCOUNT NE "" THEN

        R.ACCOUNT=""; ERR = ""
        CALL F.READ(FN.ACCOUNT, Y.VAR.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ERR)

        IF R.ACCOUNT THEN

            Y.VAR.CATEGORIA     = R.ACCOUNT<AC.CATEGORY>
            Y.VAR.LAST.DEP      = R.ACCOUNT<AC.AMNT.LAST.CR.CUST>
            Y.VAR.LAST.DATE.DEP = R.ACCOUNT<AC.DATE.LAST.CR.CUST>
            Y.VAR.OPENING.DATE  = R.ACCOUNT<AC.OPENING.DATE>

            IF (Y.VAR.LAST.DEP EQ "" OR Y.VAR.LAST.DATE.DEP EQ "") AND Y.VAR.OPENING.DATE GT '20201231' THEN
                GOSUB VERIFY.CARTEG.PARAM
            END
        END
    END

RETURN

VERIFY.CARTEG.PARAM:
********************

    R.CONTROL.CUENTA.AHORRO = ""; ERR.2 = ""
    CALL F.READ(FN.CONTROL.CUENTA.AHORRO, Y.VAR.CATEGORIA, R.CONTROL.CUENTA.AHORRO, F.CONTROL.CUENTA.AHORRO, ERR.2)

    IF R.CONTROL.CUENTA.AHORRO THEN

        Y.VAR.MONTO.MIN = R.CONTROL.CUENTA.AHORRO<ST.L.APAP.MONTO.MIN>

        IF Y.VAR.MONTO.DEP LT Y.VAR.MONTO.MIN THEN
            AF =   TT.TE.AMOUNT.LOCAL.1
            ETEXT = "Monto mínimo apertura " : Y.VAR.MONTO.MIN
            CALL STORE.END.ERROR

            RETURN
        END
    END

RETURN
END
