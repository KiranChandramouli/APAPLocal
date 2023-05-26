* @ValidationCode : MjozNjM5MzY3MjU6Q3AxMjUyOjE2ODQ4NDIxNTQ5MjY6SVRTUzotMTotMTo4MzY6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 836
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.SC.GET.BAL(P.CONTRACT.ID, R.SM, P.RETURN)

*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: This program get the balances for the contract in ARRANGEMENT application
*
*
* Linked With:
*               SERVICE      REDO.CCRG.B.EXT
*               PARAMETER in REDO.CCRG.PARAMETERS field P.EVALUATOR.RTN
*
* In Parameter:
*               P.CONTRACT.ID    (in)  Contranct Id.
*               R.SM             (in)  Record of the contract in process
*
* Out Parameter:
*               P.RETURN     (out)  Returns balances related: 1 Direct Balance, 2 Income Receivable, 3 Balance Contingent
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 18/04/2011 - ODR-2011-03-0154
*              Description of the development associated
*              anoriega@temenos.com
* 26/09/2011 - Fix Code Reviews issues
*              hpasquel@temenos.com
*REM Just for compile
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, <> TO NE
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DAS.COMMON
*
    $INSERT I_F.SECURITY.POSITION
    $INSERT I_F.SECURITY.MASTER
*
    $INSERT I_F.SC.PARAMETER
    $INSERT I_F.ENTITLEMENT
    $INSERT I_F.DIARY
*
    $INSERT I_DAS.SECURITY.POSITION
    $INSERT I_DAS.ENTITLEMENT
*
    $INSERT I_REDO.CCRG.CONSTANT.COMMON
*
*--------------------------------------------------------------------------------------------
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
*Direct Balance
*
*De la aplicacion SECURITY.POSITION obtener el campo GROSS.COST.SEC.CCY
*(valor en moneda del papel) cuando su ID contenga CUST.SEC.ACC y SECURITY.CODE
*

*   P.CONTRACT.ID = PORTAFOLIO.TITULOVALOR.TIPO
    Y.ID1 = FIELD(P.CONTRACT.ID,".",1)    ;* Security.Acc.Master
    Y.ID2 = FIELD(P.CONTRACT.ID,".",2)    ;* Security.Number
    Y.ID3 = FIELD(P.CONTRACT.ID,".",3)    ;* "Security Type"
    Y.ID = Y.ID1:".":Y.ID2

*    Y.ID = P.CONTRACT.ID Partir en tres partes y tomas los dos primeras partes

    RETURNED.LIST    = dasSecurityPositionForAccountAndSecurity
    THE.ARGS    = Y.ID1
    THE.ARGS<2> = Y.ID2
    DAS.TABLE.SUFFIX = ''
    CALL DAS('SECURITY.POSITION', RETURNED.LIST, THE.ARGS, DAS.TABLE.SUFFIX)
    IF E THEN
        RETURNED.LIST = ""
        RETURN
    END

    CALL F.READ(FN.SECURITY.MASTER,Y.ID2,R.SECURITY.MASTER,F.SECURITY.MASTER,YERR)
    Y.SEC.CCY = R.SECURITY.MASTER<SC.SCM.SECURITY.CURRENCY>
*
    SECURITY.POSITION.ID = ''
    LOOP
        REMOVE SECURITY.POSITION.ID FROM RETURNED.LIST SETTING SECURITY.POSITION.MARK
    WHILE SECURITY.POSITION.ID : SECURITY.POSITION.MARK
        R.SECURITY.POSITION = ''
        YERR = ''
        CALL F.READ(FN.SECURITY.POSITION,SECURITY.POSITION.ID,R.SECURITY.POSITION,F.SECURITY.POSITION,YERR)
        Y.AMT.SC = R.SECURITY.POSITION<SC.SCP.GROSS.COST.SEC.CCY>
        IF LCCY NE Y.SEC.CCY THEN                                    ;** R22 Auto conversion - <> TO NE
*CALL S.REDO.CONV.LOCAL.CURR(Y.SEC.CCY,"1",Y.CCY.RATE)
** R22 Manual conversion
            CALL APAP.TAM.sRedoConvLocalCurr(Y.SEC.CCY,"1",Y.CCY.RATE)
            Y.AMT.SC = Y.AMT.SC * Y.CCY.RATE
            CALL EB.ROUND.AMOUNT(LCCY, Y.AMT.SC, "", "")
        END
        Y.DB += Y.AMT.SC
    REPEAT

*Interes

    IF Y.ID3 EQ 'B' THEN
*
        RETURNED.LIST    = dasAllIds
        THE.ARGS = ""
        DAS.TABLE.SUFFIX = '$NAU'
        CALL DAS('ENTITLEMENT', RETURNED.LIST, THE.ARGS, DAS.TABLE.SUFFIX)
        IF E THEN
            RETURNED.LIST = ""
            RETURN
        END
