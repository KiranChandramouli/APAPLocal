$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.INT.RATE.ACC(Y.ACC.ID, R.ACCOUNT, Y.CR.INT.RATE)
*--------------------------------------------------------------------------------------------------
* Description           : RUTINA QUE RECIBE RESULT SET DE ACCOUNT Y RETORNA EL INTERES DE LA CUENTA
* Developed On          : 03/08/2018
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference     Modified By            Date of Change   Change Details
* CN008141             Anthony Martinez       03/08/2018       Creacion
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion  - F.READ to CACHE.READ and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes   
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_F.BASIC.INTEREST

    GOSUB INIT
    GOSUB GET.ACCOUNT.INT.RATE

INIT:
    FN.GCI = "FBNK.GROUP.CREDIT.INT"
    F.GCI = ''
    CALL OPF(FN.GCI, F.GCI)

    FN.BINT = "FBNK.BASIC.INTEREST"
    F.BINT = ''
    CALL OPF(FN.BINT, F.BINT)

    FN.ACI = "FBNK.ACCOUNT.CREDIT.INT"
    F.ACI = ''
    CALL OPF(FN.ACI, F.ACI)

RETURN

*--------------------
GET.ACCOUNT.INT.RATE:
    Y.ACCT.CREDIT.INT = ''; Y.ACCT.CREDIT.INT.LAST = ''; Y.ACCT.CRD.INT.ID = ''
    Y.ACCT.CREDIT.INT = R.ACCOUNT<AC.ACCT.CREDIT.INT>
    Y.CCY = R.ACCOUNT<AC.CURRENCY>

    IF Y.ACCT.CREDIT.INT NE '' THEN
        Y.ACI.CNT = DCOUNT(Y.ACCT.CREDIT.INT, @VM)
        Y.ACCT.CREDIT.INT.LAST = Y.ACCT.CREDIT.INT<1, Y.ACI.CNT>

        GOSUB READ.ACCOUNT.CREDIT.INT

        IF Y.CR.INT.RATE EQ '' THEN
            Y.CONDITION.GROUP = R.ACCOUNT<AC.CONDITION.GROUP>

            Y.CONDITION.GROUP.ID = Y.CONDITION.GROUP:Y.CCY

            GOSUB READ.GROUP.CREDIT.INT
        END

    END ELSE

        Y.CONDITION.GROUP = R.ACCOUNT<AC.CONDITION.GROUP>
        Y.CONDITION.GROUP.ID = Y.CONDITION.GROUP:Y.CCY

        GOSUB READ.GROUP.CREDIT.INT
    END

RETURN
*--------------------

*------------------------
READ.ACCOUNT.CREDIT.INT:

    CALL F.READ(FN.ACI, Y.ACC.ID, R.ACI, F.ACI, ACI.ERR)

    IF (R.ACI) THEN
        Y.CR.INT.RATE = R.ACI<IC.ACI.CR.INT.RATE>
        Y.CR.BASIC.RATE = R.ACI<IC.ACI.CR.BASIC.RATE>

        IF NOT(Y.CR.INT.RATE) THEN
            Y.BASIC.INTEREST.ID = Y.CR.BASIC.RATE:Y.CCY
            GOSUB READ.BASIC.INTEREST
        END
    END
RETURN
*------------------------

*------------------------
READ.GROUP.CREDIT.INT:
    SEL.CMD.GCI = "SELECT " : FN.GCI : " WITH @ID LIKE " : Y.CONDITION.GROUP.ID : "..."
    CALL EB.READLIST(SEL.CMD.GCI, SEL.LIST.GCI, "", NO.OF.RECS.GCI, SEL.GCI.ERR)

    LOOP REMOVE GCI.ID FROM SEL.LIST.GCI SETTING POS.GCI
    WHILE GCI.ID  DO
        CALL CACHE.READ(FN.GCI, GCI.ID, R.GCI, GCI.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.CANT.I.RATE = DCOUNT(R.GCI<IC.GCI.CR.INT.RATE>, @VM)
        Y.CR.INT.RATE = R.GCI<IC.GCI.CR.INT.RATE,Y.CANT.I.RATE>
        Y.CR.BASIC.RATE = R.GCI<IC.GCI.CR.BASIC.RATE>
    REPEAT

    IF NOT(Y.CR.INT.RATE) THEN
        Y.BASIC.INTEREST.ID = Y.CR.BASIC.RATE:Y.CCY
        GOSUB READ.BASIC.INTEREST
    END

RETURN
*------------------------

*------------------------
READ.BASIC.INTEREST:
    SEL.CMD.BINT = "SELECT " : FN.BINT : " WITH @ID LIKE " : Y.BASIC.INTEREST.ID : "..."
    CALL EB.READLIST(SEL.CMD.BINT, SEL.LIST.BINT, "", NO.OF.RECS.BINT, SEL.BINT.ERR)

    LOOP REMOVE BINT.ID FROM SEL.LIST.BINT SETTING POS.BINT
    WHILE BINT.ID  DO
        CALL CACHE.READ(FN.BINT, BINT.ID, R.BINT, BINT.ERR)	;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.CR.INT.RATE = R.BINT<EB.BIN.INTEREST.RATE>
    REPEAT

RETURN
*------------------------

RETURN
