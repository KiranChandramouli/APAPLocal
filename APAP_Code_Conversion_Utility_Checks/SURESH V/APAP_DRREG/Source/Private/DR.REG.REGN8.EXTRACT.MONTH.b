* @ValidationCode : MjozODA3MDk3NjQ6Q3AxMjUyOjE3MDI5NjM5ODgzMTU6MzMzc3U6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:03:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.DRREG


*
*--------------------------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*05-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM
*05-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*13/12/2023         Suresh                    R22 Manual Conversion      Change Hardcoding the value to IDVAR
*----------------------------------------------------------------------------------------




*--------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE DR.REG.REGN8.EXTRACT.MONTH
*----------------------------------------------------------------------------------------------------------------------------------
*
* Description  : This routine will get the details from work file and writes into text file.
*
*-------------------------------------------------------------------------
* Date              Author                    Description
* ==========        ====================      ============
*
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BATCH
    $INSERT I_F.DATES
    $INSERT I_F.DR.REG.REGN8.PARAM
    $INSERT I_F.DR.REG.REGN8.CONCAT
*
    GOSUB OPEN.FILES
    GOSUB INIT.PARA
    GOSUB OPEN.EXTRACT.FILE
    GOSUB PROCESS.PARA
*
RETURN

*----------------------------------------------------------
OPEN.FILES:
***********

    FN.DR.REG.REGN8.PARAM = 'F.DR.REG.REGN8.PARAM'
    FV.DR.REG.REGN8.PARAM = ''
    CALL OPF(FN.DR.REG.REGN8.PARAM, FV.DR.REG.REGN8.PARAM)

    FN.DR.REG.REGN8.WORKFILE = "F.DR.REG.REGN8.CONCAT"
    FV.DR.REG.REGN8.WORKFILE = ""
    CALL OPF(FN.DR.REG.REGN8.WORKFILE, FV.DR.REG.REGN8.WORKFILE)
*
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********


*  CALL F.READ(FN.DR.REG.REGN8.PARAM, "SYSTEM", R.DR.REG.REGN8.PARAM, F.DR.REG.REGN8.PARAM, DR.REG.REGN8.PARAM.ERR)        ;*/ TUS START/END
    IDVAR="SYSTEM" ;*R22 Manual Conversion
    CALL CACHE.READ(FN.DR.REG.REGN8.PARAM, IDVAR, R.DR.REG.REGN8.PARAM, DR.REG.REGN8.PARAM.ERR) ;*R22 Manual Conversion
    FN.CHK.DIR = R.DR.REG.REGN8.PARAM<REGN8.PARAM.OUT.PATH>

RETURN

*-------------------------------------------------------------------
OPEN.EXTRACT.FILE:
******************
    OPEN.ERR = ''
    EXTRACT.FILE.ID = R.DR.REG.REGN8.PARAM<REGN8.PARAM.FILE.NAME>:'_':TODAY[1,6]:'.txt'     ;* Parameterise
    OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE THEN
        DELETESEQ FN.CHK.DIR,EXTRACT.FILE.ID ELSE NULL          ;* In case if it exisit DELETE, for Safer side
        OPENSEQ FN.CHK.DIR,EXTRACT.FILE.ID TO FV.EXTRACT.FILE ELSE        ;* After DELETE file pointer will be closed, hence reopen the file
            CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
        END
    END ELSE
        CREATE FV.EXTRACT.FILE ELSE OPEN.ERR = 1
    END

    IF OPEN.ERR THEN
        TEXT = "Unable to Create a File -> ":EXTRACT.FILE.ID
        CALL FATAL.ERROR("DR.REG.REGN8.EXTRACT.POST")
    END

RETURN