*
        LOOP
            REMOVE ENTITLEMENT$NAU.ID FROM RETURNED.LIST SETTING ENTITLEMENT$NAU.MARK
        WHILE ENTITLEMENT$NAU.ID : ENTITLEMENT$NAU.MARK
*
            R.ENTITLEMENT$NAU = ''
            YERR = ''
            CALL F.READ(FN.ENTITLEMENT$NAU,ENTITLEMENT$NAU.ID,R.ENTITLEMENT$NAU,F.ENTITLEMENT$NAU,YERR)
            Y.VALUE.DATE = R.ENTITLEMENT$NAU<SC.ENT.VALUE.DATE>
            Y.DIARY.ID = FIELD(ENTITLEMENT$NAU.ID,".",1)
*
            GOSUB CHECK.AND.ADD.RB
*
        REPEAT
    END

*Balances to send go out
    P.RETURN<1> = ABS(Y.DB)
    P.RETURN<2> = ABS(Y.RB)
*    P.RETURN<3> = ABS(Y.CB)

RETURN
*--------------------------------------------------------------------------------------------
CHECK.AND.ADD.RB:
*--------------------------------------------------------------------------------------------
    IF R.ENTITLEMENT$NAU<SC.ENT.SECURITY.NO> EQ Y.ID2 AND R.ENTITLEMENT$NAU<SC.ENT.PORTFOLIO.NO> EQ Y.ID1 THEN
        R.DIARY = ''
        YERR = ''
        CALL F.READ(FN.DIARY,Y.DIARY.ID,R.DIARY,F.DIARY,YERR)
        Y.EVENT.TYPE = R.DIARY<SC.DIA.EVENT.TYPE>

        NO.OF.DAYS = ''
        CALL CDD('',Y.VALUE.DATE,TODAY,NO.OF.DAYS)

        IF NO.OF.DAYS LE 90 AND Y.EVENT.TYPE MATCHES Y.COUPON.TYPE THEN
            Y.AMT.ENT = R.ENTITLEMENT$NAU<SC.ENT.NET.AMOUNT>
            IF LCCY NE R.ENTITLEMENT$NAU<SC.ENT.CURRENCY> THEN            ;** R22 Auto conversion - <> TO NE
                Y.CCY.RATE = 1
* CALL S.REDO.CONV.LOCAL.CURR(R.ENTITLEMENT$NAU<SC.ENT.CURRENCY>,"1",Y.CCY.RATE)
** R22 Manual conversion
                CALL APAP.TAM.sRedoConvLocalCurr(R.ENTITLEMENT$NAU<SC.ENT.CURRENCY>,"1",Y.CCY.RATE)
                Y.AMT.ENT = Y.AMT.ENT * Y.CCY.RATE
                CALL EB.ROUND.AMOUNT(LCCY, Y.AMT.ENT, "", "")
            END
            Y.RB += Y.AMT.ENT
        END

    END
RETURN
*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------

    FN.SECURITY.POSITION = 'F.SECURITY.POSITION'
    F.SECURITY.POSITION = ''
    CALL OPF(FN.SECURITY.POSITION,F.SECURITY.POSITION)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER  = ''
    CALL OPF(FN.SECURITY.MASTER, F.SECURITY.MASTER)

    FN.SECURITY.POSITION = 'F.SECURITY.POSITION'
    F.SECURITY.POSITION = ''
    CALL OPF(FN.SECURITY.POSITION,F.SECURITY.POSITION)

    FN.ENTITLEMENT$NAU = 'F.ENTITLEMENT$NAU'
    F.ENTITLEMENT$NAU = ''
    CALL OPF(FN.ENTITLEMENT$NAU,F.ENTITLEMENT$NAU)

    FN.DIARY = 'F.DIARY'
    F.DIARY = ''
    CALL OPF(FN.DIARY,F.DIARY)
*
    CALL CACHE.READ('F.SC.PARAMETER', ID.COMPANY, R.SC.PARAMETER,YERR)
    Y.COUPON.TYPE = R.SC.PARAMETER<SC.PARAM.COUPON.TYPE>

RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------

    LOOP.CNT         = 1
    MAX.LOOPS        = 2
    PROCESS.GOAHEAD  = @TRUE
    P.RETURN         = ''

    Y.ID1 = ''
    Y.ID2 = ''
    Y.ID3 = ''
    Y.DB = 0
    Y.RB = 0
    Y.CB = 0



RETURN

*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(P.CONTRACT.ID) THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "P.CONTRACT.ID" : @VM : "S.REDO.CCRG.SM.GET.BAL"
                    PROCESS.GOAHEAD = @FALSE
                END
            CASE LOOP.CNT EQ 2
                IF NOT(R.SM) THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "R.SM" : @VM : "S.REDO.CCRG.SM.GET.BAL"
                    PROCESS.GOAHEAD = @FALSE
                END
        END CASE

        LOOP.CNT +=1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------

END
