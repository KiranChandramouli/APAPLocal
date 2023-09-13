* @ValidationCode : MjotMTM2NzQ1NDIzMDpDcDEyNTI6MTY5MzkyMjQ0MjcyNzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Sep 2023 19:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PROCESA.ACH.ENTRANTE.RT.SELECT

*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 14-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,INCLUDE to INSERT,T to C$T24.SESSION.,FM to @FM
* 05-09-2023    VICTORIA S             R22 Manual Conversion     call routine format modified,R22 interface Unit testing changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto Conversion  -START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ACH.DATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.REDO.ACH.PROCESS
    $INSERT I_F.REDO.ACH.PROCESS.DET
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_LAPAP.PROCESA.ACH.ENTRANTE.RT
    $INSERT I_F.CUSTOMER ;*R22 Auto Conversion - END
 
    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""
    Y.FECHA = TODAY

    GOSUB METHOD_INIT
    GOSUB METHOD_GET_GENERAL_PARAMETERS
    GOSUB METHOD_PROCESS
    
    SEL.CMD = "SELECT " : FN.REDO.ACH.PROCESS.DET : " WITH @ID LIKE ": Y.FECHA :"... AND STATUS EQ '01'"

    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

*---------------
METHOD_INIT:
*---------------
    FLAG.PATH = ''
    INVALID.ACCT = ''
    REVERSE.FLAG = ''
    R.REDO.ACH.PROCESS = ''
    INVALID.ERR.FLAG = ''
    INVALID.PROC.DET.ERR.FLAG = ''
    R.REDO.ACH.PROCESS.DET = ''
    OFS.RAD.ERR.FLAG = ''
    OFS.RAD.PROC.ERR.FLAG = ''
    OFS.ERR.FLAG = ''
    Y.ARR.OFS.MSG = ''
    INVALID.ACCT.ERR.FLAG = ''

    FN.REDO.ACH.DATE = 'F.REDO.ACH.DATE'; F.REDO.ACH.DATE = ''
    CALL OPF(FN.REDO.ACH.DATE,F.REDO.ACH.DATE)

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'; F.REDO.INTERFACE.PARAM = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'; F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    FN.REDO.ACH.PROCESS = 'F.REDO.ACH.PROCESS'; F.REDO.ACH.PROCESS = ''
    CALL OPF(FN.REDO.ACH.PROCESS,F.REDO.ACH.PROCESS)

    FN.REDO.ACH.PROCESS.DET = 'F.REDO.ACH.PROCESS.DET'; F.REDO.ACH.PROCESS.DET = ''
    CALL OPF(FN.REDO.ACH.PROCESS.DET,F.REDO.ACH.PROCESS.DET)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.PASS.NAT = 'F.CUSTOMER.L.CU.PASS.NAT'; F.CUSTOMER.PASS.NAT = ''
    CALL OPF(FN.CUSTOMER.PASS.NAT,F.CUSTOMER.PASS.NAT)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    LREF.APP.ACCT = 'ACCOUNT'
    LREF.FIELD.ACCT = 'L.AC.STATUS1'
    LREF.FIELD.ACCT2 = 'L.AC.STATUS2'
    LREF.APP.CUS = 'CUSTOMER'
    LREF.FIELD.CUS = 'L.CU.PASS.NAT'

    CALL GET.LOC.REF(LREF.APP.ACCT,LREF.FIELD.ACCT,LREF.POS)
    CALL GET.LOC.REF(LREF.APP.ACCT,LREF.FIELD.ACCT2,LREF.POS2)
    CALL MULTI.GET.LOC.REF(LREF.APP.CUS,LREF.FIELD.CUS,LREF.FIELD.CUS.POS)

RETURN

