* @ValidationCode : MjotMjA3OTI2MDk4OTpDcDEyNTI6MTY4MTI3NjU1NjE4ODpJVFNTOi0xOi0xOjY4OToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 689
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.ACCT.DEP.DETAILS.POST
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.RELATION
    $INSERT I_F.CATEGORY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.REDO.AML.PARAM
    $INSERT I_REDO.ACCT.DEP.DETAILS.COMMON
    $INSERT I_F.REDO.H.TELLER.TXN.CODES
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB POST.PROCESS
*
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------
**************
POST.PROCESS:
**************
    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ""
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    YFILE.NAME = "REPORT55"
    EXTRACT.FILE.ID = YFILE.NAME:'_':TODAY:'.CSV'   ;* Parameterise

    CALL F.READ(FN.REDO.H.REPORTS.PARAM,"REP55",R.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM,REPORTS.PARAM.ERR)
    Y.OUT.PATH = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>

    FN.OUT.PATH = Y.OUT.PATH
    F.OUT.PATH = ""
    CALL OPF(FN.OUT.PATH,F.OUT.PATH)

    CALL F.READ(FN.OUT.PATH,EXTRACT.FILE.ID,R.FILE,F.OUT.PATH,PATH.ERR)
    IF R.FILE THEN
        DELETE F.OUT.PATH,EXTRACT.FILE.ID

    END

    Y.RETURN     = " Nombre de la institucion : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS "
    Y.RETURN<-1> = " Nombre del Reporte : REPORTE DE DEPOSITOS A CUENTAS IGUALES O SUPERIORES A US$10000 "
    Y.TODAY      = TODAY
    CALL EB.DATE.FORMAT.DISPLAY(Y.TODAY,Y.TODAY.OUT,'','')
    Y.RETURN<-1> = " Fecha del Reporte : " : Y.TODAY.OUT
    Y.RETURN<-1> = "AGENCIA,FECHA,OFICIAL DE CUENTA,TIPO DE CUENTA,MONEDA,NO.DE CUENTA,NOMBRE DE LA CUENTA,CODIGO CLIENTE,MONTO TRANSACCION,REFERENCIA TXN,USUARIO INGRESA,USUARIO AUTORIZA"

    SEL.CMD = " SELECT ": FN.REDO.APAP.BKP.REP55
    CALL EB.READLIST(SEL.CMD,ID.LIST,"",ID.CNT, ERR.SEL)
    LOOP
        REMOVE REC.ID FROM ID.LIST SETTING ID.POS
    WHILE REC.ID:ID.POS
        R.REC = ''; RD.ERR = ''
        CALL F.READ(FN.REDO.APAP.BKP.REP55,REC.ID,R.REC,F.REDO.APAP.BKP.REP55,RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = R.REC
        END
    REPEAT

    R.FINAL.MSG = Y.RETURN:@FM:R.FILE.DATA

    WRITE R.FINAL.MSG ON F.OUT.PATH,EXTRACT.FILE.ID ON ERROR

        CALL OCOMO("Unable to write to the file":F.OUT.PATH)
    END
*
RETURN