*-------------------------------------------------------------------
INIT.FLDS:
**********
*
    FIELD8 = ''
    FIELD9 = ''
    FIELD10 = ''
    FIELD11 = ''
    FIELD12 = ''
    FIELD13 = ''
    FIELD14 = ''
    FIELD15 = ''
    FIELD16 = ''
    FIELD17 = ''
    FIELD18 = ''
    FIELD19 = ''
    FIELD20 = ''
    FIELD21 = ''
    FIELD22 = ''
    FIELD23 = ''
    FIELD24 = ''
    FIELD25 = ''
    FIELD26 = ''
    FIELD27 = ''
    FIELD28 = ''
    FIELD29 = ''
*
RETURN
*------------------------------------------------------------------
PROCESS.PARA:
*************
*
    GOSUB INIT.FLDS
*
    GOSUB WRITE.HEADER
*
    SEL.CMD = "SELECT ":FN.DR.REG.REGN8.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        CALL F.READ(FN.DR.REG.REGN8.WORKFILE, REC.ID, R.REC, FV.DR.REG.REGN8.WORKFILE, RD.ERR)
        IF R.REC THEN
            FIELD8 += R.REC<DR.REGN8.CONCAT.FIELD8>
            FIELD9 += R.REC<DR.REGN8.CONCAT.FIELD9>
            FIELD10 += R.REC<DR.REGN8.CONCAT.FIELD10>
            FIELD11 += R.REC<DR.REGN8.CONCAT.FIELD11>
            FIELD12 += R.REC<DR.REGN8.CONCAT.FIELD12>
            FIELD13 += R.REC<DR.REGN8.CONCAT.FIELD13>
            FIELD14 += R.REC<DR.REGN8.CONCAT.FIELD14>
            FIELD15 += R.REC<DR.REGN8.CONCAT.FIELD15>
            FIELD16 += R.REC<DR.REGN8.CONCAT.FIELD16>
            FIELD17 += R.REC<DR.REGN8.CONCAT.FIELD17>
            FIELD18 += R.REC<DR.REGN8.CONCAT.FIELD18>
            FIELD19 += R.REC<DR.REGN8.CONCAT.FIELD19>
            FIELD20 += R.REC<DR.REGN8.CONCAT.FIELD20>
            FIELD21 += R.REC<DR.REGN8.CONCAT.FIELD21>
            FIELD22 += R.REC<DR.REGN8.CONCAT.FIELD22>
            FIELD23 += R.REC<DR.REGN8.CONCAT.FIELD23>
            FIELD24 += R.REC<DR.REGN8.CONCAT.FIELD24>
            FIELD25 += R.REC<DR.REGN8.CONCAT.FIELD25>
            FIELD26 += R.REC<DR.REGN8.CONCAT.FIELD26>
            FIELD27 += R.REC<DR.REGN8.CONCAT.FIELD27>
            FIELD28 += R.REC<DR.REGN8.CONCAT.FIELD28>
            FIELD29 += R.REC<DR.REGN8.CONCAT.FIELD29>
        END
        ID.CTR += 1
    REPEAT
