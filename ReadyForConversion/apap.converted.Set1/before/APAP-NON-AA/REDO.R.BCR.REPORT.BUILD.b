*-----------------------------------------------------------------------------
* <Rating>-48</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.R.BCR.REPORT.BUILD(Y.INT.CODE,Y.INT.TYPE,R.REDO.INTERFACE.PARAM)
*-----------------------------------------------------------------------------
* Esta rutina es la encargada de generar el archivo correspondiente de acuerdo a los datos
* enviados en el par?metro R.REDO.INTERFACE.PARAM. Este contiene los datos correspondientes
* al formato y localizaci?n final del archivo
* @author youremail@temenos.com
* @stereotype subroutine
* @package REDO
*!
*-----------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE TAM.BP I_F.REDO.INTERFACE.PARAM
    $INCLUDE TAM.BP I_F.REDO.BCR.REPORT.DATA
    $INCLUDE TAM.BP I_F.REDO.BCR.REPORT.EXEC
    $INCLUDE TAM.BP I_REDO.B.BCR.REPORT.BUILD.COMMON
    $INCLUDE JBC.h
*-----------------------------------------------------------------------------

    EQU LF TO CHAR(10)
    EQU CR TO CHAR(13)
    E = ''
    GOSUB INITIALISE
    IF E NE '' THEN
        RETURN
    END

    GOSUB PROCESS
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    K.INT.CODE=Y.INT.CODE
    K.INT.TYPE='BATCH'
    K.BAT.NO=1
    K.BAT.TOT=''
    K.INFO.OR=''
    K.INFO.DE=''
    K.ID.PROC=''
    K.MON.TP='01'
    K.DESC=''
    K.REC.CON=''
    K.EX.USER='OPERATOR'
    K.EX.PC='TNO'



    FN.BCR = 'F.REDO.BCR.REPORT.DATA'
    F.BCR = ''
    CALL OPF(FN.BCR, F.BCR)

    Y.SEL = 'SELECT ' : FN.BCR

    CALL EB.READLIST(Y.SEL, Y.KEY.LIST, '', SELECTED, SYSTEM.ERR)

    K.BAT.TOT=DCOUNT(Y.KEY.LIST,FM)

    K.DESC = ""
    LOOP
        REMOVE Y.BCR.ID FROM Y.KEY.LIST SETTING Y.POS
    WHILE Y.BCR.ID : Y.POS AND K.DESC EQ ""
        M.ERR = ''
        R.BCR = ''
        R.RETURN.MESSAGE = ''
        Y.ERR = ''
        CALL RAD.CONDUIT.LINEAR.TRANSLATION("FORMAT",Y.BCR.TYPE,"F.REDO.BCR.REPORT.DATA",Y.BCR.ID,R.BCR,R.RETURN.MESSAGE,Y.ERR)
        IF Y.ERR NE '' THEN
            K.MON.TP='08'
            K.DESC=Y.ERR
            CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
        END ELSE

            IF R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIPTATION> EQ 'SI' THEN
                yLine = R.RETURN.MESSAGE
                yLine = ENCRYPT(yLine,Y.ENCRIP.KEY,JBASE_CRYPT_3DES_BASE64)
                GOSUB WRITE.LINE
            END ELSE
                yLine = R.RETURN.MESSAGE
                GOSUB WRITE.LINE
            END
        END
        K.BAT.NO++
    REPEAT

    WEOFSEQ  F.PROP.FILE.1    ;* Writes an EOF
    CLOSESEQ F.PROP.FILE.1

    IF Y.LOAN.PRODUCT THEN
        WEOFSEQ  F.PROP.FILE.2
        CLOSESEQ F.PROP.FILE.2

    END

    K.MON.TP='01'
    K.DESC='FIN DEL BARRIDO'
    CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)

    RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
* CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,'OPERATOR','TNO')
* CALL REDO.INTERFACE.REC.ACT(Y.REDO.INT.PARAM.ID,'BATCH','','','','','','01',E,'','OPERATOR','TNO')

    K.INT.CODE=Y.INT.CODE
    K.INT.TYPE='BATCH'
    K.BAT.NO=''
    K.BAT.TOT=''
    K.INFO.OR=''
    K.INFO.DE=''
    K.ID.PROC=''
    K.MON.TP='01'
    K.DESC='INICIO DEL BARRIDO'
    K.REC.CON=''
    K.EX.USER='OPERATOR'
    K.EX.PC='TNO'
    CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)


    MY.POS.1 = REDO.INT.PARAM.ENCRIP.KEY
    Y.ENCRIP.KEY=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.ENCRIP.KEY>
    MY.POS.1 = REDO.INT.PARAM.PARAM.TYPE
    fieldParamType=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    MY.POS.1 = REDO.INT.PARAM.PARAM.VALUE
    fieldParamValue=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
    paramType = 'FILE.FORMAT'

    GOSUB GET.PARAM.TYPE.VALUE
    IF paramValue EQ '' THEN
        K.MON.TP='04'
        K.DESC='ERROR AL INTENTAR OBTENER UN PARAM VALUE ':paramType
        CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
        E = K.DESC

        RETURN
    END
    FN.REDO.BCR.REPORT.EXEC = 'F.REDO.BCR.REPORT.EXEC'
    F.REDO.BCR.REPORT.EXEC  = ''
    CALL OPF(FN.REDO.BCR.REPORT.EXEC,F.REDO.BCR.REPORT.EXEC)

    CALL F.READ(FN.REDO.BCR.REPORT.EXEC,Y.INT.CODE,R.REDO.BCR.REPORT.EXEC,F.REDO.BCR.REPORT.EXEC,EXEC.ERR)
    Y.LOAN.PRODUCT = R.REDO.BCR.REPORT.EXEC<REDO.BCR.REP.EXE.LOAN.PRODUCT.GROUP>

    Y.BCR.TYPE=  paramValue   ;*"BCR.NORMAL" OR "BCR.EXTEND"
    yPath=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
    yPropFile=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>
    Y.FILE.NAME1 = yPropFile:'.1'
    Y.FILE.NAME2 = yPropFile:'.2'

    OPENSEQ yPath, Y.FILE.NAME1 TO F.PROP.FILE.1 ELSE
        CREATE F.PROP.FILE.1 ELSE
            AF = 1
            E    = "ST-REDO.BCR.PROPERTY.NOT.FOUND"
            E<2> = Y.FILE.NAME1 : VM : yPath
            K.MON.TP='08'
            K.DESC=E
            CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
            RETURN
        END
    END
    IF Y.LOAN.PRODUCT THEN
        OPENSEQ yPath, Y.FILE.NAME2 TO F.PROP.FILE.2 ELSE
            CREATE F.PROP.FILE.2 ELSE
                AF = 1
                E    = "ST-REDO.BCR.PROPERTY.NOT.FOUND"
                E<2> = Y.FILE.NAME2 : VM : yPath
                K.MON.TP='08'
                K.DESC=E
                CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
                RETURN
            END
        END
    END

    RETURN

*** <region name= getParamTypeValue>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

    valueNo = 0
    paramValue = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
        paramValue = fieldParamValue<1, valueNo>
    END ELSE
        valueNo = 0
    END
    RETURN

*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
WRITE.LINE:
*-----------------------------------------------------------------------------
    IF R.BCR<BCR.LOAN.TIPO> MATCHES Y.LOAN.PRODUCT THEN
        yLine = yLine
        WRITESEQ yLine TO F.PROP.FILE.2 ELSE
            K.MON.TP='08'
            K.DESC= "ERROR TRYING TO WRITE ON FILE " : yPath : "/" : Y.FILE.NAME2
            CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
            CALL OCOMO("ERROR TRYING TO WRITE TO SEQ-FILE " : K.DESC)
        END

    END ELSE
        yLine = yLine
        WRITESEQ yLine TO F.PROP.FILE.1 ELSE
            K.MON.TP='08'
            K.DESC= "ERROR TRYING TO WRITE ON FILE " : yPath : "/" : Y.FILE.NAME1
            CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
            CALL OCOMO("ERROR TRYING TO WRITE TO SEQ-FILE " : K.DESC)
        END

    END
    RETURN
*-----------------------------------------------------------------------------
END
