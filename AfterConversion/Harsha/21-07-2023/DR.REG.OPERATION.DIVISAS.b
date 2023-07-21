* @ValidationCode : Mjo1MjQzMjcyNzM6Q3AxMjUyOjE2ODk5MzIzNDQ0MDA6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2023 15:09:04
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
$PACKAGE APAP.DRREG
*
*-----------------------------------------------------------------------------
* <Rating>1368</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.OPERATION.DIVISAS
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-JULY-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM ,SM to @SM 
* 21-JULY-2023      Harsha                R22 Manual Conversion - ;*Commented because of missing DR.OPER.DIVISAS.FILE table                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DR.BLD.OPER.DIVISAS
    $INSERT I_F.DR.REGREP.PARAM



    GOSUB INIT.PARA
    GOSUB SEL.PARA
    GOSUB PROC.PARA

RETURN

PROC.PARA:
*--------
*
    LOOP
        REMOVE CON.ID FROM DIV.LIST SETTING DVPOS
    WHILE CON.ID NE ''
        REP.LINE =  '' ; R.DR.OPER.DIVISAS.FILE = ''

*    READ R.DR.OPER.DIVISAS.FILE FROM F.DR.OPER.DIVISAS.FILE,CON.ID THEN ;*Tus Start
        CALL F.READ(FN.DR.OPER.DIVISAS.FILE,CON.ID,R.DR.OPER.DIVISAS.FILE,F.DR.OPER.DIVISAS.FILE,R.DR.OPER.DIVISAS.FILE.ERR)
        IF R.DR.OPER.DIVISAS.FILE THEN  ;* Tus End
            GOSUB PROCESS.CON
        END

    REPEAT
    GOSUB PRINT.SUMM.1
    GOSUB PRINT.SUMM.2

RETURN


PROCESS.CON:
*--------
*CON.ID =  R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.CONCEPT>   ;*Commented because of missing DR.OPER.DIVISAS.FILE table
    CON.ID = ""											;* Added due to comment
    IF CON.ID THEN
        GOSUB GET.CONCEPT
*R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.CONCEPT> = CONCEPT    ;*Commented because of missing DR.OPER.DIVISAS.FILE table
    END ELSE
        CONCEPT =  'Blank'
    END

*SUMM1.KEY =  R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.CURRENCY>     ;*Commented because of missing DR.OPER.DIVISAS.FILE table
    SUMM1.KEY =  ""											  ;* Added due to comment
    SUMM2.KEY = CONCEPT
*BEGIN CASE

*CASE  R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.OPER.TYPE> EQ 'OPE'                          ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*Have to update only the summary 1
* LOCATE SUMM1.KEY IN  SUMM.1.KEY.ARRAY<1> SETTING SUMPOS THEN                       ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*     SUMM1.ARRAY<SUMPOS,2> += R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.AMOUNT.FCY>          ;*Commented because of missing DR.OPER.DIVISAS.FILE table
* END ELSE                                                                           ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*     INS SUMM1.KEY BEFORE SUMM.1.KEY.ARRAY<SUMPOS>                                  ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*     INS SUMM1.KEY BEFORE SUMM1.ARRAY<SUMPOS>                                       ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*     SUMM1.ARRAY<SUMPOS,2> = R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.AMOUNT.FCY>           ;*Commented because of missing DR.OPER.DIVISAS.FILE table
* END                                                                                ;*Commented because of missing DR.OPER.DIVISAS.FILE table

*CASE R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.OPER.TYPE> EQ "Venta"         ;* SELL         ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    VENTA.AMT = R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.AMOUNT.FCY>                        ;*Commented because of missing DR.OPER.DIVISAS.FILE table
    COMPA.AMT =  0                                                                   
*    GOSUB SUMM1.PARA                                                                ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    IF SUMM1.KEY EQ 'USD' THEN                                                      ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*        GOSUB SUMM2.VENTA.PARA                                                      ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    END                                                                             ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    GOSUB PRINT.DET                                                                 ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*CASE  R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.OPER.TYPE> EQ "compra"       ;* BUY          ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    COMPA.AMT = R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.AMOUNT.FCY>                        ;*Commented because of missing DR.OPER.DIVISAS.FILE table
    VENTA.AMT =  0                                                                   
*    GOSUB SUMM1.PARA                                                                ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    IF SUMM1.KEY EQ 'USD' THEN                                                      ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*        GOSUB SUMM2.COMPA.PARA                                                      ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    END                                                                             ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    GOSUB PRINT.DET                                                                 ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*END CASE                                                                            ;*Commented because of missing DR.OPER.DIVISAS.FILE table

RETURN
GET.CONCEPT:
*----------


