* @ValidationCode : MjoyODUzOTE4OTY6Q3AxMjUyOjE2ODQyMjI4MDk0NDE6SVRTUzotMTotMToxOTI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 192
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*Modification history
*Date                Who               Reference                  Description
*24-04-2023      conversion tool     R22 Auto code conversion     = TO EQ
*24-04-2023      Mohanraj R          R22 Manual code conversion   No changes
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.GET.DEALTICKET.INFO.RT
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER

    GOSUB LOCREF
    GOSUB INI
    GOSUB DOCALL

LOCREF:
    APPL.NAME.ARR<1> = 'TELLER' ;
    FLD.NAME.ARR<1,1> = 'L.BOL.DIVISA' ;
    FLD.NAME.ARR<1,2> = 'L.NOM.DIVISA' ;
    FLD.NAME.ARR<1,3> = 'L.TT.BASE.AMT' ;

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.BOL.DIVISA.POS = FLD.POS.ARR<1,1>
    L.NOM.DIVISA.POS = FLD.POS.ARR<1,2>
    L.TT.BASE.AMT.POS = FLD.POS.ARR<1,3>
RETURN

INI:
    param = COMI    ;*R.NEW(TT.TE.LOCAL.REF)<1,L.BOL.DIVISA.POS>
    Y.EB.API.ID = 'LAPAP.FIM.DT.INFO.GET'
RETURN

DOCALL:
    CALL EB.CALL.JAVA.API(Y.EB.API.ID,param,Y.RESPONSE,Y.CALLJ.ERROR)
    GOSUB PROCESS
RETURN
PROCESS:
    IF Y.CALLJ.ERROR THEN
        BEGIN CASE
            CASE Y.CALLJ.ERROR EQ 1
                MESSAGE = "Fatal error creating thread."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 2
                MESSAGE = "Cannot create JVM."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 3
                MESSAGE = "Cannot find JAVA class, please check EB.API Record " : Y.EB.API.ID
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 4
                MESSAGE = "Unicode conversion error"
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 5
                MESSAGE = "Cannot find method, please check EB.API Record  " : Y.EB.API.ID
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 6
                MESSAGE = "Cannot find object constructor"
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
            CASE Y.CALLJ.ERROR EQ 7
                MESSAGE = "Cannot instantiate object, check all dependencies registrered in CLASSPATH env."
                E = MESSAGE
                ETEXT = E
                CALL ERR
                RETURN
        END CASE
    END

    IF FIELD(Y.RESPONSE,'*',1) EQ '0' THEN
*DEBUG
        GOSUB FORMARRAY
    END


RETURN

FORMARRAY:
**1: Code, 2: Message, 3: Deal Ticket No., 4: Currency, 5: Ex. Rate, 6: Amount
**R.NEW(TT.TE.LOCAL.REF)<1,L.NOM.DIVISA.POS> = FIELD(Y.RESPONSE,'*',4)
**R.NEW(TT.TE.DEAL.RATE) = FIELD(Y.RESPONSE,'*',5)
**R.NEW(TT.TE.AMOUNT.LOCAL.1) = FIELD(Y.RESPONSE,'*',6)
**R.NEW(TT.TE.CURR.MARKET.1) = 'USD/DOP/ETC'

    R.NEW(TT.TE.CURRENCY.1) = FIELD(Y.RESPONSE,'*',4)
    R.NEW(TT.TE.DEAL.RATE) = FIELD(Y.RESPONSE,'*',5)
    R.NEW(TT.TE.LOCAL.REF)<1,L.TT.BASE.AMT.POS> = FIELD(Y.RESPONSE,'*',6)

*DEBUG
RETURN



END