*---------------------------------
METHOD_GET_GENERAL_PARAMETERS:
*---------------------------------
    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,Y.ERR.ACH.PAR)

    Y.PARAM.TXN.PURPOSE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.PURPOSE>
    Y.PARAM.TXN.CODE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.CODE>
    Y.PARAM.TXN.VERSION = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.VERSION>
    Y.PARAM.OFS.RAD.ID = R.REDO.ACH.PARAM<REDO.ACH.PARAM.OFS.RAD.ID>
    Y.SPL.CHAR = R.REDO.ACH.PARAM<REDO.ACH.PARAM.ACH.SPL.CHAR>
    Y.DELIMITER =  R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.DELIMITER>
    Y.NO.OF.ELEMENTS = R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.NO.OF.ELMNT>
    ACH.PROC.FLAG = ''
    INW.PATH.OUTPUT = ''
    Y.INTERF.ID = 'ACH003'

    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM,Y.INTERF.ID,R.REDO.INTERFACE.PARAM,Y.ERR.INT.PARAM)
    IN.DIR.PATH = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
    HIST.PATH = R.REDO.ACH.PARAM<REDO.ACH.PARAM.INW.HIST.PATH>

RETURN

*------------------
METHOD_PROCESS:
*------------------
    
    CALL OCOMO('Entrando al metodo METHOD_PROCESS')

    OPEN IN.DIR.PATH TO F.FILE.PATH ELSE
        DESC = 'No fue posible abrir el directorio ':IN.DIR.PATH
        CALL OCOMO(DESC)
        FLAG.PATH = '1'
    END

    IF FLAG.PATH NE '1' THEN
        SEL.CMD.INW = "SELECT ":IN.DIR.PATH
        CALL EB.READLIST(SEL.CMD.INW,SEL.LIST.INW,'',NO.OF.INW.REC,SEL.ERR.INW)

        LOOP
            REMOVE Y.INW.ID FROM SEL.LIST.INW SETTING INW.POS
        WHILE Y.INW.ID : INW.POS
            Y.FILE.NAME = Y.INW.ID
            Y.ARC.PROCESADO = 'N'
            GOSUB METHOD_VALIDA_ARC_PROCESADO

            IF Y.ARC.PROCESADO EQ 'N' THEN
*                Y.COMMAND = 'COPY FROM ':IN.DIR.PATH: ' TO ':HIST.PATH:' ':Y.INW.ID  ;*SJ in this way doesn't work
                Y.COMMAND = 'SH -c cp ':IN.DIR.PATH: '/':Y.INW.ID:' ':HIST.PATH:'/':Y.INW.ID ;*R22 interface Unit testing changes
                
                EXECUTE Y.COMMAND

                GOSUB METHOD_INW_INDIR_PROC
            END
            ACH.PROC.FLAG = ''
        REPEAT
    END

    CALL OCOMO('Saliendo del metodo METHOD_PROCESS')
RETURN

*-------------------------------
METHOD_VALIDA_ARC_PROCESADO:
*-------------------------------
    
    SEL.CMD.VAL.FILE = "SELECT " : FN.REDO.ACH.PROCESS : " WITH @ID LIKE ": Y.FECHA :"... AND FILE.NAME EQ '" : Y.FILE.NAME: "'"
    CALL EB.READLIST(SEL.CMD.VAL.FILE, SEL.LIST.VAL.FILE,"", NO.OF.REC.VAL.FILE, SEL.ERR.VAL.FILE)

    IF NO.OF.REC.VAL.FILE GT 0 THEN
        Y.ARC.PROCESADO = 'Y'
        CALL OCOMO('Archivo ': Y.FILE.NAME :' ya procesado el dia de hoy.')
    END

RETURN

*-------------------------
METHOD_INW_INDIR_PROC:
*-------------------------
    
    CALL OCOMO('Entrando al metodo METHOD_INW_INDIR_PROC')

    READ Y.FILE.MSG FROM F.FILE.PATH,Y.FILE.NAME THEN
* Fix for PACS00452811 [ACH special character]
        LOOP
            REMOVE Y.SPL FROM Y.SPL.CHAR SETTING Y.SPL.POS
        WHILE Y.SPL:Y.SPL.POS
            Y.FILE.MSG = CHANGE(Y.FILE.MSG,CHARX(Y.SPL),'***')
        REPEAT
