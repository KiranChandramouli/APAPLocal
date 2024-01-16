* @ValidationCode : Mjo0NzYyODU0OTpDcDEyNTI6MTcwMjk4ODM3NTc5OTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:49:35
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
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.IC.MANCTA.RT(CUS.ID)
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE               DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     No changes
* 13-07-2023    Narmadha V             R22 Manual Conversion   BP is removed in insert file
* 19-12-2023    Santosh C           MANUAL R22 CODE CONVERSION   APAP Code Conversion Utility Check
*-----------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 Manual Conversion- START
*   $INSERT  I_EQUATE ;*R22 Manual Code Conversion_Utility Check
    $INSERT  I_F.ACCOUNT
    $INSERT  I_F.DATES
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.CUSTOMER.ACCOUNT
    $INSERT  I_F.AC.CHARGE.REQUEST
    $INSERT  I_F.ST.LAPAP.EMP.COM.PAR
    $INSERT  I_LAPAP.IC.MANCTA.RT.COMMON ;*R22 Manual Conversion -END
    $USING EB.API ;*R22 Manual Code Conversion_Utility Check

    GOSUB READ.CUSTOMER
RETURN

READ.CUSTOMER:
    CALL F.READ(FN.CUS,CUS.ID,R.CUS, FV.CUS, CUS.ERR)
    IF R.CUS THEN
        GOSUB DO.EVALUTE.SEGMENT
    END
RETURN

DO.EVALUTE.SEGMENT:
    Y.CUS.SEGMENT = R.CUS<EB.CUS.LOCAL.REF,Y.L.CU.SEGMENTO.POS>
    Y.CUS.TIPO.CL = R.CUS<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>

    FIND Y.CUS.SEGMENT IN Y.PA.SEGMENT SETTING SEGMENT.POS,SEG.VAL THEN
        Y.SEGMENT.PAR = Y.PA.SEGMENT<1,SEG.VAL>
        Y.CHG.CODE = Y.PA.CHG.CODE<1,SEG.VAL>
*Y.CHG.AMT = Y.PA.CHG.AMT<1,SEG.VAL>
        Y.WAIV.CAT = Y.PA.WAIV.CAT<1,SEG.VAL>

        GOSUB DO.READ.CUSAC

    END
RETURN

DO.READ.CUSAC:
    CALL F.READ(FN.CUSAC, CUS.ID, R.CUSAC, FV.CUSAC, CUSAC.ERR)
*Here we don't have field number actually, the whole array is a single field separated by FM'
    Y.ACC.LIST = R.CUSAC
    Y.CNT.ACC = DCOUNT(Y.ACC.LIST,@FM)

    FOR A = 1 TO Y.CNT.ACC STEP 1
        Y.CURR.ACC = Y.ACC.LIST<A>
        GOSUB DO.READ.ACC
    NEXT A
RETURN

DO.READ.ACC:
    CALL F.READ(FN.AC, Y.CURR.ACC, R.AC, FV.AC, AC.ERR)
    IF(R.AC) THEN
        Y.CURR.CAT = R.AC<AC.CATEGORY>

        FIND Y.CURR.CAT IN Y.WAIV.CAT SETTING POS1, POS2 THEN
*           CALL OCOMO('WAIVED CATEGORY FOR ACCOUNT: ' : Y.CURR.ACC)
            EB.API.Ocomo('WAIVED CATEGORY FOR ACCOUNT: ' : Y.CURR.ACC) ;*R22 Manual Code Conversion_Utility Check
            RETURN
        END
        IF (Y.CURR.CAT GE 6000 AND Y.CURR.CAT LE 6012) OR (Y.CURR.CAT GE 6020 AND Y.CURR.CAT LE 6599) THEN
            GOSUB DO.POST.CHARGE
        END ELSE
*           CALL OCOMO('SKIPPED, NOT A SAVING ACCOUNT, ACC: ':Y.CURR.ACC)
            EB.API.Ocomo('SKIPPED, NOT A SAVING ACCOUNT, ACC: ':Y.CURR.ACC) ;*R22 Manual Code Conversion_Utility Check
            RETURN
        END
    END
RETURN

DO.POST.CHARGE:
    Y.TRANS.ID = ""
    Y.APP.NAME = "AC.CHARGE.REQUEST"
    Y.VER.NAME = Y.APP.NAME :",MANEMPRE.CHG"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.ACR = ""

    R.ACR<CHG.CHARGE.CODE> = Y.CHG.CODE
    R.ACR<CHG.CUSTOMER.NO> = CUS.ID
    R.ACR<CHG.DEBIT.ACCOUNT> = Y.CURR.ACC
*R.ACR<CHG.CHARGE.AMOUNT> = Y.CHG.AMT


    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"GENCHG",'')

*   CALL OCOMO("CHARGE POSTED FOR ACCOUNT: ":Y.CURR.ACC)
    EB.API.Ocomo("CHARGE POSTED FOR ACCOUNT: ":Y.CURR.ACC) ;*R22 Manual Code Conversion_Utility Check
RETURN


END
