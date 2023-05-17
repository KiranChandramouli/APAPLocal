SUBROUTINE REDO.VP.B.GEN.DD.REP
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.30.2013
* Description  : Routine for generating report of Direct Debit transactions
* Type         : Batch Routine
* Attached to  : BATCH > REDO.VP.DD.SERVICE
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $INSERT I_F.REDO.VISION.PLUS.DD

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
    DD.FILE.HDR1 = 'nombrenumero_cuentanumero_cuenta_ahorronumero_cuenta_ahorro2tipo_pago_senalmonto_de_pagofecha_limite_pago'
    DD.FILE.HDR2 = '------------------------------------------------------------------------------------------------------------------------------------------------------------------'

    FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
    F.REDO.VISION.PLUS.PARAM  = ''
    REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

    FN.REDO.VISION.PLUS.DD = 'F.REDO.VISION.PLUS.DD'
    F.REDO.VISION.PLUS.DD = ''
    R.REDO.VISION.PLUS.DD = ''

    Y.ERR = ''

    DD.LIST = ''
    DD.LIST.NAME = ''
    DD.SELECTED = ''
    SYSTEM.RETURN.CODE = ''

    DD.DATA = ''
    CRLF = CHARX(13) : CHARX(10)

RETURN

***********************
* Open Files
OPEN.FILES:
***********************
    CALL OPF(FN.REDO.VISION.PLUS.PARAM,F.REDO.VISION.PLUS.PARAM)
    CALL OPF(FN.REDO.VISION.PLUS.DD,F.REDO.VISION.PLUS.DD)

RETURN

***********************
* Main Process
PROCESS:
***********************
    DD.DATA<-1> = DD.FILE.HDR1
    DD.DATA<-1> = DD.FILE.HDR2

    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)
    PROCESS.DATE = R.REDO.VISION.PLUS.PARAM<VP.PARAM.PROCESS.DATE>

    SELECT.STATEMENT  = "SELECT " : FN.REDO.VISION.PLUS.DD
    SELECT.STATEMENT := " WITH @ID LIKE '..." : PROCESS.DATE : "...'"
    SELECT.STATEMENT := " WITH PROCESADO EQ 'OK'"

    CALL EB.READLIST(SELECT.STATEMENT, DD.LIST, DD.LIST.NAME, DD.SELECTED, SYSTEM.RETURN.CODE)

    LOOP
        REMOVE DD.ID FROM DD.LIST SETTING DD.POS
    WHILE DD.ID:DD.POS
        CALL F.READ(FN.REDO.VISION.PLUS.DD, DD.ID, R.REDO.VISION.PLUS.DD, F.REDO.VISION.PLUS.DD, Y.ERR)

        DD.LINE  = R.REDO.VISION.PLUS.DD<VP.DD.NOMBRE>
        DD.LINE := FMT(R.REDO.VISION.PLUS.DD<VP.DD.NUMERO.CUENTA>,'L*58')
        DD.LINE := FMT(R.REDO.VISION.PLUS.DD<VP.DD.MONTO.PAGO>,'R2,')

        DD.LINE = EREPLACE(DD.LINE,"*"," ")

        DD.DATA<-1> = DD.LINE
    REPEAT

    GOSUB WRITE.DD.REPORT

* Log writing: process finished
    CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL004', 'BATCH', '09', 'EMAIL ARCHIVO DEBITO DIRECTO', 'REPORTE - DEBITO DIRECTO A LAS ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '')

RETURN

***********************
* Write Report File
WRITE.DD.REPORT:
***********************
    DD.FILE.NAME = PROCESS.DATE : '_REPORTE_DEBITO_DIRECTO.txt'
    DD.FILE.PATH = TRIM(R.REDO.VISION.PLUS.PARAM<VP.PARAM.DD.FILE.PATH>,' ','B')

    DD.DATA = CHANGE(DD.DATA,@FM,CRLF)

* Open File Directory
    OPEN DD.FILE.PATH ELSE

        CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL004', 'BATCH', '09', 'EMAIL ARCHIVO DEBITO DIRECTO', 'ERROR REPORTE - DEBITO DIRECTO AL ABRIR DIRECTORIO ' : DD.FILE.PATH, '', '', '', '', '', OPERATOR, '')
        CRT 'ERROR IN DD FILE PATH!'
        RETURN
    END

* Open File
    DD.FILE.PATH = DD.FILE.PATH : '/' : DD.FILE.NAME
    OPENSEQ DD.FILE.PATH TO DD.FILE THEN
        CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL004', 'BATCH', '09', 'EMAIL ARCHIVO DEBITO DIRECTO', 'ERROR REPORTE - DEBITO DIRECTO ARCHIVO YA EXISTE EN ' : DD.FILE.PATH, '', '', '', '', '', OPERATOR, '')
        CRT 'FILE ALREADY EXISTS ' : DD.FILE.PATH
        WEOFSEQ DD.FILE
    END

* Write File
    LOOP
        REMOVE DD.LINE FROM DD.DATA SETTING DD.LINE.POS
    WHILE DD.LINE:DD.LINE.POS
        WRITESEQ DD.LINE TO DD.FILE ELSE
            CALL REDO.S.NOTIFY.INTERFACE.ACT ('VPL004', 'BATCH', '09', 'EMAIL ARCHIVO DEBITO DIRECTO', 'ERROR REPORTE - DEBITO DIRECTO NO SE PUEDE ESCRIBIR EN ' : DD.FILE.PATH, '', '', '', '', '', OPERATOR, '')
            CRT 'UNABLE TO WRITE IN FILE ' : DD.FILE.PATH
            BREAK
        END
    REPEAT

* Close File
    CLOSESEQ DD.FILE

RETURN

* </region>

END
