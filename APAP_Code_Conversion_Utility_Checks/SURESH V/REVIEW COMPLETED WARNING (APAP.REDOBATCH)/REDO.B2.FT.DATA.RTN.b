* @ValidationCode : MjotMTM4MTgzNjM1NjpDcDEyNTI6MTcwNDcxNDQ2ODA2MDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jan 2024 17:17:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B2.FT.DATA.RTN
****************************************
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
* Incoming:
* ---------
* N/A
*
* Outgoing:
* ---------
*
**
* Error Variables:
* N/A
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Santiago Jijon - TAM Latin America
* Date            : Jul, 18 - 2012
* Modify by       :
* Modify date     :
* Notes           :
* Date                  who                   Reference
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - VM TO @VM AND ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   Change F.READ to CACHE.READ
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON

    $INSERT I_F.REDO.B2.FT.DATA
    $INSERT I_F.REDO.B2.FT.PARAMETERS
    $INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE
    $INSERT I_F.REDO.APAP.H.COMP.NAME

***<region name=MAIN.LOGIC>
*---------------------------------------------------------------------------------------------------------
MAIN.LOGIC:
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
***</region>
***<region name=INITIALISE>
*---------------------------------------------------------------------------------------------------------
INITIALISE:
    Y.TOT.VALUE = 0
    Y.NET.VALUE = 0
    Y.APAP.COMMISION = 0
    Y.ITBIS.VALUE = 0
    Y.MONTO.BASE = 0
    Y.VAL.COMISION.BRUTO = 0
    Y.VAL.COMISION.NETO = 0
    Y.ITBIS.COMMISION = 0



    Y.COMPANY     = System.getVariable("CURRENT.COMPAN")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.COMPANY = ""
    END
    Y.POLICY.TYPE = System.getVariable("CURRENT.POLIZA")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.POLICY.TYPE = ""
    END
    Y.TOT.VALUE   = System.getVariable("CURRENT.VALUE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.TOT.VALUE = ""
    END
    Y.NEWCLOSDATE = System.getVariable("CURRENT.NEWCLOSDATE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.NEWCLOSDATE = ""
    END
    Y.CHARGE      = System.getVariable("CURRENT.CHARGE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.CHARGE = ""
    END
    Y.TYPE.ENQ    = System.getVariable("CURRENT.TYPE.ENQ")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.TYPE.ENQ = ""
    END
    Y.CLS.POL = System.getVariable("CURRENT.CLS.POL")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CONVERSTION ADDED IF E EQ "EB-UNKNOWN.VARIABLE" THEN VARIABLE NULL AND END
        Y.CLS.POL = ""
    END

    FN.DATA = 'F.REDO.B2.FT.DATA'
    F.DATA = ''
    R.DATA = ''
    CALL OPF (FN.DATA, F.DATA)

    FN.PARAM = 'F.REDO.B2.FT.PARAMETERS'
    F.PARAM = ''
    R.PARAM = ''
    CALL OPF (FN.PARAM, F.PARAM)

    FN.POLICY = 'F.APAP.H.INSURANCE.POLICY.TYPE'
    F.POLICY = ''
    R.POLICY = ''
    CALL OPF (FN.POLICY, F.POLICY)

    FN.COMPNAME = 'F.REDO.APAP.H.COMP.NAME'
    F.COMPNAME = ''
    R.COMPNAME = ''
    CALL OPF (FN.COMPNAME, F.COMPNAME)


RETURN
***</region>
***<region name=PROCESS>
*---------------------------------------------------------------------------------------------------------
PROCESS:

    R.PARAM = ''
    YERR = ''
*    CALL F.READ(FN.PARAM,Y.POLICY.TYPE,R.PARAM,F.PARAM,YERR)
    CALL CACHE.READ(FN.PARAM,Y.POLICY.TYPE,R.PARAM,YERR) ;*R22 Manual Conversion
    BEGIN CASE
        CASE Y.TYPE.ENQ EQ 'NORMAL'
            LOCATE Y.CLS.POL IN R.PARAM<PAY.PAR.CLASS.POLICY,1> SETTING PS.M THEN
                LOCATE Y.COMPANY IN R.PARAM<PAY.PAR.INS.COMPANY,PS.M,1> SETTING POS.CL THEN
                    Y.PRIM.NET  = R.PARAM<PAY.PAR.PRIMA.NETA,PS.M,POS.CL>
                    Y.COMM.APAP = R.PARAM<PAY.PAR.COMISION.APAP,PS.M,POS.CL>
                    Y.ITBIS     = R.PARAM<PAY.PAR.ITBIS,PS.M,POS.CL>
                    Y.BRUTO     = 0
                    Y.NETO      = 0

                    GOSUB ENQ.NORMAL
                END
            END

        CASE Y.TYPE.ENQ EQ 'DESEMBOLSO'
            LOCATE Y.CLS.POL IN R.PARAM<PAY.PAR.CLASS.POLICY,1> SETTING PS.M THEN
                LOCATE Y.COMPANY IN R.PARAM<PAY.PAR.INS.COMPANY,PS.M,1> SETTING POS.CL THEN
                    Y.PRIM.NET  = R.PARAM<PAY.PAR.DES.PRIMA.NETA,PS.M,POS.CL>
                    Y.COMM.APAP = R.PARAM<PAY.PAR.DES.COMISION.APAP,PS.M,POS.CL>
                    Y.ITBIS     = R.PARAM<PAY.PAR.DES.ITBIS,PS.M,POS.CL>
                    Y.BASE      = R.PARAM<PAY.PAR.DES.MONTO.BASE,PS.M,POS.CL>
                    Y.BRUTO     = R.PARAM<PAY.PAR.DES.BRUTO,PS.M,POS.CL>
                    Y.NETO      = R.PARAM<PAY.PAR.DES.NETO,PS.M,POS.CL>
                    GOSUB ENQ.DESEMBOLSO
                END
            END

        CASE Y.TYPE.ENQ EQ 'FHA'
            LOCATE Y.CLS.POL IN R.PARAM<PAY.PAR.CLASS.POLICY,1> SETTING PS.M THEN
                LOCATE Y.COMPANY IN R.PARAM<PAY.PAR.INS.COMPANY,PS.M,1> SETTING POS.CL THEN
                    Y.BRUTO     = 0
                    Y.NETO      = 0
                    GOSUB ENQ.FHA
                END
            END

    END CASE

    R.NEW(PAY.DAT.INS.COMPANY) = Y.COMPANY
    R.NEW(PAY.DAT.INS.POLICY.TYPE) = Y.POLICY.TYPE
    R.NEW(PAY.DAT.CLOSING.DATE) = Y.NEWCLOSDATE
    R.NEW(PAY.DAT.CURRENCY) = 'DOP'
    Y.TT.VAL = DROUND(Y.TOT.VALUE,2)
    Y.TT.VAL = FMT(Y.TT.VAL,'R2,')
    R.NEW(PAY.DAT.TOTAL.VALUE) = Y.TT.VAL
    R.NEW(PAY.DAT.CHARGE) = Y.CHARGE
    R.NEW(PAY.DAT.INS.CLAS.POLICY) = Y.CLS.POL


    CALL F.READ(FN.COMPNAME,Y.COMPANY,R.COMPNAME,F.COMPNAME,YERR)
    Y.POL.STYPES = R.COMPNAME<REDO.CMP.INS.POLICY.TYPE> ; Y.POL.CNT = DCOUNT(Y.POL.STYPES,@VM) ; Y.FLG = ''
    Y.CLS.GRP = R.COMPNAME<REDO.CMP.CLASS.POLICY>
    LOOP
    WHILE Y.POL.CNT GT 0 DO
        Y.FLG += 1
        IF Y.POLICY.TYPE EQ Y.POL.STYPES<1,Y.FLG> THEN
            IF Y.CLS.POL EQ Y.CLS.GRP<1,Y.FLG> THEN
                R.NEW(PAY.DAT.SEN.POLICY.NUMBER) = R.COMPNAME<REDO.CMP.SEN.POLICY.NUMBER,Y.FLG>
                Y.POL.CNT = 0
            END
        END
        Y.POL.CNT -= 1
    REPEAT

RETURN
***</region>

***<region name = ENQ.NORMAL>
*---------------------------------------------------------------------------------------------------------
ENQ.NORMAL:
* b.
    IF Y.PRIM.NET NE '' AND Y.PRIM.NET NE 0 THEN
        Y.NET.VALUE = Y.TOT.VALUE / Y.PRIM.NET
    END
    Y.NET.VALUE.1 = DROUND(Y.NET.VALUE,2)
    Y.NET.VALUE = FMT(Y.NET.VALUE.1,'R2,')
    R.NEW(PAY.DAT.NET.VALUE) = Y.NET.VALUE
* c.
    Y.APAP.COMMISION = (Y.NET.VALUE.1 * Y.COMM.APAP) / 100
    Y.APAP.COMMISION.1 = DROUND(Y.APAP.COMMISION,2)
    Y.APAP.COMMISION = FMT(Y.APAP.COMMISION.1,'R2,')
    R.NEW(PAY.DAT.BASE.COMMISION) = Y.APAP.COMMISION

    Y.ORIG.COM = R.PARAM<PAY.PAR.ORIG.COM.PERC>
    Y.AP.OR.COM = Y.APAP.COMMISION.1 / Y.ORIG.COM
    Y.AP.OR.COM.1 = DROUND(Y.AP.OR.COM,2)
    Y.AP.OR.CCMM = FMT(Y.AP.OR.COM.1,'R2,')
    R.NEW(PAY.DAT.APAP.COMMISION) = Y.AP.OR.CCMM

* d.
    Y.ITBIS.VALUE = (Y.AP.OR.COM.1 * Y.ITBIS) / 100
    Y.ITBIS.VALUE.1 = DROUND(Y.ITBIS.VALUE,2)
    Y.ITBIS.VALUE = FMT(Y.ITBIS.VALUE.1,'R2,')
    R.NEW(PAY.DAT.ITBIS.VALUE) = Y.ITBIS.VALUE
* e.
    Y.APAGAR = Y.TOT.VALUE - Y.AP.OR.COM.1 - Y.ITBIS.VALUE.1
    R.NEW(PAY.DAT.PAYMENT.VALUE) = Y.APAGAR
RETURN
***</region>

***<region name = ENQ.DESEMBOLSO>
*---------------------------------------------------------------------------------------------------------
ENQ.DESEMBOLSO:
* b.
    IF Y.PRIM.NET NE '' AND Y.PRIM.NET NE 0 THEN
        Y.NET.VALUE = Y.TOT.VALUE / Y.PRIM.NET
    END
    Y.NET.VALUE.1 = DROUND(Y.NET.VALUE,2)
    Y.NET.VALUE = FMT(Y.NET.VALUE.1,'R2,')
    R.NEW(PAY.DAT.NET.VALUE) = Y.NET.VALUE
* c.
    Y.APAP.COMMISION = (Y.NET.VALUE.1 * Y.COMM.APAP) / 100
    Y.APAP.COMMISION.1 = DROUND(Y.APAP.COMMISION,2)
    Y.APAP.COMMISION = FMT(Y.APAP.COMMISION.1,'R2,')
    R.NEW(PAY.DAT.BASE.COMMISION) = Y.APAP.COMMISION

    Y.ORIG.COM = R.PARAM<PAY.PAR.ORIG.COM.PERC>
    Y.AP.OR.COM = Y.APAP.COMMISION.1 / Y.ORIG.COM
    Y.AP.OR.COM.1 = DROUND(Y.AP.OR.COM,2)
    Y.AP.OR.CCMM = FMT(Y.AP.OR.COM.1,'R2,')
    R.NEW(PAY.DAT.APAP.COMMISION) = Y.AP.OR.CCMM
* d.
    Y.ITBIS.VALUE = (Y.AP.OR.COM.1 * Y.ITBIS) / 100
    Y.ITBIS.VALUE.1 = DROUND(Y.ITBIS.VALUE,2)
    Y.ITBIS.VALUE = FMT(Y.ITBIS.VALUE.1,'R2,')
    R.NEW(PAY.DAT.ITBIS.VALUE) = Y.ITBIS.VALUE
* e.
    Y.MONTO.BASE = (Y.NET.VALUE.1 * Y.BASE) / 100
    Y.MONTO.BASE.1 = DROUND(Y.MONTO.BASE,2)
    Y.MONTO.BASE = FMT(Y.MONTO.BASE.1,'R2,')
    R.NEW(PAY.DAT.BASE.AMOUNT) = Y.MONTO.BASE
* f.
    Y.VAL.COMISION.BRUTO = (Y.MONTO.BASE.1 * Y.BRUTO) / 100
    Y.VAL.COMISION.BRUTO.1 = DROUND(Y.VAL.COMISION.BRUTO,2)
    Y.VAL.COMISION.BRUTO = FMT(Y.VAL.COMISION.BRUTO.1,'R2,')
    R.NEW(PAY.DAT.GROSS.COMMISION) = Y.VAL.COMISION.BRUTO
* g.
    Y.VAL.COMISION.NETO = Y.VAL.COMISION.BRUTO.1 / Y.NETO
    Y.VAL.COMISION.NETO.1 = DROUND(Y.VAL.COMISION.NETO,2)
    Y.VAL.COMISION.NETO = FMT(Y.VAL.COMISION.NETO.1,'R2,')
    R.NEW(PAY.DAT.NET.COMMISION) = Y.VAL.COMISION.NETO
* h.
    Y.ITBIS.COMMISION = Y.VAL.COMISION.BRUTO.1 - Y.VAL.COMISION.NETO.1
    R.NEW(PAY.DAT.ITBIS.COMMISION) = Y.ITBIS.COMMISION
* i.
    Y.APAGAR = Y.TOT.VALUE - Y.AP.OR.COM.1 - Y.ITBIS.VALUE.1
    R.NEW(PAY.DAT.PAYMENT.VALUE) = Y.APAGAR
RETURN
***</region>

***<region name = ENQ.FHA>
*---------------------------------------------------------------------------------------------------------
ENQ.FHA:
* b.
    Y.APAGAR = Y.TOT.VALUE
    Y.APAGAR = DROUND(Y.APAGAR,2)
    Y.APAGAR = FMT(Y.APAGAR,'R2,')
    R.NEW(PAY.DAT.PAYMENT.VALUE) = Y.APAGAR
RETURN
***</region>


END
