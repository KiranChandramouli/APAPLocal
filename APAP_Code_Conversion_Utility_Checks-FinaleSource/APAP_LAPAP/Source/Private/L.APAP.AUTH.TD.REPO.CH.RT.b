* @ValidationCode : MjotMTYzNjM0NjY5MDpDcDEyNTI6MTcwMjk4ODM0NTI3NDpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>40</Rating>
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed
*18-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.AUTH.TD.REPO.CH.RT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE ;*R22 MANUAL CONVERSION
    $INSERT  I_F.LATAM.CARD.ORDER
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INSERT  I_F.ST.L.APAP.TD.REPO.CHG.PARAMS ;*R22 MANUAL CONVERSION
    $INSERT  I_F.ST.L.APAP.TD.REPO.CHG.PARA.AD
    $USING EB.LocalReferences ;*R22 Manual Code Conversion_Utility Check


    FN.CT = "F.CARD.TYPE"
    F.CT = ""
    R.CT = ""
    CT.ERR = ""
    CALL OPF(FN.CT,F.CT)

    FN.LCO = "F.LATAM.CARD.ORDER$NAU"
    F.LCO = ""
    R.LCO = ""
    TD.LCO = ""
    CALL OPF(FN.LCO,F.LCO)

    FN.TD.REPO = "F.ST.L.APAP.TD.REPO.CHG.PARAMS"
    F.TD.REPO = ""
    R.TD.REPO = ""
    TD.REPO.ERR = ""
    CALL OPF(FN.TD.REPO,F.TD.REPO)
    FN.TD.REPO.ADI = "F.ST.L.APAP.TD.REPO.CHG.PARA.AD"
    F.TD.REPO.ADI = ""
    R.TD.REPO.ADI = ""
    TD.REPO.ADI.ERR = ""
    CALL OPF(FN.TD.REPO.ADI,F.TD.REPO.ADI)

    Y.VERSION.NAME = PGM.VERSION

*   CALL GET.LOC.REF("LATAM.CARD.ORDER","RELATION.REASON",LCO.POS.1)
    EB.LocalReferences.GetLocRef("LATAM.CARD.ORDER","RELATION.REASON",LCO.POS.1) ;*R22 Manual Code Conversion_Utility Check

    Y.RELATION.REASON = R.NEW(CARD.IS.LOCAL.REF)<1,LCO.POS.1>

    IF Y.VERSION.NAME EQ ",REDO.PRINCIPAL" THEN
*       CALL F.READ(FN.TD.REPO,Y.RELATION.REASON,R.TD.REPO, F.TD.REPO, TD.REPO.ERR)
        CALL CACHE.READ(FN.TD.REPO,Y.RELATION.REASON,R.TD.REPO, TD.REPO.ERR) ;*R22 Manual Code Conversion_Utility Check
    END
    IF Y.VERSION.NAME EQ ",REDO.ADDITIONAL" THEN
        CALL F.READ(FN.TD.REPO.ADI,Y.RELATION.REASON,R.TD.REPO, F.TD.REPO.ADI, TD.REPO.ADI.ERR)
    END

    Y.CARD.TYPE =  R.NEW(CARD.IS.CARD.TYPE)

    IF R.TD.REPO NE '' THEN

*       FINDSTR Y.CARD.TYPE IN R.TD.REPO<2> SETTING Ap, Vp THEN
        FINDSTR Y.CARD.TYPE IN R.TD.REPO<ST.L.A22.CARD.TYPE> SETTING Ap, Vp THEN ;*R22 Manual Code Conversion_Utility Check


*           Y.CHARGE.CODE = R.TD.REPO<1,Vp>
            Y.CHARGE.CODE = R.TD.REPO<ST.L.A22.COMMISSION.TYPE,Vp>  ;*R22 Manual Code Conversion_Utility Check
            IF Y.CHARGE.CODE NE '' THEN



                Y.CANT.CUS = DCOUNT(R.NEW(CARD.IS.CUSTOMER.NO),@VM)

                Y.CUSTOMER = R.NEW(CARD.IS.CUSTOMER.NO)<1,Y.CANT.CUS>

                Y.CANT.ACC = DCOUNT(R.NEW(CARD.IS.ACCOUNT),@VM)

                Y.ACCOUNT = R.NEW(CARD.IS.ACCOUNT)<1,Y.CANT.ACC>
                Y.ST = R.NEW(CARD.IS.CARD.STATUS)

                IF V$FUNCTION EQ 'A' THEN

                    GOSUB OFS.PROC
                END
            END


        END

    END




OFS.PROC:
    Y.TRANS.ID = ""
    Y.APP.NAME = "AC.CHARGE.REQUEST"
    Y.VER.NAME = Y.APP.NAME :",L.APAP.ADI"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.ACR = ""

    R.ACR<CHG.CHARGE.CODE> = Y.CHARGE.CODE
    R.ACR<CHG.CUSTOMER.NO> = Y.CUSTOMER
    R.ACR<CHG.DEBIT.ACCOUNT> = Y.ACCOUNT


    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"TD.ADI.CH",'')

RETURN


END