*
    REP.CONTENT = ''
    REP.CONTENT<-1> = '1 CHEQUES PAGADOS VIA CAMARA DE COMPENSACION|':FIELD8:'|'
    REP.CONTENT<-1> = '2 CHEQUES PAGADOS VIA DEPOSITOS EN EL MISMO BANCO|':FIELD9:'|'
    REP.CONTENT<-1> = '3 CHEQUES PAGADOS POR LAS VENTANILLAS BAN CARIAS|':FIELD10:'|'
    REP.CONTENT<-1> = '4 TRANSFERENCIAS  ELECTRONICAS A TERCEROS DENTRO DEL MISMO BANCO|':FIELD11:'|'
    REP.CONTENT<-1> = '5 DEBITOS POR TRANSFERENCIAS ELECTRONICA|':FIELD12:'|'
    REP.CONTENT<-1> = '6 DEBITOS POR PAGOS DE NOMINAS ELECTRONICAS|':FIELD13:'|'
    REP.CONTENT<-1> = '7 DEBITOS PARA EL PAGO A TERCEROS|':FIELD14:'|'
    REP.CONTENT<-1> = '8 PAGO A SUPLIDORES DE LOS BANCOS|':FIELD15:'|'
    REP.CONTENT<-1> = '9 DEBITOS PARA EL COBRO DE PRESTAMOS|':FIELD16:'|'
    REP.CONTENT<-1> = '10 DEBITOS PARA EL COBRO DE TARJETAS DE CREDITO|':FIELD17:'|'
    REP.CONTENT<-1> = '11 TRANSFERENCIAS DE BANCO A BANCO POR ORDEN DEL CLIENTE|':FIELD18:'|'
    REP.CONTENT<-1> = '12 TRANSFERENCIA DE BANCO NACIONAL A BANCO EXTRANJERO POR ORDEN DEL CLIENTE|':FIELD19:'|'
    REP.CONTENT<-1> = '13 CHEQUES PARA EL PAGO DE INTERESES DE DEPOSITOS|':FIELD20:'|'
    REP.CONTENT<-1> = '14 CHEQUES EMITIDOS A FAVOR DEL BANCO CENTRAL PARA APERTURAR CERTIFICADOS POR|':FIELD21:'|'
    REP.CONTENT<-1> = '15 OTRAS OPERACIONES  GRAVADAS|':FIELD22:'|'
    SUM1.15 = FIELD8 + FIELD9 + FIELD10 + FIELD11 + FIELD12 + FIELD13 + FIELD14 + FIELD15 + FIELD16 + FIELD17 + FIELD18 + FIELD19 + FIELD20 + FIELD21 + FIELD22
    REP.CONTENT<-1> = '16 TOTAL DE TRANSACCIONES GRAVADAS|':SUM1.15:'|'
    REP.CONTENT<-1> = 'C LIQUIDACION'
    REP.CONTENT<-1> = 'D PENALIDADES'
    REP.CONTENT<-1> = 'F INFORMACIONES ADICIONALES'
    REP.CONTENT<-1> = 'RETIROS DE EFECTIVO EN CAJEROS AUTOMATICOS DE CUENTAS CORRIENTES|':FIELD27:'|'
    REP.CONTENT<-1> = 'RETIROS DE EFECTIVO EN CAJEROS AUTOMATICOS DE CUENTAS DE AHORRO|':FIELD28:'|'
    REP.CONTENT<-1> = 'RETIROS DE EFECTIVO DE CUENTAS DE AHORRO EN VENTANILLA|':FIELD29:'|'
    CRLF = CHARX(013):CHARX(010)
    CHANGE @FM TO CRLF IN REP.CONTENT
    WRITESEQ REP.CONTENT TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*-------------------------------------------------------------------
WRITE.HEADER:
*************
*
    HEAD = ''
    HEAD<-1> = 'A DATOS GENERALES'
    HEAD<-1> = 'PERIOD desde ':TODAY:' hasta ':TODAY
    HEAD<-1> = 'DIA/MES/ANO'
    HEAD<-1> = 'TIPO DE DECLARACION'
    HEAD<-1> = 'RNC/CEDULA ':R.DR.REG.REGN8.PARAM<REGN8.PARAM.RNC.CEDULA>:'  NOMBRE/RAZON SOCIAL ASOCIACION POPULAR DE AHORROS Y PRESTAMOS'
    HEAD<-1> = 'NOMBRE COMERCIAL ASOCIACION POPULAR DE AHORROS Y PRESTAMOS   TELEFONO ':R.DR.REG.REGN8.PARAM<REGN8.PARAM.TELEFONO>
    HEAD<-1> = 'B OPERACINE S GRAVADAS|CANTIDAD|DECLARADO'
    CRLF = CHARX(013):CHARX(010)
    CHANGE @FM TO CRLF IN HEAD
    WRITESEQ HEAD TO FV.EXTRACT.FILE ELSE NULL
*
RETURN
*-------------------------------------------------------------------
END