*CON.ID =  R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.CONCEPT>         ;*Commented because of missing DR.OPER.DIVISAS.FILE table
    CON.ID = ""												 ;* Added due to comment
    LOCATE CON.ID IN CONCEPT.ID.ARRAY<1> SETTING CONPOS THEN
        CONCEPT = CONCEPT.NAME.ARRAY<CONPOS>
    END ELSE
        INS CON.ID BEFORE CONCEPT.ID.ARRAY<CONPOS>
*        IF R.DR.OPER.DIVISAS.FILE<DR.OP.DIV.OPER.TYPE> EQ "Venta" THEN     ;*Commented because of missing DR.OPER.DIVISAS.FILE table
*        CON.ID = 'L.TT.FX.SEL.DST*':CON.ID									;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    END ELSE      															;*Commented because of missing DR.OPER.DIVISAS.FILE table
*        CON.ID = 'L.TT.FX.BUY.SRC*':CON.ID									;*Commented because of missing DR.OPER.DIVISAS.FILE table
*    END																	;*Commented because of missing DR.OPER.DIVISAS.FILE table
        R.CONCEPT = ''

*    READ R.CONCEPT FROM F.EB.LOOKUP,CON.ID ELSE NULL ;*Tus Start
        CALL F.READ(FN.EB.LOOKUP,CON.ID,R.CONCEPT,F.EB.LOOKUP,R.CONCEPT.ERR);*Tus End
        CONCEPT = R.CONCEPT<1,1>
        INS CONCEPT BEFORE CONCEPT.NAME.ARRAY<CONPOS>
    END
RETURN

SUMM1.PARA:
*-------------

    LOCATE SUMM1.KEY IN  SUMM.1.KEY.ARRAY<1> SETTING SUMPOS THEN
        SUMM1.ARRAY<SUMPOS,3> += COMPA.AMT
        SUMM1.ARRAY<SUMPOS,4> += VENTA.AMT
    END ELSE
        INS SUMM1.KEY BEFORE SUMM.1.KEY.ARRAY<SUMPOS>
        INS SUMM1.KEY BEFORE SUMM1.ARRAY<SUMPOS>
        SUMM1.ARRAY<SUMPOS,3> = COMPA.AMT
        SUMM1.ARRAY<SUMPOS,4> = VENTA.AMT
    END

RETURN
SUMM2.VENTA.PARA:
*-----------


    LOCATE SUMM2.KEY IN  SUMM.2.VKEY.ARRAY<1> BY 'AR' SETTING SUMPOS THEN
        SUMM2.V.ARRAY<SUMPOS,2> += VENTA.AMT
    END ELSE
        INS SUMM2.KEY BEFORE SUMM.2.VKEY.ARRAY<SUMPOS>
        INS SUMM2.KEY BEFORE SUMM2.V.ARRAY<SUMPOS>
        SUMM2.V.ARRAY<SUMPOS,2> = VENTA.AMT

    END


RETURN
SUMM2.COMPA.PARA:
*----------------


    LOCATE SUMM2.KEY IN  SUMM.2.CKEY.ARRAY<1> BY 'AR' SETTING SUMPOS THEN
        SUMM2.C.ARRAY<SUMPOS,2> += COMPA.AMT
    END ELSE
        INS SUMM2.KEY BEFORE SUMM.2.CKEY.ARRAY<SUMPOS>
        INS SUMM2.KEY BEFORE SUMM2.C.ARRAY<SUMPOS>
        SUMM2.C.ARRAY<SUMPOS,2> = COMPA.AMT
    END
RETURN


PRINT.DET:
*--------

    CONVERT @FM TO '|' IN R.DR.OPER.DIVISAS.FILE
    WRITESEQ R.DR.OPER.DIVISAS.FILE TO  F.REGREPORT.DET ELSE NULL

RETURN
PRINT.SUMM.1:
*-----------

    PRINT.LINE = 'TIPO DE MONEDA | POSICION INICIAL | COMPRAS | VENTAS | POSICION FINAL'
    WRITESEQ PRINT.LINE TO F.REGREPORT.SUM ELSE NULL
    TOT.CURR =  DCOUNT(SUMM.1.KEY.ARRAY,@FM)

    FOR ICUR = 1 TO TOT.CURR

        PRINT.LINE = SUMM1.ARRAY<ICUR>
        PRINT.LINE<1,5> = PRINT.LINE<1,2> - PRINT.LINE<1,3> + PRINT.LINE<1,4>
        CONVERT @VM TO '|' IN PRINT.LINE
        WRITESEQ PRINT.LINE TO F.REGREPORT.SUM ELSE NULL

    NEXT ICUR

RETURN