* End of Fix

        Y.TOTAL.REC = DCOUNT(Y.FILE.MSG,@FM)
        CALL OCOMO('TOTAL DE TRANSACCIONES DEL ARCHIVO: ': Y.TOTAL.REC)
        FILE.LOOP = 1

        LOOP
            REMOVE Y.INW.LINE FROM Y.FILE.MSG SETTING Y.REC.POS
        WHILE Y.INW.LINE : Y.REC.POS

*Procedemos a limpiar la linea entrante, ya que algunos bancos no la envian correctamente segun la espera T24.
            APAP.LAPAP.lapapCorrigeTramaEntAchRt(Y.INW.LINE, Y.DELIMITER) ;*R22 Manual Conversion

            IF ACH.PROC.FLAG NE '1' THEN
*Esta seccion solo se ejecuta con el primer registro para guardar el header.
                CALL OCOMO('Entrando a la primera ejecucion del ACH.PROC.FLAG')
                GOSUB METHOD_ACH_PROC_PROCESS

                IF INVALID.ERR.FLAG EQ '1' THEN
                    DESC = 'Error regitrando el record en REDO.ACH.PROCESS. Finalizando proceso '
                    CALL OCOMO(DESC)

                    RETURN
                END
            END

            IF INVALID.ERR.FLAG NE '1' THEN
                GOSUB METHOD_ACH_PROC_DET

                IF INVALID.ACCT.ERR.FLAG NE '1' AND INVALID.PROC.DET.ERR.FLAG NE '1' THEN
                    GOSUB METHOD_OFS_RAD_PROC
                END

            END

            R.REDO.ACH.PROCESS.DET = ''; INVALID.ERR.FLAG = '' ; INVALID.PROC.DET.ERR.FLAG = ''; INVALID.ACCT.ERR.FLAG = ''
            OFS.RAD.ERR.FLAG = ''; OFS.RAD.PROC.ERR.FLAG = ''; OFS.ERR.FLAG = ''; Y.OFS.RAD.ID = ''; Y.OFS.RAD.VERSION = ''

            FILE.LOOP += 1

        REPEAT

        GOSUB METHOD_DELETE_FILE

    END ELSE
        DESC = 'No fue posible leer el directorio ':F.FILE.PATH
        CALL OCOMO(DESC)
    END

    CALL OCOMO('Saliendo del metodo METHOD_INW_INDIR_PROC')
RETURN
*---------------------------
METHOD_ACH_PROC_PROCESS:
*---------------------------
    
    Y.EXP.FMT = DCOUNT(Y.INW.LINE,Y.DELIMITER)

    IF Y.EXP.FMT NE Y.NO.OF.ELEMENTS THEN
        DESC = 'Archivo invalido. Incorrecto numero de elementos.'
        CALL OCOMO(DESC)
        INVALID.ERR.FLAG = '1'
    END ELSE
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.EXEC.DATE> = TODAY
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.FILE.NAME> = Y.FILE.NAME
        TEMPTIME = OCONV(TIME(),"MTS")
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.EXEC.TIME> = TEMPTIME
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.PROCESS.TYPE> = 'REDO.ACH.INWARD'
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.TOTAL.REC> = Y.TOTAL.REC

*AUDIT FIELDS
        Y.CURR.NO = 1
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.CURR.NO> = Y.CURR.NO
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR

        DATE.TIME = OCONV(DATE(), 'D2:YMD') : OCONV(TIME(), 'MT')
        CHANGE ':' TO '' IN DATE.TIME

        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.DATE.TIME> = DATE.TIME
        R.REDO.ACH.PROCESS<REDO.ACH.PROCESS.CO.CODE> = ID.COMPANY
        Y.ID.MASTER = TODAY:".":TIME()

        WRITE R.REDO.ACH.PROCESS TO F.REDO.ACH.PROCESS,Y.ID.MASTER ON ERROR
            DESC = 'No se pudo escribir el registro en la tabla REDO.ACH.PROCESS. Archivo ' : Y.FILE.NAME
            CALL OCOMO(DESC)
            INVALID.ERR.FLAG = '1'

            RETURN
        END

    END

    ACH.PROC.FLAG = '1'

RETURN

