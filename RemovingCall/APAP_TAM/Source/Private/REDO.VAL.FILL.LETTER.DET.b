* @ValidationCode : Mjo4OTE0OTIyMTU6Q3AxMjUyOjE2ODExMjUyNzUzMjM6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:44:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.FILL.LETTER.DET
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.ACH.POP.DETAILS
*-----------------------------------------------------------------------------
* Description :
* Linked with :
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*21/09/11      PACS00106561           PRABHU N                   MODIFICATION
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - F TO CACHE, New condition added
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER


    GOSUB OPEN.FILES
    GOSUB FILL.DETAILS.FT
RETURN
*-----------*
OPEN.FILES:
*-----------*

    GET.ARC.CHG.CODE = ''
    Y.CHARGE.KEY = ''
    FN.ARCIB.PARAM='F.AI.REDO.ARCIB.PARAMETER'
    F.ARCIB.PARAM=''
*CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM) ;*Tus S/E

    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    GET.ARC.CHG.CODE = System.getVariable("CURRENT.ARC.CHG.CODE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                  ;** R22 Auto Conversion - Start
        GET.ARC.CHG.CODE = ""
    END                                         ;** R22 Auto Conversion - End

RETURN

*------------*
FILL.DETAILS.FT:
*------------*
    CALL CACHE.READ(FN.ARCIB.PARAM,'SYSTEM',R.ARC.REC,ARC.ERR)
    IF NOT(ARC.ERR) THEN
        Y.CHARGE.KEY = GET.ARC.CHG.CODE
    END

    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE.KEY, R.FT.COMMISSION.TYPE, COMM.TYPE.ERR)                ;** R22 Auto conversion - F TO CACHE
    Y.DEFAULT.CCY=R.FT.COMMISSION.TYPE<FT4.DEFAULT.CCY>
    Y.CURRENCY=R.FT.COMMISSION.TYPE<FT4.CURRENCY>
    IF Y.DEFAULT.CCY NE '' THEN
        R.NEW(FT.DEBIT.CURRENCY)=Y.DEFAULT.CCY
        LOCATE Y.DEFAULT.CCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
            R.NEW(FT.DEBIT.AMOUNT)=R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
            R.NEW(FT.CREDIT.ACCT.NO)="PL":R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
        END
    END ELSE
        LOCATE LCCY IN Y.CURRENCY<1,1> SETTING POS1 THEN
            R.NEW(FT.DEBIT.AMOUNT)=R.FT.COMMISSION.TYPE<FT4.FLAT.AMT,POS1>
        END
        R.NEW(FT.CREDIT.ACCT.NO)="PL":R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
    END


RETURN

END
