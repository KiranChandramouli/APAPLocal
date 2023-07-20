* @ValidationCode : MjoxNTk4MTk3ODc5OkNwMTI1MjoxNjg5MzM5OTc1NzIxOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:36:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.CHG.DEALTICKET.STA.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 14-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 14-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.DC.LAPAP.DEALTICKT.NOPROC
**Esta subrutina sirve para cambiar el estado de un dealticket luego de ser realizada la transaccion.
**Probar standalone java apapT24FIMDT.ClsPrincipal
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

    Y.IDINSTRUMENTO = R.NEW(TT.TE.LOCAL.REF)<1,L.BOL.DIVISA.POS>
    Y.USUARIO = FIELD(R.NEW(TT.TE.INPUTTER),'_',2)
    IF(Y.USUARIO EQ '') THEN
        Y.USUARIO = 'T24'
    END
    Y.LOCALIDAD = R.NEW(TT.TE.CO.CODE)
    param = Y.IDINSTRUMENTO: '-':Y.USUARIO:'-':Y.LOCALIDAD
*MSG<-1> = param
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)
    Y.EB.API.ID = 'LAPAP.FIM.DT.STA.CHG'
RETURN

DOCALL:
    CALL EB.CALL.JAVA.API(Y.EB.API.ID,param,Y.RESPONSE,Y.CALLJ.ERROR)
*MSG = ''
*MSG<-1> = Y.RESPONSE
*MSG<-1> = Y.CALLJ.ERROR
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

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

    GOSUB DO_OPERATION



RETURN

DO_OPERATION:
**1: Code, 2: Message, 3: Codigo ASMRISK, 4: Success Indicator, 5: Data Indicator
    V.CODE = FIELD(Y.RESPONSE,'*',1)
    V.MSG = FIELD(Y.RESPONSE,'*',2)
    V.CODEASM = FIELD(Y.RESPONSE,'*',3)
    V.SUCCESS = FIELD(Y.RESPONSE,'*',4)
    IF(V.CODE NE '0' OR V.CODEASM NE '100') THEN
**Insertar OFS en DC.LAPAP.DEALTICKT.NOPROC
        GOSUB OFS_PROC
    END

RETURN

OFS_PROC:
    Y.TRANS.ID = ""
    Y.APP.NAME = "DC.LAPAP.DEALTICKT.NOPROC"
    Y.VER.NAME = Y.APP.NAME :",RAD"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.DT = ""

    R.DT<DC.LAP19.IDINSTRUMENTO> = Y.IDINSTRUMENTO
    R.DT<DC.LAP19.USUARIO> = Y.USUARIO
    R.DT<DC.LAP19.LOCALIDAD> = Y.LOCALIDAD
    R.DT<DC.LAP19.ESTATUS> = 'PENDIENTE'
    R.DT<DC.LAP19.MENSAJE> = V.MSG

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.DT,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"FIM",'')

RETURN

END