*-----------------------
METHOD_ACH_PROC_DET:
*-----------------------
    Y.MSG = Y.INW.LINE
    Y.COUNT = '1'

    Y.SEQUENCE = FILE.LOOP

    IF LEN(Y.SEQUENCE) LT 4 THEN

        Y.SEQUENCE=FMT(Y.SEQUENCE,'4"0"R')

    END

    Y.ID.DETAIL = Y.ID.MASTER:".":Y.SEQUENCE
**cambiando la generacion de id detalle
*Y.ID.DETAIL = Y.ID.MASTER:Y.SEQUENCE
    MAP.FMT = 'I'; ID.RCON.L = 'REDO.ACH.INWARD'; ID.APP = ''; R.APP = '' ;*R22 interface Unit testing changes
    APP = ""; R.RETURN.MSG= ''; ERR.MSG= ''
    R.APP = Y.INW.LINE
    
*;    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) SJ comment for test
*CALL REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 interface Unit testing changes
    APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 MANUAL CONVERSION
    IF ERR.MSG EQ '' THEN
        Y.TXN.CODE = R.RETURN.MSG<1>
        GOSUB METHOD_SUCCESS_PROCESS
    END ELSE
        DESC = 'Mensaje invalido en el detalle para el record ' : Y.SEQUENCE : '. Error en la transformacion al RAD: ' : ERR.MSG
        CALL OCOMO(DESC)
        INVALID.PROC.DET.ERR.FLAG = '1'
    END

RETURN

*--------------------------
METHOD_SUCCESS_PROCESS:
*--------------------------
    
    Y.ACCOUNT.NO = R.RETURN.MSG<3>
    R.RETURN.MSG<3> = TRIM(R.RETURN.MSG<3>)

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)
    Y.LOAN.FLAG=''
    Y.CARD.FLAG=''
    Y.RECHAZO = ''

    IF SUBSTRINGS(R.RETURN.MSG<1>,2,1) EQ '1' THEN
        Y.RECHAZO = 1
    END

    IF R.RETURN.MSG<1> EQ "52"  AND R.RETURN.MSG<7> EQ "04" THEN
*PRESTAMOS
        Y.LOAN.FLAG=1
    END

    IF R.RETURN.MSG<1> EQ "52" AND R.RETURN.MSG<7> EQ "05" THEN
*TARJETAS
        Y.CARD.FLAG=1
    END

    IF R.ACCOUNT EQ '' AND Y.CARD.FLAG EQ '' THEN
        DESC = 'Cuenta invalida ' : Y.ACCOUNT.NO : '. '
        CALL OCOMO(DESC)
        INVALID.ACCT.ERR.FLAG = '1'

        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R04'

        GOSUB METHOD_UPDATE_PROCESS_DET

        GOSUB METHOD_ACH_PROC_DET_AUDIT
    END ELSE
* Si existe el registro de la cuenta y no es una tarjeta
        IF Y.CARD.FLAG EQ '' AND Y.RECHAZO EQ '' THEN
            Y.RECH.ACCT = 'N'
            Y.ACCOUNT.STATUS = R.ACCOUNT<AC.LOCAL.REF,LREF.POS>
            Y.ACCOUNT.STATUS2 = R.ACCOUNT<AC.LOCAL.REF,LREF.POS2>


**** Todo Tomar en cuenta el estatus fallecido por codigo R04
            IF Y.ACCOUNT.STATUS2 EQ 'DECEASED' AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
*R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R14'
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R04'
                Y.RECH.ACCT = 'Y'
            END ELSE
                IF Y.ACCOUNT.STATUS EQ 'ABANDONED' AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R20'
                    Y.RECH.ACCT = 'Y'
                END ELSE
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
                END
            END

            IF Y.RECH.ACCT EQ 'N' AND Y.LOAN.FLAG EQ '' THEN
* si ya fue rechazada por alguna de las validaciones anteriores, no es necesario validar tambien el ID del cliente.
                GOSUB METHOD_VALIDA_ID_ACH
            END
        END ELSE
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
        END
        GOSUB SET.VALIDAR.CONTRATO
        GOSUB METHOD_UPDATE_PROCESS_DET
    END

RETURN

