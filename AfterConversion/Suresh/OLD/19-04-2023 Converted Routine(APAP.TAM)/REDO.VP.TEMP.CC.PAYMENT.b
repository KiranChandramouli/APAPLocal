* @ValidationCode : MjotMTQyMDEzNDY5MDpDcDEyNTI6MTY4MTg5MTM0MzIwODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 13:32:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.TEMP.CC.PAYMENT(ALLOW.OFFLINE, TXN.RESULT)
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.17.2013
* Description  : Vision Plus Payments Registry
* Type         : Interface Routine
* Attached to  : -
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       05.17.2013     lpazmino       -                 Initial Version
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION         CALL routine format modified
*-----------------------------------------------------------------------------
* Input:
*        TXN.CHANNEL   > Transaction Channel
*        ALLOW.OFFLINE > Allow Offline (Process despite of not registering online payment)
* Output:
*        TXN.RESULT<1> > OK/ERROR/OFFLINE  para ONLINE_PAYMENT
*        TXN.RESULT<2> = EB.ERROR @ID
*        TXN.RESULT<3> = Message Detail
*        TXN.RESULT<4> = Override Pos
*-----------------------------------------------------------------------------

* <region name="INSERTS">
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System

    $INSERT I_F.REDO.FT.TT.TRANSACTION

    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.VISION.PLUS.PARAM

* </region>
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM = ''
    R.REDO.VISION.PLUS.TXN = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    R.REDO.CARD.BIN = ''

    Y.ERR = ''

    CREDIT.CARD = ''
    TXN.PAYMENT.AMT = ''
    TXN.CURRENCY = ''

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.VISION.PLUS.PARAM, F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.REDO.CARD.BIN, F.REDO.CARD.BIN)

RETURN

***********************
* Main Process
PROCESS:
***********************
    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)

    BEGIN CASE
        CASE APPLICATION EQ 'REDO.FT.TT.TRANSACTION'
            GOSUB GET.REDO.FT.FIELDS
        CASE 1
    END CASE

    IF NOT(R.NEW(FT.TN.L.FT.MSG.CODE)) THEN
        GOSUB INVOKE.VP.WS.OP
    END

RETURN

GET.REDO.FT.FIELDS:
*********************************
    CREDIT.CARD = R.NEW(FT.TN.L.FT.CR.CARD.NO)
    TXN.CURRENCY = R.NEW(FT.TN.CREDIT.CURRENCY)
    IF R.NEW(FT.TN.CREDIT.AMOUNT) LE 0 THEN
        TXN.PAYMENT.AMT = R.NEW(FT.TN.DEBIT.AMOUNT)
    END ELSE
        TXN.PAYMENT.AMT = R.NEW(FT.TN.CREDIT.AMOUNT)
    END

    TXN.OVERRIDE = R.NEW(FT.TN.OVERRIDE)

RETURN

****************************************
* Invoke VP Web Service 'OnlinePayment'
INVOKE.VP.WS.OP:
****************************************
    ACTIVATION = 'VP_ONLINE_TXN_SERVICE'
*Tus Start
    EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
    IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
        EXT.USER.ID = ""
    END

    IF EXT.USER.ID NE 'EXT.EXTERNAL.USER' THEN
        CREDIT.CARD = System.getVariable("CURRENT.CARD.ORG.NO")
        IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN
            CREDIT.CARD = ""
        END
    END
*Tus End
    FINDSTR 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS.FM.OVER THEN
        DEL E<POS.FM.OVER>
    END

    WS.DATA = ''
    WS.DATA<1>  = 'ONLINE_PAYMENT'
    WS.DATA<2>  = R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.USER>
    WS.DATA<3>  = 'C'
    WS.DATA<4>  = FMT(CREDIT.CARD, 'R%19')
    WS.DATA<7>  = '0000'
    WS.DATA<8>  = TXN.PAYMENT.AMT
    WS.DATA<9>  = '0000'
    WS.DATA<10> = '                             '
    WS.DATA<11> = '000'

    CREDIT.CARD.BIN = CREDIT.CARD[1,6]
    CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

    LOCATE TXN.CURRENCY IN R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY,1> SETTING TXN.CURRENCY.POS THEN
* OrgId
        ORG.ID = FIELD(R.REDO.CARD.BIN<REDO.CARD.BIN.ORG.ID>,@VM,TXN.CURRENCY.POS)
        WS.DATA<5> = ORG.ID
* Mercant Number
        MERCHANT.NUMBER = R.REDO.CARD.BIN<REDO.CARD.BIN.MERCHANT.NUMBER>
        WS.DATA<6> = MERCHANT.NUMBER
        CALL APAP.TAM.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA) ;*MANUAL R22 CODE CONVERSION
        CRT "WS.DATA: " WS.DATA
    END ELSE
        WS.DATA = ''
        WS.DATA<1> = 'ERROR'
    END

    IF NOT(WS.DATA<5>) THEN
        WS.DATA<5> = '000000'
    END
* Obtiene la autorizacion de pago sin problemas OK^26125.29^0.00^-411.
    IF WS.DATA<1> EQ 'OK' THEN

        R.NEW(FT.TN.L.FT.MSG.CODE) = WS.DATA<5>
        TXN.RESULT<1> = 'OK'
        TXN.RESULT<2> = ''
        TXN.RESULT<3> = ''
        TXN.RESULT<4> = ''
    END ELSE
        GOSUB CHECK.OFFLINE
    END

RETURN

*****************************************************************************
* Check if the transaction is allowed for offline mode (monetary file record)
CHECK.OFFLINE:
*****************************************************************************
    TXN.RESULT<1> = WS.DATA<1>
    IF WS.DATA<1> EQ 'ERROR' OR NOT(ALLOW.OFFLINE) THEN
        R.NEW(FT.TN.L.FT.MSG.CODE) = 'ERROR'
        TXN.RESULT<2> = 'ST-VP-ERR.VP.PYMNT'
    END
    IF WS.DATA<1> EQ 'OFFLINE' AND ALLOW.OFFLINE THEN
        R.NEW(FT.TN.L.FT.MSG.CODE) = '000000'
        TXN.RESULT<2> = 'ST-VP-NO.ONLINE.PYMNT'
    END
    IF WS.DATA<1> EQ 'OFFLINE' AND ALLOW.OFFLINE THEN
        R.NEW(FT.TN.L.FT.MSG.CODE) = '000000'
        TXN.RESULT<2> = 'ST-VP-NO.ONLINE.PYMNT'
    END
    TXN.RESULT<3> = WS.DATA<2>
    IF TXN.OVERRIDE THEN
        TXN.RESULT<4> = DCOUNT(TXN.OVERRIDE, @VM) + 1
    END ELSE
        TXN.RESULT<4> = 1
    END

RETURN

END
