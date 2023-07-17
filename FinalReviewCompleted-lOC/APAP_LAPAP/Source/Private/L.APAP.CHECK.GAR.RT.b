* @ValidationCode : MjotNzQ4MjczMzczOkNwMTI1MjoxNjgyMzMxMzIwMTAyOklUU1M6LTE6LTE6MTg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CHECK.GAR.RT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion
    $INSERT I_EQUATE ;*R22 Auto conversion
    $INSERT I_F.APAP.H.GARNISH.DETAILS ;*R22 Auto conversion

    GOSUB INI
    GOSUB READ.GAR
INI:
    CALL GET.LOC.REF('APAP.H.GARNISH.DETAILS','L.GARNISH.STAT',L.G.S)

    Y.INDIVIDUAL.NAME = R.NEW(APAP.GAR.INDIVIDUAL.NAME)
    Y.IDENTITY.NUMBER = R.NEW(APAP.GAR.IDENTITY.NUMBER)
    Y.GARNISHMENT.AMT = R.NEW(APAP.GAR.GARNISHMENT.AMT)
    Y.NO.OF.LEGAL.ACT = R.NEW(APAP.GAR.NO.OF.LEGAL.ACT)
    Y.L.GARNISH.STATU = R.NEW(APAP.GAR.LOCAL.REF)<1,L.G.S>

    FN.GAR  = "F.APAP.H.GARNISH.DETAILS"
    F.GAR  = ""
    R.GAR  = ""
    GAR.ERR = ""
    CALL OPF(FN.GAR,F.GAR)
RETURN

READ.GAR:
    SEL.CMD = "SELECT " : FN.GAR : " WITH NO.OF.LEGAL.ACT EQ " : Y.NO.OF.LEGAL.ACT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECS,SEL.ERR)
    LOOP REMOVE GAR.ID FROM SEL.LIST SETTING POS
    WHILE GAR.ID DO
        GOSUB DO.VAL
    REPEAT

RETURN
DO.VAL:
    CALL F.READ(FN.GAR,GAR.ID,R.GAR, F.GAR, GAR.ERR)
    V.INDIVIDUAL.NAME = R.GAR<APAP.GAR.INDIVIDUAL.NAME>
    V.IDENTITY.NUMBER = R.GAR<APAP.GAR.IDENTITY.NUMBER>
    V.GARNISHMENT.AMT = R.GAR<APAP.GAR.GARNISHMENT.AMT>
    V.NO.OF.LEGAL.ACT = R.GAR<APAP.GAR.NO.OF.LEGAL.ACT>
    V.L.GARNISH.STATU = R.GAR<APAP.GAR.LOCAL.REF,L.G.S>

    IF Y.INDIVIDUAL.NAME EQ V.INDIVIDUAL.NAME THEN
        IF Y.IDENTITY.NUMBER EQ V.IDENTITY.NUMBER THEN
            IF Y.GARNISHMENT.AMT EQ V.GARNISHMENT.AMT THEN
                IF Y.NO.OF.LEGAL.ACT EQ V.NO.OF.LEGAL.ACT THEN
                    IF Y.L.GARNISH.STATU EQ V.L.GARNISH.STATU THEN
                        E = "TRANSACCION NO PERMITIDA"
                        CALL STORE.END.ERROR
                    END
                END
            END
        END
    END

RETURN

END