*--------------------------
SET.VALIDAR.CONTRATO:
*--------------------------
****rechazos si estan procesando préstamos como numero de cueta.
    
    IF R.ACCOUNT<AC.CATEGORY> GE '3000' AND R.ACCOUNT<AC.CATEGORY> LE '3999' AND LEN (R.ACCOUNT<AC.CATEGORY>) LE 4 THEN
        IF R.RETURN.MSG<1> NE "52"  AND R.RETURN.MSG<7> NE "04" THEN
            Y.RECHAZO = 1
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R04'
            DESC = 'Para préstamo se debe utilizar el codigo de transación 52'
            CALL OCOMO(DESC)
        END
    END
****----------------------------------------------------------------
RETURN
*--------------------------
METHOD_VALIDA_ID_ACH:
*--------------------------
    
    Y.CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>
    Y.REL.CONT = DCOUNT(R.ACCOUNT<AC.JOINT.HOLDER>,@VM)
    Y.ACH.CUS.ID = R.RETURN.MSG<6>

    IF Y.CUSTOMER.NO THEN
        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
        YCUS.LEGAL = R.CUSTOMER<EB.CUS.LEGAL.ID,1>

*ESTA FUNCION DEVULEVE LA IDENTIFICACION DEL CLIENTE SEA CUAL SEA.
        APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR) ;*R22 Manual Conversion
        Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

        L.CU.PASS.NAT.POS = LREF.FIELD.CUS.POS<1,1>
        YCUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PASS.NAT.POS>

        IF YCUS.FOREIGN THEN
* VALIDACION DE PASAPORTE
            IF Y.ACH.CUS.ID EQ YCUS.LEGAL OR Y.ACH.CUS.ID EQ Y.CUS.ID THEN
* IDENTIFICACION VALIDA
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = ''
                RETURN
            END ELSE

                IF Y.REL.CONT EQ 0 OR Y.REL.CONT EQ '' THEN
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
                END ELSE
*Si la transferencia no fue realizada por el dueno de la cuenta, verifica si es una cliente relacionado.
                    FOR A = 1 TO Y.REL.CONT STEP 1
                        Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER,A>
                        Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE,A>

                        IF Y.RELATION.CODE EQ 500 OR Y.RELATION.CODE EQ 501 OR Y.RELATION.CODE EQ 510 THEN
                            CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLDER,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
                            APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR);*R22 Manual Conversion
                            Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

                            IF Y.ACH.CUS.ID EQ Y.CUS.ID THEN
* IDENTIFICACION VALIDA
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = ''
                                RETURN
                            END ELSE
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
                            END
                        END ELSE
                            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
                        END
                    NEXT A
                END
            END
        END ELSE
* VALIDACION DE CEDULA Y RNC
            IF Y.ACH.CUS.ID EQ Y.CUS.ID THEN
* IDENTIFICACION VALIDA
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = ''
                RETURN
            END ELSE

                IF Y.REL.CONT EQ 0 OR Y.REL.CONT EQ '' THEN
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
                END ELSE
*Si la transferencia no fue realizada por el dueno de la cuenta, verifica si es una cliente relacionado.
                    FOR A = 1 TO Y.REL.CONT STEP 1
                        Y.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER,A>
                        Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE,A>

                        IF Y.RELATION.CODE EQ 500 OR Y.RELATION.CODE EQ 501 OR Y.RELATION.CODE EQ 510 THEN

                            CALL F.READ(FN.CUSTOMER,Y.JOINT.HOLDER,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUS)
                            APAP.LAPAP.drRegGetCustType(R.CUSTOMER, OUT.ARR);*R22 Manual Conversion
                            Y.CUS.ID = EREPLACE(OUT.ARR<2>, "-", "")

                            IF Y.ACH.CUS.ID EQ Y.CUS.ID THEN
* IDENTIFICACION VALIDA
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '01'
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = ''
                                RETURN
                            END ELSE
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                                R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
                            END

                        END ELSE
                            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
                            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
                        END

                    NEXT A
                END
            END
        END

    END ELSE
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R32'
    END

