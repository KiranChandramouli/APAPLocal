* @ValidationCode : MjotMjQ2MTUwOTQzOkNwMTI1MjoxNjg0ODQyMTUyODQ5OklUU1M6LTE6LTE6MjIyOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 222
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.CC.PAYMENT(ALLOW.OFFLINE, TXN.RESULT)
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
*           11.04.2023   Conversion Tool       R22          Auto Conversion     - VM TO @VM, New condition added
*           11.04.2023   Shanmugapriya M       R22          Manual Conversion   - Add call routine prefix
*
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

    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER

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

    Y.LOCAL.REF = 'LOCAL.REF'
    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

* Using internal VPlus Credit Card Number
* 'L.SUN.SEQ.NO' instead of 'L.TT.CR.CARD.NO'
    Y.LOCAL.FIELDS<1,1> = 'L.SUN.SEQ.NO'


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
        CASE APPLICATION EQ 'TELLER'
            Y.LOCAL.FIELDS<1,2> = 'L.TT.MSG.CODE'
            Y.LOCAL.FIELDS<1,3> = 'L.TT.BASE.AMT'
            GOSUB GET.TT.FIELDS
        CASE APPLICATION EQ 'FUNDS.TRANSFER'
            Y.LOCAL.FIELDS<1,2> = 'L.FT.MSG.CODE'
            GOSUB GET.FT.FIELDS
    END CASE

    VMSG.CODE = R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>
*DEBUG
    IF NOT(R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS>) THEN
        GOSUB INVOKE.VP.WS.OP
    END

RETURN

*************************
* Get Teller information
GET.TT.FIELDS:
*************************
*DEBUG
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.CARD.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    MSG.CODE.POS = Y.LOCAL.FIELDS.POS<1,2>
    BASE.AMT    = Y.LOCAL.FIELDS.POS<1,3>

* Set Global vars
    CREDIT.CARD = R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS>
    TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.1)

* Case for the TFS TELLER versions
    IF NOT(TXN.CURRENCY) THEN
        TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
        TXN.PAYMENT.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)
    END ELSE
        IF TXN.CURRENCY EQ LCCY THEN
            TXN.PAYMENT.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        END ELSE
            TXN.PAYMENT.AMT = R.NEW(TT.TE.AMOUNT.FCY.1)
        END
    END
    IF PGM.VERSION EQ ',REDO.CR.CARD.LCY.CASHIN.FCY.ACCT' THEN
        TXN.CURRENCY = R.NEW(TT.TE.CURRENCY.2)
        TXN.PAYMENT.AMT = R.NEW(Y.LOCAL.REF)<1,BASE.AMT>
    END


    TXN.OVERRIDE = R.NEW(TT.TE.OVERRIDE)

RETURN

*********************************
* Get Funds Transfer information
GET.FT.FIELDS:
*********************************
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    CR.CARD.NO.POS = Y.LOCAL.FIELDS.POS<1,1>
    MSG.CODE.POS = Y.LOCAL.FIELDS.POS<1,2>

* Set Global vars
    CREDIT.CARD = R.NEW(Y.LOCAL.REF)<1,CR.CARD.NO.POS>
    TXN.CURRENCY = R.NEW(FT.CREDIT.CURRENCY)
    IF R.NEW(FT.CREDIT.AMOUNT) LE 0 THEN
        TXN.PAYMENT.AMT = R.NEW(FT.DEBIT.AMOUNT)
    END ELSE
        TXN.PAYMENT.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END

    TXN.OVERRIDE = R.NEW(FT.OVERRIDE)

RETURN

****************************************
* Invoke VP Web Service 'OnlinePayment'
INVOKE.VP.WS.OP:
****************************************
    ACTIVATION = 'VP_ONLINE_TXN_SERVICE'

    EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                    ;** R22 Auto Conversion - Start
        EXT.USER.ID = ""
    END                                                   ;** R22 Auto Conversion - End
    IF EXT.USER.ID NE 'EXT.EXTERNAL.USER' THEN
        CREDIT.CARD = System.getVariable("CURRENT.CARD.ORG.NO")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN                 ;** R22 Auto Conversion - Start
            CREDIT.CARD = ""
        END                                                ;** R22 Auto Conversion - End
    END

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
*CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
** R22 Manual conversion
        APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA)
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

        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = WS.DATA<5>
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
* Para transacciones en las que cuando falla el WS se pueden aplicar en modo offline (archivo monetario)
* Indica el error al no poder obtener la autorizacion
* de pago y no proceder por necesitar el pago en linea (IVR,ARCIB)
    TXN.RESULT<1> = WS.DATA<1>
    IF WS.DATA<1> EQ 'ERROR' OR NOT(ALLOW.OFFLINE) THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = 'ERROR'
        TXN.RESULT<2> = 'ST-VP-ERR.VP.PYMNT'
    END
    IF WS.DATA<1> EQ 'OFFLINE' AND ALLOW.OFFLINE THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = '000000'
* RECHAZO - 000000
        TXN.RESULT<2> = 'ST-VP-NO.ONLINE.PYMNT'
    END
    IF WS.DATA<1> EQ 'OFFLINE' AND ALLOW.OFFLINE THEN
        R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = '000000'
* RECHAZO - 000000
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
