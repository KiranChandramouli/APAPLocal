SUBROUTINE S.REDO.CCRG.VP.GET.BAL(P.CUSTOMER.ID,P.RETURN)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP - Asociacion Popular de Ahorros y Prestamos.
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description: Subrutine to get the direct and income balances from credit cards. This subroutine
*      interacts with the VP interface to get this information.
*
* Linked With:
*               SERVICE      REDO.CCRG.B.EXT
*
* In Parameter:
*               P.CUSTOMER.ID    (in)  Contranct Id.
*
* Out Parameter:
*               P.RETURN     (out)  Returns balances related: 1 Direct Balance, 2 Income Receivable, 3 Balance Contingent
*               E            (out)  Message in case Error
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 17/08/2014 - msthandier Sunnel replacement with Vision+ ODR-2011-03-0154

*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.CCRG.B.EXT.COMMON
    $INSERT I_REDO.CCRG.CONSTANT.COMMON

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
    Y.DB = 0
    Y.RB = 0
    Y.CB = 0

* Get the direct balance.
    WS.DATA = ''
    WS.DATA<1> = 'LIMITE_CREDITO'
    WS.DATA<2> = P.CUSTOMER.ID
    CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
    IF WS.DATA<1> EQ 'OK' THEN
        Y.DB = WS.DATA<2>
    END ELSE
        Y.ERROR = WS.DATA<2>
    END

* Get the income receivable.
    WS.DATA = ''
    WS.DATA<1> = 'RIESGO_INTERESES'
    WS.DATA<2> = P.CUSTOMER.ID
    CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
    IF WS.DATA<1> EQ 'OK' THEN
        Y.RB = WS.DATA<2>
    END ELSE
        Y.ERROR = WS.DATA<2>
    END

    IF Y.ERROR THEN
        P.RETURN<1> = 'ERROR'
        P.RETURN<2> = Y.ERROR
    END ELSE
        P.RETURN<1> = Y.DB
        P.RETURN<2> = Y.RB
        P.RETURN<3> = Y.CB
    END

RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------
    LOOP.CNT         = 1
    MAX.LOOPS        = 2
    PROCESS.GOAHEAD  = @TRUE
    P.RETURN         = ''

    ACTIVATION       = 'WS_T24_VPLUS'

RETURN

*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF NOT(P.CUSTOMER.ID) THEN
                    E = K.PARAMETER.IS.EMPTY : @FM : "P.CUSTOMER.ID" : @VM : "S.REDO.CCRG.VP.GET.BAL"
                    PROCESS.GOAHEAD = @FALSE
                END
        END CASE
        LOOP.CNT +=1
    REPEAT

RETURN

END