RETURN
*-----------------------------
METHOD_UPDATE_PROCESS_DET:
*-----------------------------
    Y.TXN.AMT = R.RETURN.MSG<2>
    Y.TXN.AMT = Y.TXN.AMT / 100

    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.EXEC.ID> = Y.ID.MASTER
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.CODE> = R.RETURN.MSG<1>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.AMOUNT> = Y.TXN.AMT
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ACCOUNT> = R.RETURN.MSG<3>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.PARTICIP.NAME> = R.RETURN.MSG<4>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.ID> = R.RETURN.MSG<5>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.PARTICIP.ID> = R.RETURN.MSG<6>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.DESCRIPTION> = R.RETURN.MSG<7>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ADDIT.INFO> = R.RETURN.MSG<8>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.NAME> = R.RETURN.MSG<9>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.ID> = R.RETURN.MSG<10>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.ACCT> = R.RETURN.MSG<11>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ORIGINATOR.B.ID> = R.RETURN.MSG<12>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.ERROR.MSG> = R.ACCOUNT<AC.CUSTOMER>

RETURN

*-----------------------------
METHOD_ACH_PROC_DET_AUDIT:
*-----------------------------
*AUDIT FIELDS
    Y.CURR.NO = 1
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CURR.NO> = Y.CURR.NO
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR

    DATE.TIME = OCONV(DATE(), 'D2:YMD') : OCONV(TIME(), 'MT')
    CHANGE ':' TO '' IN DATE.TIME

    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.DATE.TIME> = DATE.TIME
    R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.CO.CODE> = ID.COMPANY

    WRITE R.REDO.ACH.PROCESS.DET TO F.REDO.ACH.PROCESS.DET,Y.ID.DETAIL ON ERROR
        CALL OCOMO('Error regitrando auditoria de registro de detalle: ' : Y.ID.DETAIL)
    END

RETURN

*-----------------------
METHOD_OFS_RAD_PROC:
*-----------------------
    
    Y.TXN.PURPOSE = R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.TXN.DESCRIPTION>

    LOCATE Y.TXN.PURPOSE IN Y.PARAM.TXN.PURPOSE<1,1> SETTING TXN.PUR.POS THEN
        LOCATE Y.TXN.CODE IN Y.PARAM.TXN.CODE<1,TXN.PUR.POS,1> SETTING TXN.CODE.POS THEN
            Y.OFS.RAD.ID = Y.PARAM.OFS.RAD.ID<1,TXN.PUR.POS,TXN.CODE.POS>
            Y.OFS.RAD.VERSION = Y.PARAM.TXN.VERSION<1,TXN.PUR.POS,TXN.CODE.POS>
        END
    END

    IF Y.OFS.RAD.ID EQ '' OR Y.OFS.RAD.VERSION EQ '' THEN
        DESC = 'No hay version o RAD para el codigo de transaccion ' : Y.TXN.PURPOSE : '. Msj: '
        CALL OCOMO(DESC)

        OFS.RAD.ERR.FLAG = '1'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '03'
        R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.REJECT.CODE> = 'R31'
    END ELSE
        MAP.FMT = 'I' ;*R22 interface Unit testing changes
        ID.RCON.L = Y.OFS.RAD.ID
        APP = ''
        ID.APP = ''
        R.APP = Y.MSG
        R.RETURN.MSG= ''
        ERR.MSG= ''
        
*        CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;* SJ commented for test
*CALL REDO.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 interface Unit testing changes
        APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 MANUAL CONVERSION
        IF ERR.MSG NE '' THEN
            DESC = 'Error de conversion a formato RAD ' : ID.RCON.L : '. Error: ' : ERR.MSG
            CALL OCOMO(DESC)

            OFS.RAD.PROC.ERR.FLAG = '1'
            R.REDO.ACH.PROCESS.DET<REDO.ACH.PROCESS.DET.STATUS> = '05'
        END
    END

    GOSUB METHOD_ACH_PROC_DET_AUDIT

RETURN

*---------------------------
METHOD_DELETE_FILE:
*---------------------------
    CALL OCOMO('Eliminando el archivo de la carpeta In')
    DEL.CMD = "DELETE ":IN.DIR.PATH:" ":Y.FILE.NAME
    EXECUTE DEL.CMD
RETURN

END