PRINT.SUMM.2:
*---------------
    PRINT.LINE = 'CONCEPTO COMPRAS | VALOR '
    WRITESEQ PRINT.LINE TO F.REGREPORT.SUM ELSE NULL

    TOT.COMPA  = DCOUNT(SUMM.2.CKEY.ARRAY,@FM)
    FOR ICOMP = 1 TO TOT.COMPA
        PRINT.LINE = SUMM2.C.ARRAY<ICOMP>
        CONVERT @VM TO '|' IN PRINT.LINE
        WRITESEQ PRINT.LINE TO F.REGREPORT.SUM ELSE NULL

    NEXT ICOMP

    PRINT.LINE = 'CONCEPTO VENTAS | VALOR '
    WRITESEQ PRINT.LINE TO F.REGREPORT.SUM ELSE NULL

    TOT.VENTA  = DCOUNT(SUMM.2.VKEY.ARRAY,@FM)
    FOR IVENTA = 1 TO TOT.VENTA
        PRINT.LINE = SUMM2.V.ARRAY<IVENTA>
        CONVERT @VM TO '|' IN PRINT.LINE
        WRITESEQ PRINT.LINE TO F.REGREPORT.SUM ELSE NULL

    NEXT IVENTA     ;*R22 Manual Conversion - ICOMP to IVENTA
RETURN

SEL.PARA:
*---------
    SEL.CMD = 'SELECT ':  FN.DR.OPER.DIVISAS.FILE
    CALL EB.READLIST(SEL.CMD,DIV.LIST,'','','')
RETURN

INIT.PARA:
**********

    PROCESS.GO.AHEAD =  1 ; REC.COUNT = 0
    CONCEPT.ID.ARRAY = '' ; CONCEPT.NAME.ARRAY =  ''
    ORIG.FUNDS.ARRAY = ''
    SUMM1.ARRAY = '' ; SUMM.1.KEY.ARRAY = ''
    SUMM2.C.ARRAY = '' ; SUMM.2.CKEY.ARRAY = ''
    SUMM2.V.ARRAY = '' ; SUMM.2.VKEY.ARRAY = ''
    GOSUB OPEN.FILES

    PROC.DATE =  TODAY
    PROC.DATE =  PROC.DATE[7,2]: '/':PROC.DATE[5,2] : '/' : PROC.DATE[1,4]
    REGREP.SYS.ID =  'SYSTEM'  ; R.REGREP.SYSTEM  = '' ; ERR.REGREP.SYSTEM = ''

*  CALL F.READ(FN.DR.REGREP.PARAM,REGREP.SYS.ID,R.REGREP.SYSTEM,F.DR.REGREP.PARAM,ERR.REGREP.SYSTEM)        ;*/ TUS START/END
    CALL CACHE.READ(FN.DR.REGREP.PARAM,REGREP.SYS.ID,R.REGREP.SYSTEM,ERR.REGREP.SYSTEM)
    IF ERR.REGREP.SYSTEM EQ '' THEN
        REGREP.FILE.PATH =  R.REGREP.SYSTEM<DR.REG.REPORT.PATH>
        REPORT.ID =  'REP.OPER.DIV.DET.' : TODAY
        OPENSEQ REGREP.FILE.PATH,REPORT.ID TO F.REGREPORT.DET ELSE NULL
        GOSUB PRINT.HEADER.DET
        REPORT.ID =  'REP.OPER.DIV.SUM.' : TODAY
        OPENSEQ REGREP.FILE.PATH,REPORT.ID TO F.REGREPORT.SUM ELSE NULL

    END
RETURN

OPEN.FILES:
*-----------

    FN.DR.REGREP.PARAM = 'F.DR.REGREP.PARAM'
    F.DR.REGREP.PARAM = ''
    CALL OPF(FN.DR.REGREP.PARAM,F.DR.REGREP.PARAM)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.DR.OPER.DIVISAS.FILE = 'F.DR.OPER.DIVISAS.FILE'
    F.DR.OPER.DIVISAS.FILE = ''
    CALL OPF(FN.DR.OPER.DIVISAS.FILE,F.DR.OPER.DIVISAS.FILE)

RETURN

PRINT.HEADER.DET:
*-----------------

    WRITESEQ 'Asociaciopular de Ahorros y Pramos' TO  F.REGREPORT.DET ELSE NULL
    WRITESEQ 'RNC 4-01-00013-1. Av. Mmo G esq. 27 de Febrero, El Vergel.' TO  F.REGREPORT.DET ELSE NULL
    WRITESEQ 'Tel. 809-689-0171'  TO  F.REGREPORT.DET ELSE NULL

    PRT.HEAD = 'Numero de Recibo | Nombres y apellidos| Numero de |Tipo de | Moneda | Monto | Tasa | Concepto'
    WRITESEQ PRT.HEAD TO F.REGREPORT.DET ELSE NULL
    PRT.HEAD = ' |del cliente | identificacion | Operacion'
    WRITESEQ PRT.HEAD TO F.REGREPORT.DET ELSE NULL
RETURN
