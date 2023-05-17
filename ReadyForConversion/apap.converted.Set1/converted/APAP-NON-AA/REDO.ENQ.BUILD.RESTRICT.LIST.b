SUBROUTINE REDO.ENQ.BUILD.RESTRICT.LIST(ENQ.DATA)
***********************************************************************

* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRADEEP P
* PROGRAM NAME: REDO.ENQ.BUILD.RESTRICT.LIST
* ODR NO      : ODR-2010-08-0470
*----------------------------------------------------------------------
* DESCRIPTION:   This is a Build routine attached to the Enquiry
*                REDO.ENQ.CUS.BAD.REFERENCE
* IN PARAMETER : ENQ.DATA
* OUT PARAMETER: ENQ.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO           REFERENCE         DESCRIPTION
* 18.08.2010  PRADEEP P     ODR-2010-08-0470  INITIAL CREATION
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.RESTRICTIVE.LIST
*
    GOSUB PROCESS
RETURN
*
*********
PROCESS:
*********
    Y.SEL.FIELD = ENQ.DATA<2>
    LOCATE "DATE.TIME" IN Y.SEL.FIELD<1,1> SETTING Y.DT.POS THEN
        Y.FR.TO.DATE = ENQ.DATA<4,Y.DT.POS>
        IF Y.FR.TO.DATE THEN

            Y.FROM.DATE = FIELD(Y.FR.TO.DATE," ",1)
            Y.TO.DATE = FIELD(Y.FR.TO.DATE," ",2)

            Y.FROM.DATE = Y.FROM.DATE[3,8]:"0000"
            Y.TO.DATE = Y.TO.DATE[3,8]:"2400"

            ENQ.DATA<4,Y.DT.POS> = Y.FROM.DATE:" ":Y.TO.DATE
        END
    END

    LOCATE "TIPO.DE.PERSONA" IN Y.SEL.FIELD<1,1> SETTING Y.TIP.POS THEN
        Y.TIP.VAL = ENQ.DATA<4,Y.TIP.POS>

        Y.SP.CNT = DCOUNT(Y.TIP.VAL,' ')

        IF Y.SP.CNT GT 2 THEN

            Y.FST.VALUE = FIELD(Y.TIP.VAL," ",1)
            Y.SEC.VALUE = FIELD(Y.TIP.VAL," ",3)

            Y.TIP.VAL = Y.FST.VALUE:' ':Y.SEC.VALUE
        END ELSE
            Y.TIP.VAL = FIELD(Y.TIP.VAL," ",1)
        END

        ENQ.DATA<4,Y.TIP.POS> = "'":Y.TIP.VAL:"'"
    END

    LOCATE "LISTA.RESTRICTIVA" IN Y.SEL.FIELD<1,1> SETTING Y.RES.LIST.POS THEN
        Y.RES.LIST = ENQ.DATA<4,Y.RES.LIST.POS>

        Y.RESP.CNT = DCOUNT(Y.RES.LIST,' ')

        IF Y.RESP.CNT EQ 9 THEN
            Y.VALUE1 = FIELD(Y.RES.LIST,' ',1)
            Y.VALUE2 = FIELD(Y.RES.LIST,' ',2)
            Y.VALUE3 = FIELD(Y.RES.LIST,' ',3)
            Y.VALUE4 = FIELD(Y.RES.LIST,' ',4)
            Y.VALUE5 = FIELD(Y.RES.LIST,' ',5)
            Y.RES.LIST = Y.VALUE1:' ':Y.VALUE2:' ':Y.VALUE3:' ':Y.VALUE4:' ':Y.VALUE5
        END

        IF Y.RESP.CNT EQ 3 THEN
            Y.F.LST.VALUE = FIELD(Y.RES.LIST," ",1)
            Y.S.LST.VALUE = FIELD(Y.RES.LIST," ",3)

            Y.RES.LIST = Y.F.LST.VALUE:' ':Y.S.LST.VALUE
        END

        ENQ.DATA<4,Y.RES.LIST.POS> = "'":Y.RES.LIST:"'"
    END
RETURN
END
